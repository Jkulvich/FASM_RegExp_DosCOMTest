use16
org 100h

; (a120)*(a001)*(baa0)*
; выходы в точках A E K
; 012ab (48 49 50 97 98)
; 338 СТРОК 7:10 17/04/2017 Кулагин Юрий (Jkulvich)

JMP f_start

s_buff db 254 ; max symbols
db 255 dup(?) ; symbols

s_welcome_0 db "Welcome to RegExp checker! By @Jkulvich P.S. it powered by FASM!$"
s_welcome_1 db "I can check it: (a120)*(a001)*(baa0)*$"
s_welcome_2 db "Write your string on next line:$"

s_checking_symbols db "Checking symbols...$"
s_incorrect_symbol db "Incorrect symbol finded! Must be only: 012ab$"
s_correct_symbols db "All symbols is correct.$"

s_string_less_four db "[NO] - SAD, BUT YOUR STRING CANT BE LESS FOUR$"

s_all_ok db "[YES] - ALL OK, ITs CONTAIN RegExp!$"
s_no_ok db "[NO] - SAD, BUT YOUR STRING IS NOT CONTAIN RegExp$"

; --------------------

f_start:
	MOV dx,s_welcome_0
	CALL f_write
	CALL f_EOL

	MOV dx,s_welcome_1
	CALL f_write
	CALL f_EOL

	MOV dx,s_welcome_2
	CALL f_write
	CALL f_EOL

	; чтение строки в буфер
	CALL f_readline
	CALL f_EOL

	; Проверяем все символы на допустимые, в противном случае ЗАВЕРШАЕМ работу
	CALL f_symbolscheck

	; Проверяем строку на длинну, если меньше 4, то не укладывается в наше условие, ЗАВЕРШАЕМ
	CALL f_getlength
	CMP al,4
	JB f_exit_because_less

	; Основная проверка выражения
	CALL f_check

CALL f_end

; --------------------

f_check:
	MOV dl,">"
	CALL f_print

	MOV dh,0

	MOV al,dh
	CALL f_getchar

	CMP al,"a"
	JZ f_pA

	CMP al,"b"
	JZ f_pK

	CALL f_exit_because_nocontain
RET

f_pA:
	MOV dl,"A"
	CALL f_print
		; если строка закончилась и мы не вылетели раньше - ПОБЕДА!
		; выходы возможны в точках AEK
		CALL f_check_eol_exit
	MOV al,dh
	CALL f_getchar
	ADD dh,1
		CMP al,"a"
		JZ f_pB

		CMP al,"b"
		JZ f_pL
	CALL f_exit_because_nocontain
RET

f_pB:
	MOV dl,"B"
	CALL f_print
	MOV al,dh
	CALL f_getchar
	ADD dh,1
		CMP al,"1"
		JZ f_pC

		CMP al,"0"
		JZ f_pG
	CALL f_exit_because_nocontain
RET

f_pC:
	MOV dl,"C"
	CALL f_print
	MOV al,dh
	CALL f_getchar
	ADD dh,1
		CMP al,"2"
		JZ f_pD
	CALL f_exit_because_nocontain
RET

f_pD:
	MOV dl,"D"
	CALL f_print
	MOV al,dh
	CALL f_getchar
	ADD dh,1
		CMP al,"0"
		JZ f_pA
	CALL f_exit_because_nocontain
RET

f_pE:
	MOV dl,"E"
	CALL f_print
		CALL f_check_eol_exit
	MOV al,dh
	CALL f_getchar
	ADD dh,1
		CMP al,"a"
		JZ f_pF

		CMP al,"b"
		JZ f_pL
	CALL f_exit_because_nocontain
RET

f_pF:
	MOV dl,"F"
	CALL f_print
	MOV al,dh
	CALL f_getchar
	ADD dh,1
		CMP al,"0"
		JZ f_pG
	CALL f_exit_because_nocontain
