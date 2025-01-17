EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 3 6
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text Notes 3150 2750 0    50   ~ 0
CHARGER FROM THE MAIN POWER BUS
Wire Wire Line
	6700 1750 6900 1750
Wire Wire Line
	8700 1750 9550 1750
Wire Wire Line
	7300 1750 7350 1750
$Comp
L Device:R R24
U 1 1 5E020D56
P 7600 2050
F 0 "R24" V 7393 2050 50  0000 C CNN
F 1 "100k" V 7484 2050 50  0000 C CNN
F 2 "Resistor_SMD:R_0402_1005Metric" V 7530 2050 50  0001 C CNN
F 3 "~" H 7600 2050 50  0001 C CNN
F 4 "RT0402FRE07100KL" H 7600 2050 50  0001 C CNN "#manf"
F 5 "C25741" V 7600 2050 50  0001 C CNN "LCSC"
	1    7600 2050
	0    1    1    0   
$EndComp
Wire Wire Line
	7350 1750 7350 2050
Wire Wire Line
	7350 2050 7450 2050
Connection ~ 7350 1750
Wire Wire Line
	7350 1750 8300 1750
Wire Wire Line
	7750 2050 7850 2050
$Comp
L Device:C C37
U 1 1 5E028842
P 7850 2200
F 0 "C37" H 7965 2246 50  0000 L CNN
F 1 "22u" H 7965 2155 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 7888 2050 50  0001 C CNN
F 3 "~" H 7850 2200 50  0001 C CNN
F 4 "GRM21BR61C226ME44L" H 7850 2200 50  0001 C CNN "#manf"
F 5 "C45783" H 7850 2200 50  0001 C CNN "LCSC"
	1    7850 2200
	1    0    0    -1  
$EndComp
Connection ~ 7850 2050
Wire Wire Line
	7850 2050 8200 2050
$Comp
L Device:R R25
U 1 1 5E029125
P 8200 2200
F 0 "R25" H 8270 2246 50  0000 L CNN
F 1 "100k" H 8270 2155 50  0000 L CNN
F 2 "Resistor_SMD:R_0402_1005Metric" V 8130 2200 50  0001 C CNN
F 3 "~" H 8200 2200 50  0001 C CNN
F 4 "MCS04020C7503FE000" H 8200 2200 50  0001 C CNN "#manf"
F 5 "C25741" H 8200 2200 50  0001 C CNN "LCSC"
	1    8200 2200
	1    0    0    -1  
$EndComp
Connection ~ 8200 2050
Wire Wire Line
	8200 2050 8500 2050
Wire Wire Line
	7850 2350 7850 2550
Wire Wire Line
	7850 2550 8200 2550
Wire Wire Line
	8200 2550 8200 2350
Connection ~ 7850 2550
Text Notes 7150 1450 0    50   ~ 0
ON/OFF & REVERSE_POLARITY_PROTECTION
Wire Wire Line
	8500 2050 8500 2500
Wire Wire Line
	8800 2700 8900 2700
$Comp
L Device:R R26
U 1 1 5E045D6F
P 8900 2850
F 0 "R26" H 8970 2896 50  0000 L CNN
F 1 "100k" H 8970 2805 50  0000 L CNN
F 2 "Resistor_SMD:R_0402_1005Metric" V 8830 2850 50  0001 C CNN
F 3 "~" H 8900 2850 50  0001 C CNN
F 4 "MCS04020C7503FE000" H 8900 2850 50  0001 C CNN "#manf"
F 5 "C25741" H 8900 2850 50  0001 C CNN "LCSC"
	1    8900 2850
	1    0    0    -1  
$EndComp
Connection ~ 8900 2700
Wire Wire Line
	8900 2700 9250 2700
$Comp
L Device:C C38
U 1 1 5E046279
P 9250 2850
F 0 "C38" H 9365 2896 50  0000 L CNN
F 1 "22u" H 9365 2805 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 9288 2700 50  0001 C CNN
F 3 "~" H 9250 2850 50  0001 C CNN
F 4 "GRM21BR61C226ME44L" H 9250 2850 50  0001 C CNN "#manf"
F 5 "C45783" H 9250 2850 50  0001 C CNN "LCSC"
	1    9250 2850
	1    0    0    -1  
