.model small
.stack 100h
.code
org 100h
entry:
EXTERNDELAY = 3

.data
	score db 'Score: $'
	scoreCount dw 0
	ending db ' $'
	ctr db 0
	gamemode db 0
	time db ' $'

	tens db 35h
	ones db 39h
	timeCtr db 0
	
	blockbuster_text db 'BLOCK BUSTER', '$'
	start_text db 'Press S to start', '$'
	gameover_text db 'GAME OVER', '$'
	gamecompleted_text db 'That is it for now', '$'
	
	levelmode_text db 'LEVEL MODE', '$'
	timedmode_text db 'TIMED MODE','$'
	options_text db 'OPTIONS','$'
	exit_text db 'EXIT','$'
	mainmenu_text db 'MAIN MENU', '$'

	xloc dw 114
	yloc dw 129
	wid dw 90
	opt db 1
	optCompleted db 1
	optOver db 1
	lmenu db 1
	
	xlocRec dw 0
	ylocRec dw 0
	widRec dw 0
	heightRec dw 0
	
	ballY dw 163                   ;initial Y location of ball
	ballX dw 158                   ;initial X location of ball
	ballLeft db 1                  ;left movement of ball
	ballUp db 1	                   ;up movement of ball
	innerDelay db 0                ;movement of the ball
	
	color db 0	                   ;brick color
	startx dw 0	                   ;starting X location of multiple elements
	starty dw 0                    ;starting Y location of multiple elements
	endx dw 0                      ;ending X location of multiple elements
	endy dw 0                      ;ending Y location of multiple elements
	begin db 0                     ;boolean var for starting the game
	
	strikerX dw 140                ;initial X location of the striker (paddle)
	strikerY dw 170                ;initial Y location of the striker (paddle)
	
	boundaryEnd dw 270             ;ending boundary for the ball and striker
	boundaryStart dw 5             ;starting boundary for the ball and striker
	
	brick1x dw 0                 ;X and Y locations of the bricks
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
	
.code
drawTitle macro x, y, w, h, c
	mov xlocRec, x
	mov ylocRec, y
	mov widRec, w
	mov heightRec, h
	mov color, c
	
	call AddRec
endm

BuildBrick macro  A, B, C
    push ax
    push bx
	
    mov ax, A                           ;draw the X position of brick at A
    mov bx, B                           ;draw the Y position of brick at B
	MOV color, C
    call AddBrick
	
    pop bx
    pop ax
endm

BuildSpecialBrick macro  A, B
    push ax
    push bx
	
    mov ax, A
    mov bx, B
    call AddSpecialBrick
	
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
	
    mov ax, ballY
    mov bx, ballX
    mov cx, X
    mov dx, Y
    
    cmp dx, ballY                       ;check if ball hits the brick
    jl check
    sub dx, 7
  
    cmp ballY, dx
    jl check
    
    mov dx, X 
    cmp ballX, dx
    jl check
    add dx, 36
    cmp dx, ballX
    jl check
    
    call switcher                       ;if ball hits a brick, change ball direction
    DestroyBrick X, Y                   ;destroy brick
    mov Y, 300                          ;move the brick out of the way
    cmp scoreCount, 8                   ;check if all the bricks are destroyed
    jne check
	
	mov begin, 0                        ;stop gameloop
	redrawball 0
	redrawStriker 0
	mov scoreCount, 0
    call GameCompletedPage
    
    check:
    pop dx
    pop cx
    pop bx
    pop ax                      
endm

DestroyBrick macro  A, B
local drawscore1
    push ax
    push bx
	
    mov ax, A                           ;remove brick located at x-position A
    mov bx, B                           ;remove brick located at y-position B
    call RemoveBrick
    call beep     
    inc scoreCount
	
	cmp gamemode, 0
	je drawscore1
	;call DrawScores
	
	drawscore1:
    pop bx
    pop ax
endm

main proc
    mov ax,@data                          ;incorporate the data values
    mov ds,ax			                   
    
	call setVideoMode                     ;clear screen
	call StartPage                        ;initiate start page
	call menu
	call setVideoMode
main endp

printTime proc
	push ax
	push dx
	push cx
	
	mov ah, 02h
	mov dh, 00h
	mov dl, 13h
	int 10h
	
	show:
	cmp ones, 2Fh
	je tenths
	
	mov ah, 02h
	mov dl, tens
	int 21h
	
	mov ah, 02h
	mov dl, ones
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
	mov ones, 39h
	jmp show
printTime endp

