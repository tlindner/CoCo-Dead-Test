; CoCo 1/2 Color BASIC socket replacement: $A000-$BFFF (8 KiB).
; RAM-free sizing/report, then repeating stack-free March-U over all found RAM.
; Never uses a stack, RAM variables, or calls to the original BASIC ROM.
;
; PIA1 CA2 drives the cassette relay. CRA bits 5:3 = 110 force CA2 low;
; 111 force it high. Bit 2 selects the data register, bit 0 disables CA1
; interrupts. Thus $34 = motor off, $3C = motor on. No DDR setup needed.

ROM_BASE        equ     $a000
VECTOR_BASE     equ     $bff0
PIA1_CRA        equ     $ff21
MOTOR_OFF       equ     $34
MOTOR_BIT       equ     $08
HALF_PERIODS    equ     10              ; 5 on/off cycles, about 10 Hz
DELAY_COUNT     equ     5591
VERSION_MAJOR   equ     '1
VERSION_MINOR   equ     '0

; Inline renderers need neither a stack nor a RAM cursor. HEX clobbers A/B/X.
hexbyte         macro
                tfr     a,b
                lsra
                lsra
                lsra
                lsra
                ldx     #hex_digits
                lda     a,x
                sta     >\1
                tfr     b,a
                anda    #15
                lda     a,x
                sta     >\1+1
                endm
glyph           macro
                lda     #\1
                ora     #$40
                sta     >\2
                endm

; Shared footer on every report/progress/failure screen. Clobbers A only.
version_footer  macro
                glyph   'V,$01e0
                glyph   'E,$01e1
                glyph   'R,$01e2
                glyph   'S,$01e3
                glyph   'I,$01e4
                glyph   'O,$01e5
                glyph   'N,$01e6
                glyph   VERSION_MAJOR,$01e8
                glyph   '.,$01e9
                glyph   VERSION_MINOR,$01ea
                endm

                org     ROM_BASE
start           orcc    #$50            ; Mask IRQ/FIRQ; never initialize S.
                                        ; Reset inhibits NMI until S is loaded.
                lda     #MOTOR_OFF
                sta     >PIA1_CRA        ; Only peripheral setup: force relay off.
                ldb     #HALF_PERIODS

; At reset speed (~894886 Hz NTSC), each half-period is 8*N+15 cycles:
; EORA 2 + STA 5 + LDX 3 + N*(LEAX 5 + BNE 3) + DECB 2 + BNE 3.
; N=5591 gives 44743 cycles (~49.999 ms); 10 periods take ~0.5000 s.
; PAL machines are close to this duration, but not cycle-identical in seconds.
click           eora    #MOTOR_BIT
                sta     >PIA1_CRA        ; Toggle only CA2's forced output level.
                ldx     #DELAY_COUNT
delay           leax    -1,x
                bne     delay
                decb
                bne     click

; The initial alive burst ends here, before the first RAM access.
size_ram        lda     #0
                sta     >$ff03          ; PIA0 B: select DDR.
                lda     #$40
                sta     >$ff02          ; Only PB6 (RAMSZ strobe) is an output.
                lda     #$34
                sta     >$ff03          ; Select data; interrupts disabled.
                lda     #0
                sta     >$ff23          ; PIA1 B: select DDR.
                lda     #$f8
                sta     >$ff22          ; Video bits outputs; RAMSZ PB2 input.
                lda     #$34
                sta     >$ff23          ; Select data, disable cartridge FIRQ.
                lda     #0
                sta     >$ff22          ; Internal alphanumerics, green screen.

; Try geometries independently of RAMSZ. Larger DRAM can appear to work in a
; smaller geometry, so try 64K, 16K x 1, LS785 16K x 4, then 4K, in that order.
; Explicit row/column probes reject the ghosting caused by smaller chips in a
; larger geometry. See SAM Data sheet.md, Signal Routing and Page Switch.
geometry64      sta     >$ffda          ; M0=0, M1=1, P1=0.
                sta     >$ffdd
                sta     >$ffd4
                ldy     #probes64
                bra     probe_next
geometry16      sta     >$ffdc          ; M1=0, M0=1, P1=0.
                sta     >$ffdb
                sta     >$ffd4
                ldy     #probes16
                bra     probe_next
geometry16x4    sta     >$ffd5          ; LS785: M1:M0=01, P1=1.
                ldy     #probes16x4
                bra     probe_next
