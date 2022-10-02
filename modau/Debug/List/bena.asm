
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega128A
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega128A
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _dl=R5
	.DEF _dr=R4
	.DEF _du=R7
	.DEF _dd=R6
	.DEF _i=R8
	.DEF _i_msb=R9
	.DEF _slength=R10
	.DEF _slength_msb=R11
	.DEF _tempx=R12
	.DEF _tempx_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_font5x7:
	.DB  0x5,0x7,0x20,0x60,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x5F,0x0,0x0,0x0,0x7
	.DB  0x0,0x7,0x0,0x14,0x7F,0x14,0x7F,0x14
	.DB  0x24,0x2A,0x7F,0x2A,0x12,0x23,0x13,0x8
	.DB  0x64,0x62,0x36,0x49,0x55,0x22,0x50,0x0
	.DB  0x5,0x3,0x0,0x0,0x0,0x1C,0x22,0x41
	.DB  0x0,0x0,0x41,0x22,0x1C,0x0,0x8,0x2A
	.DB  0x1C,0x2A,0x8,0x8,0x8,0x3E,0x8,0x8
	.DB  0x0,0x50,0x30,0x0,0x0,0x8,0x8,0x8
	.DB  0x8,0x8,0x0,0x30,0x30,0x0,0x0,0x20
	.DB  0x10,0x8,0x4,0x2,0x3E,0x51,0x49,0x45
	.DB  0x3E,0x0,0x42,0x7F,0x40,0x0,0x42,0x61
	.DB  0x51,0x49,0x46,0x21,0x41,0x45,0x4B,0x31
	.DB  0x18,0x14,0x12,0x7F,0x10,0x27,0x45,0x45
	.DB  0x45,0x39,0x3C,0x4A,0x49,0x49,0x30,0x1
	.DB  0x71,0x9,0x5,0x3,0x36,0x49,0x49,0x49
	.DB  0x36,0x6,0x49,0x49,0x29,0x1E,0x0,0x36
	.DB  0x36,0x0,0x0,0x0,0x56,0x36,0x0,0x0
	.DB  0x0,0x8,0x14,0x22,0x41,0x14,0x14,0x14
	.DB  0x14,0x14,0x41,0x22,0x14,0x8,0x0,0x2
	.DB  0x1,0x51,0x9,0x6,0x32,0x49,0x79,0x41
	.DB  0x3E,0x7E,0x11,0x11,0x11,0x7E,0x7F,0x49
	.DB  0x49,0x49,0x36,0x3E,0x41,0x41,0x41,0x22
	.DB  0x7F,0x41,0x41,0x22,0x1C,0x7F,0x49,0x49
	.DB  0x49,0x41,0x7F,0x9,0x9,0x1,0x1,0x3E
	.DB  0x41,0x41,0x51,0x32,0x7F,0x8,0x8,0x8
	.DB  0x7F,0x0,0x41,0x7F,0x41,0x0,0x20,0x40
	.DB  0x41,0x3F,0x1,0x7F,0x8,0x14,0x22,0x41
	.DB  0x7F,0x40,0x40,0x40,0x40,0x7F,0x2,0x4
	.DB  0x2,0x7F,0x7F,0x4,0x8,0x10,0x7F,0x3E
	.DB  0x41,0x41,0x41,0x3E,0x7F,0x9,0x9,0x9
	.DB  0x6,0x3E,0x41,0x51,0x21,0x5E,0x7F,0x9
	.DB  0x19,0x29,0x46,0x46,0x49,0x49,0x49,0x31
	.DB  0x1,0x1,0x7F,0x1,0x1,0x3F,0x40,0x40
	.DB  0x40,0x3F,0x1F,0x20,0x40,0x20,0x1F,0x7F
	.DB  0x20,0x18,0x20,0x7F,0x63,0x14,0x8,0x14
	.DB  0x63,0x3,0x4,0x78,0x4,0x3,0x61,0x51
	.DB  0x49,0x45,0x43,0x0,0x0,0x7F,0x41,0x41
	.DB  0x2,0x4,0x8,0x10,0x20,0x41,0x41,0x7F
	.DB  0x0,0x0,0x4,0x2,0x1,0x2,0x4,0x40
	.DB  0x40,0x40,0x40,0x40,0x0,0x1,0x2,0x4
	.DB  0x0,0x20,0x54,0x54,0x54,0x78,0x7F,0x48
	.DB  0x44,0x44,0x38,0x38,0x44,0x44,0x44,0x20
	.DB  0x38,0x44,0x44,0x48,0x7F,0x38,0x54,0x54
	.DB  0x54,0x18,0x8,0x7E,0x9,0x1,0x2,0x8
	.DB  0x14,0x54,0x54,0x3C,0x7F,0x8,0x4,0x4
	.DB  0x78,0x0,0x44,0x7D,0x40,0x0,0x20,0x40
	.DB  0x44,0x3D,0x0,0x0,0x7F,0x10,0x28,0x44
	.DB  0x0,0x41,0x7F,0x40,0x0,0x7C,0x4,0x18
	.DB  0x4,0x78,0x7C,0x8,0x4,0x4,0x78,0x38
	.DB  0x44,0x44,0x44,0x38,0x7C,0x14,0x14,0x14
	.DB  0x8,0x8,0x14,0x14,0x18,0x7C,0x7C,0x8
	.DB  0x4,0x4,0x8,0x48,0x54,0x54,0x54,0x20
	.DB  0x4,0x3F,0x44,0x40,0x20,0x3C,0x40,0x40
	.DB  0x20,0x7C,0x1C,0x20,0x40,0x20,0x1C,0x3C
	.DB  0x40,0x30,0x40,0x3C,0x44,0x28,0x10,0x28
	.DB  0x44,0xC,0x50,0x50,0x50,0x3C,0x44,0x64
	.DB  0x54,0x4C,0x44,0x0,0x8,0x36,0x41,0x0
	.DB  0x0,0x0,0x7F,0x0,0x0,0x0,0x41,0x36
	.DB  0x8,0x0,0x2,0x1,0x2,0x4,0x2,0x7F
	.DB  0x41,0x41,0x41,0x7F
