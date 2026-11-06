# CoCo Dead Test ROM

A sign-of-life, RAM-sizing and repeating March-U RAM-test ROM for the
**Color Computer 1 or 2**.
It replaces the **Color BASIC ROM**, mapped at **$A000–$BFFF**, not the
Extended BASIC ROM or a cartridge ROM.

On hardware reset it masks IRQ/FIRQ, forces the cassette motor relay off, then
commands 25 on/off cycles at approximately 50 Hz over **0.5 seconds**, without
accessing RAM. It then determines RAM capacity, prints the result on the default
32-column text screen at **$0400**, and signals the result with slower relay
pulses. Successful sizing then starts a repeating, destructive March-U test.
Reset restarts the diagnostic. The initial rapid burst may sound like a
buzz; the later pulses are deliberately slow enough to count.

## Results

After the alive burst and RAM probes, there is a half-second quiet separator,
then one group of pulses (150 ms on, 200 ms off). Count **on/off pairs**, not
individual mechanical clicks:

| Screen | Relay pulses |
| --- | ---: |
| `RAM: 4K` | 1 |
| `RAM: 8K` | 2 |
| `RAM: 16K` | 3 |
| `RAM: 32K` | 4 |
| `RAM: 64K` | 5 |
| `RAM ERROR` | 6 |

The relay is left off between reports. On sizing failure, `RAM ERROR`
stays on screen until reset; otherwise the RAM test begins. With broken
RAM or video hardware, the screen may be unreadable; the relay report still
requires no working RAM. 8K and dual-bank 32K cover the configurations described
by the SAM, including nonstandard machines. Standard CoCo motherboard wiring
is assumed, but the RAM-type jumper is **not trusted for detection**.

The third screen row reports **`RAM JUMPER: OK`** or
**`RAM JUMPER: INCORRECT`** by comparing the sensed setting with the independently
detected DRAM geometry. On a RAM-detection failure it prints
**`RAM JUMPER: UNKNOWN`**, rather than blaming the jumper without evidence.
The relay code reports RAM capacity only; it does not change for a bad jumper.
The jumper line is shown during the initial size report, before testing overwrites
the screen.

## Repeating RAM test

Every detected byte is tested, including the screen buffer. On 64K machines,
P1 selects the two 32K pages through CPU addresses $0000–$7FFF; ROM and I/O
remain mapped. No stack, RAM variables, or relocated code are needed.

The byte-wide March-U sequence uses `$00` / `$FF`, with an additional final
read-zero sweep:

```
up(w0)
up(r0,w1,r1,w0)
up(r0,w1)
down(r1,w0,r0,w1)
down(r1,w0)
up(r0)
```

Operations within each element run on one byte before advancing to the next.
The complete sequence costs 14 memory accesses per byte. After each successful
sequence the screen shows, for example:

```
MARCH-U
PASSES: 0001
RAM: 64K
```

`PASSES` is hexadecimal, increments only after a complete successful sequence,
and wraps from `FFFF` to `0000`. Each complete successful pass gives one
**150 ms relay pulse**, followed by approximately one second with the relay off
and the status readable before the next pass. This heartbeat means the test is
still running and that the preceding pass found no errors. Its interval depends
on RAM capacity and the time taken by a complete pass.
**Screen noise during testing is expected**:
the video buffer itself is under test. The count is stored in a CPU register,
not in potentially faulty RAM.

The first failed comparison stops testing until reset and displays:

```
FAIL
ADDR: 8123

CHECK: 4
EXP: FF
GOT: 7E
XOR: 81
```

`ADDR` is the physical RAM address, including the upper-page bit for 64K.
`EXP`, `GOT`, and `XOR` are hexadecimal; each set bit in `XOR` identifies a
data bit that disagreed. This identifies a data lane, not a board-specific chip
reference designator. `CHECK` identifies the failing read:

