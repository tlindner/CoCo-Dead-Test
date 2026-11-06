"""Narrow 6809/SAM/PIA regression model; not a complete hardware emulator.

Executes the actual ROM. Unknown instructions/accesses fail, including all stack
instructions. RAM row/column routing follows SAM Data sheet.md, Figure 6.
CoCo RAMSZ wiring is modeled separately from SAM geometry selection.
"""

from pathlib import Path
import re
import sys

SYMBOLS = {}


class Machine:
    def __init__(self, rom, size, kind, fault=None, jumper=None):
        self.rom, self.size, self.kind, self.fault = rom, size, kind, fault
        self.jumper = jumper or {"4x1": "4K", "16x1": "16K",
                                 "16x4": "16K", "64x1": "64K"}[kind]
        self.sense_reads = 0
        self.ram = bytearray([0xCC]) * (64 * 1024)
        self.sam = 0
        self.pia = {0xFF02: 0, 0xFF03: 0, 0xFF22: 0, 0xFF23: 0}
        self.ddr = {0xFF02: 0, 0xFF22: 0}
        self.reg = dict(a=0, b=0, x=0, y=0, u=0, dp=0)
        self.marching = False
        self.trace = []
        self.inject = None
        self.inject_after = 0
        self.injected = False
        self.instruction = 0
        self.pc = int.from_bytes(rom[-2:], "big")
        self.cc = 0
        self.cycles = 0
        self.relay = []
        self.probes = set()
        self.probe_cells = set()
        self.screen_writes = set()
        self.screen_output = bytearray(512)
        self.first_ram_cycle = None

    def ram_address(self, address):
        mode = (self.sam >> 13) & 3
        page = (self.sam >> 10) & 1
        if mode == 0:
            row, col, bank = address & 0x7F, (address >> 6) & 0x3F, address >> 12 & 1
        elif mode == 1:
            row, col, bank = address & 0x7F, (address >> 7) & 0x7F, address >> 14 & 1
            if self.kind == "16x4" and page:
                row = address & 0xFF
        else:
            assert mode == 2, "Unexpected static RAM geometry"
            row, col, bank = address & 0xFF, (address >> 8) | (page << 7), 0
        if self.kind == "4x1":
            physical = bank * 4096 + (col & 0x3F) * 64 + (row & 0x3F)
        elif self.kind == "16x1":
            physical = bank * 16384 + (col & 0x7F) * 128 + (row & 0x7F)
        elif self.kind == "16x4":
            # 4416 wiring: 8 row bits; 6 column bits (Z1-Z6).
            physical = ((col >> 1) & 0x3F) * 256 + row
        else:
            physical = col * 256 + row
        if self.fault == "page_alias":
            physical &= 0x7FFF
        elif self.fault == "bank_alias":
            physical %= self.size
        return physical if physical < self.size else None

    def ram_access(self, address):
        if self.first_ram_cycle is None:
            self.first_ram_cycle = self.cycles
        if 0x0400 <= address < 0x0600:
            self.screen_writes.add(address)
        elif not self.marching:
            assert address in (0, 0x20, 0x40, 0x80, 0x100, 0x800,
                               0x1000, 0x2000, 0x4000), hex(address)
            self.probes.add((address, (self.sam >> 10) & 1, (self.sam >> 13) & 3))
        physical = self.ram_address(address)
        if not self.marching and not 0x0400 <= address < 0x0600 and physical is not None:
            self.probe_cells.add(physical)
        return physical

    def read(self, address):
        if 0xA000 <= address < 0xC000:
            assert not self.sam & 0x8000, "Executing ROM was banked out"
            return self.rom[address - 0xA000]
        if address < 0x8000:
            assert self.marching or not 0x0400 <= address < 0x0600, "Unexpected screen RAM read"
            physical = self.ram_access(address)
            if physical is None:
                return 0 if self.fault == "open_zero" else 0xFF
            value = self.ram[physical]
            if self.fault == "stuck_bit":
                value &= 0xFE
            if self.marching and SYMBOLS['mu0_cell'] <= self.instruction < SYMBOLS['march_pass']:
                physical_address = address + (0x8000 if self.sam & 0x400 and self.kind == '64x1' else 0)
                self.trace.append(('r', physical_address, value))
                if (self.inject == (self.reg['dp'], physical_address)
                        and self.reg['u'] >= self.inject_after and not self.injected):
                    self.injected = True
                    return value ^ 0x81
            return value
        assert address == 0xFF22, f"Unexpected read: ${address:04X}"
        assert len(self.screen_writes) == 512, "RAMSZ read before independent sizing"
        self.sense_reads += 1
        assert self.pia[0xFF23] & 4 and self.ddr[0xFF22] == 0xF8
        assert self.ddr[0xFF02] == 0x40 and self.pia[0xFF03] & 4
        if self.jumper == "4K":
            return 0
        if self.jumper == "64K":
            return self.pia[0xFF02] & 0x40 and 4
        if self.jumper == "invalid":
            return 0 if self.pia[0xFF02] & 0x40 else 4
        return 4

    def write(self, address, value):
        assert self.cc & 0x50 == 0x50, "Interrupts not masked"
        if address < 0x8000:
            physical = self.ram_access(address)
            if self.marching and SYMBOLS['mu0_cell'] <= self.instruction < SYMBOLS['march_pass']:
                physical_address = address + (0x8000 if self.sam & 0x400 and self.kind == '64x1' else 0)
                self.trace.append(('w', physical_address, value))
            if 0x400 <= address < 0x600:
                self.screen_output[address - 0x400] = value
            if physical is not None:
                self.ram[physical] = value
        elif address == 0xFF21:
            assert value in (0x34, 0x3C)
            self.relay.append((self.cycles, value))
        elif address in self.pia:
            if address in self.ddr and not self.pia[address + 1] & 4:
                self.ddr[address] = value
            else:
                self.pia[address] = value
        else:
            assert 0xFFC0 <= address <= 0xFFDF, f"Unexpected write: ${address:04X}"
            bit = 1 << ((address - 0xFFC0) // 2)
            self.sam = (self.sam | bit) if address & 1 else (self.sam & ~bit)
            assert not self.sam & 0x9800, "Map type or clock speed changed"

    def fetch(self):
        assert 0xA000 <= self.pc < 0xC000, "Execution left the ROM"
        value = self.read(self.pc)
        self.pc += 1
        return value

    def word(self):
        return (self.fetch() << 8) | self.fetch()

    def zero(self, value):
        self.cc = (self.cc & ~4) | (4 if value == 0 else 0)

    def compare(self, left, right):
        self.zero(left - right)
        self.cc = (self.cc & ~1) | (left < right)

    def indexed(self):
        post = self.fetch()
        register = ("x", "y", "u", "s")[(post >> 5) & 3]
        assert register != "s", "Stack register used"
        base = self.reg[register]
        if post & 0x80:
            if post & 0x1F in (6, 5):  # A,R / B,R
                offset = self.reg['a' if post & 0x1F == 6 else 'b']
                if offset & 128:
                    offset -= 256
                return (base + offset) & 0xFFFF, 1
            if post & 0x1F == 9:  # 16-bit offset,R
                return (base + self.word()) & 0xFFFF, 4
            assert post & 0x1F in (0, 1, 4), f"Unsupported indexed mode: {post:02X}"
            if post & 0x1F in (0, 1):  # ,R+ / ,R++
                amount = (post & 1) + 1
                self.reg[register] = (base + amount) & 0xFFFF
                return base, 2 if amount == 1 else 3
            return base, 0  # ,R
        offset = post & 31
        if offset & 16:
            offset -= 32
        return (base + offset) & 0xFFFF, 1

    def run(self, march=False, passes=2):
        self.marching = march
        for _ in range(100_000_000):
            if not march and self.pc == SYMBOLS['march_start']:
                return
            if march and self.pc == SYMBOLS['march_repeat'] and self.reg['u'] == passes:
                return
            address = self.pc
            self.instruction = address
            op = self.fetch()
            long_branch = False
            if op == 0x10:
                op = self.fetch()
                if op == 0x8E:  # LDY immediate
                    self.reg["y"] = self.word()
                    self.zero(self.reg["y"])
                    self.cycles += 4
                    continue
                assert op in (0x25, 0x26, 0x27), f"Unknown prefix-10 opcode {op:02X}"
                long_branch = True
            if op in (0x1A, 0x1C):  # ORCC / ANDCC
                value = self.fetch()
                self.cc = self.cc | value if op == 0x1A else self.cc & value
                self.cycles += 3
            elif op == 0x1F:  # TFR (only register-to-register, never S)
                post = self.fetch()
                registers = {1: "x", 2: "y", 3: "u", 8: "a", 9: "b", 11: "dp"}
                value = (self.reg['a'] << 8) | self.reg['b'] if post >> 4 == 0 else self.reg[registers[post >> 4]]
                if post & 15 == 0:
                    self.reg['a'], self.reg['b'] = value >> 8, value & 255
                else:
                    self.reg[registers[post & 15]] = value
                self.cycles += 6
            elif op in (0x86, 0xC6, 0x8E, 0xCE):  # LD immediate
                register = {0x86: "a", 0xC6: "b", 0x8E: "x", 0xCE: "u"}[op]
                self.reg[register] = self.fetch() if register in "ab" else self.word()
                self.zero(self.reg[register])
                self.cycles += 2 if register in "ab" else 3
            elif op in (0x88, 0x8A, 0x85, 0x84):  # EORA / ORA / BITA / ANDA
                value = self.fetch()
                a = self.reg["a"]
                result = a ^ value if op == 0x88 else a | value if op == 0x8A else a & value
                if op != 0x85:
                    self.reg["a"] = result
                self.zero(result)
                self.cycles += 2
            elif op == 0x44:  # LSRA
                self.cc = (self.cc & ~1) | (self.reg['a'] & 1)
                self.reg['a'] >>= 1
                self.zero(self.reg['a'])
                self.cycles += 2
            elif op in (0x43, 0x5A):  # COMA / DECB
                register = "a" if op == 0x43 else "b"
                self.reg[register] = self.reg[register] ^ 255 if op == 0x43 else (self.reg[register] - 1) & 255
                self.zero(self.reg[register])
                if op == 0x43:
                    self.cc |= 1
                self.cycles += 2
            elif op in (0xB6, 0xB7, 0xB1, 0xA6, 0xA7, 0xA1, 0xE6, 0xAE, 0xAC, 0xE1):
                if op in (0xB6, 0xB7, 0xB1):
                    target, extra = self.word(), 1
                else:
                    target, extra = self.indexed()
                self.cycles += 4 + extra
                if op in (0xB7, 0xA7):  # STA
                    self.write(target, self.reg["a"])
                    self.zero(self.reg["a"])
                elif op in (0xB1, 0xA1):  # CMPA
                    self.compare(self.reg["a"], self.read(target))
                elif op == 0xAC:
                    self.compare(self.reg['x'], self.read(target) * 256 + self.read(target + 1))
                    self.cycles += 2
                elif op == 0xE1:
                    self.compare(self.reg['b'], self.read(target))
                else:
                    register = "x" if op == 0xAE else "b" if op == 0xE6 else "a"
                    value = self.read(target)
                    if op == 0xAE:
                        value = (value << 8) | self.read(target + 1)
                        self.cycles += 1
                    self.reg[register] = value
                    self.zero(self.reg[register])
            elif op == 0x8C:  # CMPX immediate
                self.compare(self.reg["x"], self.word())
                self.cycles += 4
            elif op in (0x81, 0xC1):  # CMPA / CMPB immediate
                self.compare(self.reg['a' if op == 0x81 else 'b'], self.fetch())
                self.cycles += 2
            elif op in (0x30, 0x31, 0x33):  # LEAX / LEAY / LEAU indexed
                register = {0x30: 'x', 0x31: 'y', 0x33: 'u'}[op]
                self.reg[register], extra = self.indexed()
                self.zero(self.reg[register])
                self.cycles += 4 + extra
            elif op in (0x7E, 0x6E):  # JMP extended / indexed
                if op == 0x7E:
                    target, extra = self.word(), 0
                else:
                    target, extra = self.indexed()
                self.pc = target
                self.cycles += 3 + extra
            elif op in (0x20, 0x24, 0x25, 0x26, 0x27):
                offset = self.word() if long_branch else self.fetch()
                bits = 16 if long_branch else 8
                if offset & (1 << (bits - 1)):
                    offset -= 1 << bits
                taken = {0x20: True, 0x24: not self.cc & 1, 0x25: bool(self.cc & 1),
                         0x26: not self.cc & 4, 0x27: bool(self.cc & 4)}[op]
                if op == 0x20 and self.pc + offset == address:
                    assert self.rom[0x1FF0:0x1FFE] == address.to_bytes(2, "big") * 7
                    return
                if taken:
                    self.pc += offset
                self.cycles += (6 if taken else 5) if long_branch else 3
            else:
                raise AssertionError(f"Unknown opcode ${op:02X} at ${address:04X}")
        raise AssertionError("ROM did not reach idle")


def check(rom, size, kind, expected, pulses, fault=None, jumper=None):
    machine = Machine(rom, size, kind, fault, jumper)
    machine.run()
    relay = machine.relay
    assert [value for _, value in relay[:51]] == [0x34] + [0x3C, 0x34] * 25
    assert [relay[i + 1][0] - relay[i][0] for i in range(1, 50)] == [8951] * 49
    assert machine.first_ram_cycle > 447550, "RAM touched during alive burst"
    assert [value for _, value in relay[51:]] == [0x3C, 0x34] * pulses
    assert (relay[51][0] - relay[50][0]) / 894886 > 0.5
    for index in range(51, len(relay), 2):
        duration = (relay[index + 1][0] - relay[index][0]) / 894886
        assert 0.149 < duration < 0.151
        if index + 2 < len(relay):
            gap = (relay[index + 2][0] - relay[index + 1][0]) / 894886
            assert 0.199 < gap < 0.201
    assert machine.screen_writes == set(range(0x400, 0x600))
    assert machine.sam & 7 == 0 and ((machine.sam >> 3) & 127) == 2
    assert machine.pia[0xFF22] == 0
    expected_screen = bytearray(b"\x60" * 512)
    expected_screen[:len(expected)] = bytes(ord(char) | 0x40 for char in expected)
    geometry = {"4x1": "4K", "16x1": "16K", "16x4": "16K", "64x1": "64K"}[kind]
    status = "UNKNOWN" if pulses == 6 else "OK" if machine.jumper == geometry else "INCORRECT"
    status_text = f"RAM JUMPER: {status}"
    expected_screen[64:64 + len(status_text)] = bytes(ord(char) | 0x40 for char in status_text)
    assert machine.screen_output == expected_screen, machine.screen_output[:96]
    # Also check actual RAM contents when the physical screen can work.
    if size and fault != "stuck_bit":
        display = bytes(machine.ram[machine.ram_address(a)] for a in range(0x400, 0x600))
        assert display == expected_screen, (display[:32], display[64:96])
    assert machine.sense_reads == (0 if pulses == 6 else 2)
    assert len(machine.probe_cells) <= (6 if fault is None else 12), machine.probe_cells
    assert not machine.sam & 0x8000
    print(f"PASS: {kind}, {size // 1024}K, jumper {machine.jumper}, "
          f"{fault or 'healthy'} -> {expected}, {pulses} pulses; "
          f"{len(machine.probe_cells)} probe cells")


def screen_line(machine, row):
    return ''.join(chr(c & 0x3F | (0x40 if c & 0x3F < 32 else 0))
                   for c in machine.screen_output[row * 32:(row + 1) * 32]).rstrip()


def march_trace(size):
    """Independent March-U oracle, including element direction and ordering."""
    elements = [(False, [('w', 0)]),
                (False, [('r', 0), ('w', 255), ('r', 255), ('w', 0)]),
                (False, [('r', 0), ('w', 255)]),
                (True, [('r', 255), ('w', 0), ('r', 0), ('w', 255)]),
                (True, [('r', 255), ('w', 0)]),
                (False, [('r', 0)])]
    for descending, operations in elements:
        addresses = range(size - 1, -1, -1) if descending else range(size)
        for address in addresses:
            for operation, value in operations:
                yield operation, address, value


def check_march(rom, capacity, kind, checkpoint=None, address=0, inject_after=0):
    machine = Machine(rom, capacity * 1024, kind)
    machine.run()
    relay = machine.relay[:]
    if checkpoint is not None:
        machine.inject = checkpoint, address
        machine.inject_after = inject_after
    machine.run(march=True)
    heartbeats = machine.relay[len(relay):]
    completed = 2 if checkpoint is None else inject_after
    assert [value for _, value in heartbeats] == [0x3C, 0x34] * completed, (
        'Exactly one heartbeat per successful pass, none on a failed pass')
    for index in range(0, len(heartbeats), 2):
        duration = (heartbeats[index + 1][0] - heartbeats[index][0]) / 894886
        assert 0.149 < duration < 0.151, duration
        if index + 2 < len(heartbeats):
            assert (heartbeats[index + 2][0] - heartbeats[index + 1][0]) / 894886 > 1
    assert machine.relay[-1][1] == 0x34, 'March must leave motor off'
    assert not machine.sam & 0x8000
    display = bytes(machine.ram[machine.ram_address(a)] for a in range(0x400, 0x600))
    assert display == machine.screen_output, 'Diagnostic is not in the visible RAM page'
    if checkpoint is None:
        expected = list(march_trace(capacity * 1024))
        assert machine.trace == expected * 2, 'Wrong March-U ordering/coverage'
        assert screen_line(machine, 0) == 'MARCH-U'
        assert screen_line(machine, 1) == 'PASSES: 0002'
        assert screen_line(machine, 2) == f'RAM: {capacity:2}K'
        print(f'PASS: March-U {capacity}K {kind}, two complete ordered passes')
    else:
        expected = 255 if checkpoint in (2, 4, 6) else 0
        assert machine.injected
        assert machine.pc == SYMBOLS['idle'] + 2
        assert screen_line(machine, 0) == 'FAIL'
        assert screen_line(machine, 1) == f'ADDR: {address:04X}'
        assert screen_line(machine, 3) == f'CHECK: {checkpoint}'
        assert screen_line(machine, 4) == f'EXP: {expected:02X}'
        assert screen_line(machine, 5) == f'GOT: {expected ^ 0x81:02X}'
        assert screen_line(machine, 6) == 'XOR: 81'
        print(f'PASS: March-U failure checkpoint {checkpoint}, address {address:04X}, {kind}')


if __name__ == "__main__":
    image = Path(sys.argv[1]).read_bytes()
    SYMBOLS.update((name, int(value, 16)) for name, value in re.findall(
        r'Symbol: (\w+) .* = ([0-9A-Fa-f]+)',
        Path(sys.argv[1]).with_suffix('.map').read_text()))
    assert len(image) == 8192
    for capacity, kind, count in [(4, "4x1", 1), (8, "4x1", 2),
                                   (16, "16x1", 3), (32, "16x1", 4),
                                   (16, "16x4", 3), (64, "64x1", 5)]:
        for setting in ("4K", "16K", "64K", "invalid"):
            check(image, capacity * 1024, kind, f"RAM: {capacity}K", count, jumper=setting)
    check(image, 64 * 1024, "64x1", "RAM: 32K", 4, "page_alias")
    check(image, 4 * 1024, "4x1", "RAM: 4K", 1, "bank_alias")
    check(image, 16 * 1024, "16x1", "RAM: 16K", 3, "bank_alias")
    for kind in ("4x1", "16x1", "64x1"):
        check(image, 0, kind, "RAM ERROR", 6)
        check(image, 0, kind, "RAM ERROR", 6, "open_zero")
        check(image, 64 * 1024, kind, "RAM ERROR", 6, "stuck_bit")
    for capacity, kind in [(4, '4x1'), (8, '4x1'), (16, '16x1'),
                           (32, '16x1'), (16, '16x4'), (64, '64x1')]:
        check_march(image, capacity, kind)
    for checkpoint in range(1, 8):
        check_march(image, 4, '4x1', checkpoint, 0x0713)
    for address in (0, 0x0400, 0x7FFF, 0x8000, 0xFFFF):
        check_march(image, 64, '64x1', 4, address)
    check_march(image, 16, '16x4', 2, 0x1234)
    check_march(image, 4, '4x1', 4, 0x0713, inject_after=1)