$EndComp
Connection ~ 9250 2700
$Comp
L Device:R R27
U 1 1 5E04EF17
P 9250 2350
F 0 "R27" H 9320 2396 50  0000 L CNN
F 1 "10k" H 9320 2305 50  0000 L CNN
F 2 "Resistor_SMD:R_0402_1005Metric" V 9180 2350 50  0001 C CNN
F 3 "~" H 9250 2350 50  0001 C CNN
F 4 "RT0402FRE0710KL" H 9250 2350 50  0001 C CNN "#manf"
F 5 "C25744" H 9250 2350 50  0001 C CNN "LCSC"
	1    9250 2350
	1    0    0    -1  
$EndComp
Wire Wire Line
	9250 2500 9250 2700
$Comp
L power:PWR_FLAG #FLG0102
U 1 1 5E95D2A6
P 9550 1750
F 0 "#FLG0102" H 9550 1825 50  0001 C CNN
F 1 "PWR_FLAG" H 9550 1923 50  0000 C CNN
F 2 "" H 9550 1750 50  0001 C CNN
F 3 "~" H 9550 1750 50  0001 C CNN
	1    9550 1750
	1    0    0    -1  
$EndComp
Connection ~ 9550 1750
Wire Wire Line
	9550 1750 9750 1750
$Comp
L Device:LED D?
U 1 1 5DEF3530
P 1950 4150
AR Path="/5E2C3773/5DEF3530" Ref="D?"  Part="1" 
AR Path="/5DFADF1E/5DEF3530" Ref="D14"  Part="1" 
F 0 "D14" H 1943 3895 50  0000 C CNN
F 1 "RED" H 1943 3986 50  0000 C CNN
F 2 "LED_SMD:LED_0603_1608Metric" H 1950 4150 50  0001 C CNN
F 3 "~" H 1950 4150 50  0001 C CNN
F 4 "C2286" H 1950 4150 50  0001 C CNN "LCSC"
	1    1950 4150
	0    1    1    0   
$EndComp
Wire Wire Line
	7250 2550 7850 2550
Text HLabel 1700 3800 0    50   Output ~ 0
CHG_OK
Text HLabel 9750 1750 2    50   Output ~ 0
BAT_VDD
Text Label 6700 1750 0    50   ~ 0
BAT+
Text HLabel 9900 2700 2    50   Input ~ 0
PWR_SHUTDOWN
Wire Wire Line
	9250 2700 9900 2700
Text HLabel 7250 2550 0    50   Input ~ 0
PWR_START
Text HLabel 9250 2200 1    50   Input ~ 0
3V3
Text HLabel 7100 2050 3    50   UnSpc ~ 0
GND
Text HLabel 8500 2900 3    50   UnSpc ~ 0
GND
Text HLabel 8900 3000 3    50   UnSpc ~ 0
GND
Text HLabel 9250 3000 3    50   UnSpc ~ 0
GND
$Comp
L Device:Q_PMOS_SGD Q?
U 1 1 5FC760BF
P 8500 1850
F 0 "Q?" V 8842 1850 50  0000 C CNN
F 1 "NCE20P45Q" V 8751 1850 50  0000 C CNN
F 2 "rofi:DFN3.3X3.3-EP" H 8700 1950 50  0001 C CNN
F 3 "~" H 8500 1850 50  0001 C CNN
F 4 "C193354" H 8500 1850 50  0001 C CNN "LCSC"
	1    8500 1850
	0    1    -1   0   
$EndComp
Connection ~ 8500 2050
$Comp
L Device:Q_PMOS_SGD Q?
U 1 1 5FC81675
P 7100 1850
F 0 "Q?" V 7442 1850 50  0000 C CNN
F 1 "NCE20P45Q" V 7351 1850 50  0000 C CNN
F 2 "rofi:DFN3.3X3.3-EP" H 7300 1950 50  0001 C CNN
F 3 "~" H 7100 1850 50  0001 C CNN
F 4 "C193354" H 7100 1850 50  0001 C CNN "LCSC"
	1    7100 1850
	0    -1   -1   0   
$EndComp
$Comp
L Transistor_FET:2N7002 Q?
U 1 1 5FC85EDF
P 8600 2700
F 0 "Q?" H 8805 2746 50  0000 L CNN
F 1 "2N7002" H 8805 2655 50  0000 L CNN
F 2 "Package_TO_SOT_SMD:SOT-23" H 8800 2625 50  0001 L CIN
F 3 "https://www.fairchildsemi.com/datasheets/2N/2N7002.pdf" H 8600 2700 50  0001 L CNN
F 4 "C8545" H 8600 2700 50  0001 C CNN "LCSC"
	1    8600 2700
	-1   0    0    -1  