| Check | Direction | Read within element |
| --- | --- | --- |
| 1 | Up | r0 before w1,r1,w0 |
| 2 | Up | r1 after w1, before w0 |
| 3 | Up | r0 before w1 |
| 4 | Down | r1 before w0,r0,w1 |
| 5 | Down | r0 after w0, before w1 |
| 6 | Down | r1 before w0 |
| 7 | Up | Final r0 |

The failing byte is captured before repainting the screen. Diagnostics remain
best-effort if screen RAM or video hardware is defective. A March failure stops
the heartbeat and leaves the relay off; there is no additional failure pulse code.
The initial relay pulse group still describes sizing only.

## Build and check

Requires LWTOOLS `lwasm`; tests additionally require Python 3.

```sh
make
make test
```

Outputs:

- `build/coco-dead-test.rom`: raw **8192-byte** image, no loader header.
- `build/coco-dead-test.lst`: assembler listing.
- `build/coco-dead-test.map`: symbol map.

The image starts at $A000 and includes the reset vector at ROM offset $1FFE
($BFFE), mirrored by the SAM to $FFFE. Program a suitable ROM/EPROM replacement
with this image, observing the specific board's socket pinout and electrical
requirements; equal capacity alone does not guarantee compatibility. Disconnect
power before changing ROMs. This ROM does not boot BASIC.

## Design

There are no RAM variables, stack operations, or dependencies on either original
BASIC ROM. All working state and return continuations are held in CPU registers.
The CPU stack pointer is deliberately not loaded;
on a hardware-reset 6809, NMI remains inhibited until S is initialized. This is
a reset-entry ROM, not code to call from an already-running BASIC session.

Writing `$34` / `$3C` to $FF21 selects CA2 forced-output-low/high respectively:
bits 5:3 are `110` / `111`. CA2 controls the cassette motor relay. No PIA port
data-direction setup or PIA reads are required; CA1 interrupts stay disabled.
The SAM clock mode stays at its reset setting (slow, with refresh and video).

Each half-period uses 8951 CPU cycles; the entire burst uses 447550 cycles
(about 0.5001 s at the NTSC reset clock of 0.894886 MHz), plus a few setup
cycles. PAL timing differs slightly. There are 50 relay transitions; the last
transition turns it off, followed by the final half-period delay and RAM sizing.

### RAM sizing with minimal storage

The algorithm is based on [SAM Data sheet.md](SAM%20Data%20sheet.md), especially
**Signal Routing for Address Multiplexer**, **Memory Size**, **Page Switch**,
and **Writing To The SAM Control Register**. SAM M1:M0 selects DRAM addressing
geometry, not a readable installed-capacity value. All SAM bits start clear;
odd control addresses set bits and even addresses clear them, regardless of data.

1. Configure only the necessary PIA pins. Do not read RAMSZ to choose a mode.
2. Try **64K dynamic**, **16K x 1**, **LS785 16K x 4**, then **4K x 1** geometry,
   explicitly setting M1:M0 and P1 for each candidate. Larger chips can appear
   to work in a smaller mode, so candidates must be tried in this order.
3. In each mode, probe $0000 against selected row/column addresses using
   complementary `$55`/`$AA` patterns. Check both locations in both polarities.
   Aliased addresses overwrite each other's pattern and reject the candidate:

   | Candidate | Probe offsets from $0000 | Ghosting rejected |
   | --- | --- | --- |
   | 64K dynamic | $0040, $0080, $0100, $4000 | Missing row bits in 4K/16K chips; 4416's ignored column Z0 in this wrong mode |
   | 16K x 1 | $0040, $0080, $2000 | Missing row/column bits in 4K chips; 4416's ignored A7 in this wrong mode |
   | LS785 16K x 4 | $0040, $0080, $2000 | Requires the 4416 row/column mapping, with P1=1 |
   | 4K x 1 | $0020, $0800 | Demonstrates highest required row/column bits |

