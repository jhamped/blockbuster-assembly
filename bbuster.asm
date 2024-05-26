.model small
.stack 100h
.code
org 100h
entry:
EXTERNDELAY = 3

.data
	score_text db 'Time Consumed: $'
	timeScore dw 0
	scoreCount dw 0
	lives dw 3
	ending db ' $'
	ctr db 0
	gamemode db 0
	time db ' $'
	soundOn db 1

	tens dw 53
	ones dw 57
	timeCtr db 0
	
	blockbuster_text db 'BLOCK BUSTER', '$'
	start_text db 'Press S to start', '$'
	gameover_text db 'GAME OVER', '$'
	gamecompleted_text db 'That is it for now', '$'
	
	entername_text db 'ENTER YOUR NAME:', '$'
	;playername db 3 dup(0) 
	playername db 'twice', '$'
	;filename db 'names.txt', 0
	handle dw ?
	scores db 00h, 6*50 dup (0) 
	iscore db 000h, 010h
	snake_length dw 0
	strbuf db 4 dup(?)
	
	levelmode_text db 'LEVEL MODE', '$'
	timedmode_text db 'TIMED MODE','$'
	options_text db 'OPTIONS','$'
	nextlevel_text db 'NEXT', '$'
	exit_text db 'EXIT','$'
	mainmenu_text db 'MAIN MENU', '$'
	back_text db 'BACK', '$'
	yes_text db 'YES!', '$'
    no_text db 'NO:(','$'
	
	level1_text db 'LEVEL 1', '$'
	level2_text db 'LEVEL 2', '$'
	level3_text db 'LEVEL 3', '$'
	level4_text db 'LEVEL 4', '$'
	level5_text db 'LEVEL 5', '$'

	xloc dw 147
	yloc dw 129
	wid dw 25
	opt db 1
	optCompleted db 1
	optOver db 1
	optLevel db 1
	currentOpt db 1
	lmenu db 1
	
	xlocRec dw 0
	ylocRec dw 0
	widRec dw 0
	heightRec dw 0
	
	tempLifeX dw 0
	tempLifeY dw 0
	
	ballY dw 163                   ;initial Y location of ball
	ballX dw 158                   ;initial X location of ball
	ballLeft db 1                  ;left movement of ball
	ballUp db 1	                   ;up movement of ball
	innerDelay db 0                ;speed of the ball
	fastBall db 0
	
	color db 0	                   ;brick color
	startx dw 0	                   ;starting X location of multiple elements
	starty dw 0                    ;starting Y location of multiple elements
	endx dw 0                      ;ending X location of multiple elements
	endy dw 0                      ;ending Y location of multiple elements
	begin db 0                     ;boolean var for starting the game
	
	strikerX dw 140                ;initial X location of the striker (paddle)
	strikerY dw 170                ;initial Y location of the striker (paddle)
	
	boundaryEnd dw 253             ;ending boundary for the ball and striker
	boundaryStart dw 30            ;starting boundary for the ball and striker
	
	brick1x dw 0                   ;X and Y locations of the bricks
	brick1y dw 0
	brick2x dw 0
	brick2y dw 0
	brick3x dw 0
	brick3y dw 0
	brick4x dw 0
	brick4y dw 0
	brick5x dw 0
	brick5y dw 0
	brick6x dw 0
	brick6y dw 0
	brick7x dw 0
	brick7y dw 0
	brick8x dw 0
	brick8y dw 0
	brick9x dw 0
	brick9y dw 0
	brick10x dw 0
	brick10y dw 0
	
	musicEnabled db 1	
	; Notes (approximate frequencies for Super Mario Bros. Overworld theme)
    do      dw 523   ; do
    re      dw 587   ; re
    mi      dw 659   ; mi
    fa      dw 698   ; fa
    sol     dw 784   ; sol
    la      dw 880   ; la
    ti      dw 988   ; ti
    do_high dw 1046  ; do (Higher octave)

    clock equ es:6Ch
    tone dw ?
	
	life db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
		db 00h, 00h, 00h, 00h, 00h, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 00h, 00h, 00h, 00h
		db 00h, 00h, 00h, 00h, 0Eh, 00h, 00h, 00h, 00h, 00h, 00h, 0Eh, 00h, 00h, 00h
		db 00h, 00h, 00h, 00h, 00h, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 00h, 00h, 00h, 00h
		db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
		db 00h, 00h, 04h, 0Fh, 0Fh, 0Ch, 04h, 00h, 04h, 0Fh, 0Ch, 04h, 04h, 00h, 00h
		db 00h, 04h, 0Fh, 0Ch, 0Ch, 0Fh, 0Ch, 04h, 0Ch, 0Ch, 04h, 04h, 04h, 04h, 00h
		db 04h, 0Fh, 0Fh, 0Ch, 0Fh, 0Ch, 0Ch, 0Ch, 0Ch, 0Ch, 04h, 04h, 04h, 04h, 04h
		db 04h, 0Fh, 04h, 0Fh, 0Ch, 0Ch, 0Ch, 0Ch, 0Ch, 04h, 04h, 04h, 04h, 04h, 04h
		db 04h, 0Ch, 04h, 0Ch, 0Ch, 0Ch, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h
		db 00h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 00h
		db 00h, 00h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 00h, 00h
		db 00h, 00h, 00h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 00h, 00h, 00h
		db 00h, 00h, 00h, 00h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 00h, 00h, 00h, 00h
		db 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h
	
.code
drawTitle macro x, y, w, h, c
	mov xlocRec, x
	mov ylocRec, y
	mov widRec, w
	mov heightRec, h
	mov color, c
	
	call AddRec
endm

BuildBrick macro A, B, C
    push ax
    push bx
	
    mov ax, A                           ;draw the X position of brick at A
    mov bx, B                           ;draw the Y position of brick at B
	MOV color, C
    call AddBrick
	
    pop bx
    pop ax
endm

redrawBall macro newColor
    mov color, newColor
    call drawball
endm

redrawStriker macro newColor
	mov color, newColor
	call drawStriker
endm

BrickCollision macro X, Y
local check
    push ax
    push bx
    push cx
    push dx
	
    ;mov ax, ballY
    ;mov bx, ballX
    ;mov cx, X
    ;mov dx, Y
	
    mov ax, X 
	add ax, 36
	cmp ax, ballX 
	jng check 
	
	mov ax, ballX 
	add ax, 4
	cmp X, ax
	jnl check 
	
	mov ax, Y 
	add ax, 7
	cmp ax, ballY
	jng check
	
	mov ax, ballY 
	add ax, 4
	cmp Y, ax
	jnl check
	
    call switcher                       ;if ball hits a brick, change ball direction
    DestroyBrick X, Y                   ;destroy brick
    mov Y, 300                          ;move the brick out of the way
    cmp scoreCount, 10                  ;check if all the bricks are destroyed
    jne check
	
	mov begin, 0                        ;stop gameloop
	redrawball 0
	redrawStriker 0
    call GameCompletedPage
    
    check:
    pop dx
    pop cx
    pop bx
    pop ax                      
endm

DestroyBrick macro  A, B
local drawscore1, noSound
    push ax
    push bx
	
    mov ax, A                           ;remove brick located at x-position A
    mov bx, B                           ;remove brick located at y-position B
    call RemoveBrick
	
	cmp soundOn, 1
	jne noSound
    call beep     
	
	noSound:
    inc scoreCount
	cmp gamemode, 0
	je drawscore1
	
	drawscore1:
    pop bx
    pop ax
endm

main proc
    mov ax,@data                          ;incorporate the data values
    mov ds,ax			                   
	
	call setVideoMode                     ;clear screen
	call addName 
	call setVideoMode 
	call StartPage                        ;initiate start page
	call menu
	call setVideoMode
main endp