$EndComp
$Comp
L Device:Battery_Cell BT2
U 1 1 5DFAE964
P 5150 4300
F 0 "BT2" H 5268 4396 50  0000 L CNN
F 1 "Battery_Cell" H 5268 4305 50  0000 L CNN
F 2 "rofi:BATTERY_18350" V 5150 4360 50  0001 C CNN
F 3 "~" V 5150 4360 50  0001 C CNN
F 4 "" H 5150 4300 50  0001 C CNN "#manf"
	1    5150 4300
	1    0    0    -1  
$EndComp
$Comp
L Device:Battery_Cell BT1
U 1 1 5DFAE385
P 5150 4000
F 0 "BT1" H 5268 4096 50  0000 L CNN
F 1 "Battery_Cell" H 5268 4005 50  0000 L CNN
F 2 "rofi:BATTERY_18350" V 5150 4060 50  0001 C CNN
F 3 "~" V 5150 4060 50  0001 C CNN
F 4 "" H 5150 4000 50  0001 C CNN "#manf"
	1    5150 4000
	1    0    0    -1  
$EndComp
$Comp
L rofi:TP5100 U?
U 1 1 5FCD9B70
P 3400 3700
F 0 "U?" H 3400 4425 50  0000 C CNN
F 1 "TP5100" H 3400 4334 50  0000 C CNN
F 2 "Package_DFN_QFN:QFN-16-1EP_4x4mm_P0.65mm_EP2.1x2.1mm" H 3650 3100 50  0001 C CNN
F 3 "" H 3650 3100 50  0001 C CNN
	1    3400 3700
	1    0    0    -1  
$EndComp
$Comp
L Device:L L?
U 1 1 5FCDAE43
P 4350 3200
F 0 "L?" V 4540 3200 50  0000 C CNN
F 1 "22u" V 4449 3200 50  0000 C CNN
F 2 "rofi:SLO0630H" H 4350 3200 50  0001 C CNN
F 3 "~" H 4350 3200 50  0001 C CNN
F 4 "C207843" V 4350 3200 50  0001 C CNN "LCSC"
	1    4350 3200
	0    -1   -1   0   
$EndComp
$Comp
L Device:R R?
U 1 1 5FCDB663
P 4800 3600
AR Path="/5DD3C100/5FCDB663" Ref="R?"  Part="1" 
AR Path="/5DFADF1E/5FCDB663" Ref="R?"  Part="1" 
F 0 "R?" V 4593 3600 50  0000 C CNN
F 1 "75m" V 4684 3600 50  0000 C CNN
F 2 "Resistor_SMD:R_1206_3216Metric" V 4730 3600 50  0001 C CNN
F 3 "~" H 4800 3600 50  0001 C CNN
F 4 "C57963" V 4800 3600 50  0001 C CNN "LCSC"
	1    4800 3600
	-1   0    0    1   
$EndComp
Wire Wire Line
	4800 3450 4650 3450
Wire Wire Line
	3950 3750 4800 3750
Text HLabel 5150 4550 3    50   UnSpc ~ 0
GND
Wire Wire Line
	5150 4400 5150 4500
$Comp
L power:PWR_FLAG #FLG?
U 1 1 5FCEAD76
P 5150 4500
F 0 "#FLG?" H 5150 4575 50  0001 C CNN
F 1 "PWR_FLAG" V 5150 4627 50  0000 L CNN
F 2 "" H 5150 4500 50  0001 C CNN
F 3 "~" H 5150 4500 50  0001 C CNN
	1    5150 4500
	0    1    1    0   
$EndComp
Connection ~ 5150 4500
Wire Wire Line
	5150 4500 5150 4550
Wire Wire Line
	5150 3800 5150 3750
Wire Wire Line
	5150 3750 4800 3750
Connection ~ 4800 3750
Text Label 6950 3750 0    50   ~ 0
BAT+
Wire Wire Line
	3950 3200 4100 3200
Wire Wire Line
	4100 3200 4100 3300
Wire Wire Line
	4100 3300 3950 3300
Connection ~ 4100 3200
Wire Wire Line
	4100 3200 4200 3200
Wire Wire Line
	4500 3200 4800 3200
Wire Wire Line
	4800 3200 4800 3450
Connection ~ 4800 3450
$Comp
L Device:D_Schottky D?
U 1 1 5FCFD521
P 5150 3450
F 0 "D?" V 5104 3530 50  0000 L CNN
F 1 "SS54" V 5195 3530 50  0000 L CNN
F 2 "Diode_SMD:D_SMA" H 5150 3450 50  0001 C CNN
F 3 "~" H 5150 3450 50  0001 C CNN
F 4 "C22452" V 5150 3450 50  0001 C CNN "LCSC"
	1    5150 3450
	0    1    1    0   