levelmode proc
	call setVideoMode
	call drawBoundary
	call levelOne
	call BuildB
	redrawStriker 13
	redrawBall 15
	call gameLoop
	ret
levelmode endp

timedmode proc
	call setVideoMode
	call drawBoundary
	call levelOne
	call BuildB
	redrawStriker 13
	redrawBall 15
	call gameLoop
	ret
timedmode endp

BuildB proc	
	BuildBrick Brick1x, Brick1y, 9
	BuildBrick Brick2x, Brick2y, 9
	BuildBrick Brick3x, Brick3y, 9
	BuildBrick Brick4x, Brick4y, 9
	BuildBrick Brick5x, Brick5y, 12
	BuildBrick Brick6x, Brick6y, 12
	BuildBrick Brick7x, Brick7y, 12
	BuildBrick Brick8x, Brick8y, 12
	ret
BuildB endp

CollideB proc
	BrickCollision Brick1x, Brick1y
    BrickCollision Brick2x, Brick2y
    BrickCollision Brick3x, Brick3y
    BrickCollision Brick4x, Brick4y
    BrickCollision Brick5x, Brick5y
    BrickCollision Brick6x, Brick6y 
    BrickCollision Brick7x, Brick7y
    BrickCollision Brick8x, Brick8y
	ret
CollideB endp

levelOne proc
	mov Brick1x, 87h
	mov Brick1y, 15h
	mov brick2x, 6Bh
	mov brick2y, 25h
	mov brick3x, 0A3h
	mov brick3y, 25h
	mov brick4x, 87h
	mov brick4y, 35h
	mov brick5x, 30h
	mov brick5y, 55h
	mov brick6x, 6Ah
	mov brick6y, 55h
	mov brick7x, 0A4h
	mov brick7y, 55h
	mov brick8x, 0DEh
	mov brick8y, 55h
	ret
levelOne endp

StartPage proc
	call setVideoMode

	drawTitle 99, 20, 24, 4, 13         ;draw B shadow
	drawTitle 99, 49, 24, 4, 13
	drawTitle 120, 20, 4, 32, 13
	drawTitle 103, 20, 4, 32, 13
	drawTitle 103, 35, 20, 4, 13
	drawTitle 98, 19, 24, 4, 5          ;draw B
	drawTitle 98, 48, 24, 4, 5
	drawTitle 119, 19, 4, 32, 5
	drawTitle 102, 19, 4, 32, 5
	drawTitle 102, 34, 20, 4, 5

	drawTitle 131, 20, 4, 32, 13        ;draw L shadow
	drawTitle 131, 49, 16, 4, 13
	drawTitle 130, 19, 4, 32, 5         ;draw L
	drawTitle 130, 48, 16, 4, 5
	
	drawTitle 153, 20, 21, 4, 13        ;draw O shadow
	drawTitle 153, 49, 21, 4, 13
	drawTitle 153, 20, 4, 32, 13
	drawTitle 171, 20, 4, 32, 13
	drawTitle 152, 19, 21, 4, 5         ;draw O
	drawTitle 152, 48, 21, 4, 5
	drawTitle 152, 19, 4, 32, 5
	drawTitle 170, 19, 4, 32, 5
	
	drawTitle 181, 20, 18, 4, 13        ;draw C shadow
	drawTitle 181, 49, 18, 4, 13
	drawTitle 181, 20, 4, 32, 13
	drawTitle 180, 19, 18, 4, 5         ;draw C
	drawTitle 180, 48, 18, 4, 5
	drawTitle 180, 19, 4, 32, 5
	
	drawTitle 205, 20, 4, 33, 13        ;draw K shadow
	drawTitle 205, 33, 20, 4, 13
	drawTitle 219, 20, 4, 16, 13
	drawTitle 222, 33, 4, 20, 13
	drawTitle 204, 19, 4, 33, 5         ;draw K
	drawTitle 204, 32, 20, 4, 5
	drawTitle 218, 19, 4, 16, 5
	drawTitle 221, 32, 4, 20, 5
	
	drawTitle 83, 66, 25, 4, 13         ;draw B shadow
	drawTitle 83, 96, 25, 4, 13
	drawTitle 105, 66, 4, 33, 13
	drawTitle 87, 66, 4, 33, 13
	drawTitle 87, 82, 21, 4, 13
	drawTitle 82, 65, 25, 4, 5          ;draw B
	drawTitle 82, 95, 25, 4, 5
	drawTitle 104, 65, 4, 33, 5
	drawTitle 86, 65, 4, 33, 5
	drawTitle 86, 81, 21, 4, 5
	
	drawTitle 115, 66, 4, 33, 13        ;draw U shadow
	drawTitle 133, 66, 4, 33, 13
	drawTitle 115, 96, 21, 4, 13
	drawTitle 114, 65, 4, 33, 5         ;draw U
	drawTitle 132, 65, 4, 33, 5
	drawTitle 114, 95, 21, 4, 5
	
	drawTitle 145, 66, 18, 4, 13         ;draw S shadow
	drawTitle 145, 96, 17, 4, 13
	drawTitle 145, 66, 4, 16, 13
	drawTitle 159, 80, 4, 20, 13
	drawTitle 145, 80, 17, 4, 13
	drawTitle 144, 65, 18, 4, 5          ;draw S
	drawTitle 144, 95, 17, 4, 5
	drawTitle 144, 65, 4, 16, 5
	drawTitle 158, 79, 4, 20, 5
	drawTitle 144, 79, 17, 4, 5
	
	drawTitle 170, 66, 21, 4, 13        ;draw T shadow
	drawTitle 179, 66, 4, 34, 13
	drawTitle 169, 65, 21, 4, 5         ;draw T 
	drawTitle 178, 65, 4, 34, 5
	
	drawTitle 197, 66, 4, 33, 13        ;draw E shadow
	drawTitle 197, 66, 18, 4, 13
	drawTitle 197, 82, 16, 4, 13
	drawTitle 197, 96, 18, 4, 13
	drawTitle 196, 65, 4, 33, 5         ;draw E
	drawTitle 196, 65, 18, 4, 5
	drawTitle 196, 81, 16, 4, 5
	drawTitle 196, 95, 18, 4, 5
	
	drawTitle 221, 66, 4, 34, 13         ;draw R shadow
	drawTitle 221, 66, 22, 4, 13
	drawTitle 221, 81, 22, 4, 13
	drawTitle 240, 66, 4, 18, 13
	drawTitle 236, 81, 4, 19, 13
	drawTitle 220, 65, 4, 34, 5         ;draw R
	drawTitle 220, 65, 22, 4, 5
	drawTitle 220, 80, 22, 4, 5
	drawTitle 239, 65, 4, 18, 5
	drawTitle 235, 80, 4, 19, 5
	
	ret