geometry4       sta     >$ffd4          ; M1:M0=00, P1=0.
                sta     >$ffda
                sta     >$ffdc
                ldy     #probes4

; Probe tables end in zero, then success/failure code addresses. Y walks ROM;
; U holds pair_probe's return continuation. No stack or RAM working storage.
probe_next      ldx     ,y++
                beq     geometry_pass
                ldu     #probe_return
                jmp     pair_probe
probe_return    bcc     probe_next
probe_skip      ldx     ,y++
                bne     probe_skip
                ldx     2,y            ; Failed geometry -> try next candidate.
                jmp     ,x
geometry_pass   ldx     ,y
                jmp     ,x

extent16        ldx     #$4000          ; Second RAS bank, not a wraparound.
                ldu     #check32
                jmp     pair_probe
check32         ldy     #result16
                bcs     found16
                ldy     #result32
found16         jmp     report

extent4         ldx     #$1000          ; Second bank in 4K geometry.
                ldu     #check8
                jmp     pair_probe
check8          ldy     #result4
                bcs     found4
                ldy     #result8
found4          jmp     report

; Compare physical $0000 and $8000 through CPU address $0000. P1 replaces
; A15 in TY=0; ROM stays mapped throughout. Two complementary pattern passes.
extent64        ldb     #2
                lda     #$55
page_probe      sta     >$ffd4
                sta     >$0000
                sta     >$ffd5
                coma
                sta     >$0000
                cmpa    >$0000
                bne     page_alias
                sta     >$ffd4
                coma
                cmpa    >$0000
                bne     page_alias
                coma
                decb
                bne     page_probe
                ldy     #result64
                bra     page_done
page_alias      ldy     #result32_64     ; 32K accessible, but 64K DRAM geometry.
page_done       sta     >$ffd4          ; Restore lower page before display.
                jmp     report

found16x4       ldy     #result16
                jmp     report

; Destructive two-byte alias/data probe: $0000 and ,X in the current geometry.
; U is a register-held continuation, not a stack return address. Carry=fail.
; Check both locations with $55/$AA and then $AA/$55. No saved RAM contents.
pair_probe      ldb     #2
                lda     #$55
pair_pass       sta     >$0000
                coma
                sta     ,x
                cmpa    ,x
                bne     pair_fail
                coma
                cmpa    >$0000
                bne     pair_fail
                coma
                decb
                bne     pair_pass
                andcc   #$fe
                jmp     ,u
pair_fail       orcc    #1
                jmp     ,u

ram_error       sta     >$ffd4          ; No successful geometry/base probe.
                ldy     #result_error

; Descriptor: pulse count, expected RAMSZ high/low input bits, result string.
; No screen reads, cursor variables, BASIC calls, or stack. Screen uses 512 B.
report          ldb     ,y+
                lda     #0
                sta     >$ffc0          ; V2:V0=000: 32 x 16 text.
                sta     >$ffc2
                sta     >$ffc4
                sta     >$ffc6          ; F6:F0=0000000: screen starts at $0000.
                sta     >$ffc8
                sta     >$ffca
                sta     >$ffcc
                sta     >$ffce
                sta     >$ffd0
                sta     >$ffd2
                ldx     #$0000
                lda     #$60           ; VDG blank, as used by Color BASIC CLS.
clear_screen    sta     ,x+
                cmpx    #$0200
                bne     clear_screen
                version_footer

; Read RAMSZ only AFTER independent sizing. A wrong jumper affects this status
; line, never geometry or capacity selection. Compare both strobe levels.
                ldu     #jumper_ok
                cmpb    #6
                beq     jumper_unknown_result
                lda     #$40
                sta     >$ff02
                lda     >$ff22
                anda    #$04
                cmpa    ,y+
                beq     sense_low
                ldu     #jumper_bad
sense_low       lda     #0
                sta     >$ff02
                lda     >$ff22
                anda    #$04
                cmpa    ,y+
                beq     sense_done
                ldu     #jumper_bad
                bra     sense_done
jumper_unknown_result
                leay    2,y
                ldu     #jumper_unknown
sense_done      ldx     #$0000
print_message   lda     ,y+
                beq     print_jumper
                ora     #$40           ; Uppercase ASCII -> normal VDG text.
                sta     ,x+
                bra     print_message
print_jumper    tfr     u,y
                ldx     #$0040          ; Third text row, beneath RAM amount.
