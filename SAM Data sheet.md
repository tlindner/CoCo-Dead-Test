# MOTOROLA
## SYNCHRONOUS ADDRESS MULTIPLEXER
**SN74LS783 / MC6883**  
**SN74LS785**

The **SN74LS783/MC6883** and **SN74LS785** bring together the MC6809E (MPU), the MC6847 (Color Video Display Generator), and dynamic RAM to form a highly effective, compact and cost-effective computer and display system.

The **SN74LS783/MC6883** is designed to support 4K × 1, 16K × 1, and 64K × 1 (128 column refresh) dynamic RAMs. The **SN74LS785** has been modified to support the above listed products as well as 16K × 4 and 64K × 1 (256 column refresh) dynamic RAMs. A further enhancement allows the LS785 to support low power dynamic ROMs (such as MCM68364) without additional logic.

---

### Features

* **MC6809E, MC6800, MC6801E, MC68000, and MC6847 (VDG)** Compatible
* **Transparent MPU / VDG / Refresh**
* **RAM Size**: 4K, 8K, 16K, 32K, or 64K Bytes (Dynamic or Static)
* **Addressing Range**: 96K Bytes
* **Single Crystal** Provides All Timing
* **Register Programmable**:
  * VDG Addressing Modes
  * VDG Offset (0 to 64K)
  * RAM Size
  * Page Switch
  * MPU Rate (Crystal $\div$ 16 or $\div$ 8)
  * MPU Rate (Address Dependent or Independent)
* **System "Device Selects" Decoded On-Chip**
* **Timing is Optimized for Standard Dynamic RAMs**
* **+5.0 V Only Operation**
* **Easy Synchronization of Multiple SAM Systems**
* **DMA Mode**

---

### Pin Assignment

```
                +---v---+
           A11  |  1  40|  VCC
           A10  |  2  39|  A12
            A9  |  3  38|  A13
            A8  |  4  37|  A14
         OscIn  |  5  36|  A15
        OscOut  |  6  35|  Z7 (RAS1)
          VClk  |  7  34|  Z6
           DA0  |  8  33|  Z5
            HS  |  9  32|  Z4
            WE  | 10  31|  Z3
           CAS  | 11  30|  Z2
          RAS0  | 12  29|  Z1
             Q  | 13  28|  Z0
             E  | 14  27|  S0
           R/W  | 15  26|  S1
            A0  | 16  25|  S2
            A1  | 17  24|  A7
            A2  | 18  23|  A6
            A3  | 19  22|  A5
           GND  | 20  21|  A4
                +-------+
```

---

### Maximum Ratings ($T_A = 25^\circ	ext{C}$ unless otherwise noted)

| Rating | Symbol | Value | Unit |
| :--- | :---: | :---: | :---: |
| Power Supply Voltage | $V_{CC}$ | -0.5 to +7.0 | Vdc |
| Input Voltage (Except OscIn) | $V_I$ | -0.5 to +10 | Vdc |
| Input Current (Except OscIn) | $I_I$ | -30 to +5.0 | mA |
| Output Voltage | $V_O$ | -0.5 to +7.0 | Vdc |
| Operating Ambient Temperature Range | $T_A$ | 0 to +70 | ${}^\circ	ext{C}$ |
| Storage Temperature Range | $T_{stg}$ | -65 to +150 | ${}^\circ	ext{C}$ |
| Input Voltage OscIn | $V_{IOscIn}$ | -0.5 to $V_{CC}$ | Vdc |
| Input Current OscIn | $I_{OscIn}$ | -0.5 to +5.0 | mA |

---

### Guaranteed Operating Ranges

| Parameter | Symbol | Min | Typ | Max | Unit |
| :--- | :---: | :---: | :---: | :---: | :---: |
| Supply Voltage | $V_{CC}$ | 4.75 | 5.0 | 5.25 | V |
| Operating Ambient Temperature Range | $T_A$ | 0 | 25 | 70 | ${}^\circ	ext{C}$ |
| **Output Current High** | $I_{OH}$ | | | | |
| - $\overline{	ext{RAS0}}$, $\overline{	ext{RAS1}}$, $\overline{	ext{CAS}}$, $\overline{	ext{WE}}$ | | | | -1.0 | mA |
| - All Other Outputs | | | | -0.2 | mA |
| **Output Current Low** | $I_{OL}$ | | | | |
| - $\overline{	ext{RAS0}}$, $\overline{	ext{RAS1}}$, $\overline{	ext{CAS}}$, $\overline{	ext{WE}}$ | | | | 8.0 | mA |
| - VClk | | | | 0.8 | mA |
| - All Other Outputs | | | | 4.0 | mA |

---

### DC Characteristics 
*(Unless otherwise noted specifications apply over recommended power supply and temperature ranges)*

| Characteristic | Symbol | Min | Typ | Max | Unit |
| :--- | :---: | :---: | :---: | :---: | :---: |
| Input Voltage - High Logic State | $V_{IH}$ | 2.0 | — | — | V |
| Input Voltage - Low Logic State | $V_{IL}$ | — | — | 0.8 | V |
| Input Clamp Voltage ($V_{CC} = 	ext{Min}, I_{in} = -18	ext{ mA}$) All Inputs Except OscIn | $V_{IK}$ | — | — | -1.5 | V |
| **Input Current High Logic State at Max Input Voltage** | $I_{IH}$ | | | | |
| - ($V_{CC} = 	ext{Max}, V_{in} = 5.25	ext{ V}$) VClk Input | | — | — | 200 | $\mu	ext{A}$ |
| - ($V_{CC} = 	ext{Max}, V_{in} = 5.25	ext{ V}$) DA0 Input | | — | — | 100 | $\mu	ext{A}$ |
| - ($V_{CC} = 	ext{Max}, V_{in} = 5.25	ext{ V}$, OscIn = Gnd) OscOut Input | | — | — | 250 | $\mu	ext{A}$ |
| - ($V_{CC} = 	ext{Max}, V_{in} = 7.0	ext{ V}$) All Other Inputs Except OscIn | | — | — | 100 | $\mu	ext{A}$ |
| Input Current High Logic State ($V_{CC} = 	ext{Max}, V_{in} = 2.7	ext{ V}$) All Inputs Except VClk, DA0, OscIn, OscOut | $I_{IH}$ | — | — | 30 | $\mu	ext{A}$ |
| **Input Current Low Logic State** | $I_{IL}$ | | | | |
| - ($V_{CC} = 	ext{Max}, V_{in} = 0.4	ext{ V}$) DA0 Input | | — | — | -1.2 | mA |
| - ($V_{CC} = 	ext{Max}, V_{in} = 0.4	ext{ V}$) VClk Input | | — | — | -60 | $\mu	ext{A}$ |
| - ($V_{CC} = 	ext{Max}, V_{in} = 0.4	ext{ V}$, OscIn = Gnd) OscOut Input | | — | — | -8 | mA |
| - ($V_{CC} = 	ext{Max}, V_{in} = 0.4	ext{ V}$) All Other Inputs Except OscIn | | — | — | -0.4 | mA |
| **Output Voltage High Logic State** | $V_{OH}$ | | | | |
| - ($V_{CC} = 	ext{Min}, I_{OH} = -1.0	ext{ mA}$) $\overline{	ext{RAS0}}$, $\overline{	ext{RAS1}}$, $\overline{	ext{CAS}}$, $\overline{	ext{WE}}$ | $V_{OH(C)}$ | 3.0 | — | — | V |
| - ($V_{CC} = 	ext{Min}, I_{OH} = -0.2	ext{ mA}$) E, Q | $V_{OH(E)}$ | $V_{CC}-0.75$ | — | — | V |
| - ($V_{CC} = 	ext{Min}, I_{OH} = -0.2	ext{ mA}$) All Other Outputs | $V_{OH}$ | 2.7 | — | — | V |
| **Output Voltage Low Logic State** | $V_{OL}$ | | | | |
| - ($V_{CC} = 	ext{Min}, I_{OL} = 8.0	ext{ mA}$) $\overline{	ext{RAS0}}$, $\overline{	ext{RAS1}}$, $\overline{	ext{CAS}}$, $\overline{	ext{WE}}$ | $V_{OL(C)}$ | — | — | 0.5 | V |
| - ($V_{CC} = 	ext{Min}, I_{OL} = 4.0	ext{ mA}$) E, Q Outputs | $V_{OL(E)}$ | — | — | 0.5 | V |
| - ($V_{CC} = 	ext{Min}, I_{OL} = 0.8	ext{ mA}$) VClk Output | $V_{OL(V)}$ | — | — | 0.6 | V |
| - ($V_{CC} = 	ext{Min}, I_{OL} = 4.0	ext{ mA}$) All Other Outputs | $V_{OL}$ | — | — | 0.5 | V |
| Power Supply Current | $I_{CC}$ | — | 180 | 230 | mA |
| Output Short-Circuit Current | $I_{OS}$ | -30 | — | -225 | mA |

