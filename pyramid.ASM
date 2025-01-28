_code segment
	assume  cs:_code, ds:_data, ss:_stack

start:		
	mov	ax,_data
	mov	ds,ax
	mov	ax,_stack
	mov	ss,ax
	mov	sp,offset top

        push    0b800h
        pop     es
        mov     al,' '
        mov     ah,7
        mov     di,0
        mov     cx,2000

clear:
        mov     es:[di],al
        inc     di
        mov     es:[di],ah
        inc     di

        loop clear

        mov     al,'A'
	mov	ah,7
        mov     di,400
        mov     cx,1

petla:
	mov 	dx,cx
wypisz_wiersz:
        mov 	es:[di],al
	inc 	di
	mov 	es:[di],ah
	inc	di
	dec cx
	jnz wypisz_wiersz

	mov	cx,dx

	add	di,158
	sub	di,cx
	sub	di,cx

	add	cx,2
	inc	al

	cmp 	di,4000
	jb	petla	

        mov     ah,4ch
        mov     al,0
        int     21h

_code ends

_data segment
	; your data goes here
_data ends

_stack segment stack
	top_stack	equ 100h
top	Label word
_stack ends

end start