print_status    lda     ,y+
                beq     signal_size
                ora     #$40
                sta     ,x+
                bra     print_status

; Separate the countable size code from the initial alive burst.
; 1/2/3/4/5 pulses = 4/8/16/32/64K. Six pulses = RAM/configuration error.
signal_size     tfr     b,dp            ; Preserve capacity code through pulses.
                ldx     #55930          ; ~0.5 second quiet separator.
                ldu     #size_pulse
                bra     wait_x
size_pulse      lda     #$3c
                sta     >PIA1_CRA
                ldx     #22372          ; ~200 ms on (relay has time to move).
                ldu     #size_off
                bra     wait_x
size_off        lda     #MOTOR_OFF
                sta     >PIA1_CRA
                ldx     #33558          ; ~300 ms off between pulses.
                ldu     #size_next
                bra     wait_x
size_next       decb
                bne     size_pulse
                ldb     #2             ; Hold the RAM report for ~1 more second.
size_hold       ldx     #55930
                ldu     #size_hold_next
                bra     wait_x
size_hold_next  decb
                bne     size_hold
                jmp     march_start
wait_x          leax    -1,x
                bne     wait_x
                jmp     ,u

; Do not SYNC/CWAI or touch a stack. Reset repeats the entire diagnostic.
idle            bra     idle

; Y points to a ROM extent descriptor: exclusive CPU end, upper-page flag,
; two printable capacity digits, inclusive CPU start. Each main descriptor
; follows its screen descriptor. U counts completed passes modulo 65536.
; P1 only switches at page boundaries; TY remains zero, so ROM stays visible.
march_start     tfr     dp,a
                cmpa    #6
                beq     idle
                ldy     #march4
                cmpa    #1
                beq     march_ready
                ldy     #march8
                cmpa    #2
                beq     march_ready
                ldy     #march16
                cmpa    #3
                beq     march_ready
                ldy     #march32
                cmpa    #4
                beq     march_ready
                ldy     #march64
march_ready     ldu     #0
                leay    -7,y           ; Test video RAM first, then restore progress.

; March U plus final verification: up(w0); up(r0,w1,r1,w0); up(r0,w1);
; down(r1,w0,r0,w1); down(r1,w0); up(r0). 14 accesses/byte.
; B is the physical page (0/1), NOT a RAM variable. DP identifies the read
; checkpoint (1..7), allowing a failure to name the precise operation.
march_repeat    ldx     5,y
                ldb     #0
                lda     #0
mu0_cell        sta     ,x
                leax    1,x
                cmpx    ,y
                lbne    mu0_cell
                cmpb    2,y
                beq     mu1_start
                ldb     #1
                sta     >$ffd5
                ldx     #0
                bra     mu0_cell

mu1_start       ldx     5,y
                ldb     #0
                lda     2,y
                beq     mu1_cell
                sta     >$ffd4
mu1_cell        lda     #1
                tfr     a,dp
                lda     ,x
                cmpa    #0
                lbne    march_fail
                lda     #$ff
                sta     ,x
                lda     #2
                tfr     a,dp
                lda     ,x
                cmpa    #$ff
                lbne    march_fail
                lda     #0
                sta     ,x
                leax    1,x
                cmpx    ,y
                lbne    mu1_cell
                cmpb    2,y
                beq     mu2_start
                ldb     #1
                sta     >$ffd5
                ldx     #0
                bra     mu1_cell

mu2_start       ldx     5,y
                ldb     #0
                lda     2,y
                beq     mu2_cell
                sta     >$ffd4
mu2_cell        lda     #3
                tfr     a,dp
                lda     ,x
                cmpa    #0
                lbne    march_fail
                lda     #$ff
                sta     ,x
                leax    1,x
                cmpx    ,y
                lbne    mu2_cell
                cmpb    2,y
                beq     mu3_start
                ldb     #1
                sta     >$ffd5
                ldx     #0
                bra     mu2_cell

mu3_start       ldx     ,y
                ldb     2,y
mu3_cell        leax    -1,x
                lda     #4
                tfr     a,dp
                lda     ,x
                cmpa    #$ff
                lbne    march_fail
                lda     #0
                sta     ,x
                lda     #5
                tfr     a,dp
                lda     ,x
                cmpa    #0
                lbne    march_fail
                lda     #$ff
                sta     ,x
                cmpb    #0
                bne     mu3_upper_end
                cmpx    5,y
                bra     mu3_end
