# UWB-Algorithms-on-MATLAB
Master 1 Internship at Sapienza University in Ultra wideband in the DIET department.

# Table of Contents
1. [Introduction & Definition](#1-introduction-def-to-ultra-wideband-uwb)
2. [UWB 802.15.4 toolbox Matlab](#2-uwb-802154-toolbox-matlab)
     - [One Way Ranging / Time Difference On Arrival]()
     - [Two Way Ranging / Time Difference On Arrival with LOS & N-LOS]()
3. [References](#3-References)
     - [Papers](#papers)
     - [DWM1000](#dwm1000)
     - [DWM3000](#dwm3000)
     - [MATLAB](#for-MATLAB)

# 1. Introduction (&Def) to Ultra Wideband (UWB)

Ultra Wideband (UWB) is a wireless communication technology known for transmitting data over a wide frequency band (>500 MHz) using very low energy levels. UWB operates in a frequency range from 3.1 to 10.6 GHz. Due to its high bandwidth, UWB can achieve high data rates and precise location capabilities, making it ideal for a range of applications, including real-time location systems (RTLS), sensor data collection, and secure communications.

UWB's precision in determining the position of objects or subjects is enhanced through various ranging techniques, which include one-way ranging, two-way ranging, and methods such as Time of Arrival (ToA), Time Difference of Arrival (TDoA), and Time of Flight (ToF). These methods are fundamental in scenarios requiring high accuracy, such as navigation, tracking systems, and automated industrial processes.

#### One-Way Ranging (OWR)
One-Way Ranging involves the transmission of a signal from a transmitter to a receiver. The distance between the transmitter and receiver is calculated based on the time it takes for the signal to travel from one to the other, assuming the speed of signal propagation is known. This technique is less commonly used due to its vulnerability to clock synchronization issues between the transmitter and receiver.

#### Two-Way Ranging (TWR)
Two-Way Ranging improves upon OWR by involving an exchange of signals between two devices. The first device sends a signal, the second device receives it and immediately sends a response back. The round-trip time is then measured and used to calculate the distance. TWR mitigates some synchronization issues seen in OWR as it only requires the initiating device to measure time.

#### Time of Arrival (ToA)
Time of Arrival is a method used to determine the position of an object by measuring the time it takes for a signal to travel from the object to several receivers. ToA can be used independently or as part of TWR and requires precise time synchronization between the transmitting and receiving devices.

#### Time Difference of Arrival (TDoA)
Time Difference of Arrival involves measuring the difference in arrival times of a signal to multiple receivers. Unlike ToA, TDoA does not require synchronization of the clocks at the receivers because it relies on the difference in time, not the absolute time of arrival.

#### Time of Flight (ToF)
Time of Flight is similar to ToA; however, it specifically refers to the measurement of the overall time taken for a signal to travel from a source to a destination. ToF is widely used in various applications, including 3D imaging and simple distance measurement tasks.

#### Line of Sight (LOS) and Non-Line of Sight (NLOS)
Line of Sight (LOS) refers to a propagation scenario where the transmitter and receiver have a clear, unobstructed path between them. LOS conditions are ideal for most wireless communications as they ensure minimal signal interference and attenuation. Non-Line of Sight (NLOS) conditions occur when there are obstacles or obstructions between the transmitter and receiver, causing reflections, diffraction, and scattering. NLOS scenarios are challenging due to the unpredictability and degradation of the signal, which can adversely affect the accuracy of location-based measurements.

# 2. UWB 802.15.4 toolbox Matlab
Pretty big prog which does a lot of things !
I tried to synthetise all prog that matlab gives and more !
So, i will try to detail it !
### 1.  One Way Ranging / Time Difference On Arrival
This first part is based on the [UWB Localization Using IEEE 802.15.4z](https://fr.mathworks.com/help/comm/ug/uwb-localization-using-ieee-802.15.4z.html) program gives by matlab.
- Firstly, you put in input **all your devices and nodes**. It will calculates the distance and the time of flight between the initiators and the receptors based on the coordonates.
```matlab
numDevices = 2;
numNodes = 6;

deviceLoc = [50 50;
             25 25]; 

nodeLoc = [40 41;
           62 83;
           87 24;
           40 20;
           60 30;
           80 40];
```
<p align="center"><img src="img/distance.png"></p>

- Then you will put your data file for configure the MAC and PHY layers
- Based on your data and your config it will calculates for each blincks, iniators and receptors pairs : **the distance**, **the time of flight** and mostly **the Time Difference On Arrival (TDOA)**. It takes in account the noise and preamble (but you need to configure it).
<p align="center"><img src="img/hyperbolic intersection.png"</p>
<p align="center"><img src="img/hyperbolic intersection2.png"</p>

- After that, you will be able to see the TDOA based on hyperbolics intersection of pairs of nodes **for each initiators (devices)**. It takes 3 pairs of nodes (receptors) based on 3 nodes that you can choose and modify
```matlab
nodePairs = [1, 2; 
             1, 3; 
             2, 3];

numPairs = size(nodePairs, 1);

```
- Finaly, the program will caculates **the distance errors** difference between the device position and the hyperbolics intersection because as you see the intersection doesn't cross the initiator.
<p align="center"><img src="img/hyperbolicIntersectionError.png" width="500"></p>


### 2.  Two Way Ranging / Time Difference On Arrival
In this program i will fous myself not only in the two way ranging part but in the types of communications : LOS (Line of Sight) and N-LOS(Non Line of Sight). In an industrial environment, the are a lot of obstructions between the anchors and the tags. 

You will be able to switch between this two methods.

**W.I.P**

# 2. UWB development boards on DWM3000 and SEGGER Embedded Studio for ARM 7.30
maybe one day

# 3. References
## Papers
Some papers interesting and not it depends on what you search.
- [Detection of the LOS/NLOS state change based on the CIR features](doc/Detection-of-the-LOS/NLOS-state-change-based-on-the-CIR-features.pdf)
- [NOISE: Radio Channel Impulse Response Measurement and Analysis](doc/Radio Channel Impulse Response Measurement and Analysis.pdf)
- [Impulsive noise in UWB systems and its suppression]()
- [UWB Channel Impulse Responses for Positioning in complex environments]()
## DWM1000
- [Application Note APS006 Part 1](doc/Application_Note_APS006_Part_1.pdf)
- [Application Note APS006 Part 2](doc/Application_Note_APS006_Part_2.pdf)
- [Application Note APS006 Part 3](doc/Application_Note_APS006_Part_3.pdf)
- [DWM1001-DEV_Datasheet]()
## DWM3000
- [DWM3000 Data Sheet](doc/DWM3000_Data_Sheet.pdf)
- [DWM3001CDK_SDK_Developer_Guide_0.1.1](doc/DWM3001CDK_SDK_Developer_Guide_0.1.1.pdf)
- [DWM3001CDK_SDK_Release_Notes_0.1.1](doc/DWM3001CDK_SDK_Release_Notes_0.1.1.pdf)
- [Qovro_7_7_2022_DWM3001CDK_Quick_Start_Guide-2998998](doc/Qovro_7_7_2022_DWM3001CDK_Quick_Start_Guide-2998998.pdf)
- [UWB-Stack-R11.9.2](doc/UWB-Stack-R11.9.2.pdf)
- [Indoor UWB Positioning and Position Tracking Data Set](doc/Indoor_UWB_Positioning_and_Position_Tracking_Data_Set.pdf)

## For Matlab :
### Description :
[Ultra-Wideband (UWB)](https://fr.mathworks.com/discovery/ultra-wideband.html)
### All progs gives by the toolbox
[UWB](https://fr.mathworks.com/help/comm/uwb.html?s_tid=CRUX_lftnav)
- [uwbChannel](https://fr.mathworks.com/help/comm/ref/uwbchannel-system-object.html)
- [UWB Localization Using IEEE 802.15.4z](https://fr.mathworks.com/help/comm/ug/uwb-localization-using-ieee-802.15.4z.html)
- [UWB Ranging Using IEEE 802.15.4z](https://fr.mathworks.com/help/comm/ug/uwb-ranging-using-ieee-802.15.4z.html)

