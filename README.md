# UWB-Algorithms-on-MATLAB
Master 1 Internship at Sapienza University in Ultra wideband in the DIET department.

# Table of Contents
1. [Introduction & Definition](#1-introduction-&-definition)
2. [UWB 802.15.4 toolbox Matlab](#2-uwb-802154-toolbox-matlab)
     - One Way Ranging / Time Difference On Arrival
     - Two Way Ranging / Time Difference On Arrival with LOS & N-LOS

# 1. Introduction & Definition
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
<p align="center"><img src="img/hyperbolicIntersectionError.png"></p>


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
- [Application Note APS006 Part 1.pdf]()
- [Application Note APS006 Part 2.pdf]()
- [Application Note APS006 Part 3.pdf]()
- [DWM1001-DEV_Datasheet]
## DWM3000
- [DWM3000 Data Sheet]()
- [DWM3001CDK_SDK_Developer_Guide_0.1.1]()
- [DWM3001CDK_SDK_Release_Notes_0.1.1]()
- [Qovro_7_7_2022_DWM3001CDK_Quick_Start_Guide-2998998]()
- [UWB-Stack-R11.9.2]()
- [Indoor UWB Positioning and Position Tracking Data Set]()

## For Matlab :
### Description :
[Ultra-Wideband (UWB)](https://fr.mathworks.com/discovery/ultra-wideband.html)
### All progs gives by the toolbox
[UWB](https://fr.mathworks.com/help/comm/uwb.html?s_tid=CRUX_lftnav)
- [uwbChannel](https://fr.mathworks.com/help/comm/ref/uwbchannel-system-object.html)
- [UWB Localization Using IEEE 802.15.4z](https://fr.mathworks.com/help/comm/ug/uwb-localization-using-ieee-802.15.4z.html)
- [UWB Ranging Using IEEE 802.15.4z](https://fr.mathworks.com/help/comm/ug/uwb-ranging-using-ieee-802.15.4z.html)