---

### AC Characteristics ($4.75	ext{ V} \le V_{CC} \le 5.25	ext{ V}$ and $0 \le T_A \le 70^\circ	ext{C}$)

| Characteristic | Symbol | Min | Typ | Max | Unit |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **Propagation Delay Times** | | | | | |
| OscillatorIn to OscillatorOut | $t_{d(OL-OH)}$ | — | 3.0 | — | ns |
| OscillatorIn to OscillatorOut | $t_{d(OH-OL)}$ | — | 20 | — | ns |
| ($C_L = 195	ext{ pF}$) A0 thru A15 to Z0, Z1, Z2 thru Z7 | $t_{d(A-Z)}$ | — | 28 | — | ns |
| ($C_L = 30	ext{ pF}$) A0 thru A15, R/$\overline{	ext{W}}$ to S0, S1, S2 | $t_{d(A-S)}$ | — | 18 | — | ns |
| ($C_L = 95	ext{ pF}$) OscillatorOut to $\overline{	ext{RAS0}}$ (High) | $t_{d(OL-R0H)}$ | — | 20 | — | ns |
| ($C_L = 95	ext{ pF}$) OscillatorOut to $\overline{	ext{RAS0}}$ (Low) | $t_{d(OL-R0L)}$ | — | 18 | — | ns |
| ($C_L = 95	ext{ pF}$) OscillatorOut to $\overline{	ext{RAS1}}$ (High) | $t_{d(OL-R1H)}$ | — | 22 | — | ns |
| ($C_L = 95	ext{ pF}$) OscillatorOut to $\overline{	ext{RAS1}}$ (Low) | $t_{d(OL-R1L)}$ | — | 20 | — | ns |
| ($C_L = 195	ext{ pF}$) OscillatorOut to $\overline{	ext{CAS}}$ (High) | $t_{d(OL-CH)}$ | — | 20 | — | ns |
| ($C_L = 195	ext{ pF}$) OscillatorOut to $\overline{	ext{CAS}}$ (Low) | $t_{d(OL-CL)}$ | — | 20 | — | ns |
| ($C_L = 195	ext{ pF}$) OscillatorOut to $\overline{	ext{WE}}$ (High) | $t_{d(OL-WH)}$ | — | 22 | — | ns |
| ($C_L = 195	ext{ pF}$) OscillatorOut to $\overline{	ext{WE}}$ (Low) | $t_{d(OL-WL)}$ | — | 40 | — | ns |
| ($C_L = 100	ext{ pF}$) OscillatorOut to E (High) | $t_{d(OL-EH)}$ | — | 55 | — | ns |
| ($C_L = 100	ext{ pF}$) OscillatorOut to E (Low) | $t_{d(OL-EL)}$ | — | 25 | — | ns |
| ($C_L = 100	ext{ pF}$) OscillatorOut to Q (High) | $t_{d(OL-QH)}$ | — | 55 | — | ns |
| ($C_L = 100	ext{ pF}$) OscillatorOut to Q (Low) | $t_{d(OL-QL)}$ | — | 25 | — | ns |
| ($C_L = 30	ext{ pF}$) OscillatorOut to VClk (High) | $t_{d(OH-VH)}$ | — | 50 | — | ns |
| ($C_L = 30	ext{ pF}$) OscillatorOut to VClk (Low) | $t_{d(OH-VL)}$ | — | 65 | — | ns |
| ($C_L = 195	ext{ pF}$) OscillatorOut to Row Address | $t_{d(OL-AR)}$ | — | 36 | — | ns |
| ($C_L = 195	ext{ pF}$) OscillatorOut to Column Address | $t_{d(OL-AC)}$ | — | 33 | — | ns |
| ($C_L = 15	ext{ pF}$) OscillatorOut to DA0 Earliest | $t_{d(OL-DH)}$ | — | -15 | — | ns |
| ($C_L = 15	ext{ pF}$) OscillatorOut to DA0 Latest | $t_{d(OL-DH)}$ | — | +15 | — | ns |
| ($C_L = 95	ext{ pF}$ on RAS, $C_L = 195	ext{ pF}$ on CAS) CAS to RAS | $t_{d(CL-RH)}$ | — | 208 | — | ns |
| **Setup Time for A0 thru A15, R/$\overline{	ext{W}}$** | $t_{su(A)}$ | | | | |
| - Rate = $\div 16$ / Rate = $\div 8$ | | — | 28 / 28 | — | ns |
| **Hold Time for A0 thru A15, R/$\overline{	ext{W}}$** | $t_{h(A)}$ | | | | |
| - Rate = $\div 16$ / Rate = $\div 8$ | | — | 30 / 30 | — | ns |
| **Width of HS Low** | $t_{WL(HS)}$ | 2.0 | 5.0 | 6.0 | $\mu	ext{s}$ |

---

### Pin Description Table

| Name | Pin No. | Function |
| :--- | :---: | :--- |
| **$V_{CC}$** | 40 | Apply +5 Volts $\pm 5\%$. SAM draws less than 230 mA. |
| **Gnd** | 20 | Return Ground for +5 Volts. |
| **A15–A0** | 36–39, 1–4, 24–21, 19–16 | MPU Address Inputs A0–A15. A15 is MSB, A0 is LSB. Directly address up to 64K memory locations or indirectly address up to 96K memory locations. |
| **R/$\overline{	ext{W}}$** | 15 | MPU Read or Write input. Used to enable writing to SAM control register, dynamic RAM (via WE), and enable device select #0. |
| **OscIn** | 5 | Apply 14.31818 MHz crystal and 2.5–30 pF trimmer to ground. |
| **OscOut** | 6 | Apply 1.5 k$\Omega$ resistor to 14.31818 MHz crystal and 33 pF capacitor to ground. |
| **DA0** | 8 | Display Address DA0. Inputs LSB of 16-bit video address. Inputs logic level of VDG FS pulse for vertical address updating. |
| **HS** | 9 | Horizontal Synchronization. Detects falling edge of VDG HS pulse to initiate eight dynamic RAM refresh cycles. Resets up to 4 LSBs of internal video address counter. |
| **VClk** | 7 | VDG Clock output (3.579545 MHz). When pulled low externally ($<0.8	ext{ V}$), resets SAM control register. |
| **S2, S1, S0** | 25, 26, 27 | Device Select Outputs. Binary value selects 1 of 8 MPU address space chunks. |
| **E, Q** | 14, 13 | MPU Clocks for MC6809E. 90° out of phase. |
| **Z0–Z7 / $\overline{	ext{RAS1}}$** | 28–34, 35 | Multiplexed RAM Addresses Z0–Z7. Z7 (Pin 35) serves as $\overline{	ext{RAS1}}$ for 4K $	imes$ 1 and 16K $	imes$ 1 RAM configurations. |
| **$\overline{	ext{RAS0}}$** | 12 | Row Address Strobe Zero. |
| **$\overline{	ext{CAS}}$** | 11 | Column Address Strobe. |
| **$\overline{	ext{WE}}$** | 10 | Write Enable. Enables MPU write into dynamic RAM when low. |