mu3_upper_end   cmpx    #0
mu3_end         lbne    mu3_cell
                cmpb    #0
                beq     mu4_start
                ldb     #0
                sta     >$ffd4
                ldx     ,y
                bra     mu3_cell

mu4_start       ldx     ,y
                ldb     2,y
                beq     mu4_cell
                sta     >$ffd5
mu4_cell        leax    -1,x
                lda     #6
                tfr     a,dp
                lda     ,x
                cmpa    #$ff
                lbne    march_fail
                lda     #0
                sta     ,x
                cmpb    #0
                bne     mu4_upper_end
                cmpx    5,y
                bra     mu4_end
mu4_upper_end   cmpx    #0
mu4_end         lbne    mu4_cell
                cmpb    #0
                beq     mu5_start
                ldb     #0
                sta     >$ffd4
                ldx     ,y
                bra     mu4_cell

mu5_start       ldx     5,y
                ldb     #0
mu5_cell        lda     #7
                tfr     a,dp
                lda     ,x
                cmpa    #0
                lbne    march_fail
                leax    1,x
                cmpx    ,y
                lbne    mu5_cell
                cmpb    2,y
                beq     march_pass
                ldb     #1
                sta     >$ffd5
                ldx     #0
                bra     mu5_cell

march_pass      lda     5,y
                bne     main_pass
                leay    7,y            ; Screen passed: restore the running display.
                lda     #0
                tfr     a,dp
                bra     pass_display
main_pass       leau    1,u
                lda     #1
                tfr     a,dp
                lda     2,y
                beq     pass_display
                sta     >$ffd4
pass_display    ldx     #$0000
                lda     #$60
pass_clear      sta     ,x+
                cmpx    #$0200
                bne     pass_clear
                version_footer
                glyph   'M,$0000
                glyph   'A,$0001
                glyph   'R,$0002
                glyph   'C,$0003
                glyph   'H,$0004
                glyph   '-,$0005
                glyph   'U,$0006
                glyph   'P,$0020
                glyph   'A,$0021
                glyph   'S,$0022
                glyph   'S,$0023
                glyph   'E,$0024
                glyph   'S,$0025
                glyph   ':,$0026
                tfr     u,d
                hexbyte $0028
                tfr     u,d
                tfr     b,a
                hexbyte $002a
                glyph   'R,$0040
                glyph   'A,$0041
                glyph   'M,$0042
                glyph   ':,$0043
                lda     3,y
                ora     #$40
                sta     >$0045
                lda     4,y
                ora     #$40
                sta     >$0046
                glyph   'K,$0047
                tfr     dp,a
                cmpa    #0
                lbeq    march_repeat
                ; One audible heartbeat only after a fully successful pass.
                ; Pulse for ~150 ms, then leave
                ; the motor off for the ~1 second readable-result hold.
                lda     #$3c
                sta     >PIA1_CRA
                ldx     #16779
pass_click      leax    -1,x
                bne     pass_click
                lda     #MOTOR_OFF
                sta     >PIA1_CRA
                ldb     #2
pass_hold       ldx     #55930
pass_wait       leax    -1,x
                bne     pass_wait
                decb
                bne     pass_hold
                leay    -7,y           ; Begin the next pass with video RAM.
                jmp     march_repeat

; Capture the failing read before any display writes. U=actual:page,
; Y=CPU address, DP=checkpoint. The capacity descriptor is no longer needed.
march_fail      tfr     d,u
                lda     2,y
                beq     fail_page_ready
                sta     >$ffd4
fail_page_ready
                tfr     x,y
                tfr     u,d
                cmpb    #0
                beq     fail_lower
                leay    $8000,y         ; Report physical, not window address.
fail_lower      ldx     #$0000
                lda     #$60
