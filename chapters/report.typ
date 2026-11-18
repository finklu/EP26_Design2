= Task Description
The objective is the complete hardware design of a cost-effective evaluation board for the Texas Instruments MSP430F5659IPZ microcontroller in Altium Designer.
== System & Functional Requirements
- *Target MCU & Clocks:* The evaluation board is built around the 100-pin MSP430F5659 microcontroller which is operated with a $32.768 "kHz"$ crystal (XT1) and a high-speed oscillator  on XT2 for system and USB PLL clocking.
- *USB 2.0 Hub & Emulation:* A single USB Type-C host port is connected via a 4-port USB hub (TUSB2046B) to both the target MCU and an on-board eZ-FET Lite programmer/debugger.
- *Power Supply & UI:* The board uses exclusive USB 2.0 bus-powered operation ($5 "V"$) with a step-down converter, alongside status LEDs and push buttons for reset, BSL invocation, and user I/O.
- *Breakout Headers:* All remaining target peripherals (USCIx SPI/UART/I2C, ADC12_A, DAC12_A, timer PWM, clock inputs, and MCLK) are routed to $2.54 "mm"$ socket headers.

== Layout, Verification & Manufacturing Outputs
- *PCB Layout:* The design uses a cost-optimized multi-layer stackup with through-hole vias exclusively, inner supply/GND planes and polygons, impedance-controlled USB differential pairs, and sufficient EMI decoupling.
- *Manufacturing Outputs:* Design rules are verified according to Eurocircuits Class 6C, followed by the generation of full fabrication, assembly and BOM documentation.

= Schematic Design Considerations
== Supply Circuit
For the supply of the evaluation board, the TPS62237DRYR step-down converter is used. This buck-converter with its small USON-package is designed for low-power applications and provides a peak output current of up to 500 mA. The converter has a fixed output voltage of 3.3 V with an input voltage range of 2.05 V to 6 V. A buck converter was chosen over an LDO because of its higher efficiency and lower power dissipation. The EN-pin is directly tied to VBUS_5V for automatic startup at USB connection. The design was created as described in the "Detailed Design Procedure" in @TI_TPS62230.
=== Inductor Selection
The TPS62237DRYR is optimized to operate with an inductance of $L=1.0 "µH" "/" 2.2 "µH" $. The saturation current of the selected inductor must be rated higher than the maximum inductor current calculated in @eq:saturation-current @TI_TPS62230[Eq. 4] and @eq:inductor-current @TI_TPS62230[Eq. 5] calculates the inductor current ripple.
$
  Delta I_L = V_("out") frac(1 - frac(V_("out"), V_("in")), L  f) = 3.3 frac(1 -frac(3.3, 5), 2.2 dot 2.25) = 0.226 A
$ <eq:inductor-current>

$
  I_("Lmax") = I_("outmax") + frac(Delta I_L, 2) = 0.5 + frac(0.226, 2) = 0.613 A
$ <eq:saturation-current>
The efficiency of the converter is mostly dependent on the inductor AC resistance (its quality factor) and also by its inductor DCR value. According to @TaiyoYuden_BRC2012T2R2MD the  used inductor "BRC2012T2R2MD" has a saturation current of 1.1 A and a rated current of 1 A, therefore suited for this design.

=== Input and Output Capacitor Selection
Ceramic capacitors with low ESR values give the lowest output voltage ripple and are recommended by the TPS62237DRYR design. Additionally the output capacitor requires at least an X5R dielectric. The design procedure recommends a 4.7 µF capacitor for input and output. 

#pagebreak()

== USB HUB
The Texas Instruments TUSB2046BIRHBT is a 3.3 V CMOS 4-port USB 2.0 full-speed hub controller which requires no external firmware programming @TI_TUSB2046B. It connects the single upstream USB-C host interface via HUB0_D_P/HUB0_D_N to two on-board downstream devices: the target microcontroller  and the eZ-FET Lite emulator.

