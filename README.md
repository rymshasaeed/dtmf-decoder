# Dual-Tone Multi-Frequency Transmission
Dual-tone multi-frequency (DTMF) signals are used in touch-tone telephones and other industries including interactive power, telephone banking, and pager systems. Due to its strong anti-noise and anti-attenuation performance as well as ease of implementation, it is a frequently utilized approach in the transmission of medium and low-speed data. A DTMF codec consists of an encoder that converts keystrokes or digits data into dual tone signals, as well as a decoder that detects the presence and content of incoming DTMF tones.

A DTMF signal is made up of two sinusoidal tones. Their frequencies are set such that harmonics are avoided. To put it another way, there are no multiples of a particular frequency, no sum of two frequencies, and no difference of two frequencies that equals another. This enables for reliable long-distance communication. The transmitted signal is thus analogous to equation below.
<p  align="center">x(t) = sin⁡(2πf<sub>L</sub>t) + sin(2πf<sub>H</sub>t)</p>

The first sinusoidal tone is chosen from a set of low-frequency tones that comprise 697 Hz, 770 Hz, 852 Hz, and 941 Hz. While the second one is selected from a set of high frequency group: 1209 Hz, 1336 Hz, 1477 Hz, and 1633 Hz. By combining two sinusoidal tones with four frequencies from each group, a total of 16 permutations representing ten decimal digits (0-9) are obtained, four alphabets (A,B,C,D) and two special characters (*,#).

## Decoder Design
The repository presents a DTMF-tones generator and DTMF-keys decoder. Two design approaches have been followed: i) via a straightforward <a href="https://github.com/rimshasaeed/dtmf-decoder/tree/main/matlab%20scripts" traget="blank_">MATLAB program</a>, ii) via a <a href="https://github.com/rimshasaeed/dtmf-decoder/tree/main/matlab%20gui" traget="blank_">MATLAB GUI</a>. The workflow of the GUI design approach is shown in Figure 1.
<p align="center">
  <img src="https://github.com/rimshasaeed/dtmf-decoder/blob/main/results/workflow.jpg", alt="workflow" width="70%">
  <br>
  <i>Figure 1: Design Workflow</i>
</p>

## Results
<p align="center">
  <img src="https://github.com/rimshasaeed/dtmf-decoder/blob/main/results/dtmf_gui.jpg", alt="gui" width="70%">
  <br>
  <i>Figure 2: Touch tones generation and detection</i>
</p>