---

### VDG Address Modifier (Figure 5)

| Mode (V2, V1, V0) | Division Variables (Y, X) | Bits Cleared by HS (Low) |
| :---: | :---: | :---: |
| 0, 0, 0 | Y=12, X=1 | B1–B4 |
| 0, 0, 1 | Y=3, X=1 | B1–B3 |
| 0, 1, 0 | Y=3, X=1 | B1–B4 |
| 0, 1, 1 | Y=1, X=2 | B1–B3 |
| 1, 0, 0 | Y=1, X=2 | B1–B4 |
| 1, 0, 1 | Y=1, X=1 | B1–B3 |
| 1, 1, 0 | Y=1, X=1 | B1–B4 |
| 1, 1, 1 | Y=1, X=1 | None (DMA Mode) |

---

### Signal Routing for Address Multiplexer (Figure 6)

| Memory Size (M1, M0) | Signal Source | Row/Col | Z7 | Z6 | Z5 | Z4 | Z3 | Z2 | Z1 | Z0 | Timing |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **4K** (0, 0) | MPU | ROW | RAS1 | A6 | A5 | A4 | A3 | A2 | A1 | A0 | T7–TA |
| | | COL | RAS1 | LOW | A11 | A10 | A9 | A8 | A7 | A6 | TA–TF |
| | VDG | ROW | RAS1 | B6 | B5 | B4 | B3 | B2 | B1 | B0 | TF–T2 |
| | | COL | RAS1 | LOW | B11 | B10 | B9 | B8 | B7 | B6 | T2–T7 |
| | REF | ROW | RAS1 | C6 | C5 | C4 | C3 | C2 | C1 | C0 | TF–T2 |
| | | COL | RAS1 | LOW | LOW | LOW | LOW | LOW | LOW | LOW | T2–T7 |
| **16K $	imes$ 1** (0, 1) | MPU | ROW | RAS1 | A6 | A5 | A4 | A3 | A2 | A1 | A0 | T7–TA |
| | | COL | RAS1 | A13 | A12 | A11 | A10 | A9 | A8 | A7 | TA–TF |
| | VDG | ROW | RAS1 | B6 | B5 | B4 | B3 | B2 | B1 | B0 | TF–T2 |
| | | COL | RAS1 | B13 | B12 | B11 | B10 | B9 | B8 | B7 | T2–T7 |
| | REF | ROW | RAS1 | C6 | C5 | C4 | C3 | C2 | C1 | C0 | TF–T2 |
| | | COL | RAS1 | LOW | LOW | LOW | LOW | LOW | LOW | LOW | T2–T7 |
| **16K $	imes$ 4** (0, 1 - LS785) | MPU | ROW | A7 | A6 | A5 | A4 | A3 | A2 | A1 | A0 | T7–TA |
| | | COL | A14 | A13 | A12 | A11 | A10 | A9 | A8 | A7 | TA–TF |
| **64K Dynamic** (1, 0) | MPU | ROW | A7 | A6 | A5 | A4 | A3 | A2 | A1 | A0 | T7–TA |
| | | COL | P/A15 | A14 | A13 | A12 | A11 | A10 | A9 | A8 | TA–TF |
| | VDG | ROW | B7 | B6 | B5 | B4 | B3 | B2 | B1 | B0 | TF–T2 |
| | | COL | B15 | B14 | B13 | B12 | B11 | B10 | B9 | B8 | T2–T7 |
| **64K Static** (1, 1) | MPU | ROW | A7 | A6 | A5 | A4 | A3 | A2 | A1 | A0 | T7–T9 |
| | | COL | P/A15 | A14 | A13 | A12 | A11 | A10 | A9 | A8 | T9–TF |

---

### MPU Rate Options

| Rate Mode | R1 | R0 | Frequency of "E" Clock |
| :--- | :---: | :---: | :--- |
| **SLOW** | 0 | 0 | $f_{	ext{crystal}} \div 16$ (~0.9 MHz) |
| **A.D. (Address Dependent)** | 0 | 1 | $f_{	ext{crystal}} \div 16$ or $f_{	ext{crystal}} \div 8$ depending on address |
| **FAST** | X | 1 | $f_{	ext{crystal}} \div 8$ (~1.8 MHz) |

---

### Memory Size Options

| RAM Size | M1 | M0 | Notes |
| :--- | :---: | :---: | :--- |
| **4K $	imes$ 1** | 0 | 0 | One or two banks |
| **16K $	imes$ 1** | 0 | 1 | One or two banks |
| **16K $	imes$ 4** | 0 | 1 | LS785 only ($P_1 = 1$) |
| **64K Dynamic** | 1 | 0 | One bank ($64	ext{K} 	imes 1$) |
| **64K Static** | 1 | 1 | Up to 64K Static RAM |

---

### Control Register Address Mapping

To **set** a control register bit, write to the **odd** address. To **clear** a control register bit, write to the **even** address.

| Control Bit | Description | Clear Address | Set Address |
| :---: | :--- | :---: | :---: |
| **V0** | VDG Mode Bit 0 | \$FFC0 | \$FFC1 |
| **V1** | VDG Mode Bit 1 | \$FFC2 | \$FFC3 |
| **V2** | VDG Mode Bit 2 | \$FFC4 | \$FFC5 |
| **F0** | Display Offset Bit 0 | \$FFC6 | \$FFC7 |
| **F1** | Display Offset Bit 1 | \$FFC8 | \$FFC9 |
| **F2** | Display Offset Bit 2 | \$FFCA | \$FFCB |
| **F3** | Display Offset Bit 3 | \$FFCC | \$FFCD |
| **F4** | Display Offset Bit 4 | \$FFCE | \$FFCF |
| **F5** | Display Offset Bit 5 | \$FFD0 | \$FFD1 |
| **F6** | Display Offset Bit 6 | \$FFD2 | \$FFD3 |
| **P1** | Page Bit / RAM Select | \$FFD4 | \$FFD5 |
| **R0** | MPU Rate Bit 0 | \$FFD6 | \$FFD7 |
| **R1** | MPU Rate Bit 1 | \$FFD8 | \$FFD9 |
| **M0** | Memory Size Bit 0 | \$FFDA | \$FFDB |
| **M1** | Memory Size Bit 1 | \$FFDC | \$FFDD |
| **TY** | Map Type Bit | \$FFDE | \$FFDF |


## SAM BLOCK DIAGRAM DESCRIPTION
### MPU Addresses (A0 - A15):

These 16 signals come directly from the MPU and are used to directly address up to 64K memory locations (K = 1024) or to indirectly address up to 96K memory locations, by using a paging bit "p" (see pages 17 and 18 for memory maps.) Each input is approximately equivalent to one low power Schottky load.

### VDG Address Counter (B0 - B15):

These 16 signals are derived from one input (DA0) which is the least significant bit of the VDG address. Most of the counter is simply binary. However, to duplicate the various addressing modes of the MC6847 VDG, ADDRESS MODIFIER logic is used. Selected by three VDG mode bits (V2, V1, and VO) from the SAM CONTROL REGISTER, eight address modifications are obtained as shown in Figure 5.

Also, notice that bits B9-B15 may be loaded from bits F0-F6 from the CONTROL REGISTER. This allows the starting address of the VDG display to be offset (in ½ K increments) from $0000 to $FFFF†. B9-B15 are loaded when a VERTICAL PRE-LOAD(VP) pulse is generated. VP goes active (high) when HS{BAR} from the VDG rises if DA0 is high (or a high impedance.) This condition should occur only while the TV electron beam is in vertical blanking and is simply implemented by connecting FS{BAR} and MS{BAR} together on the MC6847. The VP pulse also clears bits B1 - B8.

