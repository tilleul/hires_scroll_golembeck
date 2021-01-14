
	processor 6502
	seg.u ZEROPAGE	; uninitialized zero-page variables
	org $0

Temp	equ $06
mask	equ $07
page	equ $08

	seg CODE
	org $803	; starting address

Start

        lda	$c050		; graphics
        lda	$c052		; full
        lda	$c057		; hires
        
        
	LDX	#0
        STX 	mask
        stx	page
        lda	$c054,x
        
loop	
	jsr 	scroll
        

end	jmp 	loop


scroll  subroutine

	ldx	#0
lpY
	LDA 	YLOOKHI,X	; get line base adress HI-byte
        EOR 	mask		; HIRES page #1
        STA	hb1+2
        STA	hb2+2


	;LDA 	YLOOKHI,X
        eor	#$60		; HIRES page #2
        STA	hb1_1+2
        STA	hb1_2+2
        STA	noC2+2
        STA	noC3+2
        STA	hb2_1+2
        STA	hb2_2+2
        STA	hb2_3+2
        STA	hb2_4+2
        STA	hb3_1+2
        STA	hb3+2
        
	LDA 	YLOOKLO,X	; get line base adress LO-byte
	STA	hb1+1
        STA	hb1_1+1
        STA	hb1_2+1
        STA	noC2+1
        STA	noC3+1
        STA	hb2+1
        STA	hb2_1+1
        STA	hb2_2+1
        STA	hb2_3+1
        STA	hb2_4+1
        STA	hb3+1
        STA	hb3_1+1

cc1	LDY	#39
hb1	LDA	$2000,Y		; get the first byte of the new line
	LSR
	BCC	noC1
	LSR
	BCC	noC2
hb1_1	STA	$2000,Y			
	LDA	#%01100000
	STA	Temp		; two bits shifted out, save them
	Bne	lpX
noC1	LSR
	BCC	noC3
hb1_2	STA	$2000,Y
	LDA	#%01000000
	STA	Temp
	Bne	lpX
noC2	STA	$2000,Y
	LDA	#%00100000
	STA	Temp
	Bne	lpX
noC3	STA	$2000,Y
	LDA	#0
	STA	Temp
								
lpX	DEY
	BMI	lpXend

hb2	LDA	$2000,Y		; get the bytes 01 to 39 of the line
	LSR
	BCC	noC1a
	LSR
	BCC	noC2a
	ORA	Temp		; put the two shifted bits from the former
hb2_1	STA	$2000,Y		; HIRES-byte into the correct position
	LDA	#%01100000
	STA	Temp		; save MASK for the two shifted out bits
	Bne	lpX
noC1a	LSR
	BCC	noC3a
	ORA	Temp
hb2_2	STA	$2000,Y
	LDA	#%01000000
	STA	Temp
	Bne	lpX
noC2a	ORA	Temp
hb2_3	STA	$2000,Y
	LDA	#%00100000
	STA	Temp
	Bne	lpX
noC3a	ORA	Temp
hb2_4	STA	$2000,Y
	LDA	#0
	STA	Temp
	Beq	lpX
	
lpXend	LDY	#39
hb3	LDA	$2000,Y
	ORA	Temp
hb3_1	STA	$2000,Y			
				
	INX			; repeat for all 192 lines
	CPX	#192
	BEQ	cc1_1
	JMP	lpY
		
cc1_1	
	
	LDA 	mask
        eor	#$60
        sta	mask
        
        lda 	page
        eor 	#1
        sta	page
	tax

	sta 	$c054,x

	rts






        


YLOOKHI		hex     2024282C3034383C
        	hex     2024282C3034383C
        	hex     2125292D3135393D
        	hex     2125292D3135393D
        	hex     22262A2E32363A3E
        	hex     22262A2E32363A3E
        	hex     23272B2F33373B3F
        	hex     23272B2F33373B3F
        	hex     2024282C3034383C
        	hex     2024282C3034383C
        	hex     2125292D3135393D
        	hex     2125292D3135393D
        	hex     22262A2E32363A3E
        	hex     22262A2E32363A3E
        	hex     23272B2F33373B3F
        	hex     23272B2F33373B3F
        	hex     2024282C3034383C
        	hex     2024282C3034383C
        	hex     2125292D3135393D
        	hex     2125292D3135393D
        	hex     22262A2E32363A3E
        	hex     22262A2E32363A3E
        	hex     23272B2F33373B3F
        	hex     23272B2F33373B3F


YLOOKLO
		hex     0000000000000000
                hex     8080808080808080
                hex     0000000000000000
                hex     8080808080808080
                hex     0000000000000000
                hex     8080808080808080
                hex     0000000000000000
                hex     8080808080808080
                hex     2828282828282828
                hex     A8A8A8A8A8A8A8A8
                hex     2828282828282828
                hex     A8A8A8A8A8A8A8A8
                hex     2828282828282828
                hex     A8A8A8A8A8A8A8A8
                hex     2828282828282828
                hex     A8A8A8A8A8A8A8A8
                hex     5050505050505050
                hex     D0D0D0D0D0D0D0D0
                hex     5050505050505050
                hex     D0D0D0D0D0D0D0D0
                hex     5050505050505050
                hex     D0D0D0D0D0D0D0D0
                hex     5050505050505050
                hex     D0D0D0D0D0D0D0D0
        
        
        
		org $2000
                incbin "dott-apple2.hires.bin"