4. Test the second bank at $1000 in 4K geometry or $4000 in 16K x 1 geometry.
   In 64K geometry compare physical $0000 and $8000 by switching P1 while
   accessing CPU address $0000. **TY remains zero**: ROM is never banked out.
   Restore P1=0 afterward; the LS785 16K x 4 case retains P1=1 because it
   selects that geometry.
5. Set internal alphanumeric video mode and the SAM display offset to $0400,
   clear the 512-byte screen, and write the result directly from ROM.
6. Only after sizing, strobe PIA0 PB6 ($FF02 bit 6) high and low and read RAMSZ
   at PIA1 PB2 ($FF22 bit 2). Compare both responses against the detected geometry:
   `0/0` = 4K-type, `1/1` = 16K-type, `1/0` = 64K-type. Any mismatch produces
   `RAM JUMPER: INCORRECT`. This checks **chip geometry**, not total capacity:
   for example, two banks of 16K DRAM require the 16K-type setting.

**Sizing memory cost:** zero bytes of variables or stack. Healthy supported
configurations touch at most **six distinct probe bytes**, destructively,
plus the **512-byte screen**. Only two probe values are live at once; the
extra probe addresses are needed to reject wrong-mode ghosting. No RAM is
reserved or copied for code. Existing contents of probe cells and the screen
are not preserved.

Sizing itself is **capacity detection, not a full RAM test**. It samples a few
addresses, then March-U tests the detected extent. Sizing faults can look like
a smaller capacity or a configuration
error. In particular, a failed upper-page probe reports only 32K even if a faulty
64K bank is physically installed. Faulty RAM can also make a geometry appear
smaller and consequently cause a jumper mismatch warning. `INCORRECT` means
the RAMSZ response disagrees with the detected geometry: defective sense wiring
or a PIA fault can cause this even if the physical jumper position is correct.
Unusual upgrades outside these standard chip mappings remain unsupported.
March-U cannot test memory that sizing failed to detect. The byte-wide all-zero/
all-one backgrounds are not exhaustive for intra-byte coupling faults, and this
is not a dedicated refresh-retention or timing-margin test.

`make test` executes the assembled instructions in a narrow, cycle-counted
Python model, including SAM address translation and CoCo RAMSZ/PIA setup. It
checks 4/8/16/32/64K configurations and the LS785 16K x 4 path with **every
4K/16K/64K jumper setting**, plus an invalid sense response. It checks missing
RAM, aliased banks/pages, and a stuck data bit, as well as vectors, access
restrictions, probe footprint, both displayed lines, relay counts/timing, and
termination on sizing failure. It also rejects any attempt to read RAMSZ before
sizing is complete. March tests check two complete passes against an independent
ordered read/write trace for every supported capacity/geometry, plus injected
failures at all seven read checkpoints, screen RAM, 64K page boundaries and the
highest address. Tests also check heartbeat counts and pulse duration, including
cessation after a successful pass followed by a failure.
Failure diagnostics and preservation of the ROM mapping are
checked as well. The instruction-level tests can take several minutes.
It is **not** a complete hardware emulator; real CoCo and mechanical relay
operation still need testing. Fixed open-bus values in the tests do not reproduce
all behavior of an electrically floating or faulty bus.

## Hardware references

- [Color Computer Technical Reference Manual, section 1](https://www.bighole.nl/pub/mirror/homepage.ntlworld.com/kryten_droid/coco/coco_tm_s1.htm):
  memory map, reset clock, and BASIC ROM vector mirroring.
- [Color BASIC Unravelled II](https://www.computerarcheology.com/CoCo/color-basic-unravelled.pdf):
  PIA1 $FF21 definitions, cassette motor control.
- [Color BASIC source transcription](https://github.com/tomctomc/coco_roms/blob/master/bas.asm):
  reset-time RAMSZ strobing and PIA video setup; direct VDG character encoding.