__glcd_mask:
	.DB  0x0,0x1,0x3,0x7,0xF,0x1F,0x3F,0x7F
	.DB  0xFF
_tbl10_G103:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G103:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x3:
	.DB  0x1,0x0,0x2,0x0,0x3,0x0,0x4,0x0
	.DB  0x5,0x0,0x6,0x0,0x7,0x0,0x8,0x0
	.DB  0x9
_0x2080060:
	.DB  0x1
_0x2080000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x11
	.DW  _keypad
	.DW  _0x3*2

	.DW  0x01
	.DW  __seed_G104
	.DW  _0x2080060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

	OUT  RAMPZ,R24

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;/*
; * bena.c
; *
; * Created: 10/2/2022 8:32:03 AM
; * Author: Hoang
; */
;
;#include <io.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <glcd.h>
;#include <font5x7.h>
;#include <stdio.h>
;#include <stdint.h>
;#include <stdlib.h>
;
;#define LEFT 4
;#define DOWN 5
;#define RIGHT 6
;#define UP 2
;#define PAUSE false
;#define BACKLIGHT A0
;#define MAX_WIDTH 84
;#define MAX_HEIGHT 48
;#define speakerPin A5
;
;// global var
;int keypad[3][3] = {1, 2, 3, 4, 5, 6, 7, 8, 9};

	.DSEG