addName proc
	push ax
	push bx
	push cx
	push dx
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 05h
	mov dl, 0Ch
	int 10h
	
	mov ah, 09h
	lea dx, entername_text
	int 21h
	
	mov cx, 5
    mov bp, 0
    underscore:
		mov ah, 02h
        mov dh, 07h
        mov dl, 12h
        add dx, bp 
        inc bp
        mov bh, 0
        int 10h

        mov ax, 092Dh
        mov bl, 0Dh
        mov bh, 0
        push cx
        mov cx, 1
        int 10h
        pop cx
		loop underscore

	lea si, playername
	mov cx, 5
	mov bp, 0
	get_name1:
		mov ah, 7             ;read char input
		int 21h
		
		mov ah, 02h           ;set cursor position
		mov dh, 07h  
		mov dl, 12h
		add dx, bp            
		inc bp                ;move cursor position 
		mov bh, 0
		int 10h
	
		cmp al, 08h             ;if backspace is pressed, delete char 
		jne printchar1
		
		mov ah, 02h
		dec dx
		sub bp, 2
		dec si
		mov bh, 00h
		int 10h
		
		mov ax, 0A2Dh      
		mov bh, 0
		mov cx, 1
		int 10h
		
		jmp get_name1
		
		printchar1:
			mov ah, 0Ah
			mov bh, 0
			mov bl, 0Dh 
			push cx
			mov cx, 1
			int 10h
			pop cx
		
		mov byte ptr [si], al 
		inc si 
	
	cmp bp, 5
	je save1
	jmp get_name1
	
	save1:
		mov ah, 0h                 ;check keyboard input
		int 16h
		cmp ax, 1C0Dh              ;enter key
		jne get_name 
		
		call StartPage
		call menu
		ret 
	
	pop ax
	pop bx
	pop cx
	pop dx
	ret
addName endp

drawLives proc
	cmp lives, 3
	jne twoLives
	
	mov tempLifeX, 290         ;draw Heart3
	mov tempLifeY, 181
	call drawLife 
	
	twoLives:
	cmp lives, 2
	jl oneLife
	mov tempLifeX, 270         ;draw Heart2
	mov tempLifeY, 181
	call drawLife

	oneLife:
	cmp lives, 0
	je noLives
	mov tempLifeX, 250         ;draw Heart1
	mov tempLifeY, 181
	call drawLife
	
	noLives:
	ret
drawLives endp

drawLife proc
	mov cx, tempLifeX
	mov dx, tempLifeY
	mov si, offset life 
	
	drawLife1:
		mov ah, 0Ch 
		mov al, [si]
		mov bh, 00h
		int 10h
		
		inc si 
		inc cx 
		mov ax, cx
		sub ax, tempLifeX
		cmp ax, 15
		jne drawLife1 
		
		mov cx, tempLifeX
		inc dx
		mov ax, dx
		sub ax, tempLifeY
		cmp ax, 15
		jne drawLife1 
	ret 
drawLife endp

removeLives proc
	drawTitle 249, 181, 60, 19, 0     ;draw Heart3 this is red
	ret
removeLives endp

