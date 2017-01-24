;Pulse Width Modulator Simulator.
;Move the ADC input to change the
;pulse width and allow two cycles
;for a correct reading.


ORG 0000H
LJMP BEGIN

ORG 000BH			; interrupt 1
LJMP TIMER_1_START

ORG 001BH			;interrupt 2
LJMP TIMER_O_START

BEGIN:
MOV TMOD, #00100010B ;timer setup

;interrupt setup
SETB EA
SETB ET0
SETB ET1

CLR P0.7 ;DAC setup

TIMER_O_START:		;timer loop
	CLR TR1
	LCALL ADC		;sets pwm
	LCALL DAC_5V	;moves to 5v
	SETB TR0
	JNB TF0, $
	RETI

TIMER_1_START:
	CLR TR0
	LCALL ADC
	LCALL DAC_0V
	SETB TR1
	JNB TF1, $
	RETI

;-------Functions---------
DAC_5V:
	MOV P1, #033H
	MOV P1, #066H
	MOV P1, #099H
	MOV P1, #0CCH
	MOV P1, #0FFH	
	RET

DAC_0V:
	MOV P1, #0CCH
	MOV P1, #099H
	MOV P1, #066H
	MOV P1, #033H
	MOV P1, #00H	
	RET

ADC:
	CLR P3.6
	SETB P3.6
	CLR P3.7
	MOV TH1, P2
	MOV A, #0FFH
	SUBB A, P2
	MOV TH0, A
	RET

END
