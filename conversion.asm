_code segment
	assume  cs:_code, ds:_data, ss:_stack

start:		
	mov	ax,_data
	mov	ds,ax
	mov	ax,_stack
	mov	ss,ax
	mov	sp,offset top
                                                 
	;wypisz msg10
	mov	dx, offset msg10
	mov 	ah, 09h
	int	21h

	;wczytaj lancuch
	mov 	dx, offset max 
	mov	ah, 0ah
	int	21h

	;enter
	mov 	dx, offset newLine
	mov 	ah, 09h
	int 	21h
              
    	;zapis liczby w ax
    	call zapis
    
    	push ax
              
    	;konwersja na hex
    	call konwersjaHex
    
    	;wypisz msg16
	mov	dx, offset msg16
	mov 	ah, 09h
	int	21h           
              
    	;wypisz wynik w hex 
    	mov	dx, offset wynik16
	mov 	ah, 09h
	int	21h
    
    	;enter
	mov 	dx, offset newLine
	mov 	ah, 09h
	int 	21h
    
    	pop ax
    
    	;konwersja na bin
    	call konwersjaBin
    
    	;wypisz msg2
	mov	dx, offset msg2
	mov 	ah, 09h
	int	21h
    
   	;wypisz wynik w bin 
    	mov	dx, offset wynik2
	mov 	ah, 09h
	int	21h
    
    	;koniec programu        
   	mov     ah,4ch
    	int     21h
    
konwersjaBin:
    	;przygotowanie
    	mov     bx, 2      	;dzielnik
    	lea     di, wynik2 	;miejsce na wynik
    	mov     cl, 0       	;licznik cyfr
petlaBin:	
    	mov     dx, 0    	;reszta
    	div     bx
    	push    dx
    	inc     cl  
    	cmp     ax, 0
    	jz      b_konwersjaASCII
    	jmp     petlaBin
          
b_konwersjaASCII:
    	pop     ax
    	add     al, '0'
    	mov     [di], al
    	inc     di
    	dec     cl   
    	jnz     b_konwersjaASCII
    	mov     al, '$'
    	mov     [di], al
    	ret
    
konwersjaHex:
    	;przygotowanie
    	mov     bx, 16      ;dzielnik
    	lea     di, wynik16 ;miejsce na wynik
    	mov     dx, 0       ;reszta
    	mov     cl, 0       ;licznik cyfr
petlaHex:
    	mov     dx, 0    
    	div     bx
    	push    dx
    	inc     cl  
    	cmp     ax, 0
    	jz      h_konwersjaASCII
    	jmp     petlaHex
          
h_konwersjaASCII:
    	pop     ax
    
    	;zamien na ASCII  
    	cmp     al, 10
    	jb      cyfra
    	add     al, 55
    	jmp     h_pomin
cyfra:
    	add     al, '0'
h_pomin:
    	mov     [di], al
    	inc     di
    	dec     cl   
    	jnz     h_konwersjaASCII
    	mov     al, '$'
    	mov     [di], al
    	ret
     
zapis: 
	;przygotowanie
	mov	bx, 10      ;moznik
	mov	ax, 0       ;liczba
	mov	dx, 0     
	mov     cx, 0       ;znak
	mov	di, 0 	    ;di = 1 - liczba ujemna			
    	lea     si, chars
	
	;spr czy liczba ujemna
	cmp	[si], '-'
	jnz	konwersja

	;przeskocz minus
	inc 	si
	mov	di, 1   
	
	;spr czy wpisano sam minus
	cmp     [si], 13
	jz      blad

konwersja: 
	mov 	cl, [si]

	;spr czy enter
	cmp	cl, 13
	jz	koniec_konwersji
	
	;zamiana na cyfre
	sub 	cl, '0'
	
	;spr czy znak to cyfra
	js      blad
    	cmp     cl, 10
	jns     blad     

	mul 	bx
	cmp     dx, 0
	jnz	blad
	add	ax, cx
	
	inc	si
	jmp 	konwersja

koniec_konwersji:  
	;sprawdz czy ujemna i czy miesci sie w zakresie
	cmp	di, 1
	jnz	pomin
	cmp     ax, 32768
	ja      blad
	neg	ax
	ret
pomin: 
    	cmp	ax, 32767
	ja	blad
	ret
    
blad:
    	;wypisz blad i zakoncz
	mov	dx, offset error
	mov	ah, 09h
	int 	21h
    	mov     ah,4ch
    	int     21h

_code ends

_data segment

	;komunikaty
	msg10 	 db "Podaj liczbe w systemie dziesietnym (-32768 do 32767): $"
	msg16 	 db "Zapis w kodzie szesntastkowym: $"
	msg2  	 db "Zapis w kodzie binarnym: $"
	error 	 db "Niepoprawna liczba! $"
	newLine  db 13,10,"$"

	;wczytanie
	max	db 7
	len	db ?
	chars 	db 7 dup(0)
	
	;konwersja16
    	wynik16 db 2 dup(0)
    
    	;konwersja2
    	wynik2  db 16 dup(0) 
	
_data ends

_stack segment stack
	top_stack	equ 100h
top	Label word
_stack ends

end start
