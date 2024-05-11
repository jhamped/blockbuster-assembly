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
	
	blockbuster_text db 'BLOCK BUSTER', '$'
	start_text db 'Press S to start', '$'
	gameover_text db 'GAME OVER', '$'
	gamecompleted_text db 'That is it for now', '$'
	
	levelmode_text db 'LEVEL MODE', '$'
	timedmode_text db 'TIMED MODE','$'
	options_text db 'OPTIONS','$'
	exit_text db 'EXIT','$'
	arrow db '>>','$'

	xloc dw 114
	yloc dw 129
	wid dw 90
	opt db 1
	lmenu db 1
	
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
	boundaryStart dw 10            ;starting boundary for the ball and striker
	
	brick1x dw 87h                 ;X and Y locations of the bricks
	brick1y dw 15h

	brick2x dw 6Bh
	brick2y dw 25h
	brick3x dw 0A3h
	brick3y dw 25h

	brick4x dw 87h
	brick4y dw 35h

	brick5x dw 30h
	brick5y dw 55h
	brick6x dw 6Ah
	brick6y dw 55h
	brick7x dw 0A4h
	brick7y dw 55h
	brick8x dw 0DEh
	brick8y dw 55h
	
.code
BuildBrick macro  A, B
    push ax
    push bx
	
    mov ax, A                           ;draw the X position of brick at A
    mov bx, B                           ;draw the Y position of brick at B
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
    mov Y, 300
    cmp scoreCount, 8                   ;check if all the bricks are destroyed
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
    push ax
    push bx
	
    mov ax, A                           ;remove brick located at x-position A
    mov bx, B                           ;remove brick located at y-position B
    call RemoveBrick
    call beep     
    inc scoreCount
    call DrawScores
	
    pop bx
    pop ax
endm

main proc
    mov ax,@data                          ;incorporate the data values
    mov ds,ax			                   
    
	call setVideoMode                     ;clear screen
	;call StartPage                        ;initiate start page
	call menu
    call setVideoMode                      
    call drawBoundary                     
	
    BuildBrick brick1x brick1y          ;draw bricks
    BuildBrick brick2x brick2y
    BuildBrick brick3x brick3y
    BuildBrick brick4x brick4y
    BuildSpecialBrick brick5x brick5y
    BuildSpecialBrick brick6x brick6y
    BuildSpecialBrick brick7x brick7y
    BuildSpecialBrick brick8x brick8y
	
    redrawStriker 13                     ;draw paddle
    redrawBall 15                        ;draw ball
	
    call DrawScores                      ;show score count
    call gameLoop                        ;start gameplay
main endp

menu proc
	MOV AH, 00h
	MOV AL, 13h
	INT 10h
	
	MOV AH, 0Bh
	MOV BH, 13h
	MOV BL, 00h
	INT 10h
	
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
		je start_game1
		cmp opt, 2
		je none
		
	start_game1:
		mov begin, 1
		ret
	
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
   call checkKeyboard                   ;check keyboard inputs
   cmp begin, 1                         ;check if game is set to start
   jne repeat                           ;restart game loop if begin = 0
   
   call Collisionwall                   ;check if ball hits walls
   call CollisionStriker                ;check if ball hits striker
   BrickCollision Brick1x, Brick1y      ;check if ball hits the bricks
   BrickCollision Brick2x, Brick2y
   BrickCollision Brick3x, Brick3y
   BrickCollision Brick4x, Brick4y
   BrickCollision Brick5x, Brick5y
   BrickCollision Brick6x, Brick6y 
   BrickCollision Brick7x, Brick7y
   BrickCollision Brick8x, Brick8y

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
    
    ret
setVideoMode endp

StartPage proc
	mov ah, 02h                         ;set cursor position                    
	mov bh, 00h                         
	mov dh, 07h                         ;set row position
	mov dl, 0Eh                         ;set column position
	int 10h
	
	mov ah, 09h                         ;write text
	lea dx, blockbuster_text            
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 0Eh
	mov dl, 0Ch
	int 10h
	
	mov ah, 09h
	lea dx, start_text
	int 21h
	
	mov ah, 00h                         ;read key press
	int 16h
	
	cmp al, 'S'                         ;check if 'S' is pressed
	je start_game                       ;start game if pressed
	cmp al, 's'
	je start_game
	ret

	start_game:
		mov begin, 1
		ret
StartPage endp

GameCompletedPage proc
	call setVideoMode
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 0Ah
	mov dl, 0Ch
	int 10h
	
	mov ah, 09h
	lea dx, gamecompleted_text
	int 21h
	
	mov ah, 00h
	int 16h
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

AddBrick proc
    push ax
    push bx    
	
    mov startx, ax                      ;draw brick width
    mov color, 9                        ;set brick color to light blue
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