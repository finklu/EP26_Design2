= Task Description
This is an example of an introduction chapter. You can write your introduction here. 

= Schematic Design Considerations
== Supply Circuit
For the supply of the evaluation board, the TPS62237DRYR step-down converter is used. This buck-converter with its small USON-package is designed for low-power applications and provides a peak output current of up to 500 mA. The converter has a fixed output voltage of 3.3 V with an input voltage range of 2.05 V to 6 V. A buck converter was chosen over a LDO because it features up to 94% efficiency compared to the ~60% of a LDO alternative.
=== Inductor Selection
The TPS62237DRYR is optimized to operate with an inductance of $L=1.0 "µH" "/" 2.2 "µH" $. The saturation current of the selected inductor must be rated higher than the maximum inductor current calculated in @eq:saturation-current and @eq:inductor-current calculates the inductor current ripple.
$
  Delta I_L = V_("out") frac(1 - frac(V_("out"), V_("in")), L  f)
$ <eq:inductor-current>

$
  I_("Lmax") = I_("outmax") + frac(Delta I_L, 2)
$ <eq:saturation-current>
The efficiency of the converter is mostly on the inductor AC resistance (its quality factor) and also by its inductor DCR value. The selected inductor should have a quality factor above 25 at the switching frequency.

=== Input and Output Capacitor Selection
Ceramic capacitors with low ESR values give the lowest output voltage ripple and are recommended by the TPS62237DRYR design. Additionally the output capacitor requires at least a X5R dielectric. The design procedure recommends a 4.7 µF capacitor for input and output.

#pagebreak()

== USB HUB 
The TUSB2046BIRHBT is a 3.3V CMOS 4-port USB 2.0 hub which requires no firmware for programming. It connects to one upstream USB-C host connection and connects two downstream devices (target MCU and eZ-FET Lite Emulator).

=== Power Mode & EEPROM Cnfiguration
The evaluation board is powered via the upstream USB-C port with a max current budget of 500 mA. Therefore BUSPWR pin is pulled high to enable Bus-Powered mode. Moreover, the EEPROM interface is disabled by pulling the EXTMEM pin to EZ_3V3.

=== Clock Generation 
=== Power-On Reset
The Reset pin is an active low input with hysteresis which requires a reset pulse between 100 µs and 1 ms after the EZ_3V3 supply voltage reaches 3.3 V. Additionally, the 6 MHz clock must be stable during the last 60 µs of the reset window.

$ tau = R dot C = 47 "k"Omega dot 100 "nF" = 4.7 "ms" $ <eq:reset-rc>

Using the CMOS positive-going threshold $V_(I T+) approx 1.8 "V"$ ($V_(C C) = 3.3 "V"$): 

$ t_("reset") = -tau dot ln(1 - V_(I T+) / V_(C C)) = -4.7 "ms" dot ln(1 - (1.8 "V") / (3.3 "V")) approx 3.7 "ms" $ <eq:reset-time>

=== USB 2.0 Signal Integrity  

= PCB Layout

= Verification and Output Data

#pagebreak()