$EndComp
Wire Wire Line
	5150 3600 5150 3750
Connection ~ 5150 3750
Wire Wire Line
	5150 3300 5150 3200
Wire Wire Line
	5150 3200 4800 3200
Connection ~ 4800 3200
Wire Wire Line
	5150 3750 5900 3750
$Comp
L Device:C C?
U 1 1 5FD0BE6C
P 4250 4000
F 0 "C?" H 4365 4046 50  0000 L CNN
F 1 "100n" H 4365 3955 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric" H 4288 3850 50  0001 C CNN
F 3 "~" H 4250 4000 50  0001 C CNN
F 4 "C1525" H 4250 4000 50  0001 C CNN "LCSC"
	1    4250 4000
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 5FD0ED74
P 4650 4000
F 0 "C?" H 4765 4046 50  0000 L CNN
F 1 "10u" H 4765 3955 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 4688 3850 50  0001 C CNN
F 3 "~" H 4650 4000 50  0001 C CNN
F 4 "C15850" H 4650 4000 50  0001 C CNN "LCSC"
	1    4650 4000
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 5FD18536
P 5900 3900
F 0 "C?" H 6015 3946 50  0000 L CNN
F 1 "10u" H 6015 3855 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 5938 3750 50  0001 C CNN
F 3 "~" H 5900 3900 50  0001 C CNN
F 4 "C15850" H 5900 3900 50  0001 C CNN "LCSC"
	1    5900 3900
	1    0    0    -1  
$EndComp
Connection ~ 5900 3750
Wire Wire Line
	5900 3750 6300 3750
$Comp
L Device:C C?
U 1 1 5FD18C0D
P 6300 3900
F 0 "C?" H 6415 3946 50  0000 L CNN
F 1 "100n" H 6415 3855 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric" H 6338 3750 50  0001 C CNN
F 3 "~" H 6300 3900 50  0001 C CNN
F 4 "C1525" H 6300 3900 50  0001 C CNN "LCSC"
	1    6300 3900
	1    0    0    -1  
$EndComp
Connection ~ 6300 3750
Wire Wire Line
	6300 3750 6750 3750
Text HLabel 5900 4050 3    50   UnSpc ~ 0
GND
Text HLabel 6300 4050 3    50   UnSpc ~ 0
GND
Wire Wire Line
	4250 3850 4250 3450
Connection ~ 4250 3450
Wire Wire Line
	4250 3450 3950 3450
Wire Wire Line
	4650 3850 4650 3450
Connection ~ 4650 3450
Wire Wire Line
	4650 3450 4250 3450
Wire Wire Line
	3950 4200 4050 4200
Wire Wire Line
	4650 4200 4650 4150
Wire Wire Line
	4250 4150 4250 4200
Connection ~ 4250 4200
Wire Wire Line
	4250 4200 4650 4200
Wire Wire Line
	3950 4100 4050 4100
Wire Wire Line
	4050 4100 4050 4200
Connection ~ 4050 4200
Wire Wire Line
	4050 4200 4250 4200
Wire Wire Line
	4250 4200 4250 4300
Text HLabel 4250 4300 3    50   UnSpc ~ 0
GND
$Comp
L Device:C C?
U 1 1 5FD486E1
P 2300 4250
F 0 "C?" H 2415 4296 50  0000 L CNN
F 1 "100n" H 2415 4205 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric" H 2338 4100 50  0001 C CNN
F 3 "~" H 2300 4250 50  0001 C CNN
F 4 "C1525" H 2300 4250 50  0001 C CNN "LCSC"
	1    2300 4250
	1    0    0    -1  
$EndComp
Text HLabel 2300 4400 3    50   UnSpc ~ 0
GND
$Comp
L Device:C C?
U 1 1 5FD4F2CC
P 2300 3350
F 0 "C?" H 2415 3396 50  0000 L CNN
F 1 "22u" H 2415 3305 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 2338 3200 50  0001 C CNN
F 3 "~" H 2300 3350 50  0001 C CNN
F 4 "GRM21BR61C226ME44L" H 2300 3350 50  0001 C CNN "#manf"
F 5 "C45783" H 2300 3350 50  0001 C CNN "LCSC"
	1    2300 3350
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 5FD4F8F1
P 1900 3350
F 0 "C?" H 2015 3396 50  0000 L CNN
F 1 "22u" H 2015 3305 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 1938 3200 50  0001 C CNN
F 3 "~" H 1900 3350 50  0001 C CNN
F 4 "GRM21BR61C226ME44L" H 1900 3350 50  0001 C CNN "#manf"
F 5 "C45783" H 1900 3350 50  0001 C CNN "LCSC"
	1    1900 3350
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 5FD4FE0D
P 1550 3350
F 0 "C?" H 1665 3396 50  0000 L CNN
F 1 "22u" H 1665 3305 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 1588 3200 50  0001 C CNN
F 3 "~" H 1550 3350 50  0001 C CNN
F 4 "GRM21BR61C226ME44L" H 1550 3350 50  0001 C CNN "#manf"
F 5 "C45783" H 1550 3350 50  0001 C CNN "LCSC"
	1    1550 3350
	1    0    0    -1  