=== Power Mode, EEPROM & Overcurrent Configuration
Because the evaluation board is powered exclusively through the upstream USB-C port within the 500 mA USB 2.0 bus budget, the BUSPWR pin is tied high to EZ_3V3 to configure the hub in bus-powered mode. Additionally the optional serial EEPROM interface is disabled by pulling the EXTMEM pin high to EZ_3V3 via $10 "k"Omega$.
With EXTMEM pulled high, Pin 6 acts as EEDATA/GANGED and is pulled up to EZ_3V3 via $10 "k"Omega$ to select ganged power-management mode. OVRCUR1--OVRCUR4 pins are pulled up to EZ_3V3 through $10 "k"Omega$ to prevent overcurrent fault conditions.

=== Clock Generation
The TUSB2046B operates from a 6 MHz reference clock using its internal PLL to generate the 48 MHz USB sampling clock. Therefore, both TSTMODE and TSTPLL/48MCLK  are tied to GND, and the 6 MHz ceramic resonator  (Murata CSTCR6M00G53-R0) with integrated $15 "pF"$ load capacitors is connected. A $1.5 "k"Omega$ damping resistor is placed in series with `XTAL2` to prevent overdriving the ceramic resonator and ensure reliable startup across supply and temperature variations.

=== Power-On Reset
The active-low RESET pin requires a low pulse width between $100 "µs"$ and $1 "ms"$ after `EZ_3V3` reaches 90% of its nominal $3.3 "V"$ level, with the 6 MHz clock stable during the final $60 "µs"$ of the reset window @TI_TUSB2046B. Therefore, the RC network consisting of $47 "k"Omega$ and $100 "nF"$ is connected to RESET.

$ tau = R dot C = 47 "k"Omega dot 100 "nF" = 4.7 "ms" $ <eq:reset-rc>

Using the CMOS positive-going input threshold $V_(I T+) approx 1.8 "V"$ @TI_TUSB2046B[p. 7] at $V_(C C) = 3.3 "V"$:

$ t_("reset") = -tau dot ln(1 - V_(I T+) / V_(C C)) = -4.7 "ms" dot ln(1 - (1.8 "V") / (3.3 "V")) approx 3.7 "ms" $ <eq:reset-time>

This $3.7 "ms"$ hold time exceeds the minimum $100 "µs"$ reset requirement so the oscillator can stabilize.

=== USB 2.0 Signal Integrity & Termination
To adequately suppress electromagnetic interference (EMI) in accordance with the TUSB2046B typical application circuit @TI_TUSB2046B[p. 16], the following termination and protective components are used in the design:
- *Termination* $27 thin Omega$ series resistors on upstream and downstream ports
- *EMI Filtering:* $22 "pF"$ filter capacitors are connected to GND for all USB data lanes.
- *Upstream Pull-Up & ESD Protection:* A $1.5 "k"Omega$ resistor pulls DP0 to EZ_3V3 to identify the hub as a full-speed USB device to the host. Moreover a  TVS diode array (TPD2E009DBZR) protects the  USB-C data lines against ESD transients.
- *Downstream Pull-Downs:* Active downstream ports (HUB1 and HUB2) include $15 "k"Omega$ pull-down resistors to GND for host disconnect detection. Unused downstream ports (HUB3 and HUB4) are terminated to GND via $15 "k"Omega$ resistors.
 

== UI
=== Indicator LEDs
Five status LEDs are driven directly by general-purpose I/O pins of the MCU. Each LED is placed in series with a $470 thin Omega$ resistor to limit GPIO sink/source current. The red LED (APTD1608LSECK/J3-PF) has the smallest forward voltage $V_F = 1.8 "V"$, therefore experiences the highest forward current.

$
  I_F = frac(V_("3V3") - V_F, R_s) = frac(3.3 "V" - 1.8 "V", 470 Omega) = 3.19 "mA"
$ <eq:led-current>


== MCU
The target microcontroller is the Texas Instruments MSP430F5659IPZ in a 100-pin PZ package @TI_MSP430F5659.