RET

f_pG:
	MOV dl,"G"
	CALL f_print
	MOV al,dh
	CALL f_getchar
	ADD dh,1
		CMP al,"0"
		JZ f_pH
	CALL f_exit_because_nocontain
RET

f_pH:
	MOV dl,"H"
	CALL f_print
	MOV al,dh
	CALL f_getchar
	ADD dh,1
		CMP al,"1"
		JZ f_pE
	CALL f_exit_because_nocontain
RET

f_pK:
	MOV dl,"K"
	CALL f_print
		CALL f_check_eol_exit
	MOV al,dh
	CALL f_getchar
	ADD dh,1
		CMP al,"b"
		JZ f_pL
	CALL f_exit_because_nocontain
RET

f_pL:
	MOV dl,"L"
	CALL f_print
	MOV al,dh
	CALL f_getchar
	ADD dh,1
		CMP al,"a"
		JZ f_pM
	CALL f_exit_because_nocontain
RET

f_pM:
	MOV dl,"M"
	CALL f_print
	MOV al,dh
	CALL f_getchar
	ADD dh,1
		CMP al,"a"
		JZ f_pN
	CALL f_exit_because_nocontain
RET

f_pN:
	MOV dl,"N"
	CALL f_print
	MOV al,dh
	CALL f_getchar
	ADD dh,1
		CMP al,"0"
		JZ f_pK
	CALL f_exit_because_nocontain
RET

; Проверка строки на допустимые символы
f_symbolscheck:
	MOV dx,s_checking_symbols
	CALL f_write
	CALL f_EOL

	CALL f_getlength
	MOV ah,0h
	MOV cx,ax
	f_symbolscheck_cycle:
		MOV ax,cx
		SUB al,1
		; получаем текущий символ в AL
		CALL f_getchar

			CMP al,"0" ; если символ равен, то переходим в конец цикла
			JZ f_symbolscheck_eoc

			CMP al,"1"
			JZ f_symbolscheck_eoc

			CMP al,"2"
			JZ f_symbolscheck_eoc

			CMP al,"a"
			JZ f_symbolscheck_eoc

			CMP al,"b"
			JZ f_symbolscheck_eoc

		 ; если дошли до сюда, значит ни один из символов не подошёл
		 MOV dx,s_incorrect_symbol
		 CALL f_write
		 CALL f_end

	f_symbolscheck_eoc:
	LOOP f_symbolscheck_cycle

	MOV dx,s_correct_symbols
	CALL f_write
	CALL f_EOL
RET

; > AL - номер позиции символа
; < AL - код символа
f_getchar:
	MOV ah,0
	ADD ax,2
	ADD ax,s_buff
	MOV si,ax
	LODSB
RET

; < AL - количество символов в строке
f_getlength:
	MOV ax,1
	ADD ax,s_buff
	MOV si,ax
	LODSB
RET

; Чтение строки в 254 символа, либо до EOL
f_readline:
	MOV ah,0Ah
	MOV dx,s_buff
	INT 21h
RET

; > DL - код символа
f_print:
	MOV ah,06h
	INT 21h
RET

; > DX - номер байта с которого следует выводить строку
f_write:
	MOV ah,09h
	INT 21h
RET

; Перевод курсора на новую строку
f_EOL:
	MOV dl,0Ah
	CALL f_print
RET

f_exit_because_less:
	MOV dx,s_string_less_four
	CALL f_write
	CALL f_end
RET

f_exit_because_nocontain:
	CALL f_EOL
	MOV dx,s_no_ok
	CALL f_write
	CALL f_end
RET

f_exit_because_ok:
	CALL f_EOL
	MOV dx,s_all_ok
	CALL f_write
	CALL f_end
RET

f_check_eol_exit:
	CALL f_getlength
	CMP dh,al
	JZ f_exit_because_ok
RET

f_end:
	MOV ah,4Ch
	INT 21h