Finally, a HORIZONTAL RESET (HR) pulse may also affect the counter by clearing bits 81 - B3 or B1 - B4 when HS{BAR} from the VDG is LOW (see Figure 5.) The HR pulse should occur only while the TV electron beam is in horizontal blanking.

In summary, DA0 clocks the VDG ADDRESS COUNTER; HR initializes the horizontal portion and VP initializes the vertical portion of the VDG ADDRESS COUNTER.

### REFresh Address Counter(C0 - C6):

A seven bit binary counter with outputs labeled C0 - C6 supplies bursts of eight* sequential addresses triggered by a HS high to low transition. Thus, while the TV electron beam is in horizontal blanking, eight sequential addresses are accessed. Likewise, the next eight addresses are accessed during the next horizontal blanking period, etc. In this manner, all 128 addresses are refreshed in less than 1.1 milliseconds.

### Address Multiplexer:

Occupying a large portion of the block diagram in Figure 4, is the address multiplexer which outputs bits Z0-Z7 (as addresses to dynamic RAM's.) Inputs to the address multiplexer include the VDG address (B0 - B15) the REFresh address (C0 - C6) and the MPU address (A0 - A15) or (A0 - A14 plus one paging bit "p".) The paging bit "p" is one bit in the SAM CONTROL REGISTER that is used in place of A15 when memory map TYpe #0 is selected (via the SAM CONTROL REGISTER "TY" bit.)

Figure 6 shows which inputs are routed to 20 - 27 and when the routing occurs relative to one SAM machine cycle. Notice that Z7 and RAS1{BAR} share the same pin. Z7 is selected if "M1" in the SAM CONTROL REGISTER IS HIGH (Memory size = 64K.)

### Address Decode:

At the top left of Figure 4, is the Address Decode block. Outputs S2, S1, and SO form a three bit encoded binary word(S). Thus S may be one of eight values (0 through 7) with each value representing a different range of MPU addresses. (To enable peripheral ROM's or I/O, decode the S2, S1, and SO bits into eight seperate signals by using a 74LS138, 74LS155 or 74LS156. Notice that S2, S1, and SO are not gated with any timing signals such as E or Q.)

Along with the A5 - A15 inputs is the MEMORY MAP TYpe bit (TY.) This bit is soft-programmable (as are all 16 bits in the SAM CONTROL REGISTER,) and selects one of two memory maps. Memory map #0 is intended to be used in systems that are primarily ROM based. Whereas, memory map #1 is intended for a primarily RAM based system with 64K contiguous RAM locations (minus 256 locations.) The various meanings of S2, S1, SO are tabulated in Figure 16 (page 19) and again on pages 17 and 18.

In addition to S2, S1, and S0 outputs is a decode of $FFC0 through $FFDF which, when gated with E and R/W, results in the write strobe for the SAM CONTROL REGISTER.

### SAM Control Register
As shown in Figure 4, the CONTROL REGISTER has 16 "outputs" :

| VDG Addressing Modes: V2, V1, V0 | MPU Rate: R1, R0 |
|---|---|
| VDG Address OFFset: F6, F5, F4, F3, F2, F1, F0 | Memory Size (RAM): M1, M0 |
| 32K Page Switch: P | Memory Map TYpe: TY |

When the SAM is reset (see page 10,) all 16 bits are cleared. To set any one of these 16 bits, the MPU simply writes to a unique** odd address (within $FFC1 through $FFDF.) To clear any one of these 16 bits, the MPU simply writes to a unique** even address (within $FFC0 through $FFDE.) Note that the data on the MPU data bus is irrelevant.

Inputs to the control register include A4, A3, A2, A1 (which are used to select which one of of the 16 bits is to be cleared or set), A0 (which determines the polarity ... clear or set,) and R/W{BAR}, E and $ffc0 - $ffdf (which restrict the mothod, timing and addresses for changing one of the 16 bits.) For more detailed descriptions of the purpose of the 16 control bit, refer to related sections in the block diagram descriptions (pages 8 through 12) and the programming guide (pages 14 thru 18).

*If HS{BAR} is held low longer than 8 us, then the number of sequential addresses in one refresh "BURST" is proportional to the time interval
during which HS is low.

**See pages 17 or 18 for specific addresses.

† In this document, the "$" symbol always preceeds hexidecimal characters.


### Figure 5 — VDG Address Modifiers

| Mode | Division variables | Bits cleared by HS{BAR} (low) |
|---|---|---|
| V2 V1 V0 | X Y | |
| 0 0 0 | 1 12 | B1-B4 |
| 0 0 1 | 3 1 | B1-B3 |
| 0 1 0 | 1 3 | B1-B4 |
| 0 1 1 | 2 1 | B1-B3 |
| 1 0 0 | 1 2 | B1-B4 |
| 1 0 1 | 1 1 | B1-B3 |
| 1 1 0 | 1 1 | B1-B4 |
| 1 1 1 | 1 1 | None (DMA Mode) |

### Figure 6 — SIGNAL ROUTING for ADDRESS MULTIPLEXER for RAM

| Memory Size | M1 | M0 | Signal Source | Row/Column | Z7 | Z6 | Z5 | Z4 | Z3 | Z2 | Z1 | Z0 | Timing (Figure 2) |
|---|---:|---:|---|---|---|---|---|---|---|---|---|---|---|
| 4K | 0 | 0 | MPU | ROW | * | A6 | A5 | A4 | A3 | A2 | A1 | A0 | T7–TA |
| | | | MPU | COL | * | L | A11 | A10 | A9 | A8 | A7 | A6 | TA–TF |
| | | | VDG | ROW | * | B6 | B5 | B4 | B3 | B2 | B1 | B0 | TF–T2 |
| | | | VDG | COL | * | L | B11 | B10 | B9 | B8 | B7 | B6 | T2–T7 |
| | | | REF | ROW | * | C6 | C5 | C4 | C3 | C2 | C1 | C0 | TF–T2 |
| | | | REF | COL | * | L | L | L | L | L | L | L | T2–T7 |
| 16K | 0 | 1 | MPU | ROW | * | A6 | A5 | A4 | A3 | A2 | A1 | A0 | T7–TA |
| | | | MPU | COL | * | A13 | A12 | A11 | A10 | A9 | A8 | A7 | TA–TF |
| | | | VDG | ROW | * | B6 | B5 | B4 | B3 | B2 | B1 | B0 | TF–T2 |
| | | | VDG | COL | * | B13 | B12 | B11 | B10 | B9 | B8 | B7 | T2–T7 |
| | | | REF | ROW | * | C6 | C5 | C4 | C3 | C2 | C1 | C0 | TF–T2 |
| | | | REF | COL | * | L | L | L | L | L | L | L | T2–T7 |
| 64K (dynamic) | 1 | 0 | MPU | ROW | A7 | A6 | A5 | A4 | A3 | A2 | A1 | A0 | T7–TA |
| | | | MPU | COL | P/A15*** | A14 | A13 | A12 | A11 | A10 | A9 | A8 | TA–TF |
| | | | VDG | ROW | B7 | B6 | B5 | B4 | B3 | B2 | B1 | B0 | TF–T2 |
| | | | VDG | COL | B15 | B14 | B13 | B12 | B11 | B10 | B9 | B8 | T2–T7 |
| | | | REF | ROW | L | C6 | C5 | C4 | C3 | C2 | C1 | C0 | TF–T2 |
| | | | REF | COL | L | L | L | L | L | L | L | L | T2–T7 |
| 64K (static) | 1 | 1 | MPU | ROW | A7 | A6 | A5 | A4 | A3 | A2 | A1 | A0 | T7–T9 |
| | | | MPU | COL | P/A15*** | A14 | A13 | A12 | A11 | A10 | A9 | A8 | T9–TF |
| | | | VDG | ROW | B7 | B6 | B5 | B4 | B3 | B2 | B1 | B0 | TF–T1 |
| | | | VDG | COL | B15 | B14 | B13 | B12 | B11 | B10 | B9 | B8 | T1–T7 |
| | | | REF | ROW | L | C6 | C5 | C4 | C3 | C2 | C1 | C0 | T1–T7 |
| | | | REF | COL | L | L | L | L | L | L | L | L | T1–T7 |

Notes:
"L" implies logical LOW level

*Z7 function as RAS1 and its level is address dependent. For example, when using two banks of 16K x 1 RAM, RAS0 is active for addresses $0000 to $3fff and RAS1 is active for addresses $4000 to $7fff

***If map TYpe - 0 then page bit "P" is the output (otherwise A15)

### Internal Reset

By lowering Vcc below 0.6 volts for at least one millisecond, a complete SAM reset is initiated and is completed within 500 nanoseconds after VCC rises above 4.25 volts.

NOTE: In some applications, (for example, multiple "VDG-RAM" systems controlled by a single MPU)

multiple SAM ICs can be synchronized as follows:
* Drive all SAM's from one external oscillator.
* Stop external oscillator.
* Lower Vcc below 0.6 volts for at least 1.0 millisecond.
* Raise Vcc to 5.0 volts.
* Start external oscillator.
* Wait at least 500 nanoseconds.

Now, the "E" clocks from all SAM's should be in-phase.

### External Reset

When the VClk pin on SAM is forced below 0.8 volts for at least eight cycles of "oscillator-out", the SAM becomes partially reset. That is, all bits in the SAM control register are cleared. However, signals such as RAS{BAR} CAS{BAR}, WE{BAR}, E or Q are not stopped (as they are with an internal reset), since the SAM must maintain dynamic RAM refresh even during this external reset period.
Figure 7 shows how VClk can be pulled low through diode D1 when note "A" is low.* Whne noe "A" is high, only the backbiased capacitance of diode D1 loads the 3.58 MHz on VClk. Diode D2 helps discharge C1 (Power-on-Reset capacitor) when power is turned off. Diode D3 allows the MPU reset time constant R2C2 to be greater than the SAM reset time constant. Thereby, ensuring release of the SAM reset prior to attempting
to program the SAM control register.


### VDG Synchronization
In order for the VDG and MPU to share the same dynamic RAM (see page 13,) the VDG clock must be stopped until the VDG data fetch and MPU data fetch are synchronized as shown in Figure 12. Once synchronized, the VDG clock resumes its 3.579545 MHz rate and is not stopped again unless an extreme temperature change or SAM reset) occurs. When stopped, the VDG clock remains stopped for no more than 32 OscOut cycles (approximately 2 microseconds.)

In the block diagram in Figure 4, DA0 enters a block labeled VDG Timing Error Detector. If DAO rises between time reference points** τA and τC, then Error{BAR} is high and VClk is the result of dividing BOSC (Buffered OscOut ~ 14 MHz) by four. However, if DA0 rises outside the time Window τA to τC , then Error{BAR} goes LOW and the VDG stops. A START pulse at time reference point τB (center of Window) restarts the VDG… properly synchronized.

*Use a diode with sufficiently low forward voltage drop to meet Vil requirement at VClk.

**See timing diagrams on page 5 and 6.

### Changing the MPU Rate

(by changing SAM control register bits RO, R1).

Two bits in the SAM control register determine the period of both "E" and "Q" MPU clocks. Three rate mmodes are implemented as follows:

| RATE MODE | R1 | R0 | |
|---|---|---|---|
| Slow | 0 | 0 | The frequency of "E" (and "Q") is f crystal ÷ 16. This rate mode is automatically selected when the SAM is reset. Note that system timing is least critical in the "SLOW" rate mode. |
| Address Dependent | 0 | 1 | The frequency of "E" (and "Q") is either F crystal ÷ 16 or f crystal ÷ 8, depending on the address the MPU is presenting. |
| FAST | 1 | X | The frequency of "E" (and "Q") is f crystal ÷ 8. This is accomplished by stealing the time that is normally used for VDG/REFRESH, and using this time for the MPU. Note: Neither VDG display nor dynamic RAM refresh are available in the "FAST" rate mode. (Both are avaiable in SLOW and A.D. rate modes). |

When changing between any two of the three rate modes, the following procedures must be followed to ensure that MPU timing specifications are met:

```
| Rate Mode |                                                                                     |
|-----------|-------------------------------------------------------------------------------------|
|Slow       | * - Set R0 * - Set R1    /                                    This direct path is / |
|A.D.       |  \          \         / * - Sequence #1         *          not allowed except by /  |
|FAST       |              \       * - Set R0, then Clear R1   \ - Set R1      Hardware reset *   |
```

```
              May be ANY address from $0000 to $7FFF.
SEQUENCE #1:
7D 00 00 TST #$0000 … Synchronizes STA instruction to write during T2-TG (See Figure #8).*
21 0 0   BRN 00
B7 FF D6 STA #SFFD6 … Clears bit RO
```

*Note: "TST" instruction affects MC6809E condition code register.

### Changing the MPU Rate (In Address Dependent Mode)

When the SAM control register bits "R1", and "R0" are programmed to "0" and "1", respectively, the Address Dependent Rate Mode is selected. In this mode, the ÷ 16 MPU rate is automatically used when addressing within $0000 to $7FFF* or SFF00 to $FF1F ranges. Otherwise the ÷ 8 MPU rate is automatically used. (Refer to Figure 8 for sample "E" and "Q" waveforms yielding ÷ 8 to ÷ 16 and ÷ 16 to ÷ 8 rate changes). This mode often nearly doubles the MPU throughput while still providing transparent VDG and dynamic, RAM refresh functions. For example, since much of the MPU's time may be spent performing internal MPU functions (address = $FFFF)**, accessing ROM (address = $8000 to $FEFF) or accessing 1/0 (address = $FF20 - $FF5F), the faster f crystal ÷ 8 MPU rate may be used much of the time.

Note: The VDG operates normally when using the SLOW or A.D. rate modes. However, in the FAST rate mode, the VDG is not allowed access to

### Figure 8 — Rate Change E and E waveforms

```
        ------- Fast --------  ------------------ Slow ---------------  - Fast -
       /                     \/                                       \/        \
      E__|‾‾‾|___|‾‾‾|___|‾‾‾|_______|‾‾‾‾‾‾|_____|‾‾‾‾‾‾|_____|‾‾‾‾‾‾|_____|‾‾‾‾‾
      Q‾‾‾‾|___|‾‾‾|___|‾‾‾|_____|‾‾‾‾‾‾‾|_____|‾‾‾‾‾‾|_____|‾‾‾‾‾‾|______|‾‾‾‾|__
"slow" detected address here ^               "Fast" address detected here ^
```
*When using Memory Map 0, addresses $0000 to $7fff may access Dynamic RAM.

**The MC6809 Outputs $ffff on A0-A15 when no other valid addresses are being presented.

# SN74LS783 / MC6883 / SN74LS785

## Oscillator Section

In Figure 4, an amplifier between $\text{Osc}_{\text{In}}$ and $\text{Osc}_{\text{Out}}$ provides the gain for oscillation (using a crystal as shown in Figure 9). Alternately, Pin 5 ($\text{Osc}_{\text{In}}$) may be grounded while Pin 6 ($\text{Osc}_{\text{Out}}$) may be driven at low-power Schottky levels as shown in Figure 10. Also, see $V_{IH}$, $V_{IL}$ on page 2.

---

### Oscillator Timing Diagram & AC Specifications

```
2.0 V  +----------------+                +----------------+
                |                |                |                |
         0.8 V -+                +----------------+                +----------------
                |<-- tpH(Osc) -->|<-- tpL(Osc) -->|
                |<------------------ tcyc(Osc) ------------------->|
```

| AC Specifications* | Min | Typ | Max | Units |
| :--- | :---: | :---: | :---: | :---: |
| **$t_{pH(Osc)}$** | 22 | 30 | — | ns |
| **$t_{pL(Osc)}$** | 22 | 30 | — | ns |
| **$t_{cyc(Osc)}$** | 62.4 | 70 | — | ns |

---

### FIGURE 9 – Crystal Oscillator Circuit & Parameters

```
             +-------------------------------------------------------------+
             |                         SAM / MC6883                        |
             |                                                             |
             |   Pin 5 (Osc_in)                        Pin 6 (Osc_out)     |
             +-------+-------------------------------------+-------+-------+
                     |                                     |       |
                     |                                    [R1]     |
                     |                                     |      [CV]
                    [R2]                                   +-------+
                     |                                     |       |
                     +---------------------[X1]------------+      [CF]
                     |                                             |
                    [R3] (Optional Duty Adj.)                      |
                     |                                             |
                    GND                                           GND
```

#### Equivalent Crystal Circuit

#### Suggested Component Values

| Freq. (MHz) | $C_V$ | $C_F^*$ | $R_1^*$ | $R_2$ | $R_3$ | $X_1$ |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **14.31818** | 2.5–30 pF | 33 pF | 1.5 k$\Omega$ | 100 k$\Omega$ | 10 k$\Omega$ | See Below |
| **16.0000** | 2.5–30 pF | 33 pF | 1.5 k$\Omega$ | 100 k$\Omega$ | 10 k$\Omega$ | See Below |

#### Recommended Crystal Parameters

| Parameter | 14.31818 MHz** | 16.0000 MHz** |
| :--- | :---: | :---: |
| **$R_S$** | $10\,\Omega \pm 2.0\,\Omega$ | $10\,\Omega \pm 2.0\,\Omega$ |
| **$C_0$** | $5.0\,\text{pF} \pm 1.5\,\text{pF}$ | $6.0\,\text{pF} \pm 1.0\,\text{pF}$ |
| **$C_1$** | $0.0245\,\text{pF} \pm 15\%$ | $0.0319\,\text{pF} \pm 15\%$ |
| **$L_1$** | $5.05\,\text{mH}$ | $3.1\,\text{mH}$ |
| **$Q$** | $50\text{K} \pm 10\text{K}$ | $40\text{K} \pm 10\text{K}$ |

- **Calibration Tolerance:** $0.002\%$ at $26^\circ\text{C}$
- **Temperature Tolerance:** $0.001\%$ ($0^\circ\text{C}$ to $70^\circ\text{C}$)

---

### FIGURE 10 – TTL Clock Input Circuit

```
                 +---------------------------+
                 |        SAM / MC6883       |
                 |                           |
GND ---------------> Pin 5 (Osc_in)            |
|                           |
TTL Clock          |                           |
(74LS00) --[ R4 ]--> Pin 6 (Osc_out)           |
| (Used as an input)        |
+---------------------------+
> *$R_4 = 200\,\Omega$ Typ., $50\,\Omega$ Min.*
```
---

### Notes & Footnotes

- Typical input capacitances are **3.0 pF** for Pin 5 and **5.5 pF** for Pin 6.
- **\*** Optimum values depend on characteristics of the crystal ($X_1$). For many applications, $V_{Clk}$ must be $3.579545\text{ MHz} \pm 50\text{ Hz}$! Hence, $\text{Osc}_{\text{Out}}$ must be made similarly "drift resistant" (by balancing temperature coefficients of $X_1$, $C_V$, $C_F$, $R_1$, $R_2$, and $R_3$).
- **\*\* ** Specifically cut for the SAM are International Crystal Manufacturing, Inc. Crystals (#167568 for 14.31818 MHz or #167569 for 16.0 MHz). However, other crystals may be used.

## Video or No Video

### THEORY OF OPERATION

Although the SAM may be used as a dynamic RAM controller without a video display, most applications are likely to include a MC6847 video display generator (VDG). Therefore, this document emphasizes use of the SAM with MC6847 systems.

### Shared RAM (with interleaved DMA)

To minimize the number of RAM and interface chips, both the MPU and VDG share common dynamic RAM. Yet, the use of common RAM creates an apparent difficulty. That is, the MPU and VDG must both access the RAM without contention. This difficulty is overcome by taking advantage of the timing and architecture of Motorola MPU's (MC6800, MC6801E, MC6809E, MC68000). Specifically, all MPU accesses of external memory always occur in the latter half of the machine cycle, as shown below:

#### FIGURE 11 — MOTOROLA MPU TIMING

```
              ┌───────────────────── One Machine Cycle ─────────────────────┐
              │                                                             │
'E' Clock:    ┌───────────────────────────────┐                             ┌───────────────────────────────┐
(Approx. 1MHz)│                               │                             │                               │
              └───────────────────────────────┴─────────────────────────────┴───────────────────────────────┴────────
              └───────────────────┬───────────┘                             └───────────────────┬───────────┘
                                  │           │                                                 │           │
                                MPU Address  MPU Data                                         MPU Address  MPU Data
                                             Window                                                        Window
```

---

Similarly, the MC6847 (non-interlaced) VDG transfers a data byte in a half machine cycle ($E$ or $Q$). Thus, when properly positioned, VDG and MPU RAM accesses interleave without contention as shown below:

#### FIGURE 12 — MOTOROLA MPU WITH VDG TIMING

```
                                  ┌───────────────────────────┐   ┌─────────┐   ┌───────────────────────────┐   ┌─────────┐
                                  │   VDG Address             │   │VDG Data │   │   VDG Address             │   │VDG Data │
                                  │                           │   │ Window  │   │                           │   │ Window  │
                                  └───────────────────────────┘   └─────────┘   └───────────────────────────┘   └─────────┘
'E' Clock:    ┌───────────────────────────────┐                             ┌───────────────────────────────┐
(Approx. 1MHz)│                               │                             │                               │
              └───────────────────────────────┴─────────────────────────────┴───────────────────────────────┴────────
              │                               │                             │               │               │
              └───────────────────┬───────────┘                             └───────┬───────┴───────┬───────┘
                                  │           │                                     │               │
                                MPU Address  MPU Data                            MPU Half       VDG Half
                                             Window                         ┌───────────────┐
                                                                            │  MPU Address  │ MPU Data Window
```

---

This Interleaved Direct Memory Access (IDMA) is synchronized via the MC6883 by centering the VDG data window half-way between MPU data windows.*

The result is a shared RAM system without MPU/VDG RAM access contention, with both MPU and VDG running uninterrupted at normal operating speed, each transparent to the other.

### RAM Refresh

Dynamic RAM refresh is accomplished by accessing eight** sequential row addresses every 64** microseconds until all addresses have been accessed. To avoid RAM access contention between REFRESH and MPU, each of the refresh accesses occupies the "VDG half" of the interleaved DMA (IDMA). Furthermore, refresh accesses occur only during the television retrace period (at which time the VDG doesn't need to access RAM).

In summary, the VDG, MPU and SAM's Refresh Counter all transparently access the common dynamic RAM without contention or interruption.

### Why IDMA?

Use of the interleaved direct memory access results in fast modification to variable portions of display RAM, by the MPU, without any distracting flashes on the screen (due to RAM access contention). In addition, the MPU is not slowed down nor stopped by the SAM; thereby, assuring accurate software timing loops without costly additional hardware timers. Furthermore, additional hardware and software to give "access permission" to the MPU is eliminated since the MPU may access RAM at any time.

---

\* Only 1 pin, (DA0) out of 40 pins is dedicated to the video display.  
** See VDG synchronization (page 10) for more detail.  
*** When not using a MC6847, $	ext{HS}$ may be wired low for continuous transparent refresh.


## "Systems On Silicon" Concept

### Total Timing
For most applications, the SAM can supply complete system timing from its on-chip precision 14.31818 MHz oscillator. This includes buffered MPU clocks (E and Q), VDG clock, color subcarrier (3.58 MHz), row address select (RAS), column address select (CAS) and write enable (WE).

### Total Address Decode
For most applications, the SAM plus a "1 of 8 decoder" chip completely decodes I/O, ROM and RAM chip selects without wasting memory address space and without needlessly chopping-up contiguous address space. Chip selects are positioned in address space to allow three types of memory (RAM, local ROM and cartridge ROM) independent room for growth. For example, RAM may grow from address $0000-up, cartridge ROM may grow from address $FEFF-down and local ROM may grow from $BFFF-down. Alternately, if the application requires minimum ROM and maximum contiguous RAM, a second choice of two memory maps places RAM from $0000 to $FEFF. (See Figures 14-16.)

In both memory maps all I/O, MPU vectors, SAM control registers, and some reserved address spaces are efficiently contained between addresses $FF00 and $FFFF.

### How Much RAM?
Using nine SAM pins ($Z_0$–$Z_7$ and $\text{RAS}_0$) the following combinations require no additional address logic.

#### FIGURE 13 — RAM CONFIGURATIONS

| Address Pins (MSB → LSB) | Chip Select | Memory Configuration |
| :--- | :--- | :--- |
| $Z_5\,Z_4\,Z_3\,Z_2\,Z_1\,Z_0$<br>$Z_5\,Z_4\,Z_3\,Z_2\,Z_1\,Z_0$ | $\text{RAS}_0$<br>$\text{RAS}_1\,(=Z_7)$ | One or two banks of $4\text{K}\times 8$ (like MCM4027's) |
| $Z_6\,Z_5\,Z_4\,Z_3\,Z_2\,Z_1\,Z_0$<br>$Z_6\,Z_5\,Z_4\,Z_3\,Z_2\,Z_1\,Z_0$ | $\text{RAS}_0$<br>$\text{RAS}_1\,(=Z_7)$ | One or two banks of $16\text{K}\times 8$ (like MCM4116's) |
| $Z_7\,Z_6\,Z_5\,Z_4\,Z_3\,Z_2\,Z_1\,Z_0$ | $\text{RAS}_0$ | One bank of $64\text{K}\times 8$ (like MCM6665's) or one bank of $16\text{K}\times 4$ (like TMS4416's) |

---

### SAM Programmability

#### PROGRAMMING GUIDE
The SAM contains a 16-bit control register which allows the MC6809E to program the SAM for the following options:

* **VDG Addressing Mode:** 3-bits
* **VDG Address Offset:** 7-bits
* **32K Page Switch:** 1-bit
* **MPU Rate:** 2-bits
* **Memory Size:** 2-bits
* **Map Type:** 1-bit

Note that when the SAM is reset by first applying power or by manual hardware reset,\* all control register bits are cleared (to a logic "0").

---

### VDG Addressing Mode
Three bits ($V_2, V_1, V_0$) control the sequence of **DISPLAY ADDRESSES** generated by the SAM (which are used to scan dynamic RAM for video information). For example, if you wish to display Dynamic RAM data as **INTERNAL ALPHANUMERICS VIDEO**, you should program the MC6847 for the **INTERNAL ALPHANUMERICS MODE**\*\* and **CLEAR BITS $V_2, V_1\text{ and }V_0$** in the SAM. The table on the following page summarizes the available modes:

---

#### Footnotes
\* See Figure 7 for manual reset circuit.  
\*\* Typically, part of a PIA (MC6821) at location $FF22 is used to control MC6847 modes. (See MC6847 Data Sheet.)

# SN74LS783/MC6883 • SN74LS785

## Mode Selection

```
  Mode Type                  G/A  GM2+   GM1+    GM0+ EXT/I  CSS    V2   V1   V0
  ------------------------ ----- ------ ------ ------------ ----- ---- ---- ----
  Internal Alphanumerics       0   X      X               0   X      0    0    0
  External Alphanumerics       0   X      X               1   X      0    0    0
  OSemigraphics --- 4          0   X      X               0   X      0    0    0
  Semigraphics --- 6           0   X      X               1   X      0    0    0
  Semigraphics --- 8\*         0   X      X               0   X      0    1    0
  Semigraphics --- 12\*        0   X      X               0   X      1    0    0
  Semigraphics --- 24\*        0   X      X               0   X      1    1    0
  Full Graphics --- 1C         1   0      0               0   X      0    0    1
  Full Graphics --- 1R         1   0      0               1   X      0    0    1
  Full Graphics --- 2C         1   0      1               0   X      0    1    0
  Full Graphics --- 2R         1   0      1               1   X      0    1    1
  Full Graphics --- 3C         1   1      0               0   X      1    0    0
  Full Graphics --- 3R         1   1      0               1   X      1    0    1
  Full Graphics --- 6C         1   1      1               0   X      1    1    0
  Full Graphics --- 6R         1   1      1               1   X      1    1    0
  Direct Memory Access†        X   X      X               X   X      1    1    1
```

\* S8, S12, S24 modes are not described in the MC6847 Data Sheet. See
appendix "A".

† DMA is identical to 6R except as shown in Figure 5 on page 9.

‡ The function of the external control bits differs on the T1 version of
the 6847. See the MC6847T1 data sheet for details.

## VDG Address Offset

Seven bits (F6, F5, F4, F3, F2, F1 and F0) determine the **Starting
Address** for the video display. The "Starting Address" is defined as
"the address corresponding to data displayed in the Upper Left corner of
the TV screen." The "Starting Address" is shown below in binary:

``` text
F6 F5 F4 F3 F2 F1 F0  0  0  0  0  0  0  0  0  0
```

**Most Significant Bit:** F6

**Least Significant Bit:** the rightmost bit (bit 0 of the address)

Note that the "Starting Address" may be placed anywhere within the 64K
address space with a resolution of 1/2K (the size of one alphanumeric
page).

## Page Switch

One bit (P1) is used "in place of" A15 from the MC6809E in order to
refer access within \$0000-\$7FFF to one of two 32K byte pages of RAM.
For systems using the LS783 and 32K bytes of RAM or less, the Page bit
serves no useful function and is a "don't care." The LS785 uses the Page
bit in conjunction with the memory size bits to determine whether 16K ×
1 or 16K × 4 DRAM is being accessed. P1 is set for 16K × 4 and cleared
for 16K × 1. The Page bit must also be cleared for the LS785 to function
with 4K × 1 DRAMs.


## MPU Rate

Two bits ($R_1, R_0$) control the clock rate to the MC6809E MPU. The options are:

| R1 | R0 | Rate (Frequency of "E" Clock) |
| :---: | :---: | :--- |
| 0 | 0 | 0.9 MHz (Crystal Frequency $\div$ 16) Slow |
| 0 | 1 | 0.9 / 1.8 MHz (Address Dependent Rate) |
| 1 | X | 1.8 MHz (Crystal Frequency $\div$ 8) Fast |

*(Typical Crystal Frequency: 14.31818 MHz)*

In the "address dependent rate" mode, accesses to `$0000`–`$7FFF` and `$FF00`–`$FF1F` are slowed to 0.9 MHz (crystal frequency $\div$ 16) and all other addresses are accessed at 1.8 MHz (crystal frequency $\div$ 8).

> **Note:** "Slow" (0.9 MHz) operation can be accomplished using 1.0 MHz MC6809E and MC6821 devices. For "Fast" (1.8 MHz) operation, 2.0 MHz MC68B09E and MC68B21 devices must be used.

---

## Memory Size

Two bits ($M_1$ and $M_0$) determine RAM memory size. The options are:

| M1 | M0 | Size |
| :---: | :---: | :--- |
| 0 | 0 | One or two banks of $4	ext{K}	imes1$ dynamic RAMs |
| 0 | 1 | One or two banks of $16	ext{K}	imes1$ dynamic RAMs |
| 0 | 1 | One bank of $16	ext{K}	imes4$ dynamic RAMs$^1$ |
| 1 | 0 | One bank of $64	ext{K}	imes1$ dynamic RAMs |
| 1 | 1 | Up to 64K static RAM* |

$^1$ *This option is only available when using the LS785.*  
\* *Requires a latch for demultiplexing the RAM address.*

> **IMPORTANT!**  
> **Note:** Be sure to program the SAM for the correct memory size before using RAM (i.e., for a subroutine stack).

---

## Map Type

One bit ($TY$) is used to select between two memory map configurations. Refer to Figures 14–16 for details.

Early versions of the LS783 did not allow the "Fast" MPU rate to be used in conjunction with Map Type $TY=1$. Devices manufactured after January 1, 1983 allow both "Fast" and "Slow" MPU rates to be used with Map Type $TY=1$. *(Date of manufacture is marked on devices as YYWW, where YY is the year and WW is the week of manufacture).*

---

## Writing To The SAM Control Register

Any bit in the control register (CR) may be set by writing to a specific unique address. Each bit has two unique addresses: writing to the even-numbered address clears the bit, and writing to the odd-numbered address sets the bit. *(Data on the data bus is irrelevant in this procedure.)* The specific addresses are tabulated in Figures 14–16.

If desired, a short routine may be written to program the SAM CR "a word at a time." For example, the following routine copies $B$ bits from $A$ register to SAM CR addresses beginning with address $X$:

```assembly
SAM1    46          ROR   A
        24 06       BCC   SAM2
        30 01       INX            ; (LEAX 1,X)
        A7 80       STA   0,X-
        20 02       BRA   SAM3
SAM2    A7 81       STA   0,X++
SAM3    5A          DEC   B
        26 F2       BNE   SAM1
        39          RTS
```

### Figure 14 — Memory Map Type #0
```
Type 0:
| Page 0:
| | S=0 $0000 to $7fff (RAM)
| | S=1 $8000 to $9fff (ROM0)
| | S=2 $a000 to $bfff (ROM1)
| | S=3 $c000 to $feff (ROM2)
| | S=4 $ff00 to $ff1f (I/O0)
| | S=5 $ff20 to $ff3f (I/O1)
| | S=6 $ff40 to $ff5f (I/O3)
| | S=7 $ff60 to $ffdf (I/O4) also used internally to set/reset SAM registers
| | S=2 $ffe0 to $ffff (ROM1) purpose: grab CPU vectors from ROM1)

| Page 1:
| | S=0 $0000 to $7fff (RAM) if reading
| | S=7 $0000 to $7fff (RAM) if writing
| | S=1 $8000 to $9fff (ROM0)
| | S=2 $a000 to $bfff (ROM1)
| | S=3 $c000 to $feff (ROM2)
| | S=4 $ff00 to $ff1f (I/O0)
| | S=5 $ff20 to $ff3f (I/O1)
| | S=6 $ff40 to $ff5f (I/O3)
| | S=7 $ff60 to $ffdf (I/O4) also used internally to set/reset SAM registers
| | S=2 $ffe0 to $ffff (ROM1) purpose: grab CPU vectors from ROM1)
```
### Figure 15 — Memory Map Type #1
```

Type 1:
| Page 1 and 0:
| | S=0 $0000 to $7fff (RAM) if reading
| | S=7 $0000 to $7fff (RAM) if writing
| | S=0 $8000 to $9fff (RAM) if reading
| | S=1 $8000 to $9fff (RAM) if writing
| | S=0 $a000 to $bfff (RAM) if reading
| | S=2 $a000 to $bfff (RAM) if writing
| | S=0 $c000 to $feff (RAM) if reading
| | S=3 $c000 to $feff (RAM) if writing
| | S=4 $ff00 to $ff1f (I/O0)
| | S=5 $ff20 to $ff3f (I/O1)
| | S=6 $ff40 to $ff5f (I/O3)
| | S=7 $ff60 to $ffdf (I/O4) also used internally to set/reset SAM registers
| | S=2 $ffe0 to $ffff (ROM1) purpose: grab CPU vectors from ROM1)
```
---

### FIGURE 17 — MEMORY ALLOCATION TABLE
*(Also, see the memory MAPs on pages 17 and 18.)*

#### Type #0: (Primarily for ROM based systems)

| Address Range | S=4(S2)+2 (S1)+S0 S Value|Intended Use |
| :--- | :--- | :--- |
| **$FFF2 to $FFFF** | 2 | MC6809E Vectors: Reset, NMI, SWI, IRQ, FIRQ, SWI2, SWI3. |
| **$FFE0 to $FFF1** | 2 |  Reserved for future MPU enhancements. |
| **$FFC0 to $FFDF** | 7 |  SAM Control Register: $V_0 - V_2$, $F_0 - F_6$, P, $R_0, R_1$, $M_0, M_1$, TY. |
| **$FF60 to $FFBF** | 7 |  Reserved for future control register enhancements. |
| **$FF40 to $FF5F** | 6 |  $I/O_2$: Input/Output (PIAs, ACIAs, etc.) To subdivide, use A0–A4. |
| **$FF20 to $FF3F** | 5 |  $I/O_1$: Input/Output (PIAs, ACIAs, etc.) To subdivide, use A0–A4. |
| **$FF00 to $FF1F** | 4 |  $I/O_0$: Input/Output (PIAs, ACIAs, etc.) To subdivide, use A0–A4. |
| **$C000 to $FEFF** | 3 |  ROM2: 16K addresses. External cartridge ROM*. |
| **$A000 to $BFFF** | 2 |  ROM1: 8K addresses. Internal ROM*. Note that MC6809E vector addresses select this ROM*. |
| **$8000 to $9FFF** | 1 |  ROM0: 8K addresses. Internal ROM*. |
| **$0000 to $7FFF** | 0 if R/W = 1, 7 if R/W = 0 |  RAM: 32K addresses. RAM shared by MPU and VDG. |

*\*Not restricted to ROM. For example, RAM or I/O may be used here.*

---

#### Type #1: (Primarily for RAM based systems)

| Address Range | S=4(S2)+2 (S1)+S0 S Value | Intended Use |
| :--- | :--- | :--- |
| **$FFF2 to $FFFF** | 2 | MC6809E Vectors: Reset, NMI, SWI, IRQ, FIRQ, SWI2, SWI3. |
| **$FFE0 to $FFF1** | 2 | Reserved for future MPU enhancements. |
| **$FFC0 to $FFDF** | 7 | SAM Control Register: $V_0 - V_2$, $F_0 - F_6$, P, $R_0, R_1$, $M_0, M_1$, TY. |
| **$FF60 to $FFBF** | 7 | Small ROM: Boot load program and initial MC6809 vectors. |
| **$FF40 to $FF5F** | 6 | $I/O_2$: Input/Output (PIAs, ACIAs, etc.) To subdivide, use A0–A4. |
| **$FF20 to $FF3F** | 5 | $I/O_1$: Input/Output (PIAs, ACIAs, etc.) To subdivide, use A0–A4. |
| **$FF00 to $FF1F** | 4 | $I/O_0$: Input/Output (PIAs, ACIAs, etc.) To subdivide, use A0–A4. |
| **$0000 to $FEFF** | 0 if R/W = 1 | RAM: 64K(-256) addresses, shared by MPU and VDG.<br>*(If $R/\overline{W}=0$ then $S=3$ for $C000–$FEFF; $S=2$ for $4000–$BFFF; $S=1$ for $8000–$9FFF and $S=7$ for $0000–$7FFF.)* |