;bool dl = false, dr = false, du = false, dd = false;
;int x[200], y[200], i, slength, tempx = 0, tempy = 0, xx, yy;
;unsigned int  score, high;
;int xegg , yegg;
;
;//setup begin
;void setup() {
; 0000 0022 void setup() {

	.CSEG
_setup:
; .FSTART _setup
; 0000 0023     glcd_clear();
	CALL _glcd_clear
; 0000 0024     slength = 30;
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	MOVW R10,R30
; 0000 0025     score = 0;
	LDI  R30,LOW(0)
	STS  _score,R30
	STS  _score+1,R30
; 0000 0026     xegg = MAX_WIDTH / 2;
	LDI  R30,LOW(42)
	LDI  R31,HIGH(42)
	STS  _xegg,R30
	STS  _xegg+1,R31
; 0000 0027     yegg = MAX_HEIGHT / 2;
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	STS  _yegg,R30
	STS  _yegg+1,R31
; 0000 0028     dr = true;
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0000 0029     dl = false;
	CLR  R5
; 0000 002A     du = false;
	CLR  R7
; 0000 002B     dd = false;
	CLR  R6
; 0000 002C     tempx = 0, tempy = 0;
	CLR  R12
	CLR  R13
	LDI  R30,LOW(0)
	STS  _tempy,R30
	STS  _tempy+1,R30
; 0000 002D     for (i = 0; i < slength; i++)
	CLR  R8
	CLR  R9
_0x5:
	__CPWRR 8,9,10,11
	BRGE _0x6
; 0000 002E     {
; 0000 002F         x[i] = 10 + slength - i;
	CALL SUBOPT_0x0
	MOVW R30,R10
	ADIW R30,10
	SUB  R30,R8
	SBC  R31,R9
	ST   X+,R30
	ST   X,R31
; 0000 0030         y[i] = 10;
	CALL SUBOPT_0x1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   X+,R30
	ST   X,R31
; 0000 0031     }
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	RJMP _0x5
_0x6:
; 0000 0032 
; 0000 0033     glcd_setpixel(xegg, yegg);
	CALL SUBOPT_0x2
; 0000 0034 
; 0000 0035 
; 0000 0036 }
	RET
; .FEND
;
;//matrix button processing
;int BUTTON() {
; 0000 0039 int BUTTON() {
_BUTTON:
; .FSTART _BUTTON
; 0000 003A     int result = -1;
; 0000 003B     char a;
; 0000 003C     int i,j;
; 0000 003D     for (j = 0; j < 3; j++) {  //Xet cot
	SBIW R28,2
	CALL __SAVELOCR6
;	result -> R16,R17
;	a -> R19
;	i -> R20,R21
;	j -> Y+6
	__GETWRN 16,17,-1
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x8:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,3
	BRLT PC+2
	RJMP _0x9
; 0000 003E         if (j == 0) PORTF = 0b11111101; //1111 1101,
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SBIW R30,0
	BRNE _0xA
	LDI  R30,LOW(253)
	STS  98,R30
; 0000 003F         if (j == 1) PORTF = 0b11110111; //1111 0111,
_0xA:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,1
	BRNE _0xB
	LDI  R30,LOW(247)
	STS  98,R30
; 0000 0040         if (j == 2) PORTF = 0b11011111; //1101 1111,
_0xB:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,2
	BRNE _0xC
	LDI  R30,LOW(223)
	STS  98,R30
; 0000 0041         for (i = 0; i < 3; i++) { // Xet hang
_0xC:
	__GETWRN 20,21,0
_0xE:
	__CPWRN 20,21,3
	BRGE _0xF
; 0000 0042             if (i == 0) {
	MOV  R0,R20
	OR   R0,R21
	BRNE _0x10
; 0000 0043                 a = PINF&0x04;
	IN   R30,0x0
	ANDI R30,LOW(0x4)
	MOV  R19,R30
; 0000 0044                 if (a != 0x04) {
	CPI  R19,4
	BREQ _0x11
; 0000 0045                    result = keypad[i][j];
	CALL SUBOPT_0x3
; 0000 0046                 }
; 0000 0047             }
_0x11:
; 0000 0048             if (i == 1) {
_0x10:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0x12
; 0000 0049                a = PINF&0x10;
	IN   R30,0x0
	ANDI R30,LOW(0x10)
	MOV  R19,R30
; 0000 004A                if (a != 0x10) {
	CPI  R19,16
	BREQ _0x13
; 0000 004B                   result = keypad[i][j];
	CALL SUBOPT_0x3
; 0000 004C                }
; 0000 004D             }
_0x13:
; 0000 004E 
; 0000 004F             if (i == 2) {
_0x12:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0x14
; 0000 0050                 a = PINF&0x01;
	IN   R30,0x0
	ANDI R30,LOW(0x1)
	MOV  R19,R30
; 0000 0051                 if (a != 0x01) {
	CPI  R19,1
	BREQ _0x15
; 0000 0052                    result = keypad[i][j];
	CALL SUBOPT_0x3
; 0000 0053                 }
; 0000 0054             }
_0x15:
; 0000 0055         }
_0x14:
	__ADDWRN 20,21,1
	RJMP _0xE
_0xF:
; 0000 0056     }
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x8
_0x9:
; 0000 0057     return result;
	MOVW R30,R16
	CALL __LOADLOCR6
	ADIW R28,8
	RET
; 0000 0058 }
; .FEND
;
;
;//
;void check_egg() {
; 0000 005C void check_egg() {
_check_egg:
; .FSTART _check_egg
; 0000 005D      if (x[0] == xegg && y[0] == yegg){
	LDS  R30,_xegg
	LDS  R31,_xegg+1
	LDS  R26,_x
	LDS  R27,_x+1
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x17
	LDS  R30,_yegg
	LDS  R31,_yegg+1
	LDS  R26,_y
	LDS  R27,_y+1
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x18
_0x17:
	RJMP _0x16
_0x18:
; 0000 005E         score += 1;
	LDS  R30,_score
	LDS  R31,_score+1
	ADIW R30,1
	STS  _score,R30
	STS  _score+1,R31
; 0000 005F         slength += 3;
	MOVW R30,R10
	ADIW R30,3
	MOVW R10,R30
; 0000 0060         glcd_clrpixel(tempx, tempy);
	ST   -Y,R12
	LDS  R26,_tempy
	CALL _glcd_clrpixel
; 0000 0061         xegg = rand() % 85 + 1;
	CALL _rand
	MOVW R26,R30
	LDI  R30,LOW(85)
	LDI  R31,HIGH(85)
	CALL __MODW21
	ADIW R30,1
	STS  _xegg,R30
	STS  _xegg+1,R31
; 0000 0062         yegg = rand() % 47 + 1;
	CALL _rand
	MOVW R26,R30
	LDI  R30,LOW(47)
	LDI  R31,HIGH(47)
	CALL __MODW21
	ADIW R30,1
	STS  _yegg,R30
	STS  _yegg+1,R31
; 0000 0063         glcd_setpixel(xegg, yegg);
	CALL SUBOPT_0x2
; 0000 0064      }
; 0000 0065 }
_0x16:
	RET
; .FEND
;
;//
;void draw_snake()
; 0000 0069 {
_draw_snake:
; .FSTART _draw_snake
; 0000 006A    for (i = 0; i < slength; i++) {
	CLR  R8
	CLR  R9
_0x1A:
	__CPWRR 8,9,10,11
	BRGE _0x1B
; 0000 006B       glcd_setpixel(x[i], y[i]);
	CALL SUBOPT_0x0
	LD   R30,X
	ST   -Y,R30
	CALL SUBOPT_0x1
	LD   R26,X
	RCALL _glcd_setpixel
; 0000 006C       glcd_clrpixel(tempx, tempy);
	ST   -Y,R12
	LDS  R26,_tempy
	RCALL _glcd_clrpixel
; 0000 006D    }
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	RJMP _0x1A
_0x1B:
; 0000 006E }
	RET
; .FEND
;
;//
;void move_snake() {
; 0000 0071 void move_snake() {
_move_snake:
; .FSTART _move_snake
; 0000 0072     if (!PAUSE) {
; 0000 0073         bool isEnd = false;
; 0000 0074         delay_ms(75);
	SBIW R28,1
	LDI  R30,LOW(0)
	ST   Y,R30
;	isEnd -> Y+0
	LDI  R26,LOW(75)
	LDI  R27,0
	CALL _delay_ms
; 0000 0075         // auto move
; 0000 0076         if (dr == true) {
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x1D
; 0000 0077             tempx = x[0] + 1;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
; 0000 0078             tempy = y[0];
; 0000 0079         }
; 0000 007A         if (dl == true){
_0x1D:
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x1E
; 0000 007B             tempx = x[0] - 1;
	CALL SUBOPT_0x6
; 0000 007C             tempy = y[0];
; 0000 007D         }
; 0000 007E         if (du == true){
_0x1E:
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0x1F
; 0000 007F             tempx = x[0];
	CALL SUBOPT_0x7
; 0000 0080             tempy = y[0] - 1;
	SBIW R30,1
	CALL SUBOPT_0x8
; 0000 0081         }
; 0000 0082         if (dd == true){
_0x1F:
	LDI  R30,LOW(1)
	CP   R30,R6
	BRNE _0x20
; 0000 0083             tempx = x[0];
	CALL SUBOPT_0x7
; 0000 0084             tempy = y[0] + 1;
	ADIW R30,1
	CALL SUBOPT_0x8
; 0000 0085         }
; 0000 0086 
; 0000 0087 
; 0000 0088         for (i = 1; i < slength; i++) {
_0x20:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R8,R30
_0x22:
	__CPWRR 8,9,10,11
	BRGE _0x23
; 0000 0089             if (x[i] == x[0] && y[i] == y[0]) {
	CALL SUBOPT_0x0
	CALL __GETW1P
	MOVW R26,R30
	CALL SUBOPT_0x4
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x25
	CALL SUBOPT_0x1
	CALL __GETW1P
	MOVW R26,R30
	LDS  R30,_y
	LDS  R31,_y+1
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x26
_0x25:
	RJMP _0x24
_0x26:
; 0000 008A                 delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 008B                 isEnd = true;
	LDI  R30,LOW(1)
	ST   Y,R30
; 0000 008C                 setup();
	RCALL _setup
; 0000 008D             }
; 0000 008E         }
_0x24:
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	RJMP _0x22
_0x23:
; 0000 008F         check_egg();
	RCALL _check_egg
; 0000 0090 
; 0000 0091         //
; 0000 0092         if (tempx <= 0)
	CLR  R0
	CP   R0,R12
	CPC  R0,R13
	BRLT _0x27
; 0000 0093         {
; 0000 0094             tempx = 84 + tempx;
	MOVW R30,R12
	SUBI R30,LOW(-84)
	SBCI R31,HIGH(-84)
	MOVW R12,R30
; 0000 0095         }
; 0000 0096         if (tempx >= 84)
_0x27:
	LDI  R30,LOW(84)
	LDI  R31,HIGH(84)
	CP   R12,R30
	CPC  R13,R31
	BRLT _0x28
; 0000 0097         {
; 0000 0098             tempx = tempx - 84;
	__SUBWRR 12,13,30,31
; 0000 0099         }
; 0000 009A         if (tempy <= 0)
_0x28:
	CALL SUBOPT_0x9
	CALL __CPW02
	BRLT _0x29
; 0000 009B         {
; 0000 009C             tempy = 48 + tempy;
	LDS  R30,_tempy
	LDS  R31,_tempy+1
	ADIW R30,48
	CALL SUBOPT_0x8
; 0000 009D         }
; 0000 009E         if (tempy >= 48)
_0x29:
	CALL SUBOPT_0x9
	SBIW R26,48
	BRLT _0x2A
; 0000 009F         {
; 0000 00A0             tempy = tempy - 48;
	LDS  R30,_tempy
	LDS  R31,_tempy+1
	SBIW R30,48
	CALL SUBOPT_0x8
; 0000 00A1         }
; 0000 00A2 
; 0000 00A3         if (!isEnd) {
_0x2A:
	LD   R30,Y
	CPI  R30,0
	BRNE _0x2B
; 0000 00A4             for (i = 0; i < slength; i++)
	CLR  R8
	CLR  R9
_0x2D:
	__CPWRR 8,9,10,11
	BRGE _0x2E
; 0000 00A5                 {
; 0000 00A6                     xx = x[i];
	CALL SUBOPT_0x0
	CALL __GETW1P
	STS  _xx,R30
	STS  _xx+1,R31
; 0000 00A7                     yy = y[i];
	CALL SUBOPT_0x1
	CALL __GETW1P
	STS  _yy,R30
	STS  _yy+1,R31
; 0000 00A8                     x[i] = tempx;
	MOVW R30,R8
	LDI  R26,LOW(_x)
	LDI  R27,HIGH(_x)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R12
	STD  Z+1,R13
; 0000 00A9                     y[i] = tempy;
	MOVW R30,R8
	LDI  R26,LOW(_y)
	LDI  R27,HIGH(_y)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x9
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 00AA                     tempx = xx;
	__GETWRMN 12,13,0,_xx
; 0000 00AB                     tempy = yy;
	LDS  R30,_yy
	LDS  R31,_yy+1
	CALL SUBOPT_0x8
; 0000 00AC                 }
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	RJMP _0x2D
_0x2E:
; 0000 00AD         }
; 0000 00AE 
; 0000 00AF 
; 0000 00B0         draw_snake();
_0x2B:
	RCALL _draw_snake
; 0000 00B1 
; 0000 00B2     }
	ADIW R28,1
; 0000 00B3 }
	RET
; .FEND
;
;
;
;//
;void direct(int phim) {
; 0000 00B8 void direct(int phim) {
_direct:
; .FSTART _direct
; 0000 00B9     if (phim == DOWN && (dr == true || dl == true))
	CALL SUBOPT_0xA
;	phim -> Y+0
	SBIW R26,5
	BRNE _0x30
	LDI  R30,LOW(1)
	CP   R30,R4
	BREQ _0x31
	CP   R30,R5
	BRNE _0x30
_0x31:
	RJMP _0x33
_0x30:
	RJMP _0x2F
_0x33:
; 0000 00BA     {
; 0000 00BB         dr = false;
	CLR  R4
; 0000 00BC         dl = false;
	CLR  R5
; 0000 00BD         du = false;
	CLR  R7
; 0000 00BE         dd = true;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 00BF         tempx = x[0]; //Save the new coordinates of head in tempx,tempy
	CALL SUBOPT_0x7
; 0000 00C0         tempy = y[0] + 1;
	ADIW R30,1
	CALL SUBOPT_0x8
; 0000 00C1     }
; 0000 00C2     if (phim == UP && (dr == true || dl == true)) {
_0x2F:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,2
	BRNE _0x35
	LDI  R30,LOW(1)
	CP   R30,R4
	BREQ _0x36
	CP   R30,R5
	BRNE _0x35
_0x36:
	RJMP _0x38
_0x35:
	RJMP _0x34
_0x38:
; 0000 00C3         dr = false;
	CLR  R4
; 0000 00C4         dl = false;
	CLR  R5
; 0000 00C5         du = true;
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 00C6         dd = false;
	CLR  R6
; 0000 00C7         tempx = x[0]; //Save the new coordinates of head in tempx,tempy
	CALL SUBOPT_0x7
; 0000 00C8         tempy = y[0] - 1;
	SBIW R30,1
	CALL SUBOPT_0x8
; 0000 00C9     }
; 0000 00CA     if (phim == LEFT && (dd == true || du == true)) {
_0x34:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,4
	BRNE _0x3A
	LDI  R30,LOW(1)
	CP   R30,R6
	BREQ _0x3B
	CP   R30,R7
	BRNE _0x3A
_0x3B:
	RJMP _0x3D
_0x3A:
	RJMP _0x39
_0x3D:
; 0000 00CB         dr = false;
	CLR  R4
; 0000 00CC         dl = true;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 00CD         du = false;
	CLR  R7
; 0000 00CE         dd = false;
	CLR  R6
; 0000 00CF         tempx = x[0]-1; //Save the new coordinates of head in tempx,tempy
	CALL SUBOPT_0x6
; 0000 00D0         tempy = y[0];
; 0000 00D1     }
; 0000 00D2     if (phim == RIGHT && (dd == true || du == true))
_0x39:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,6
	BRNE _0x3F
	LDI  R30,LOW(1)
	CP   R30,R6
	BREQ _0x40
	CP   R30,R7
	BRNE _0x3F
_0x40:
	RJMP _0x42
_0x3F:
	RJMP _0x3E
_0x42:
; 0000 00D3     {
; 0000 00D4         dr = true;
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0000 00D5         dl = false;
	CLR  R5
; 0000 00D6         du = false;
	CLR  R7
; 0000 00D7         dd = false;
	CLR  R6
; 0000 00D8         tempx = x[0] + 1; //Save the new coordinates of head in tempx,tempy
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
; 0000 00D9         tempy = y[0];
; 0000 00DA     }
; 0000 00DB }
_0x3E:
	RJMP _0x2120002
; .FEND
;//main
;void main(void)
; 0000 00DE {
_main:
; .FSTART _main
; 0000 00DF GLCDINIT_t glcd_init_data;
; 0000 00E0 glcd_init_data.font = font5x7;
	SBIW R28,8
;	glcd_init_data -> Y+0
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	ST   Y,R30
	STD  Y+1,R31
; 0000 00E1 glcd_init_data.readxmem=NULL;
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+2+1,R30
; 0000 00E2 glcd_init_data.writexmem=NULL;
	STD  Y+4,R30
	STD  Y+4+1,R30
; 0000 00E3 glcd_init_data.temp_coef=160;
	LDD  R30,Y+6
	ANDI R30,LOW(0xFC)
	STD  Y+6,R30
; 0000 00E4 glcd_init_data.bias=6;
	ANDI R30,LOW(0xE3)
	ORI  R30,LOW(0x18)
	STD  Y+6,R30
; 0000 00E5 glcd_init_data.vlcd=46;
	LDD  R30,Y+7
	ANDI R30,LOW(0x80)
	ORI  R30,LOW(0x2E)
	STD  Y+7,R30
; 0000 00E6 glcd_init(&glcd_init_data);
	MOVW R26,R28
	RCALL _glcd_init
; 0000 00E7 
; 0000 00E8 DDRD = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 00E9 PORTD = 0xB6;
	LDI  R30,LOW(182)
	OUT  0x12,R30
; 0000 00EA DDRF = 0b11101010;
	LDI  R30,LOW(234)
	STS  97,R30
; 0000 00EB PORTF = 0b00010101;
	LDI  R30,LOW(21)
	STS  98,R30
; 0000 00EC 
; 0000 00ED setup();
	RCALL _setup
; 0000 00EE while (1)
_0x43:
; 0000 00EF     {
; 0000 00F0         // Please write your application code here
; 0000 00F1         int phim = BUTTON();
; 0000 00F2         direct(phim);
	SBIW R28,2
;	glcd_init_data -> Y+2
;	phim -> Y+0
	RCALL _BUTTON
	ST   Y,R30
	STD  Y+1,R31
	LD   R26,Y
	LDD  R27,Y+1
	RCALL _direct
; 0000 00F3         move_snake();
	RCALL _move_snake
; 0000 00F4     }
	ADIW R28,2
	RJMP _0x43
; 0000 00F5 }
_0x46:
	RJMP _0x46
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_pcd8544_delay_G100:
; .FSTART _pcd8544_delay_G100
	RET
; .FEND
_pcd8544_wrbus_G100:
; .FSTART _pcd8544_wrbus_G100
	ST   -Y,R26
	ST   -Y,R17
	LDS  R30,101
	ANDI R30,0xEF
	STS  101,R30
	LDI  R17,LOW(8)
_0x2000004:
	RCALL _pcd8544_delay_G100
	LDD  R30,Y+1
	ANDI R30,LOW(0x80)
	BREQ _0x2000006
	LDS  R30,101
	ORI  R30,2
	RJMP _0x20000A0
_0x2000006:
	LDS  R30,101
	ANDI R30,0xFD
_0x20000A0:
	STS  101,R30
	LDD  R30,Y+1
	LSL  R30
	STD  Y+1,R30
	RCALL _pcd8544_delay_G100
	LDS  R30,101
	ORI  R30,4
	STS  101,R30
	RCALL _pcd8544_delay_G100
	LDS  R30,101
	ANDI R30,0xFB
	STS  101,R30
	SUBI R17,LOW(1)
	BRNE _0x2000004
	LDS  R30,101
	ORI  R30,0x10
	STS  101,R30
	LDD  R17,Y+0
	RJMP _0x2120002
; .FEND
_pcd8544_wrcmd:
; .FSTART _pcd8544_wrcmd
	ST   -Y,R26
	LDS  R30,101
	ANDI R30,0xFE
	STS  101,R30
	LD   R26,Y
	RCALL _pcd8544_wrbus_G100
	RJMP _0x2120003
; .FEND
_pcd8544_wrdata_G100:
; .FSTART _pcd8544_wrdata_G100
	ST   -Y,R26
	LDS  R30,101
	ORI  R30,1
	STS  101,R30
	LD   R26,Y
	RCALL _pcd8544_wrbus_G100
	RJMP _0x2120003
; .FEND
_pcd8544_setaddr_G100:
; .FSTART _pcd8544_setaddr_G100
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+1
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R17,R30
	LDI  R30,LOW(84)
	MUL  R30,R17
	MOVW R30,R0
	MOVW R26,R30
	LDD  R30,Y+2
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STS  _gfx_addr_G100,R30
	STS  _gfx_addr_G100+1,R31
	MOV  R30,R17
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_pcd8544_gotoxy:
; .FSTART _pcd8544_gotoxy
	ST   -Y,R26
	LDD  R30,Y+1
	ORI  R30,0x80
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _pcd8544_setaddr_G100
	ORI  R30,0x40
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
	RJMP _0x2120002
; .FEND
_pcd8544_rdbyte:
; .FSTART _pcd8544_rdbyte
	ST   -Y,R26
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _pcd8544_gotoxy
	LDS  R30,_gfx_addr_G100
	LDS  R31,_gfx_addr_G100+1
	SUBI R30,LOW(-_gfx_buffer_G100)
	SBCI R31,HIGH(-_gfx_buffer_G100)
	LD   R30,Z
	RJMP _0x2120002
; .FEND
_pcd8544_wrbyte:
; .FSTART _pcd8544_wrbyte
	ST   -Y,R26
	LDI  R26,LOW(_gfx_addr_G100)
	LDI  R27,HIGH(_gfx_addr_G100)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	SUBI R30,LOW(-_gfx_buffer_G100)
	SBCI R31,HIGH(-_gfx_buffer_G100)
	LD   R26,Y
	STD  Z+0,R26
	RCALL _pcd8544_wrdata_G100
	RJMP _0x2120003
; .FEND
_glcd_init:
; .FSTART _glcd_init
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
	LDS  R30,100
	ORI  R30,0x10
	CALL SUBOPT_0xB
	ORI  R30,0x10
	STS  101,R30
	LDS  R30,100
	ORI  R30,4
	CALL SUBOPT_0xB
	ANDI R30,0xFB
	STS  101,R30
	LDS  R30,100
	ORI  R30,2
	STS  100,R30
	LDS  R30,100
	ORI  R30,1
	STS  100,R30
	LDS  R30,100
	ORI  R30,8
	CALL SUBOPT_0xB
	ANDI R30,0XF7
	STS  101,R30
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
	LDS  R30,101
	ORI  R30,8
	STS  101,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,0
	BREQ _0x2000008
	LDD  R30,Z+6
	ANDI R30,LOW(0x3)
	MOV  R17,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R30,Z+6
	LSR  R30
	LSR  R30
	ANDI R30,LOW(0x7)
	MOV  R16,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R30,Z+7
	ANDI R30,0x7F
	MOV  R19,R30
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __GETW1P
	__PUTW1MN _glcd_state,4
	ADIW R26,2
	CALL __GETW1P
	__PUTW1MN _glcd_state,25
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,4
	CALL __GETW1P
	RJMP _0x20000A1
_0x2000008:
	LDI  R17,LOW(0)
	LDI  R16,LOW(3)
	LDI  R19,LOW(50)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	__PUTW1MN _glcd_state,4
	__PUTW1MN _glcd_state,25
_0x20000A1:
	__PUTW1MN _glcd_state,27
	LDI  R26,LOW(33)
	RCALL _pcd8544_wrcmd
	MOV  R30,R17
	ORI  R30,4
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
	MOV  R30,R16
	ORI  R30,0x10
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
	MOV  R30,R19
	ORI  R30,0x80
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
	LDI  R26,LOW(32)
	RCALL _pcd8544_wrcmd
	LDI  R26,LOW(1)
	RCALL _glcd_display
	LDI  R30,LOW(1)
	STS  _glcd_state,R30
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,1
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,6
	__PUTB1MN _glcd_state,7
	__PUTB1MN _glcd_state,8
	LDI  R30,LOW(255)
	__PUTB1MN _glcd_state,9
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,16
	__POINTW1MN _glcd_state,17
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(8)
	LDI  R27,0
	CALL _memset
	RCALL _glcd_clear
	LDI  R30,LOW(1)
	CALL __LOADLOCR4
	ADIW R28,6
	RET
; .FEND
_glcd_display:
; .FSTART _glcd_display
	ST   -Y,R26
	LD   R30,Y
	CPI  R30,0
	BREQ _0x200000A
	LDI  R30,LOW(12)
	RJMP _0x200000B
_0x200000A:
	LDI  R30,LOW(8)
_0x200000B:
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
_0x2120003:
	ADIW R28,1
	RET
; .FEND
_glcd_clear:
; .FSTART _glcd_clear
	CALL __SAVELOCR4
	LDI  R19,0
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x200000D
	LDI  R19,LOW(255)
_0x200000D:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _pcd8544_gotoxy
	__GETWRN 16,17,504
_0x200000E:
	MOVW R30,R16
	__SUBWRN 16,17,1
	SBIW R30,0
	BREQ _0x2000010
	MOV  R26,R19
	RCALL _pcd8544_wrbyte
	RJMP _0x200000E
_0x2000010:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _glcd_moveto
	CALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
_glcd_putpixel:
; .FSTART _glcd_putpixel
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+4
	CPI  R26,LOW(0x54)
	BRSH _0x2000012
	LDD  R26,Y+3
	CPI  R26,LOW(0x30)
	BRLO _0x2000011
_0x2000012:
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x2120001
_0x2000011:
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _pcd8544_rdbyte
	MOV  R17,R30
	LDD  R30,Y+3
	ANDI R30,LOW(0x7)
	LDI  R26,LOW(1)
	CALL __LSLB12
	MOV  R16,R30
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x2000014
	OR   R17,R16
	RJMP _0x2000015
_0x2000014:
	MOV  R30,R16
	COM  R30
	AND  R17,R30
_0x2000015:
	MOV  R26,R17
	RCALL _pcd8544_wrbyte
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x2120001
; .FEND

	.CSEG
_glcd_clipx:
; .FSTART _glcd_clipx
	CALL SUBOPT_0xA
	CALL __CPW02
	BRLT _0x2020003
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120002
_0x2020003:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x54)
	LDI  R30,HIGH(0x54)
	CPC  R27,R30
	BRLT _0x2020004
	LDI  R30,LOW(83)
	LDI  R31,HIGH(83)
	RJMP _0x2120002
_0x2020004:
	LD   R30,Y
	LDD  R31,Y+1
	RJMP _0x2120002
; .FEND
_glcd_clipy:
; .FSTART _glcd_clipy
	CALL SUBOPT_0xA
	CALL __CPW02
	BRLT _0x2020005
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120002
_0x2020005:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,48
	BRLT _0x2020006
	LDI  R30,LOW(47)
	LDI  R31,HIGH(47)
	RJMP _0x2120002
_0x2020006:
	LD   R30,Y
	LDD  R31,Y+1
	RJMP _0x2120002
; .FEND
_glcd_setpixel:
; .FSTART _glcd_setpixel
	ST   -Y,R26
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R30,Y+1
	ST   -Y,R30
	LDS  R26,_glcd_state
	RCALL _glcd_putpixel
	RJMP _0x2120002
; .FEND
_glcd_clrpixel:
; .FSTART _glcd_clrpixel
	ST   -Y,R26
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R30,Y+1
	ST   -Y,R30
	__GETB2MN _glcd_state,1
	RCALL _glcd_putpixel
	RJMP _0x2120002
; .FEND
_glcd_moveto:
; .FSTART _glcd_moveto
	ST   -Y,R26
	LDD  R26,Y+1
	CLR  R27
	RCALL _glcd_clipx
	__PUTB1MN _glcd_state,2
	LD   R26,Y
	CLR  R27
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
_0x2120002:
	ADIW R28,2
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.DSEG

	.CSEG
_rand:
; .FSTART _rand
	LDS  R30,__seed_G104
	LDS  R31,__seed_G104+1
	LDS  R22,__seed_G104+2
	LDS  R23,__seed_G104+3
	__GETD2N 0x41C64E6D
	CALL __MULD12U
	__ADDD1N 30562
	STS  __seed_G104,R30
	STS  __seed_G104+1,R31
	STS  __seed_G104+2,R22
	STS  __seed_G104+3,R23
	movw r30,r22
	andi r31,0x7F
	RET
; .FEND

	.CSEG
_memset:
; .FSTART _memset
	ST   -Y,R27
	ST   -Y,R26
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
_0x2120001:
	ADIW R28,5
	RET
; .FEND

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_glcd_state:
	.BYTE 0x1D
_keypad:
	.BYTE 0x12
_x:
	.BYTE 0x190
_y:
	.BYTE 0x190
_tempy:
	.BYTE 0x2
_xx:
	.BYTE 0x2
_yy:
	.BYTE 0x2
_score:
	.BYTE 0x2
_xegg:
	.BYTE 0x2
_yegg:
	.BYTE 0x2
_gfx_addr_G100:
	.BYTE 0x2
_gfx_buffer_G100:
	.BYTE 0x1F8
__seed_G104:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x0:
	MOVW R30,R8
	LDI  R26,LOW(_x)
	LDI  R27,HIGH(_x)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1:
	MOVW R30,R8
	LDI  R26,LOW(_y)
	LDI  R27,HIGH(_y)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	LDS  R30,_xegg
	ST   -Y,R30
	LDS  R26,_yegg
	JMP  _glcd_setpixel

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x3:
	__MULBNWRU 20,21,6
	SUBI R30,LOW(-_keypad)
	SBCI R31,HIGH(-_keypad)
	MOVW R26,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R16,X+
	LD   R17,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	LDS  R30,_x
	LDS  R31,_x+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	ADIW R30,1
	MOVW R12,R30
	LDS  R30,_y
	LDS  R31,_y+1
	STS  _tempy,R30
	STS  _tempy+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6:
	RCALL SUBOPT_0x4
	SBIW R30,1
	MOVW R12,R30
	LDS  R30,_y
	LDS  R31,_y+1
	STS  _tempy,R30
	STS  _tempy+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x7:
	__GETWRMN 12,13,0,_x
	LDS  R30,_y
	LDS  R31,_y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8:
	STS  _tempy,R30
	STS  _tempy+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LDS  R26,_tempy
	LDS  R27,_tempy+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	ST   -Y,R27
	ST   -Y,R26
	LD   R26,Y
	LDD  R27,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	STS  100,R30
	LDS  R30,101
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