=== Power Supply & Internal Regulator Decoupling
To satisfy the recommended operating conditions of the MSP430F5659, all digital and analog supply pins are powered from the 3V3 rail so that the voltage difference between AVCC and DVCC remains within the $0.3 "V"$ maximum limit during power-up and operation. Each supply pin is decoupled with $100 "nF"$ capacitors.
Because no external backup battery is used, the battery backup supply input VBAT is tied directly to 3V3. Additionally the internal backup domain supply node VBAK is decoupled with $4.7 "nF"$ @TI_MSP430F5659[p. 24]. The integrated linear regulators VCORE @TI_MSP430F5659[p. 24] and USB supply pins are decoupled according to datasheet specifications VBUS and VUSB @TI_MSP430F5659[p. 59].


=== Clock Generation
The Unified Clock System (UCS) uses two external crystals:
- *High-Frequency Oscillator XT2:* A $12 "MHz"$ 3-pin oscillator (CSTNE12M0GH5C000R0) with integrated load capacitors drives XT2IN and XT2OUT. This $12 "MHz"$ reference satisfies the $> 8 "MHz"$ input requirement @TI_MSP430F5659[p. 34] for the internal USB PLL and is supported by the preprogrammed factory USB Bootloader (BSL) @TI_SLAU319AF[p. 22].
- *Low-Frequency Oscillator XT1:* A $32.768 "kHz"$ crystal (MC-306 32.7680K-A0 ROHS) is connected across XIN and XOUT and also integrates internal load capacitors.

=== USB Interface & Bootloader (BSL) Control
The target MCU communicates with downstream port 1 of the USB hub. Signal integrity and EMI suppression are ensured by $27 thin Omega$ series termination resistors  and $22 "pF"$ filter capacitors. A $1.4 "k"Omega$ resistor connects the PUR pin to the USB DP line and the TARGET_PUR net. 

=== Debug Interface
Programming and debugging are supported via the 2-wire Spy-Bi-Wire interface using RST/NMI/SBWTDIO  and TEST/SBWTCK, which connect directly to the on-board eZ-FET Lite emulator. The four standard JTAG signals are broken out to test points on the top-level sheet for optional external JTAG probing.


== Top Level Design Choices

 - *USB receptacle:* A USB 2.0 Type-C receptacle (629722000214) supplies VBUS_5V and routes the upstream differential pair to U_Hub, with D+1/D+2 and D-1/D-2 shorted for reversible plug orientation. CC1 and CC2 are each pulled down via $5.1 "k"Omega$ resistors as described in the USB specification @USB_TypeC_R2_0.
- *Power Isolation Jumper:* A 2-pin jumper (61300211121) separates the converter output EZ_3V3  from the target rail 3V3 , allowing isolated current measurement and debugging of the target MCU.
- *Expansion Headers:* Three 20-pin dual-row headers (61302021121) break out the free GPIO, analog, timer PWM, clock , and USCI interfaces.
- *Testability:* Dedicated test points are placed on the four JTAG lines, the four emulator UART lines, and GND for oscilloscope probe clips.
= PCB Layout
== Layer Stackup
To meet the $1.6 "mm"$ maximum board thickness constraint while balancing routing density on the $60 dot 90 "mm"$ board a Eurocircuits standard pool 4-layer build-up is used which can be seen in @tab:layer-stack.

#figure(
  table(
    columns: (auto, 1fr, auto),
    align: (left, left, right),
    stroke: 0.5pt + luma(200),
    fill: (_, row) => if row == 0 { luma(230) } else if calc.odd(row) { luma(250) } else { none },

    table.header[*Layer*][*Material / Type*][*Thickness in mm*],
    [TOP], [Copper / Signal], [0.035],
    [Dielectric 1], [Prepreg  PR7628], [0.360],
    [GND], [Copper / Signal], [0.035],
    [Core], [FR-4 Improved], [0.710],
    [POWER], [Copper / Signal], [0.035],
    [Dielectric 2], [Prepreg PR7628], [0.360],
    [BOTTOM], [Copper / Signal ], [0.035],
  ),
  caption: [Selected 4-layer stack-up (Eurocircuits standard pool)],
) <tab:layer-stack>