StartPage endp

menu proc
	mov lmenu, 1
	mov opt, 1
	mov ballX, 158
	mov ballY, 163
	mov yloc, 129
	mov timeCtr, 0

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
	lea dx, exit_text
	int 21h
	
	call drawSelect

	select:
		mov ah, 00h
		int 16h
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
		
		cmp lmenu, 1
		je select
		
		up1:
			cmp opt, 1
			je next1
			
			sub opt, 1
			call deleteSelect
			sub yloc, 16
			call drawSelect
			
		cmp lmenu, 1
		je select
			
		back1:
			mov opt, 1
			call deleteSelect
			mov yloc, 129
			call drawSelect
		
		cmp lmenu, 1
		je select
		
		next1:
			mov opt, 4
			call deleteSelect
			mov yloc, 177
			call drawSelect
		
		cmp lmenu, 1
		je select
		
	selected1:
		mov lmenu, 0
		cmp opt, 1
		je start_level
		cmp opt, 2
		je start_timed
		cmp opt, 4
		je terminate
		
	start_level:
		mov begin, 1
		mov gamemode, 0
		call levelmode
		ret
	
	start_timed:
		mov begin, 1
		mov gamemode, 1
		call timedmode
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
   
   none1:
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
	
	drawTitle 67, 24, 5, 19, 5          ;draw Y
    drawTitle 73, 37, 13, 6, 5
    drawTitle 87, 24, 5, 19, 5
    drawTitle 77, 44, 6, 13, 5 
	
	drawTitle 98, 24, 6, 33, 5          ;draw O
    drawTitle 115, 24, 4, 33, 5
    drawTitle 120, 24, 0, 32, 5
    drawTitle 105, 24, 9, 6, 5
    drawTitle 105, 52, 9, 5, 5 

	drawTitle 127, 24, 6, 33, 5         ;draw U
    drawTitle 144, 24, 6, 33, 5
    drawTitle 127, 52, 23, 6, 5
	
	drawTitle 168, 24, 5, 33, 5         ;draw D
    drawTitle 174, 24, 14, 6, 5
    drawTitle 174, 52, 14, 5, 5
    drawTitle 184, 28, 6, 27, 5  
	
	drawTitle 197, 24, 23, 6, 5         ;draw I
    drawTitle 197, 52, 23, 5, 5
    drawTitle 206, 31, 6, 20, 5
	
	drawTitle 227, 24, 5, 33, 5         ;draw D
    drawTitle 233, 24, 14, 6, 5
    drawTitle 233, 52, 14, 5, 5
    drawTitle 243, 28, 6, 27, 5 
	
	drawTitle 130, 77, 23, 6, 5         ;draw I
    drawTitle 130, 104, 23, 5, 5
    drawTitle 139, 83, 6, 20, 5 
	
	drawTitle 159, 77, 26, 6, 5         ;draw T
    drawTitle 169, 84, 6, 25, 5
	
	drawTitle 191, 77, 6, 23, 5         ;draw !
    drawTitle 191, 104, 6, 5, 5
	
	mov ah, 02h
    mov bh, 00h
    mov dh, 11h
    mov dl, 10h
    int 10h
    
    mov ah, 09h
    lea dx, mainmenu_text
    int 21h
    
    mov ah, 02h
    mov bh, 00h
    mov dh, 13h
    mov dl, 12h
    int 10h
    
    mov ah, 09h
    lea dx, exit_text
    int 21h
    
	mov lmenu, 1
	mov yloc, 145
    call drawSelect
	
	selectCompleted:
		mov ah, 00h                ;read keyboard input
		int 16h
		cmp ax, 4800h              ;up arrow key 
		je upCompleted
		cmp ax, 5000h              ;down arrow key
		je downCompleted
		cmp ax, 1C0Dh              ;enter key
		je selectedCompleted
		
		downCompleted:
			cmp optCompleted, 2             ;4 -> number of buttons, varies
			je backCompleted
			
			add optCompleted, 1
			call deleteSelect
			add yloc, 16           
			call drawSelect
		
		cmp lmenu, 1
		je selectCompleted
		
		upCompleted:
			cmp optCompleted, 1
			je nextCompleted
			
			sub optCompleted, 1
			call deleteSelect
			sub yloc, 16
			call drawSelect
			
		cmp lmenu, 1
		je selectCompleted
			
		backCompleted:
			mov optCompleted, 1
			call deleteSelect
			mov yloc, 145          ;129 -> y location of first underline, varies
			call drawSelect
		
		cmp lmenu, 1
		je selectCompleted
		
		nextCompleted:
			mov optCompleted, 2
			call deleteSelect
			mov yloc, 161          ;177 -> y location of last underline, varies
			call drawSelect
		
		cmp lmenu, 1
		je selectCompleted
		
	selectedCompleted:
		mov lmenu, 0
		cmp optCompleted, 1
		je backMain
		cmp optCompleted, 2
		je quit

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
	call setVideoMode

	mov ah, 02h
	mov bh, 00h
	mov dh, 0Ah
	mov dl, 10h
	int 10h
	
	mov ah, 09h
	lea dx, gameover_text
	int 21h
	
	mov ah, 00h
	int 16h
	
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
    mov color, 0   
    
    mov startx, 10                       ;top
    mov endx, 310
    mov starty, 1
    mov endy, 3
    call draw

    mov startx, 307                     ;right
    mov endx, 310
    mov starty, 3
    mov endy, 190
    call draw
    
    mov startx,10                       ;left
    mov endx,13
    mov starty,3
    mov endy,190
    call draw
 
    mov startx, 10                      ;bottom
    mov endx, 310
    mov starty,187
    mov endy,190
    call draw 
   
    ret
drawBoundary endp

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
    jg finish 
    
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
		jmp finish
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
    
    finish:  
		mov begin,0
		redrawball 0
		redrawStriker 0
		call GameOverPage	
	 
    movement:  
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
CollisionStriker endp

Collisionwall proc     
    mov bx, ballX
    mov cx, ballY
    
    checkLeftRight:
		cmp bx, 15                      ;check if ball hits the left wall
		jl goRight
		cmp bx, 305                     ;check if ball hits the right wall
		jg goLeft
		jmp checkUpDown
		
    goRight:
		mov ballLeft, 0 
		jmp checkUpDown;
		
    goLeft:
		mov ballLeft, 1
	
    checkUpDown:
		cmp cx, 10                      ;check if ball hits the top wall
		jl goDown
		cmp cx, 187                     ;check if ball hits the bottom wall
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
	mov innerDelay, 0
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
                 
    mov dh, 23 
    mov dl, 5 
    mov ah, 2 
    int 10h
    
    lea dx, score
    mov ah, 9
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
    mov ax, scoreCount
	
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