$EndComp
Wire Wire Line
	2850 3200 2750 3200
Wire Wire Line
	2300 3200 1900 3200
Connection ~ 2300 3200
Wire Wire Line
	1900 3200 1550 3200
Connection ~ 1900 3200
Text HLabel 1400 3200 0    50   Input ~ 0
INT
Wire Wire Line
	1400 3200 1550 3200
Connection ~ 1550 3200
Wire Wire Line
	2300 3500 1900 3500
Wire Wire Line
	1900 3500 1550 3500
Connection ~ 1900 3500
Wire Wire Line
	1550 3500 1400 3500
Connection ~ 1550 3500
Text HLabel 1400 3500 0    50   UnSpc ~ 0
GND
Wire Wire Line
	2750 3300 2750 3200
Connection ~ 2750 3200
Wire Wire Line
	2750 3200 2300 3200
Wire Wire Line
	2750 3300 2850 3300
Wire Wire Line
	2850 3400 2750 3400
Wire Wire Line
	2750 3400 2750 3300
Connection ~ 2750 3300
Wire Wire Line
	2850 3500 2750 3500
Wire Wire Line
	2750 3500 2750 3400
Connection ~ 2750 3400
Text HLabel 2550 4000 0    50   Input ~ 0
CHG_EN
Wire Wire Line
	2850 3800 1950 3800
$Comp
L Device:R R?
U 1 1 5FD94A8B
P 2850 4500
F 0 "R?" H 2920 4546 50  0000 L CNN
F 1 "0R" H 2920 4455 50  0000 L CNN
F 2 "Resistor_SMD:R_0402_1005Metric" V 2780 4500 50  0001 C CNN
F 3 "~" H 2850 4500 50  0001 C CNN
	1    2850 4500
	1    0    0    -1  
$EndComp
Text HLabel 2850 4650 3    50   UnSpc ~ 0
GND
Wire Wire Line
	2850 4350 2850 4200
$Comp
L Device:C C?
U 1 1 5FD9D3C1
P 6750 3900
F 0 "C?" H 6865 3946 50  0000 L CNN
F 1 "22u" H 6865 3855 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 6788 3750 50  0001 C CNN
F 3 "~" H 6750 3900 50  0001 C CNN
F 4 "GRM21BR61C226ME44L" H 6750 3900 50  0001 C CNN "#manf"
F 5 "C45783" H 6750 3900 50  0001 C CNN "LCSC"
	1    6750 3900
	1    0    0    -1  
$EndComp
Connection ~ 6750 3750
Wire Wire Line
	6750 3750 6950 3750
Text HLabel 6750 4050 3    50   UnSpc ~ 0
GND
Wire Wire Line
	3950 3950 4050 3950
Wire Wire Line
	4050 3950 4050 4100
Connection ~ 4050 4100
NoConn ~ 2850 3900
Wire Wire Line
	1950 4000 1950 3800
Connection ~ 1950 3800
Text HLabel 1950 4600 3    50   Input ~ 0
3V3
Wire Wire Line
	1700 3800 1950 3800
$Comp
L Device:R R?
U 1 1 5FE187E8
P 1950 4450
F 0 "R?" H 2020 4496 50  0000 L CNN
F 1 "470R" H 2020 4405 50  0000 L CNN
F 2 "" V 1880 4450 50  0001 C CNN
F 3 "~" H 1950 4450 50  0001 C CNN
F 4 "C25117" H 1950 4450 50  0001 C CNN "LCSC"
	1    1950 4450
	1    0    0    -1  
$EndComp
Wire Wire Line
	2300 4100 2850 4100
Wire Wire Line
	2550 4000 2850 4000
NoConn ~ 2850 3700
Text Notes 3150 4700 0    50   ~ 0
Note  that cell select:\n- LOW: shutdown\n- HIGH: 2 cells\n- FLOATING: 1 cell
$EndSCHEMATC