fail_clear      sta     ,x+
                cmpx    #$0200
                bne     fail_clear
                version_footer
                tfr     dp,b
                ldx     #expected_bytes
                lda     b,x
                tfr     a,dp            ; Expected byte now kept in DP.
                tfr     b,a
                ora     #$70
                sta     >$0067          ; CHECK: n
                glyph   'F,$0000
                glyph   'A,$0001
                glyph   'I,$0002
                glyph   'L,$0003
                glyph   'A,$0020
                glyph   'D,$0021
                glyph   'D,$0022
                glyph   'R,$0023
                glyph   ':,$0024
                tfr     y,d
                hexbyte $0026
                tfr     y,d
                tfr     b,a
                hexbyte $0028
                glyph   'C,$0060
                glyph   'H,$0061
                glyph   'E,$0062
                glyph   'C,$0063
                glyph   'K,$0064
                glyph   ':,$0065
                glyph   'E,$0080
                glyph   'X,$0081
                glyph   'P,$0082
                glyph   ':,$0083
                tfr     dp,a
                hexbyte $0085
                glyph   'G,$00a0
                glyph   'O,$00a1
                glyph   'T,$00a2
                glyph   ':,$00a3
                tfr     u,d
                hexbyte $00a5
                glyph   'X,$00c0
                glyph   'O,$00c1
                glyph   'R,$00c2
                glyph   ':,$00c3
                tfr     u,d
                tfr     dp,b
                ; EOR through a ROM lookup: expected is either 00 or FF.
                cmpb    #0
                beq     fail_xor
                coma
fail_xor        hexbyte $00c5
                jmp     idle

hex_digits      fcb     $70,$71,$72,$73,$74,$75,$76,$77,$78,$79
                fcc     "ABCDEF"
expected_bytes  fcb     0,0,$ff,0,$ff,0,$ff,0

                fdb     $0200          ; Separate, brief video-memory March-U.
                fcb     0
                fcc     " 4"
                fdb     $0000
march4          fdb     $1000
                fcb     0
                fcc     " 4"
                fdb     $0200
                fdb     $0200          ; Separate, brief video-memory March-U.
                fcb     0
                fcc     " 8"
                fdb     $0000
march8          fdb     $2000
                fcb     0
                fcc     " 8"
                fdb     $0200
                fdb     $0200          ; Separate, brief video-memory March-U.
                fcb     0
                fcc     "16"
                fdb     $0000
march16         fdb     $4000
                fcb     0
                fcc     "16"
                fdb     $0200
                fdb     $0200          ; Separate, brief video-memory March-U.
                fcb     0
                fcc     "32"
                fdb     $0000
march32         fdb     $8000
                fcb     0
                fcc     "32"
                fdb     $0200
                fdb     $0200          ; Separate, brief video-memory March-U.
                fcb     0
                fcc     "64"
                fdb     $0000
march64         fdb     $8000
                fcb     1
                fcc     "64"
                fdb     $0200

; Test addresses come from the SAM's row/column multiplexing, not RAMSZ.
; $0040/$0080 expose missing row bits in 4K/16K chips in 64K mode.
; $0100 exposes 4416's ignored column Z0 in the wrong (64K) geometry.
; $2000 exposes the missing column bit in 4K chips in 16K x 1 mode.
probes64        fdb     $0040,$0080,$0100,$4000,0
                fdb     extent64,geometry16
probes16        fdb     $0040,$0080,$2000,0
                fdb     extent16,geometry16x4
probes16x4      fdb     $0040,$0080,$2000,0
                fdb     found16x4,geometry4
probes4         fdb     $0020,$0800,0
                fdb     extent4,ram_error

result4         fcb     1,0,0
                fcz     "RAM: 4K"
result8         fcb     2,0,0
                fcz     "RAM: 8K"
result16        fcb     3,4,4
                fcz     "RAM: 16K"
result32        fcb     4,4,4
                fcz     "RAM: 32K"
result32_64     fcb     4,4,0
                fcz     "RAM: 32K"
result64        fcb     5,4,0
                fcz     "RAM: 64K"
result_error    fcb     6,0,0
                fcz     "RAM ERROR"
jumper_ok       fcz     "RAM JUMPER: OK"
jumper_bad      fcz     "RAM JUMPER: INCORRECT"
jumper_unknown  fcz     "RAM JUMPER: UNKNOWN"

                fill    $ff,VECTOR_BASE-*
; SAM mirrors these ROM bytes to CPU addresses $FFF0-$FFFF.
; Unused/exception vectors lead to the idle loop, not uninitialized RAM.
; This does not make an unexpected interrupt stack-safe.
                fdb     idle            ; Reserved
                fdb     idle            ; SWI3
                fdb     idle            ; SWI2
                fdb     idle            ; FIRQ (masked)
                fdb     idle            ; IRQ (masked)
                fdb     idle            ; SWI
                fdb     idle            ; NMI (inhibited after reset)
                fdb     start           ; RESET at $BFFE -> $FFFE
                end     start