printTime proc
	push ax
	push dx
	push cx
	
	mov ah, 02h
	mov dh, 01h
	mov dl, 13h
	int 10h
	
	show:
	cmp ones, 2Fh
	je tenths
	
	mov ah, 02h
	mov dx, tens
	int 21h
	
	mov ah, 02h
	mov dx, ones
	int 21h
	
	mov cx, 02
	backspace:
	mov ah, 02h         ;backspace (delete ones
	mov dl, 8h
	int 21h
	dec cx
	jnz backspace
	
	pop cx
	pop ax
	pop dx
	ret
	
	tenths:
	dec tens
	mov ones, 57
	jmp show
printTime endp

stopTime proc
	cmp tens, 48
	je checkOnes 
	ret
	
	checkOnes:
		cmp ones, 48
		je stop
		ret
	
	stop:
		call GameOverPage
stopTime endp

playNext proc
	mov ballX, 158
	mov ballY, 163
	mov ballLeft, 1
	mov ballUp, 1
	mov strikerX, 140
	mov timeCtr, 0
	mov tens, 53
	mov ones, 57
	mov scoreCount, 0
	mov timeScore, 0
	
	cmp optLevel, 1
	je playLevel2
	cmp optLevel, 2
	je playLevel3
	cmp optLevel, 3
	je playLevel4
	cmp optLevel, 4
	je playLevel5
	cmp optLevel, 5
	je goToMain
	
	playLevel2:
		mov optLevel, 2
		jmp play 
		
	playLevel3:
		mov optLevel, 3
		jmp play 
		
	playLevel4:
		mov optLevel, 4
		jmp play 
		
	playLevel5:
		mov optLevel, 5
		jmp play 
		
	goToMain:
		call StartPage
		call menu 
		ret
		
	play:
		call levelmode
	ret
playNext endp

levelmode proc
	call setVideoMode
	call drawBoundary
	call drawBorder
	mov begin, 1
	mov lives, 3

	cmp optLevel, 1
	je level1Game
	cmp optLevel, 2
	je level2Game
	cmp optLevel, 3
	je level3Game
	cmp optLevel, 4
	je level4Game
	cmp optLevel, 5
	je level5Game

	level1Game:
		call levelOne
		mov innerDelay, 0
		mov fastball, 0
		jmp next
	
	level2Game:
		call levelTwo
		mov innerDelay, 0
		mov fastball, 0
		jmp next
	
	level3Game:
		call levelThree
		mov innerDelay, 1
		mov fastball, 1
		jmp next
		
	level4Game:
		call levelFour
		mov innerDelay, 2
		mov fastball, 2
		jmp next
		
	level5Game:
		call levelFive
		mov innerDelay, 2
		mov fastball, 2
		jmp next

	next:
		call BuildB
		redrawStriker 13
		redrawBall 15
		call gameLoop
	ret
levelmode endp

levelMenu proc
	push ax
	push bx
	push dx
	push cx
	
	call setVideoMode
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 04h
	mov dl, 0Fh
	int 10h
	
	mov ah, 09h
	lea dx, levelmode_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 08h
	mov dl, 10h
	int 10h
	
	mov ah, 09h
	lea dx, level1_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 0Ah
	mov dl, 10h
	int 10h
	
	mov ah, 09h
	lea dx, level2_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 0Ch
	mov dl, 10h
	int 10h
	
	mov ah, 09h
	lea dx, level3_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 0Eh
	mov dl, 10h
	int 10h
	
	mov ah, 09h
	lea dx, level4_text
	int 21h

	mov ah, 02h
	mov bh, 00h
	mov dh, 10h
	mov dl, 10h
	int 10h
	
	mov ah, 09h
	lea dx, level5_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 12h
	mov dl, 11h
	int 10h
	
	mov ah, 09h
	lea dx, back_text
	int 21h
	
	mov optLevel, 1
	mov lmenu, 1
	mov xloc, 142
	mov yloc, 73
	mov wid, 20
	call drawSelect                ;draw underline

	selectLevel:
		mov ah, 00h                ;read keyboard input
		int 16h
		cmp soundOn, 1
		jne noSound3
		call beep
		
		noSound3:
		cmp ax, 4800h              ;up arrow key 
		je upLevel
		cmp ax, 5000h              ;down arrow key
		je downLevel
		cmp ax, 1C0Dh              ;enter key
		je selectedLevel
		
		downLevel:
			cmp optLevel, 6             ;5 -> number of buttons, varies
			je backLevel
			
			add optLevel, 1
			call deleteSelect
			add yloc, 16           
			call drawSelect
			jmp selectLevel
		
		upLevel:
			cmp optLevel, 1
			je nextLevel
			
			sub optLevel, 1
			call deleteSelect
			sub yloc, 16
			call drawSelect
			jmp selectLevel
			
		backLevel:
			mov optLevel, 1
			call deleteSelect
			mov yloc, 73          ;105 -> y location of first underline, varies
			call drawSelect
			jmp selectLevel
		
		nextLevel:
			mov optLevel, 6
			call deleteSelect
			mov yloc, 153          ;165 -> y location of last underline, varies
			call drawSelect
			jmp selectLevel
		
	selectedLevel:
		mov lmenu, 0
		cmp optLevel, 6
		je backMenu
		
	level1:
		mov begin, 1
		mov gamemode, 0
		call levelmode
		ret
	
	backMenu:
		call StartPage
		call menu
		ret 
	
	pop ax
	pop bx
	pop dx
	pop cx
levelMenu endp

timedmode proc
	call setVideoMode
	call drawBoundary
	call drawBorder
	call levelOne
	call BuildB
	redrawStriker 13
	redrawBall 15
	call gameLoop
	ret
timedmode endp

timedMenu proc
	push ax
	push bx
	push dx
	
	call setVideoMode
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 04h
	mov dl, 0Fh
	int 10h
	
	mov ah, 09h
	lea dx, timedmode_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 08h
	mov dl, 10h
	int 10h
	
	mov ah, 09h
	lea dx, level1_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 0Ah
	mov dl, 10h
	int 10h
	
	mov ah, 09h
	lea dx, level2_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 0Ch
	mov dl, 10h
	int 10h
	
	mov ah, 09h
	lea dx, level3_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 0Eh
	mov dl, 10h
	int 10h
	
	mov ah, 09h
	lea dx, level4_text
	int 21h

	mov ah, 02h
	mov bh, 00h
	mov dh, 10h
	mov dl, 10h
	int 10h
	
	mov ah, 09h
	lea dx, level5_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 12h
	mov dl, 11h
	int 10h
	
	mov ah, 09h
	lea dx, back_text
	int 21h
	
	mov optLevel, 1
	mov lmenu, 1
	mov xloc, 142
	mov yloc, 73
	mov wid, 20
	call drawSelect                ;draw underline

	selectTimed:
		mov ah, 00h                ;read keyboard input
		int 16h
		cmp soundOn, 1
		jne noSound4
		call beep
		
		noSound4:
		cmp ax, 4800h              ;up arrow key 
		je upTimed
		cmp ax, 5000h              ;down arrow key
		je downTimed
		cmp ax, 1C0Dh              ;enter key
		je selectedTimed
		
		downTimed:
			cmp optLevel, 6             ;5 -> number of buttons, varies
			je backTimed
			
			add optLevel, 1
			call deleteSelect
			add yloc, 16           
			call drawSelect
			jmp selectTimed
		
		upTimed:
			cmp optLevel, 1
			je nextTimed
			
			sub optLevel, 1
			call deleteSelect
			sub yloc, 16
			call drawSelect
			jmp selectTimed
			
		backTimed:
			mov optLevel, 1
			call deleteSelect
			mov yloc, 73          ;105 -> y location of first underline, varies
			call drawSelect
			jmp selectTimed
		
		nextTimed:
			mov optLevel, 6
			call deleteSelect
			mov yloc, 153          ;165 -> y location of last underline, varies
			call drawSelect
			jmp selectTimed
		
	selectedTimed:
		mov lmenu, 0
		cmp optLevel, 6
		jne timed1
		cmp optLevel, 6
		je backMenu1
		
	timed1:
		mov begin, 1
		mov gamemode, 1
		call levelmode
		ret
		
	backMenu1:
		call StartPage
		call menu
		ret
		
	pop ax
	pop bx
	pop dx
timedMenu endp

BuildB proc	
	BuildBrick brick1x, brick1y, 9
	BuildBrick brick2x, brick2y, 10
	BuildBrick brick3x, brick3y, 9
	BuildBrick brick4x, brick4y, 9
	BuildBrick brick5x, brick5y, 10
	BuildBrick brick6x, brick6y, 12
	BuildBrick brick7x, brick7y, 11
	BuildBrick brick8x, brick8y, 12
	BuildBrick brick9x, brick9y, 11
	BuildBrick brick10x, brick10y, 12
	ret
BuildB endp

CollideB proc
	BrickCollision brick1x, brick1y
	BrickCollision brick2x, brick2y
	BrickCollision brick3x, brick3y
	BrickCollision brick4x, brick4y
	BrickCollision brick5x, brick5y
	BrickCollision brick6x, brick6y
	BrickCollision brick7x, brick7y
	BrickCollision brick8x, brick8y
	BrickCollision brick9x, brick9y
	BrickCollision brick10x, brick10y
	ret
CollideB endp

levelOne proc
	mov brick1x, 142
	mov brick1y, 44
	mov brick2x, 39
	mov brick2y, 63
	mov brick3x, 169
	mov brick3y, 63
	mov brick4x, 243
	mov brick4y, 63
	mov brick5x, 142
	mov brick5y, 80
	mov brick6x, 88
	mov brick6y, 44
	mov brick7x, 195
	mov brick7y, 44
	mov brick8x, 114
	mov brick8y, 63
	mov brick9x, 88
	mov brick9y, 80
	mov brick10x, 195
	mov brick10y, 80
	ret
levelOne endp

levelTwo proc
	mov brick1x, 48
	mov brick1y, 44
	mov brick2x, 106
	mov brick2y, 44
	mov brick3x, 204
	mov brick3y, 62
	mov brick4x, 48
	mov brick4y, 80
	mov brick5x, 106
	mov brick5y, 80
	mov brick6x, 176
	mov brick6y, 44
	mov brick7x, 234
	mov brick7y, 44
	mov brick8x, 76
	mov brick8y, 62
	mov brick9x, 176
	mov brick9y, 80
	mov brick10x, 234
	mov brick10y, 80
	ret
levelTwo endp

levelThree proc
	mov brick1x, 115
	mov brick1y, 54
	mov brick2x, 169
	mov brick2y, 54
	mov brick3x, 91
	mov brick3y, 75
	mov brick4x, 142
	mov brick4y, 75
	mov brick5x, 193
	mov brick5y, 75
	mov brick6x, 142
	mov brick6y, 36
	mov brick7x, 65
	mov brick7y, 97
	mov brick8x, 116
	mov brick8y, 97
	mov brick9x, 167
	mov brick9y, 97
	mov brick10x, 218
	mov brick10y, 97
	ret
levelThree endp

levelFour proc
	mov brick1x, 106
	mov brick1y, 37
	mov brick2x, 191
	mov brick2y, 57
	mov brick3x, 142
	mov brick3y, 75
	mov brick4x, 192
	mov brick4y, 92
	mov brick5x, 106
	mov brick5y, 116
	mov brick6x, 150
	mov brick6y, 47
	mov brick7x, 89
	mov brick7y, 63
	mov brick8x, 215
	mov brick8y, 74
	mov brick9x, 89
	mov brick9y, 91
	mov brick10x, 152
	mov brick10y, 103
	ret
levelFour endp

levelFive proc
	mov brick1x, 71
	mov brick1y, 59
	mov brick2x, 118
	mov brick2y, 59
	mov brick3x, 167
	mov brick3y, 59
	mov brick4x, 215
	mov brick4y, 59
	mov brick5x, 142
	mov brick5y, 98
	mov brick6x, 94
	mov brick6y, 39
	mov brick7x, 190
	mov brick7y, 39
	mov brick8x, 95
	mov brick8y, 78
	mov brick9x, 142
	mov brick9y, 78
	mov brick10x, 191
	mov brick10y, 78
	ret
levelFive endp

StartPage proc
	call setVideoMode
	call drawBorder
	call drawBg

	drawTitle 100, 21, 24, 4, 13         ;draw B shadow
	drawTitle 100, 50, 24, 4, 13
	drawTitle 121, 21, 4, 32, 13
	drawTitle 104, 21, 4, 32, 13
	drawTitle 104, 36, 20, 4, 13
	drawTitle 98, 19, 24, 4, 5          ;draw B
	drawTitle 98, 48, 24, 4, 5
	drawTitle 119, 19, 4, 32, 5
	drawTitle 102, 19, 4, 32, 5
	drawTitle 102, 34, 20, 4, 5

	drawTitle 132, 21, 4, 32, 13        ;draw L shadow
	drawTitle 132, 50, 16, 4, 13
	drawTitle 130, 19, 4, 32, 5         ;draw L
	drawTitle 130, 48, 16, 4, 5
	
	drawTitle 154, 21, 21, 4, 13        ;draw O shadow
	drawTitle 154, 50, 21, 4, 13
	drawTitle 154, 21, 4, 32, 13
	drawTitle 172, 21, 4, 32, 13
	drawTitle 152, 19, 21, 4, 5         ;draw O
	drawTitle 152, 48, 21, 4, 5
	drawTitle 152, 19, 4, 32, 5
	drawTitle 170, 19, 4, 32, 5
	
	drawTitle 182, 21, 18, 4, 13        ;draw C shadow
	drawTitle 182, 50, 18, 4, 13
	drawTitle 182, 21, 4, 32, 13
	drawTitle 180, 19, 18, 4, 5         ;draw C
	drawTitle 180, 48, 18, 4, 5
	drawTitle 180, 19, 4, 32, 5
	
	drawTitle 206, 21, 4, 33, 13        ;draw K shadow
	drawTitle 206, 34, 20, 4, 13
	drawTitle 220, 21, 4, 16, 13
	drawTitle 223, 34, 4, 20, 13
	drawTitle 204, 19, 4, 33, 5         ;draw K
	drawTitle 204, 32, 20, 4, 5
	drawTitle 218, 19, 4, 16, 5
	drawTitle 221, 32, 4, 20, 5
	
	drawTitle 84, 67, 25, 4, 13         ;draw B shadow
	drawTitle 84, 97, 25, 4, 13
	drawTitle 106, 67, 4, 33, 13
	drawTitle 88, 67, 4, 33, 13
	drawTitle 88, 83, 21, 4, 13
	drawTitle 82, 65, 25, 4, 5          ;draw B
	drawTitle 82, 95, 25, 4, 5
	drawTitle 104, 65, 4, 33, 5
	drawTitle 86, 65, 4, 33, 5
	drawTitle 86, 81, 21, 4, 5
	
	drawTitle 116, 67, 4, 33, 13        ;draw U shadow
	drawTitle 134, 67, 4, 33, 13
	drawTitle 116, 97, 21, 4, 13
	drawTitle 114, 65, 4, 33, 5         ;draw U
	drawTitle 132, 65, 4, 33, 5
	drawTitle 114, 95, 21, 4, 5
	
	drawTitle 146, 67, 18, 4, 13         ;draw S shadow
	drawTitle 146, 97, 17, 4, 13
	drawTitle 146, 67, 4, 16, 13
	drawTitle 160, 81, 4, 20, 13
	drawTitle 146, 81, 17, 4, 13
	drawTitle 144, 65, 18, 4, 5          ;draw S
	drawTitle 144, 95, 17, 4, 5
	drawTitle 144, 65, 4, 16, 5
	drawTitle 158, 79, 4, 20, 5
	drawTitle 144, 79, 17, 4, 5
	
	drawTitle 171, 67, 21, 4, 13        ;draw T shadow
	drawTitle 180, 67, 4, 34, 13
	drawTitle 169, 65, 21, 4, 5         ;draw T 
	drawTitle 178, 65, 4, 34, 5
	
	drawTitle 198, 67, 4, 33, 13        ;draw E shadow
	drawTitle 198, 67, 18, 4, 13
	drawTitle 198, 83, 16, 4, 13
	drawTitle 198, 97, 18, 4, 13
	drawTitle 196, 65, 4, 33, 5         ;draw E
	drawTitle 196, 65, 18, 4, 5
	drawTitle 196, 81, 16, 4, 5
	drawTitle 196, 95, 18, 4, 5
	
	drawTitle 222, 67, 4, 34, 13         ;draw R shadow
	drawTitle 222, 67, 22, 4, 13
	drawTitle 222, 82, 22, 4, 13
	drawTitle 241, 67, 4, 18, 13
	drawTitle 237, 82, 4, 19, 13
	drawTitle 220, 65, 4, 34, 5         ;draw R
	drawTitle 220, 65, 22, 4, 5
	drawTitle 220, 80, 22, 4, 5
	drawTitle 239, 65, 4, 18, 5
	drawTitle 235, 80, 4, 19, 5
	
	ret
StartPage endp

optionsPage proc

    ; Clear the screen in graphics mode
    call setVideoMode

    ; Draw E
    drawTitle 90, 36, 6, 30, 13
    drawTitle 96, 36, 12, 6, 13
    drawTitle 96, 48, 6, 6, 13
    drawTitle 96, 60, 12, 6, 13    
  
    ; Draw n
    drawTitle 114, 36, 6, 30, 13
    drawTitle 120, 36, 6, 6, 13
    drawTitle 126, 36, 6, 30, 13

    ; Draw a
    drawTitle 138, 36, 12, 6, 13
    drawTitle 150, 36, 6, 30, 13
    
    drawTitle 138, 48, 12, 6, 13
    drawTitle 138, 54, 6, 6, 13
    drawTitle 138, 60, 12, 6, 13

    ; Draw b
    drawTitle 162, 36, 6, 30, 13
    drawTitle 168, 48, 6, 6, 13
    drawTitle 168, 60, 6, 6, 13
    drawTitle 174, 48, 6, 18, 13

    ; Draw l
    drawTitle 186, 36, 6, 30, 13
    drawTitle 192, 60, 12, 6, 13
    
    ; Draw e
    drawTitle 210, 36, 6, 30, 13
    drawTitle 216, 36, 6, 6, 13
    drawTitle 216, 48, 6, 6, 13
    drawTitle 216, 60, 12, 6, 13
    drawTitle 222, 36, 6, 18, 13

    ; Draw s
    drawTitle 78, 72, 18, 6, 13
    drawTitle 78, 84, 18, 6, 13
    drawTitle 78, 96, 18, 6, 13
    drawTitle 78, 78, 6, 6, 13
    drawTitle 90, 90, 6, 6, 13

    ; Draw o
    drawTitle 102, 72, 6, 30, 13
    drawTitle 108, 72, 6, 6, 13
    drawTitle 108, 96, 6, 6, 13
    drawTitle 114, 72, 6, 30, 13

    ; Draw u
    drawTitle 126, 72, 6, 30, 13
    drawTitle 132, 96, 6, 6, 13
    drawTitle 138, 72, 6, 30, 13

    ; Draw n
    drawTitle 150, 72, 6, 30, 13
    drawTitle 156, 72, 6, 6, 13
    drawTitle 162, 72, 6, 30, 13

    ; Draw d
    drawTitle 186, 72, 6, 30, 13
    drawTitle 174, 84, 6, 18, 13
    drawTitle 180, 84, 6, 6, 13
    drawTitle 180, 96, 6, 6, 13
   
    ; Draw s
    drawTitle 198, 72, 18, 6, 13
    drawTitle 198, 84, 18, 6, 13
    drawTitle 198, 96, 18, 6, 13
    drawTitle 198, 78, 6, 6, 13
    drawTitle 210, 90, 6, 6, 13
   
    ; draw line left
    drawTitle 5, 5, 4, 188, 13

    ; draw line right
    drawTitle 309, 5, 4, 188, 13

    ; draw line up
    drawTitle 9, 5, 300, 4, 13

    ; draw line down
    drawTitle 9, 189, 300, 4, 13

    ; Draw ?
    drawTitle 234, 72, 6, 18, 13
    drawTitle 222, 72, 12, 6, 13
    drawTitle 228, 84, 6, 6, 13
    drawTitle 228, 96, 6, 6, 13

	call enable        ; Handle user input and music

    pop ax bx cx dx
optionsPage endp

enable proc
	mov ah, 02h
    mov bh, 00h
    mov dh, 0Fh
    mov dl, 12h
    int 10h
    
    mov ah, 09h
    lea dx, yes_text
    int 21h
    
    mov ah, 02h
    mov bh, 00h
    mov dh, 11h
    mov dl, 12h
    int 10h
    
    mov ah, 09h
    lea dx, no_text
    int 21h
    
    mov ah, 02h
    mov bh, 00h
    mov dh, 13h
    mov dl, 12h
    int 10h
    
    mov ah, 09h
    lea dx, back_text
    int 21h
	
	mov currentOpt, 1
	mov xloc, 149
	mov yloc, 129
	mov wid, 20
	call drawSelect        ; Draw initial underline (yloc should be 112, not 104, for "YES")

	selectMusicOption:    ; Entry point for music option selection loop
		mov ah, 00h        ; Read keyboard input
		int 16h
		cmp soundOn, 1
		jne noSound1
		call beep
		
		noSound1:
		cmp ax, 4800h      ; Up arrow
		je upOption
		cmp ax, 5000h      ; Down arrow
		je downOption
		cmp ax, 1C0Dh      ; Enter key
		je handleMusicSelection  ; Handle music option selection immediately

		downOption:
			cmp currentOpt, 3       ; Check if already at the bottom (GO BACK TO MAIN MENU)
			je backToTopOption       ; If so, jump to backToTopOption

			add currentOpt, 1       ; Switch selection to the next option
			call deleteSelect       ; Remove old underline
			add yloc, 16             ; Move underline down by 16 pixels
			call drawSelect         ; Draw new underline

			jmp selectMusicOption   ; Continue the loop

		upOption:
			cmp currentOpt, 1       ; Check if already at the top (YES)
			je nextToBottomOption    ; If so, jump to nextToBottomOption

			sub currentOpt, 1       ; Switch selection to the previous option
			call deleteSelect       ; Remove old underline
			sub yloc, 16             ; Move underline up by 16 pixels
			call drawSelect         ; Draw new underline

			jmp selectMusicOption    ; Continue the loop

		backToTopOption:       ; Handle going back to the top when at the bottom
			mov currentOpt, 1       ; Reset to the first option (YES)
			call deleteSelect     
			mov yloc, 129          ; Set yloc to the position of "YES"
			call drawSelect
			jmp selectMusicOption  ; Continue the loop

		nextToBottomOption:   ; Handle going to the bottom when at the top
			mov currentOpt, 3       ; Set to the last option (GO BACK TO MAIN MENU)
			call deleteSelect
			mov yloc, 161          ; Set yloc to the position of "GO BACK TO MAIN MENU"
			call drawSelect
			jmp selectMusicOption  ; Continue the loop
	
		handleMusicSelection:            ; Handle the selected option
			cmp currentOpt, 1
			je enableMusic
			cmp currentOpt, 2
			je disableMusic
			cmp currentOpt, 3         ; Check for "GO BACK TO MAIN MENU" option
			je returnToMenu

		enableMusic:
		  	mov soundOn, 1
			jmp returnToMenu

		disableMusic:
		  	mov soundOn, 0
			jmp returnToMenu
		  
		returnToMenu:
		  	call StartPage
			call menu          ; Display the main menu
		  	ret             ; Return from the enable procedure

enable endp

repeatMusic:
musicLoop:
	cmp musicEnabled, 1
	jne repeatMusic 
	
	; Main melody
		mov bx, offset do      ; do
		call play_note
		call delay         ; Short
		
		mov bx, offset mi      ; mi
		call play_note
		call delay         ; Short
		
		mov bx, offset sol     ; sol
		call play_note
		call delay         ; Short

		mov bx, offset do_high ; do (high)
		call play_note
		call delay         ; Medium

		mov bx, offset ti      ; ti
		call play_note
		call delay         ; Short

		mov bx, offset la      ; la
		call play_note
		call delay         ; Medium

		mov bx, offset sol     ; sol
		call play_note
		call delay         ; Short
		
		mov bx, offset mi      ; mi
		call play_note
		call delay         ; Long
		call delay

		; Second part
		mov bx, offset do_high ; do (high)
		call play_note
		call delay         ; Short

		mov bx, offset sol     ; sol
		call play_note
		call delay         ; Short

		mov bx, offset fa      ; fa
		call play_note
		call delay         ; Medium

		mov bx, offset mi      ; mi
		call play_note
		call delay         ; Medium

		mov bx, offset re      ; re
		call play_note
		call delay         ; Short

		mov bx, offset do      ; do
		call play_note
		call delay         ; Long
		call delay

		call menu

		jmp musicLoop
exitMusic:
	ret

stop_music proc
    mov al, 0B6h        ; Set timer 2 to mode 3 (square wave)
    out 43h, al
    mov ax, 0           ; Set frequency to 0 (silence)
    out 42h, al
    mov al, ah
    out 42h, al
    ret
stop_music endp

delay proc                  ; delay procedure
    push ax               
    mov ax,40h               
    mov es,ax                 
    mov ax,[clock]
    
    Ketukawal:
      cmp ax, [clock]
      mov cx, 2               
      je Ketukawal
    
    Loopdelay:
      mov ax, [clock]
      ketuk:
        cmp ax,[clock]
        je ketuk
        loop Loopdelay
        pop ax
      ret
delay endp  

play_note proc
    mov  al, 0B6h
    out  43h, al
    mov  ax, [bx]    ; Frequency from memory
    out  42h, al
    mov  al, ah
    out  42h, al
    in   al, 61h
    or   al, 3
    out  61h, al
    ret
play_note endp

menu proc
	mov lmenu, 1
	mov opt, 1
	mov optLevel, 1
	mov optCompleted, 1
	mov optOver, 1
	mov ballX, 158
	mov ballY, 163
	mov ballLeft, 1
	mov ballUp, 1
	mov strikerX, 140
	mov xloc, 147
	mov yloc, 129
	mov wid, 25
	mov timeCtr, 0
	mov tens, 53
	mov ones, 57
	mov scoreCount, 0
	mov timeScore, 0
	mov lives, 3

	mov ah, 02h
	mov bh, 00h
	mov dh, 0Fh
	mov dl, 0Fh
	int 10h
	
	mov ah, 09h
	lea dx, levelmode_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 11h
	mov dl, 0Fh
	int 10h
	
	mov ah, 09h
	lea dx, timedmode_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 13h
	mov dl, 11h
	int 10h
	
	mov ah, 09h
	lea dx, options_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 15h
	mov dl, 12h
	int 10h
	
	mov ah, 09h
	;lea dx, exit_text
	lea dx, playername
	int 21h
	
	call drawSelect

	select:
		mov ah, 00h
		int 16h
		cmp soundOn, 1
		jne noSound2
		call beep
		
		noSound2:
		cmp ax, 4800h
		je up1
		cmp ax, 5000h
		je down1
		cmp ax, 1C0Dh
		je selected1
		
		down1:
			cmp opt, 4
			je back1
			
			add opt, 1
			call deleteSelect
			add yloc, 16
			call drawSelect
			jmp select
		
		up1:
			cmp opt, 1
			je next1
			
			sub opt, 1
			call deleteSelect
			sub yloc, 16
			call drawSelect
			jmp select
			
		back1:
			mov opt, 1
			call deleteSelect
			mov yloc, 129
			call drawSelect
			jmp select
		
		next1:
			mov opt, 4
			call deleteSelect
			mov yloc, 177
			call drawSelect
			jmp select
		
	selected1:
		mov lmenu, 0
		cmp opt, 1
		je start_level
		cmp opt, 2
		je start_timed
		cmp opt, 3
		je go_options
		cmp opt, 4
		je terminate
		
	start_level:
		call levelMenu
		ret
	
	start_timed:
		call timedMenu
		ret
		
	go_options:
		;call optionsPage
		;call enable
		call leaderboard
		ret
	
	terminate:
		call setVideoMode
		mov ah, 4Ch
		int 21h
	
	none:
		ret
menu endp

drawSelect proc
	mov cx, xloc
	mov dx, yloc
	drawLoop:
		mov ah, 0Ch
		mov al, 0Dh
		mov bh, 00h
		int 10h

		inc cx
		mov ax, cx
		sub ax, xloc
		cmp ax, wid
		jng drawLoop
	ret
drawSelect endp

deleteSelect proc
	mov cx, xloc
	mov dx, yloc
	drawLoop1:
		mov ah, 0Ch
		mov al, 00h
		mov bh, 00h
		int 10h

		inc cx
		mov ax, cx
		sub ax, xloc
		cmp ax, wid
		jng drawLoop1
	ret
deleteSelect endp

repeat:
gameLoop:   
	inc timeCtr
	call checkKeyboard                   ;check keyboard inputs
	cmp begin, 1                         ;check if game is set to start
	jne repeat                           ;restart game loop if begin = 0
   
	cmp gamemode, 0
	je none1
   
	cmp timeCtr, 100
	jne none1
	dec ones
	mov timeCtr, 0
	call printTime
	call stopTime
	
	none1:
	cmp gamemode, 0
	jne noLives1
	call drawLives
	
	noLives1:
	call Collisionwall                   ;check if ball hits walls
	call CollisionStriker                ;check if ball hits striker
	call CollideB
	call ballMove                        ;ball movement
	call sleep                           ;continue the gameloop
	jmp gameLoop                         ;loop the game
    
exit:
    ret

checkKeyboard proc
    mov ah, 1h                          
    int 16h                             ;check keypress
    jz noInput   
	
    mov ah, 0h                          ;check keyboard input
    int 16h
    cmp ax, 4D00h                       ;check if the right-key arrow is pressed
    je  rightKey
    cmp ax, 4B00h		                ;check if the left-key arrow is pressed
    je leftKey
    cmp al, 27D                         ;check if ESC key is pressed
    je exit
    
    noInput:
		ret  

    rightKey:     
		mov bx, boundaryEnd
		cmp strikerX, bx	            ;check if the striker reaches the wall  
		jg  noInput                     ;if striker reaches the wall, stop receiving input
		redrawStriker 0                     
		add strikerX, 5                 ;move the striker 5px to the right every press 
		redrawStriker 13
		cmp begin, 0
		jz moveBallRight                ;ensure the ball does not stop moving
		jmp noInput
    
    leftKey:   
		mov bx, boundaryStart                            
		cmp strikerX, bx 
		jl noInput
		redrawStriker 0
		sub strikerX, 5
		redrawStriker 13
		cmp begin,0
		jz moveBallLeft
		jmp noInput
    
	moveBallRight:
		redrawBall 0
		add ballX, 5
		redrawBall 15
		jmp noInput
	
    moveBallLeft:
		redrawBall 0
		sub ballX, 5
		redrawBall 15
		jmp noInput
checkKeyboard endp

setVideoMode proc
    mov ah, 0  
    mov al, 13h 
    int 10h     
    
	mov ah, 0Bh
	mov bh, 13h
	mov bl, 00h
	int 10h
	
    ret
setVideoMode endp

GameCompletedPage proc
	push ax
	push bx
	push dx
	
	call setVideoMode
	call drawBorder
	call drawBg
	
	drawTitle 67, 29, 5, 19, 5          ;draw Y
    drawTitle 73, 42, 13, 6, 5
    drawTitle 87, 29, 5, 19, 5
    drawTitle 77, 49, 6, 13, 5 
	
	drawTitle 98, 29, 6, 33, 5          ;draw O
    drawTitle 115, 29, 4, 33, 5
    drawTitle 120, 29, 0, 32, 5
    drawTitle 105, 29, 9, 6, 5
    drawTitle 105, 57, 9, 5, 5 

	drawTitle 127, 29, 6, 33, 5         ;draw U
    drawTitle 144, 29, 6, 33, 5
    drawTitle 127, 57, 23, 6, 5
	
	drawTitle 168, 29, 5, 33, 5         ;draw D
    drawTitle 174, 29, 14, 6, 5
    drawTitle 174, 57, 14, 5, 5
    drawTitle 184, 33, 6, 27, 5  
	
	drawTitle 197, 29, 23, 6, 5         ;draw I
    drawTitle 197, 57, 23, 5, 5
    drawTitle 206, 36, 6, 20, 5
	
	drawTitle 227, 29, 5, 33, 5         ;draw D
    drawTitle 233, 29, 14, 6, 5
    drawTitle 233, 57, 14, 5, 5
    drawTitle 243, 33, 6, 27, 5 
	
	drawTitle 130, 72, 23, 6, 5         ;draw I
    drawTitle 130, 99, 23, 5, 5
    drawTitle 139, 78, 6, 20, 5 
	
	drawTitle 159, 72, 26, 6, 5         ;draw T
    drawTitle 169, 79, 6, 25, 5
	
	drawTitle 191, 72, 6, 23, 5         ;draw !
    drawTitle 191, 99, 6, 5, 5
	
	mov ah, 02h
    mov bh, 00h
    mov dh, 11h
    mov dl, 12h
    int 10h
    
    mov ah, 09h
    lea dx, nextlevel_text
    int 21h
	
	no_next:
	mov ah, 02h
    mov bh, 00h
    mov dh, 13h
    mov dl, 10h
    int 10h
    
    mov ah, 09h
    lea dx, mainmenu_text
    int 21h
    
    mov ah, 02h
    mov bh, 00h
    mov dh, 15h
    mov dl, 12h
    int 10h
    
    mov ah, 09h
    lea dx, exit_text
    int 21h
    
	mov lmenu, 1
	mov xloc, 145
	mov yloc, 145
	mov wid, 25
    call drawSelect
	
	cmp gamemode, 1
	jne selectCompleted
	
	call computeScore
	call DrawScores
	
	selectCompleted:
		mov ah, 00h                ;read keyboard input
		int 16h
		cmp soundOn, 1
		jne noSound5
		call beep
		
		noSound5:
		cmp ax, 4800h              ;up arrow key 
		je upCompleted
		cmp ax, 5000h              ;down arrow key
		je downCompleted
		cmp ax, 1C0Dh              ;enter key
		je selectedCompleted
		
		downCompleted:
			cmp optCompleted, 3             ;4 -> number of buttons, varies
			je backCompleted
			
			add optCompleted, 1
			call deleteSelect
			add yloc, 16           
			call drawSelect
			jmp selectCompleted
		
		upCompleted:
			cmp optCompleted, 1
			je nextCompleted
			
			sub optCompleted, 1
			call deleteSelect
			sub yloc, 16
			call drawSelect
			jmp selectCompleted
			
		backCompleted:
			mov optCompleted, 1
			call deleteSelect
			mov yloc, 145          ;129 -> y location of first underline, varies
			call drawSelect
			jmp selectCompleted
		
		nextCompleted:
			mov optCompleted, 3
			call deleteSelect
			mov yloc, 177          ;177 -> y location of last underline, varies
			call drawSelect
			jmp selectCompleted
		
	selectedCompleted:
		mov lmenu, 0
		cmp optCompleted, 1
		je nextLevel1
		cmp optCompleted, 2
		je backMain
		cmp optCompleted, 3
		je quit

	nextLevel1:
		call playNext
		ret

	backMain:
		call StartPage
		call menu
		ret
		
	quit:
		call setVideoMode
		mov ah, 4Ch
		int 21h
		
	pop ax 
	pop bx
	pop dx
	ret
GameCompletedPage endp

GameOverPage proc
	push ax
	push bx
	push dx
	
	call setVideoMode
	call drawBorder
	call drawBg
	
	; draw G    
	drawTitle 91, 32, 30, 6, 5       
	drawTitle 115, 38, 6, 6, 5  
	drawTitle 91, 38, 6, 35, 5  
	drawTitle 97, 67, 25, 6, 5  
	drawTitle 107, 53, 15, 6, 5  
	drawTitle 116, 59, 6, 8, 5  

    ; draw A
    drawTitle 127, 32, 6, 41, 5  
    drawTitle 133, 32, 18, 6, 5  
	drawTitle 152, 32, 6, 41, 5  
	drawTitle 133, 50, 18, 6, 5  

	; draw M
    drawTitle 163, 32, 6, 41, 5  
    drawTitle 169, 32, 18, 6, 5  
	drawTitle 175, 38, 6, 18, 5  
	drawTitle 188, 32, 6, 41, 5  

	; draw E
    drawTitle 199, 32, 6, 41, 5  
    drawTitle 205, 32, 25, 6, 5  
	drawTitle 205, 49, 22, 6, 5  
	drawTitle 205, 67, 25, 6, 5  
    
	; draw O
    drawTitle 91, 78, 6, 41, 5  
    drawTitle 97, 78, 19, 6, 5  
	drawTitle 116, 78, 6, 41, 5  
	drawTitle 97, 113, 19, 6, 5  
	
	; draw V
    drawTitle 127, 78, 6, 35, 5  
    drawTitle 152, 78, 6, 35, 5  
	drawTitle 133, 113, 19, 6, 5  

	; draw E
    drawTitle 163, 78, 6, 41, 5  
    drawTitle 169, 78, 25, 6, 5  
	drawTitle 169, 95, 22, 6, 5  
	drawTitle 169, 113, 25, 6, 5  

	; draw R
    drawTitle 199, 78, 6, 41, 5  
    drawTitle 205, 78, 19, 6, 5  
	drawTitle 205, 94, 19, 6, 5  
	drawTitle 224, 84, 6, 10, 5  
	drawTitle 224, 100, 6, 18, 5  
	
	mov ah, 02h
    mov bh, 00h
    mov dh, 13h
    mov dl, 10h
    int 10h
    
    mov ah, 09h
    lea dx, mainmenu_text
    int 21h
    
    mov ah, 02h
    mov bh, 00h
    mov dh, 15h
    mov dl, 12h
    int 10h
    
    mov ah, 09h
    lea dx, exit_text
    int 21h
    
	mov lmenu, 1
	mov xloc, 145
	mov yloc, 161
	mov wid, 25
    call drawSelect
	
	selectOver:
		mov ah, 00h                ;read keyboard input
		int 16h
		cmp soundOn, 1
		jne noSound6
		call beep
		
		noSound6:
		cmp ax, 4800h              ;up arrow key 
		je upOver
		cmp ax, 5000h              ;down arrow key
		je downOver
		cmp ax, 1C0Dh              ;enter key
		je selectedOver
		
		downOver:
			cmp optOver, 2             ;4 -> number of buttons, varies
			je backOver
			
			add optOver, 1
			call deleteSelect
			add yloc, 16           
			call drawSelect
			jmp selectOver
		
		upOver:
			cmp optOver, 1
			je nextOver
			
			sub optOver, 1
			call deleteSelect
			sub yloc, 16
			call drawSelect
			jmp selectOver 
			
		backOver:
			mov optOver, 1
			call deleteSelect
			mov yloc, 161          ;129 -> y location of first underline, varies
			call drawSelect
			jmp selectOver
		
		nextOver:
			mov optOver, 2
			call deleteSelect
			mov yloc, 177          ;177 -> y location of last underline, varies
			call drawSelect
			jmp selectOver
		
	selectedOver:
		mov lmenu, 0
		cmp optOver, 1
		je backMain1
		cmp optOver, 2
		je quit1

	backMain1:
		call StartPage
		call menu
		ret
		
	quit1:
		call setVideoMode
		mov ah, 4Ch
		int 21h
		
	pop ax 
	pop bx
	pop dx
	ret
GameOverPage endp

AddRec proc
	mov cx, xlocRec           
	mov dx, ylocRec
	drawLoopRec:
		mov ah, 0Ch           ;draw pixel
		mov al, color
		mov bh, 00h           ;page number, always 0
		int 10h

		inc cx
		mov ax, cx
		sub ax, xlocRec
		cmp ax, widRec
		jng drawLoopRec
		
		mov cx, xlocRec
		inc dx
		
		mov ax, dx
		sub ax, ylocRec
		cmp ax, heightRec
		jng drawLoopRec
	ret
AddRec endp

AddBrick proc
    push ax
    push bx    
	
    mov startx, ax                      ;draw brick width
    mov ax, bx
    mov bx, startx
    add bx, 35                          ;add brick width
    mov endx, bx
    
    mov starty, ax                      ;draw brick height
    mov bx, starty                       
    add bx, 7                           ;add brick height
    mov endy, bx
     
    call draw
	
    pop bx
    pop ax 
    ret
AddBrick endp

AddSpecialBrick proc
    push ax
    push bx    
	
    mov startx, ax
    mov color, 12                       ;set brick color to light red
    mov ax, bx
    mov bx, startx   
    add bx, 35   
    mov endx, bx
    
    mov starty, ax    
    mov bx,starty                   
    add bx,7
    mov endy,bx
     
    call draw
	
    pop bx
    pop ax 
    ret
AddSpecialBrick endp

drawball proc
    push bx
	
    mov bx, ballX
    mov startx, bx
    add bx, 5
    mov endx,   bx
	
    mov bx, ballY
    mov starty, bx
    add bx, 5
    mov endy,   bx
	
    pop bx
    
    call draw
ret
drawball endp

drawStriker proc
    push bx
    push cx
 
    mov bx, strikerX
    mov cx, strikerY   
    mov startx, bx
    add bx, 40
    mov endx, bx
	
    mov starty, cx
    mov endy, 175
    call draw
    
    pop cx
    pop bx
    ret
drawStriker endp

drawBoundary proc
    mov color, 07h   
    
    mov startx, 22                       ;top
    mov endx, 300
    mov starty, 22
    mov endy, 23
    call draw

    mov startx, 299                     ;right
    mov endx, 300
    mov starty, 22
    mov endy, 180
    call draw
    
    mov startx,22                       ;left
    mov endx,23
    mov starty,22
    mov endy,180
    call draw
 
    mov startx, 22                      ;bottom
    mov endx, 300
    mov starty,179
    mov endy,180
    call draw 
   
    ret
drawBoundary endp

drawBorder proc
	drawTitle 17, 9, 0, 0, 05h
	drawTitle 60, 10, 0, 0, 05h
	drawTitle 95, 15, 0, 0, 05h
	drawTitle 131, 11, 0, 0, 05h
	drawTitle 167, 10, 0, 0, 05h
	drawTitle 247, 17, 0, 0, 05h
	drawTitle 7, 46, 0, 0, 05h
	drawTitle 11, 82, 0, 0, 05h
	drawTitle 13, 137, 0, 0, 05h
	drawTitle 7, 177, 0, 0, 05h
	drawTitle 39, 191, 0, 0, 05h
	drawTitle 74, 194, 0, 0, 05h
	drawTitle 164, 185, 0, 0, 05h
	drawTitle 217, 190, 0, 0, 05h
	drawTitle 277, 195, 0, 0, 05h
	drawTitle 315, 193, 0, 0, 05h
	drawTitle 309, 163, 0, 0, 05h
	drawTitle 302, 139, 0, 0, 05h
	drawTitle 313, 91, 0, 0, 05h
	drawTitle 306, 57, 0, 0, 05h
	drawTitle 39, 11, 0, 0, 0Fh
	drawTitle 112, 8, 0, 0, 0Fh
	drawTitle 205, 12, 0, 0, 0Fh
	drawTitle 279, 9, 0, 0, 0Fh
	drawTitle 311, 26, 0, 0, 0Fh
	drawTitle 306, 105, 0, 0, 0Fh
	drawTitle 296, 187, 0, 0, 0Fh
	drawTitle 144, 193, 0, 0, 0Fh
	drawTitle 95, 186, 0, 0, 0Fh
	drawTitle 7, 112, 0, 0, 0Fh
	ret
drawBorder endp

drawBg proc
	drawTitle 55, 43, 0, 0, 05h
	drawTitle 186, 51, 0, 0, 05h
	drawTitle 265, 58, 0, 0, 05h
	drawTitle 73, 94, 0, 0, 05h
	drawTitle 135, 87, 0, 0, 05h
	drawTitle 59, 130, 0, 0, 05h
	drawTitle 249, 122, 0, 0, 05h
	drawTitle 103, 154, 0, 0, 05h
	drawTitle 161, 140, 0, 0, 05h
	drawTitle 258, 163, 0, 0, 05h
	drawTitle 105, 52, 0, 0, 0Fh
	drawTitle 152, 45, 0, 0, 0Fh
	drawTitle 245, 51, 1, 1, 0Fh
	drawTitle 45, 69, 1, 1, 0Fh
	drawTitle 200, 98, 0, 0, 0Fh
	drawTitle 277, 101, 0, 0, 0Fh
	drawTitle 95, 114, 0, 0, 0Fh
	drawTitle 60, 166, 0, 0, 0Fh
	drawTitle 139, 152, 1, 1, 0Fh
	drawTitle 218, 151, 0, 0, 0Fh
	ret 
drawBg endp

draw proc
    push ax
    push cx
    push dx
     
	mov cx, startx                      ;start drawing element from startx
    mov dx, starty                      ;start drawing element from starty
    mov ah, 0Ch
    mov al, color
	
    pixel:                              ;draw element pixel by pixel
		inc cx
		int 10h
		cmp cx,endx
		jne pixel

    mov cx, startx
    inc dx
    cmp dx, endy
    jne pixel
    
    pop dx
    pop cx
    pop ax
    ret
draw endp

RemoveBrick proc 
    push ax
    push bx
    push cx
    push dx
       
    mov startx, ax                     
    mov color, 0              
    mov ax, bx
    mov bx, startx   
    add bx, 35
    mov endx,bx
    
    mov starty, ax 
    mov bx,starty
    add bx,7
    mov endy,bx
 
    call draw 
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
RemoveBrick endp

CollisionStriker proc    
    push ax
    push bx
    push cx
    push dx
    
    mov dx, ballY
    cmp dx, 165                         ;check if the ball hits the bottom
    jl movement                         ;if not, continue moving the ball
    cmp dx, 170 
    jg check1 
    
    mov cx, strikerX   
    mov ax, ballX   
    cmp ax, cx                          ;check if the ball hits the striker
    jl movement                        
    add cx, 40 
    cmp ax, cx
    jg movement
    
    mov ballUp, 1                       
    jmp movement
    
    fail:
		jmp check1
		push ax
		push bx
		push cx
		push dx
    
    redrawBall 0
    
    mov ax, strikerX
    mov ballX,ax
    add ballX,18
    
    mov ballY,  163
    redrawBall 15
    mov ballUp, 1 
    mov ballLeft,0
    
    pop dx
    pop cx
    pop bx
    pop ax

    jmp movement
    
	movement:
	pop dx
    pop cx
    pop bx
    pop ax
    ret
	
	check1:
		cmp gamemode, 1
		jl decLives1
		redrawball 0
		mov ballY, 163
		mov ballX, 158
		mov ballUp, 1
		mov ballLeft, 1
		redrawball 15
		call gameloop
		ret
		
    finish:  
		mov begin, 0
		redrawball 0
		redrawStriker 0
		call GameOverPage	
	 
    decLives1:
		cmp lives, 0
		je finish
		call removeLives
		call decLives
		ret
	
CollisionStriker endp

decLives proc
	dec lives
	redrawball 0
	mov ballY, 163
	mov ballX, 158
	mov ballUp, 1
	mov ballLeft, 1
	redrawball 15
	call gameloop
	ret
decLives endp

Collisionwall proc     
    mov bx, ballX
    mov cx, ballY
    
    checkLeftRight:
		cmp bx, 25                      ;check if ball hits the left wall
		jl goRight
		cmp bx, 290                     ;check if ball hits the right wall
		jg goLeft
		jmp checkUpDown
		
    goRight:
		mov ballLeft, 0 
		jmp checkUpDown;
		
    goLeft:
		mov ballLeft, 1
	
    checkUpDown:
		cmp cx, 25                      ;check if ball hits the top wall
		jl goDown
		cmp cx, 175                     ;check if ball hits the bottom wall
		jg goUp
    
    jmp noInput
    goUp:                                            
		mov ballUp,1
		jmp noInput
	
    goDown: 
		mov ballUp, 0
  
    ret
Collisionwall endp

switcher proc
    cmp ballUp, 1
    je DownT
    jne UpT
	
    UpT:
		inc ballUp
		ret
	
    DownT:
		dec ballUp
		ret
	ret
switcher endp

movement1:
ret
ballMove proc  
	inc innerDelay
	cmp innerDelay, EXTERNDELAY         ;create delay on the movement of the ball
	jne movement1 
	
	cmp fastBall, 0
	je slow
	mov innerDelay, 1
	jmp nextball
	
	slow:
	mov innerDelay, 0
	
	nextball:
    redrawBall 0  
    
	mov bx, ballX 
	cmp ballLeft, 1
	je Left
	jne Right
	
	Left:   
		sub bx, 2 
		jmp changeBall
		
	Right:   
		add bx, 2
	
	changeBall:
		mov ballX,  bx
		mov bx, ballY
		cmp ballUp, 1   
		je Up
		jne Down
	
	Up:
		sub bx, 2
		jmp moveBall
		
	Down:
		add bx, 2
		
	moveBall:
		mov ballY,  bx
		redrawBall 15
    
	ret
ballMove endp   

DrawScores proc
    push dx
    push ax
                 
    mov ah, 02h
	mov dh, 0Eh 
    mov dl, 0Ch
    int 10h
    
    lea dx, score_text
    mov ah, 09h
    int 21h
    
    call printScore 

    pop ax
    pop dx
    ret
DrawScores endp

printScore proc
    push ax
    push bx
    push cx
    push dx
    
    mov cx, 0
    mov ax, timeScore
	
    fetch:                              ;fetch the score by digit and store in the stack
		mov bx, 10
		mov dx, 0
		div bx
		push dx
		inc cx
		cmp ax, 0
		jne fetch
    
    print:                              ;print the contents of the stack
		pop dx
		mov ah, 2
		add dl, '0'
		int 21h
		loop print
    
    pop dx
    pop cx
    pop bx
    pop ax
    
    ret
printScore endp

computeScore proc
	push ax 
	push cx
	
	mov ax, 5
	sub tens, 48
	sub ax, tens 
	mov cx, 10
	mul cx
	mov timeScore, ax	
	
	mov ax, 10
	sub ones, 48
	sub ax, ones
	add timeScore, ax
	
	pop ax 
	pop cx
	ret
computeScore endp

sleep proc
	mov cx,111111111111111b 

	l:
		loop l
		ret
sleep endp

beep proc
        push ax
        push bx
        push cx
        push dx
        mov     al, 182         
        out     43h, al         
        mov     ax, 400       
                                
        out     42h, al         
        mov     al, ah          
        out     42h, al 
        in      al, 61h        
                                
        or      al, 00000011b   
        out     61h, al         
        mov     bx, 2          
.pause1:
        mov     cx, 65535
.pause2:
        dec     cx
        jne     .pause2
        dec     bx
        jne     .pause1
        in      al, 61h        
                                
        and     al, 11111100b   
        out     61h, al         

        pop dx
        pop cx
        pop bx
        pop ax

ret
beep endp
end main