*Stackup Selection Considerations:*
A 4-layer stack-up was chosen over a 2-layer board because it provides an uninterrupted GND reference plane on layer 2 directly beneath the TOP layer for controlled-impedance USB 2.0 differential pairs. Moreover, dedicated layer 3 can be used as a dedicated POWER layer.
Both inner layers are defined as signal layers rather than planes in Altium Designer so that multiple supply nets (EZ_3V3, 3V3, VBUS_5V) can be implemented cleanly using poured copper polygons.
== Design Rules & Manufacturing Constraints
All PCB design rules were configured according to Eurocircuits Pattern Class 6 and Drill Class C @Eurocircuits_Classification.
- *Standard Via Dimensions:* A single through-hole via definition with a $0.25 "mm"$ finished hole diameter ($0.35 "mm"$ drill tool size) and $0.60 "mm"$ pad diameter is used across the entire board, giving an inner annular ring of $(0.60 "mm" - 0.35 "mm") / 2 = 0.125 "mm"$ that satisfies Eurocircuits Class 6C.
- *Via-in-Pad Usage:* Vias placed directly inside pads are specified as capped and filled to prevent solder wicking during reflow soldering @Eurocircuits_ViaInPad.
- *Fine-Pitch Adjustments:* To prevent false DRC errors on the $0.5 "mm"$ pitch footprints,"MinimumSolderMaskSliver" mask sliver is reduced to $0.1 "mm"$.

== Floorplanning, Routing and EMI Measures

=== Floorplanning & Component Placement
The board is separated into functional zones:
- *Left Side (USB, Power & Emulator):* The USB-C receptacle and ESD diode sit at the lower-left edge, followed by the USB hub, the step-down converter kept away from clock resonators and differential pairs and the eZ-FET Lite emulator in the upper-left corner.
- *Right Side (Target MCU & UI):* The target MCU is centered on the right half with its oscillators and decoupling capacitors placed immediately adjacent to its pins, surrounded by the three 20-pin breakout headers. The UART test points are placed between MCU and Emulator for easier routing.
- *Mounting:* Four unplated M2 mounting holes are placed in the board corners.

=== Routing & Power Distribution
- *Impedance-Controlled Differential Pairs:* All USB 2.0 pairs are routed on the Top Layer with a controlled $90 thin Omega$ differential impedance ($W = 0.25 "mm"$, $S = 0.15 "mm"$) directly over the GND plane on layer 2. The series termination resistors and decoupling capacitors are placed as close to the IC as possible
- *Supply & Ground Planes:* Supply rails (VBUS_5V, EZ_3V3, 3V3) are distributed via wide copper polygons on POWER layer.

=== EMI & Documentation Measures
- *Via Stitching & Tenting:* GND stitching vias connect the TOP, GND and BOTTOM ground pours. Via stitchting is also used along differential pairs. All non-test-point vias are tented.
#pagebreak()
= Verification and Output Data

== Design Rule & Manufacturing Verification
Prior to generating manufacturing data, the hierarchical schematic project was compiled with zero Electrical Rule Check (ERC) errors, and a full Design Rule Check (DRC) was executed against the configured Eurocircuits Class 6C rule set.
#figure(
   image("../assets/graphics/report/DRCcheck.png", width: 100%),
   caption: [Altium Designer DRC],
) <fig:altium-drc>
To verify manufacturability, the exported Gerber X2 archive was uploaded to Eurocircuits. The automated analysis confirmed: Compliance with Eurocircuits Pattern Class 6 and Drill Class C.


#figure(
   image("../assets/graphics/report/Eurocircuits.png", width: 100%),
   caption: [Eurocircuits PCB Visualizer verification with technology class 6C.],
) <fig:eurocircuits-drc>



#pagebreak()