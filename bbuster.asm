.model small
.stack 100h
.code
org 100h
entry:
EXTERNDELAY = 3                                               ;delay for the movement and speed of the ball 

.data
	OpeningFileName	db	'Assets/Opening.bmp',0                ;title page bitmap 
	OpeningFileHandle dw ?                                    
	FileReadBuffer db 320 dup (?)

	congratulations_text db 'Congratulations, ', '$'                          
	score_text db 'Time Consumed: ', '$'                          
	timeScore dw 0                                            ;score for timed mode 
	scoreCount dw 0                                           ;bricks destroyed ctr 
	lives dw 3                                                ;lives ctr in level mode                              
	gamemode db 0                                             ;game mode determinator (0 -> level, 1 -> timed)                           
	soundOn db 1                                              ;1 -> soundOn, 0 -> soundOff

	tens dw 53                                                ;tenths position in timer (5)
	ones dw 57                                                ;ones position in timer (9) 
	timeCtr db 0                                              ;checks if a second has passed (timeCtr == 100 == 1 second)  
	
	entername_text db 'ENTER YOUR NAME:', '$'                 
	playername db 'twice', '$'                                ;player name variable -> stores the 5 char name 
	nameLength_text db 'Name should be', '$'                  
	nameLength_text1 db 'EXACTLY 5 characters', '$'
	
	controlB_text db '[B]Back', '$'                           
	control1_text db 'MOVE PADDLE', '$'
	control2_text db 'TOGGLE MENUS', '$'
	control3_text db 'SELECT', '$'
	controlL_text db 'LEVEL', '$'
	controlT_text db 'TIMED', '$'
	controlO_text db 'OPTIONS', '$'
	controlE_text db 'EXIT', '$'
	controlU_text db 'USING', '$'
	
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

	xloc dw 147                                               ;x-location of underline                       
	yloc dw 129                                               ;y-location of underline
	wid dw 25                                                 ;underline width 
	
	opt db 1                                                  ;checks which menu option is chosen in the main menu 
	optCompleted db 1                                         ;checks which menu option is chosen in the Game Completed Page  
	optOver db 1                                              ;checks which menu option is chosen in the Game Over Page  
	optLevel db 1                                             ;checks which level is chosen
	optSound db 1                                             ;checks which option is chosen in the Options Page for the sound                                             
	control db 1                                              ;checks if the Controls Page will be shown
	begin db 0                                                ;checks if the game is set to begin (1 == begin)
	
	xlocRec dw 0                                              ;x-location of line 
	ylocRec dw 0                                              ;y-location of line 
	widRec dw 0                                               ;width of line 
	heightRec dw 0                                            ;height of line 
	
	tempLifeX dw 0                                            ;temp storage for the x-location of heart(life) 
	tempLifeY dw 0                                            ;temp storage for the y-location of heart(life) 
	tempX dw 0                                                ;temp storage for the x-location of Controls Page keys 
	tempY dw 0                                                ;temp storage for the y-location of Controls Page keys 
	tempW dw 0                                                ;temp storage for the width of Controls Page keys 
	tempH dw 0                                                ;temp storage for the height of Controls Page keys 
	
	ballX dw 158                                              ;initial X location of ball
	ballY dw 163                                              ;initial y-location of ball
	ballLeft db 1                                             ;checks if ball is moving to the left or right 
	ballUp db 1	                                              ;checks if ball is moving upwards or downwards 
	innerDelay db 0                                           ;speed of the ball (0 == slowest)
	fastBall db 0                                             ;checks the speed of the ball 
	
	color db 0	                                              ;color of multiple elements
	startx dw 0	                                              ;starting x-location of multiple elements
	starty dw 0                                               ;starting y-location of multiple elements
	endx dw 0                                                 ;ending x-location of multiple elements
	endy dw 0                                                 ;ending y-location of multiple elements
	 
	strikerX dw 140                                           ;initial x-location of the striker(paddle)
	strikerY dw 170                                           ;initial y-location of the striker(paddle)
	
	boundaryEnd dw 253                                        ;ending boundary for the ball and striker
	boundaryStart dw 30                                       ;starting boundary for the ball and striker
	
	;x and y-locations of the bricks
	brick1x dw 0                                              
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
	
	;------------------------------------------------
	;                    BITMAPS
	;------------------------------------------------
	
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
		
	down_key db 00h, 00h, 00h, 00h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 00h, 00h, 00h, 00h
       db 00h, 00h, 05h, 05h, 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h, 05h, 05h, 00h, 00h
       db 00h, 00h, 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h, 00h, 00h
       db 05h, 05h, 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h, 05h, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Fh, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh, 0Fh, 05h
       db 00h, 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh, 00h, 00h
       db 00h, 00h, 0Fh, 0Fh, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh, 0Fh, 0Fh, 00h, 00h
       db 00h, 00h, 00h, 00h, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 00h, 00h, 00h, 00h

	up_key db 00h, 00h, 00h, 00h, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 00h, 00h, 00h, 00h
     db 00h, 00h, 0Fh, 0Fh, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh, 0Fh, 0Fh, 00h, 00h
     db 00h, 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh, 00h, 00h
     db 05h, 0Fh, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh, 0Fh, 0Fh
     db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
     db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
     db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
     db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
     db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
     db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
     db 05h, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Fh
     db 05h, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Fh
     db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
     db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
     db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
     db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
     db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
     db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
     db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
     db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
     db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
     db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
     db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
     db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
     db 05h, 05h, 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h, 05h, 05h
     db 00h, 00h, 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h, 00h, 00h
     db 00h, 00h, 05h, 05h, 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h, 05h, 05h, 00h, 00h
     db 00h, 00h, 00h, 00h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 00h, 00h, 00h, 00h

	left_key db 00h, 00h, 00h, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 05h, 00h, 00h, 00h
       db 00h, 00h, 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h, 00h, 00h, 00h
       db 00h, 0Fh, 0Fh, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h, 05h, 05h, 00h
       db 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h, 00h
       db 0Fh, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h, 05h
       db 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h, 00h
       db 00h, 0Fh, 0Fh, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h, 05h, 05h, 00h
       db 00h, 00h, 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h, 00h, 00h, 00h
       db 00h, 00h, 00h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 00h, 00h, 00h

	right_key db 00h, 00h, 00h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 00h, 00h, 00h
        db 00h, 00h, 00h, 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh, 00h, 00h, 00h
        db 00h, 05h, 05h, 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh, 0Fh, 0Fh, 00h
        db 00h, 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh, 00h
        db 05h, 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh, 0Fh
        db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
        db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
        db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
        db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
        db 05h, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
        db 05h, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Fh
        db 05h, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Fh
        db 05h, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Fh
        db 05h, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Fh
        db 05h, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Fh
        db 05h, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
        db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
        db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
        db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
        db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
        db 05h, 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh, 0Fh
        db 00h, 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh, 00h
        db 00h, 05h, 05h, 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh, 0Fh, 0Fh, 00h
        db 00h, 00h, 00h, 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh, 00h, 00h, 00h
        db 00h, 00h, 00h, 05h, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 00h, 00h, 00h

	enter_key db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 05h, 00h, 00h, 00h
        db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Fh, 0Fh, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h, 05h, 05h, 00h
        db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h, 05h
        db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Fh, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 00h, 00h, 00h, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 00h, 0Fh, 0Fh, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 0Fh, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 0Fh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 0Fh, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h, 00h
        db 00h, 0Fh, 0Fh, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h, 05h, 05h, 00h
        db 00h, 00h, 00h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 00h, 00h, 00h

	trophy db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 04h, 04h, 04h, 00h, 00h, 00h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 00h, 00h, 00h, 04h, 04h, 04h, 00h, 00h
      db 00h, 04h, 0Eh, 0Eh, 0Eh, 04h, 00h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 00h, 04h, 0Eh, 0Eh, 0Eh, 04h, 00h
      db 00h, 04h, 0Eh, 06h, 06h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 06h, 06h, 0Eh, 04h, 00h
      db 00h, 04h, 0Eh, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 0Eh, 04h, 00h
      db 00h, 04h, 0Eh, 04h, 04h, 04h, 04h, 04h, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 0Eh, 0Eh, 0Eh, 06h, 06h, 04h, 04h, 04h, 04h, 04h, 0Eh, 04h, 00h
      db 00h, 04h, 0Eh, 04h, 00h, 00h, 00h, 04h, 0Eh, 0Eh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Eh, 0Eh, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 04h, 00h, 00h, 00h, 04h, 0Eh, 04h, 00h
      db 00h, 04h, 0Eh, 04h, 00h, 00h, 00h, 04h, 0Eh, 0Eh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 06h, 04h, 00h, 00h, 00h, 04h, 0Eh, 04h, 00h
      db 00h, 04h, 0Eh, 04h, 04h, 00h, 00h, 04h, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 06h, 04h, 00h, 00h, 04h, 04h, 0Eh, 04h, 00h
      db 00h, 04h, 0Eh, 0Eh, 04h, 00h, 00h, 04h, 04h, 0Eh, 0Eh, 0Eh, 0Eh, 0Fh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 04h, 04h, 00h, 00h, 04h, 0Eh, 0Eh, 04h, 00h
      db 00h, 00h, 04h, 0Eh, 04h, 00h, 00h, 00h, 04h, 0Eh, 0Eh, 0Eh, 0Eh, 0Fh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 04h, 00h, 00h, 00h, 04h, 0Eh, 04h, 00h, 00h
      db 00h, 00h, 04h, 0Eh, 06h, 04h, 00h, 00h, 04h, 0Eh, 0Eh, 0Eh, 0Eh, 0Fh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 06h, 06h, 04h, 00h, 00h, 04h, 04h, 06h, 04h, 00h, 00h
      db 00h, 00h, 04h, 0Eh, 06h, 06h, 04h, 00h, 04h, 0Eh, 0Eh, 0Eh, 0Eh, 0Fh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 06h, 06h, 04h, 00h, 04h, 04h, 06h, 04h, 00h, 00h, 00h
      db 00h, 00h, 00h, 04h, 04h, 06h, 06h, 04h, 04h, 04h, 0Eh, 0Eh, 0Eh, 0Fh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 06h, 06h, 04h, 04h, 04h, 06h, 04h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 04h, 06h, 06h, 06h, 04h, 04h, 0Eh, 0Eh, 0Fh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 06h, 04h, 04h, 06h, 06h, 04h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 04h, 04h, 04h, 04h, 04h, 04h, 0Eh, 0Eh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 06h, 06h, 04h, 04h, 04h, 04h, 04h, 04h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 0Eh, 0Eh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 06h, 06h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 0Eh, 0Eh, 0Eh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 06h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 0Eh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 06h, 06h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 0Eh, 0Eh, 0Eh, 0Eh, 0Fh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 06h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 0Eh, 0Eh, 0Eh, 0Eh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 0Eh, 0Eh, 0Eh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 0Eh, 0Eh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 0Eh, 0Eh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 06h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 06h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 04h, 04h, 04h, 0Eh, 0Eh, 0Eh, 04h, 04h, 04h, 04h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 0Eh, 0Fh, 0Eh, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 0Fh, 0Fh, 0Eh, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 0Fh, 0Fh, 0Eh, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 0Eh, 0Fh, 0Eh, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 0Eh, 0Eh, 0Eh, 04h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 04h, 0Eh, 0Fh, 0Fh, 0Eh, 0Eh, 04h, 04h, 04h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 04h, 04h, 0Eh, 0Eh, 0Eh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 04h, 04h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 0Eh, 0Eh, 0Eh, 0Fh, 0Fh, 0Eh, 0Fh, 0Fh, 0Fh, 0Eh, 0Eh, 06h, 06h, 06h, 06h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 06h, 06h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 0Eh, 0Eh, 0Fh, 0Fh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 06h, 06h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 04h, 0Eh, 0Eh, 0Eh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 06h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h

.code
drawTitle macro X, Y, W, H, C
	;---moves the arguments to the specified variables that will be used in AddRec---
	mov xlocRec, X
	mov ylocRec, Y
	mov widRec, W
	mov heightRec, H
	mov color, C
	
	call AddRec
endm

redrawBall macro newColor
    ;---moves the specified newColor to color that will be used to draw the ball---
	mov color, newColor
    call drawball
endm

redrawStriker macro newColor
	;---moves the specified newColor to color that will be used to draw the striker---
	mov color, newColor
	call drawStriker
endm

BuildKey macro X, Y, W, H 
local drawKey 
	push ax
    push bx
    push cx
    push dx
	
	mov cx, X                             ;moves the X argument to cx (x-loc of the bmp) 
	mov dx, Y                             ;moves the Y argument to cx (y-loc of the bmp) 
	
	drawKey:
		mov ah, 0Ch                       ;draw pixel instruction 
		mov al, [si]                      ;sets al to the color of the pixel on the specified source index of the offset
		mov bh, 00h                       ;sets the page number 
		int 10h
		
		inc si                            ;increments the si pointer 
		inc cx                            ;moves to the next position (to the right) 
		mov ax, cx                        ;moves the current x-loc to the si pointer 
		sub ax, X                         ;subtracts the value of X from the value of ax (0 at first) 
		cmp ax, W                         ;checks if the value of ax is equal to the value of W
		jne drawKey                       ;if not, loop drawKey to keep drawing the pixels until the end of the row
		
		mov cx, X                         ;if yes, set cx to the specified x-loc 
		inc dx                            ;increments dx, moves to the next line/row  
		mov ax, dx                        ;moves the current y-loc to the si pointer 
		sub ax, Y                         ;subtracts the value of Y from the value of ax (0 at first) 
		cmp ax, H                         ;checks if the value of ax is equal to the value of H 
		jne drawKey                       ;if not, loop drawKey 
		
	pop dx
    pop cx
    pop bx
    pop ax
endm 

BuildBrick macro X, Y, C
    push ax
    push bx
	
	;---moves the arguments to the specified variables that will be used in AddBrick---
    mov ax, X                          
    mov bx, Y                       
	mov color, C
    call AddBrick
	
    pop bx
    pop ax
endm

BrickCollision macro X, Y
local check, done1
    push ax
    push bx
    push cx
    push dx

    mov ax, X                             ;sets ax to the value of X 
	add ax, 36                            ;adds 36 (width of brick) to ax
	cmp ax, ballX                         ;checks if ax is equal to the x-loc of the ball 
	jng check                             ;if ax is less than, jump to check 
	
	mov ax, ballX                         ;moves ballX to ax 
	add ax, 4                             ;adds 4 (ball's width) to ax 
	cmp X, ax                             ;checks if brick's x-loc is equal to ax 
	jnl check                             ;if X is greater than, jump to check
	
	mov ax, Y                             ;sets ax to the value of Y                              
	add ax, 7                             ;adds 7 (height of brick) to ax 
	cmp ax, ballY                         ;checks if ax is equal to the x-loc of the ball 
	jng check                             ;if ax is less than, jump to check 
	
	mov ax, ballY                         ;moves ballY to ax 
	add ax, 4                             ;adds 4 (ball's height) to ax
	cmp Y, ax                             ;checks if brick's y-loc is equal to ax 
	jnl check                             ;if Y is greater than, jump to check 
	
    call switcher                         ;if ball hits a brick, change ball direction
    DestroyBrick X, Y                     ;destroys brick located at the X and Y coordinates 
    mov Y, 300                            ;moves the brick out of the way
    cmp scoreCount, 10                    ;checks if all the bricks are destroyed
    jne check                             ;if not, jump to check 
	
	mov begin, 0                          ;if all bricks are destroyed, set begin to 0
	redrawball 0                          ;removes ball 
	redrawStriker 0                       ;removes striker 
	call GameCompletedPage                ;calls the game completed page 
    
    check:
    pop dx
    pop cx
    pop bx
    pop ax                      
endm

DestroyBrick macro  X, Y
local drawscore1, noSound
    push ax
    push bx
	
    mov ax, X                             ;sets ax to the value of X 
    mov bx, Y                             ;sets bx to the value of Y 
    call RemoveBrick                      ;removes brick located at the X and Y coordinates 
	
	cmp soundOn, 1                        ;checks if sound is enabled 
	jne noSound                           ;if not, jump to noSound 
    call beep                             ;if enabled, create a beep sound 
	
	noSound:
		inc scoreCount                    ;increments scoreCount 
	
	drawscore1:
    pop bx
    pop ax
endm


main proc
    mov ax,@data                          ;incorporate the data values
    mov ds,ax			        
	
	call setVideoMode 
	call PrintOpeningPage                 ;print opening screen
main endp


; ----------------------------------------
;              Title Page
; ----------------------------------------
OpenFile proc 
	push bp 
	mov bp, sp                            ;creates reference point 

	mov ah, 3Dh                           ;open file instruction
	mov al, 2                             ;read/write access 
	mov dx, [bp + 6]                      ;sets the offset 
	int 21h 

	mov bx, [bp + 4]                      ;sets filehandle location 
	mov [bx], ax                          ;ax = filehandle; moves the filehandle to the memory location of bx
	mov ax, 1
	
	pop bp 
	ret 
OpenFile endp 

CloseFile proc 
	push bp
	mov bp, sp 

	mov ah, 3Eh
	mov bx, [bp + 4]                      ;sets file handle location 
	int 21h

	pop bp
	ret
CloseFile endp

PrintFullScreenBMP proc 
	push bp 
	mov bp, sp 
	
;----Set file pointer to start of data----	
	mov ah, 42h
	xor al, al 							  ;sets the absolute byte offset from start of the file 
	mov bx, [bp + 6]                      ;sets filehandle 
	xor cx, cx                            ;sets MSB of offset 
	mov dx, 1077                          ;sets LSB of offset 
	int 21h

	mov ax, 0A000h                        ;0A000h -> VGA segment address
	mov es, ax                            ;moves the segment address to es (extra segment register)
	mov di, 0F8BFh	                      ;sets the offset value from the segment address 

	cld                                   ;clear direction flag -> makes sure that the bytes are getting read in the right direction

	mov cx, 200                           ;height of the image / number of iterations in which readLine is processed
	readLine:
		push cx 

		mov ah, 3Fh                       ;read file instruction 
		mov cx, 320                       ;number of pixels to be read in each line 
		mov dx, [bp + 4] 				  ;sets offset of buffer area
		int 21h

		mov si, dx 					      ;sets the buffer area as source location 
		mov cx, 320                       ;width of the image/ number of bytes (pixel) that will be read per iteration 
		rep movsb                         ;copies the bytes from the bmp (buffer) to the VGA memory

		sub di, 640                       ;moves the di (destination index/location) to the next line

		pop cx 
		loop readLine

	pop bp 
	ret  
PrintFullScreenBMP endp 

PrintOpeningPage proc  
	call setVideoMode                     ;clear screen 
	
	printOpening:
		push offset OpeningFileName       ;places memory address of the bmp to the stack 
		push offset OpeningFileHandle     ;places the memory address of the file to the stack where the filehandle will be stored
		call OpenFile                     ;opens the specified file 

		push [OpeningFileHandle]          ;pushes the value stored at the memory location pointed by the filehandle to the stack 
		push offset FileReadBuffer        ;pushes the memory address of the buffer area to the stack 
		call PrintFullScreenBMP           ;prints the bmp image 

		push [OpeningFileHandle]          
		call CloseFile                    ;closes the file with the specified filehandle 
	
	getKeyOpening:
		mov ah, 0h                        ;check keyboard input
		int 16h
		cmp ah, 19h                       ;check if P is pressed 
		je procEndOpening                   
		cmp ah, 2Eh                       ;check if C is pressed 
		je procEndOpening1  
		jmp getKeyOpening                 ;if not, loop to getKeyOpening until P or C is pressed
		
	procEndOpening:
		call addName                      ;calls the next screen where players will input ther name 
		ret
	
	procEndOpening1:
		call StartPage                    ;calls the controls page
		ret
PrintOpeningPage endp 


; ----------------------------------------
;             Controls Page 
; ----------------------------------------
drawControl proc
	mov ah, 02h                           ;set cursor position instruction 
	mov bh, 00h                           ;sets the page number 
	mov dh, 31h                           ;sets the y-location (row position)
	mov dl, 09h                           ;sets the x-location (column position)
	int 10h
	
	mov ah, 09h                           ;output string instruction 
	lea dx, controlB_text                 ;loads the address of the string to be printed
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 03h
	mov dl, 06h
	int 10h
	
	mov ah, 09h
	lea dx, control1_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 04h
	mov dl, 09h
	int 10h
	
	mov ah, 09h
	lea dx, controlU_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 03h
	mov dl, 17h
	int 10h
	
	mov ah, 09h
	lea dx, control2_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 04h
	mov dl, 1Bh
	int 10h
	
	mov ah, 09h
	lea dx, controlU_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 2Ch
	mov dl, 0Eh
	int 10h
	
	mov ah, 09h
	lea dx, control3_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 2Dh
	mov dl, 0Eh
	int 10h
	
	mov ah, 09h
	lea dx, controlU_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 08h
	mov dl, 19h
	int 10h
	
	mov ah, 09h
	lea dx, controlL_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 0Ah
	mov dl, 19h
	int 10h
	
	mov ah, 09h
	lea dx, controlT_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 0Ch
	mov dl, 18h
	int 10h
	
	mov ah, 09h
	lea dx, controlO_text
	int 21h
	
	mov si, offset down_key               ;loads the memory address of the bitmap variable to the source index 
	BuildKey 257, 81, 25, 28              ;calls BuildKey macro to print the bitmap (257 -> x-loc of first pixel, 81 -> y-loc, 25 -> width of image, 28 -> height of image)
	
	mov si, offset up_key
	BuildKey 257, 51, 25, 28
	
	mov si, offset enter_key
	BuildKey 235, 125, 51, 41
	
	mov si, offset left_key
	BuildKey 59, 57, 28, 25
	
	mov si, offset right_key
	BuildKey 89, 57, 28, 25
	
	ret 
drawControl endp


; ----------------------------------------
;                  Name
; ----------------------------------------
drawName proc
	drawTitle 78, 49, 4, 20, 0Dh          ;calls drawTitle macro to print each horizontal and vertical line of the letter E 
	drawTitle 78, 49, 12, 4, 0Dh          ;78 -> x-loc of first pixel, 49 -> y-loc, 12 -> width of line, 4 -> heigh of line, 0Dh -> color
	drawTitle 78, 57, 10, 4, 0Dh
	drawTitle 78, 65, 12, 4, 0Dh
	
	drawTitle 94, 49, 4, 20, 0Dh          ;draw N 
	drawTitle 94, 50, 13, 4, 0Dh
	drawTitle 104, 50, 4, 19, 0Dh
	
	drawTitle 111, 49, 16, 4, 0Dh         ;draw T
	drawTitle 117, 49, 4, 20, 0Dh
	
	drawTitle 131, 49, 4, 20, 0Dh         ;draw E
	drawTitle 131, 49, 12, 4, 0Dh
	drawTitle 131, 57, 10, 4, 0Dh
	drawTitle 131, 65, 12, 4, 0Dh
	
	drawTitle 147, 49, 4, 20, 0Dh         ;draw R
	drawTitle 147, 49, 14, 4, 0Dh
	drawTitle 158, 49, 4, 13, 0Dh
	drawTitle 147, 59, 15, 4, 0Dh
	drawTitle 156, 59, 4, 10, 0Dh
	
	drawTitle 172, 49, 4, 12, 0Dh         ;draw Y
	drawTitle 172, 58, 16, 4, 0Dh
	drawTitle 184, 49, 4, 12, 0Dh
	drawTitle 178, 58, 4, 11, 0Dh
	
	drawTitle 190, 49, 4, 20, 0Dh         ;draw O  
	drawTitle 190, 49, 14, 4, 0Dh
	drawTitle 201, 49, 4, 20, 0Dh
	drawTitle 190, 65, 14, 4, 0Dh
	
	drawTitle 207, 49, 4, 20, 0Dh         ;draw U 
	drawTitle 207, 65, 14, 4, 0Dh
	drawTitle 218, 49, 4, 20, 0Dh
	
	drawTitle 224, 49, 4, 20, 0Dh         ;draw R
	drawTitle 224, 49, 14, 4, 0Dh
	drawTitle 235, 49, 4, 13, 0Dh
	drawTitle 224, 59, 14, 4, 0Dh
	drawTitle 233, 59, 4, 10, 0Dh
	
	drawTitle 125, 79, 14, 4, 0Dh         ;draw N
	drawTitle 125, 79, 4, 20, 0Dh
	drawTitle 136, 79, 4, 20, 0Dh
	
	drawTitle 144, 79, 4, 20, 0Dh         ;draw A
	drawTitle 144, 79, 14, 4, 0Dh
	drawTitle 155, 79, 4, 20, 0Dh
	drawTitle 144, 88, 14, 4, 0Dh
	
	drawTitle 162, 79, 4, 20, 0Dh         ;draw M
	drawTitle 162, 79, 17, 4, 0Dh
	drawTitle 176, 79, 4, 20, 0Dh
	drawTitle 169, 79, 4, 9, 0Dh
	
	drawTitle 183, 79, 4, 20, 0Dh         ;draw E
	drawTitle 183, 79, 12, 4, 0Dh
	drawTitle 183, 87, 10, 4, 0Dh
	drawTitle 183, 95, 12, 4, 0Dh
	
	ret 
drawName endp

addName proc
	push ax
	push bx
	push cx
	push dx
	
	call setVideoMode                     ;clears screen 
	call drawBoundary                     ;draws boundary (line border) 
	call drawBorder                       ;draws random pixel to the screen outside the line border 
	call drawBg                           ;draws random pixel to the screen inside the line border 
	call drawName                         ;draws the "ENTER YOUR NAME" text on the screen
	mov control, 0                        ;sets the control var to 0 -> the control page will not be printed when StartPage proc is called
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 12h
	mov dl, 0Dh
	int 10h
	
	mov ah, 09h
	lea dx, nameLength_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 14h
	mov dl, 0Ah
	int 10h
	
	mov ah, 09h
	lea dx, nameLength_text1
	int 21h
	
	mov cx, 5                             ;number of times the blank line will be printed (no. of characters needed in the name)
    mov bp, 0                             ;sets pointer to the 0
    blank:
		mov ah, 02h                       
        mov dh, 0Fh
        mov dl, 12h
        add dx, bp                        ;adds the value of the bp to the value of dx (if bp=2 => dx=0F14h) 
        inc bp                            ;increments the value of dx (0F12h => 0F13h) -> moves the pointer one cursor position to the right 
        mov bh, 00h                         
        int 10h

        mov ax, 092Dh                     ;09h -> write char instruction; outputs the specified character (2Dh -> underscore) 
        mov bl, 09h                       ;color 
        mov bh, 00h
        push cx                           ;pushes the current cx (number of iterations) to the stack as cx will be used in the instruction
        mov cx, 1                         ;sets the number of times to print char 
        int 10h
        pop cx                            ;redefined cx to the no. of iterations after instruction if executed 
		loop blank 

	lea si, playername                    ;sets the offset of playername var as source 
	mov cx, 6                             ;no. of iterations (5 char for name + 1 enter key) 
	mov bp, 0
	get_name:
		mov ah, 07h                       ;read char input instruction 
		int 21h
		
		mov ah, 02h           
		mov dh, 0Fh  
		mov dl, 12h
		add dx, bp            
		inc bp                 
		mov bh, 00h
		int 10h
	
		cmp al, 08h                       ;checks if backspace is pressed 
		jne printchar1                    ;if not, print char 
		
		mov ah, 02h                       
		dec dx                            ;moves cursor position to previous location 
		sub bp, 2                         ;sets the pointer two spaces back 
		dec si                            ;sets the offset of playername var to the previous char 
		mov bh, 00h
		int 10h
		
		mov ax, 0A2Dh                     ;overwrites current char (e.g. 'A' => '-')
		mov bh, 00h 
		mov cx, 1
		int 10h
		
		jmp get_name                      ;reads char once more 
		
		;---prints char on the screen---
		printchar1:
			mov ah, 0Ah                                     
			mov bh, 00h 
			mov bl, 09h 
			push cx
			mov cx, 1
			int 10h
			pop cx
		
			mov byte ptr [si], al         ;overwrites char at the position of the pointer in the variable 
			inc si                        ;moves to next char 
	
	cmp bp, 5                             ;checks if the number of chars printed is 5
	je save                               ;if yes, then jump to save 
	jmp get_name                          ;if not, continue receiving char input 
	
	save:
		mov ah, 0h                     
		int 16h
		cmp ax, 1C0Dh                     ;checks if char read is enter key 
		jne get_name                      ;if not, continue reveiving input until enter key is pressed 
		
		call StartPage                    ;if yes, call StartPage to print the main menu 
		ret 
	
	pop ax
	pop bx
	pop cx
	pop dx
	ret
addName endp

printName proc
	;---prints the name on the specified position---
	mov ah, 02h
	mov bh, 00h
	mov dh, 01h
	mov dl, 22h
	int 10h
	
	mov ah, 09h
	lea dx, playername
	int 21h
	
	ret 
printName endp 


; ----------------------------------------
;               Main Menu
; ----------------------------------------
StartPage proc
	call setVideoMode
	call drawBorder
	call drawBg

	cmp control, 1                        ;checks if the controls page will be printed 
	je draw_control                       ;if yes, jump to draw_control 
	
	call drawMenuText                     ;if not, print the 'MAIN MENU' text 
	call printName                        ;prints the name on the screen 
	call menu                             ;calls the menu function 
	jmp done                              ;jump to done to skip draw_control 
	
	;---if control=1, call drawTitle to print the lines on controls page--- 
	draw_control:
		drawTitle 18, 11, 285, 6, 13      
		drawTitle 18, 11, 6, 35, 13
		drawTitle 298, 11, 6, 35, 13
		drawTitle 158, 11, 6, 167, 13
		drawTitle 18, 149, 6, 28, 13
		drawTitle 298, 149, 6, 28, 13
		drawTitle 18, 173, 285, 6, 13
		drawTitle 52, 103, 31, 6, 12
		drawTitle 102, 103, 31, 6, 12
		drawTitle 64, 132, 5, 5, 15
		drawTitle 75, 150, 37, 4, 13
		
		call drawControl
		drawTitle 206, 74, 25, 0, 13
		
		get_key:
			mov ah, 00h                    
			int 16h
			cmp ah, 30h                   ;checks if B is pressed  
			jne get_key                   ;loop through get_key until B is pressed 
			call PrintOpeningPage         ;if pressed, print the title page 
	
	done:
	ret
StartPage endp

drawMenuText proc
	;---prints the "MAIN MENU" text---
	drawTitle 114, 34, 6, 23, 8           ;draw M shadow
	drawTitle 114, 34, 25, 6, 8
	drawTitle 124, 34, 6, 11, 8
	drawTitle 134, 34, 6, 23, 8
	drawTitle 113, 33, 6, 23, 13          ;draw M
	drawTitle 113, 33, 25, 6, 13
	drawTitle 123, 33, 6, 11, 13
	drawTitle 133, 33, 6, 23, 13
	
	drawTitle 145, 34, 6, 23, 8           ;draw A shadow 
	drawTitle 145, 34, 19, 6, 8
	drawTitle 159, 34, 6, 23, 8
	drawTitle 145, 45, 19, 6, 8
	drawTitle 144, 33, 6, 23, 13          ;draw A
	drawTitle 144, 33, 19, 6, 13
	drawTitle 158, 33, 6, 23, 13
	drawTitle 144, 44, 19, 6, 13
	
	drawTitle 169, 34, 21, 6, 8           ;draw I shadow
	drawTitle 177, 34, 6, 23, 8
	drawTitle 169, 51, 21, 6, 8
	drawTitle 168, 33, 21, 6, 13          ;draw I
	drawTitle 176, 33, 6, 23, 13
	drawTitle 168, 50, 21, 6, 13
	
	drawTitle 195, 34, 6, 23, 8           ;draw N shadow 
	drawTitle 195, 34, 19, 6, 8
	drawTitle 209, 34, 6, 23, 8
	drawTitle 194, 33, 6, 23, 13          ;draw N
	drawTitle 194, 33, 19, 6, 13
	drawTitle 208, 33, 6, 23, 13
	
	drawTitle 114, 65, 6, 23, 8          ;draw M shadow
	drawTitle 114, 65, 25, 6, 8
	drawTitle 124, 65, 6, 11, 8
	drawTitle 134, 65, 6, 23, 8
	drawTitle 113, 64, 6, 23, 13         ;draw M
	drawTitle 113, 64, 25, 6, 13
	drawTitle 123, 64, 6, 11, 13
	drawTitle 133, 64, 6, 23, 13
	
	drawTitle 145, 65, 6, 23, 8          ;draw E shadow 
	drawTitle 145, 65, 19, 6, 8
	drawTitle 145, 73, 13, 6, 8
	drawTitle 145, 82, 19, 6, 8
	drawTitle 144, 64, 6, 23, 13         ;draw E
	drawTitle 144, 64, 19, 6, 13
	drawTitle 144, 72, 13, 6, 13
	drawTitle 144, 81, 19, 6, 13
	
	drawTitle 170, 65, 6, 23, 8          ;draw N shadow
	drawTitle 170, 65, 19, 6, 8
	drawTitle 184, 65, 6, 23, 8
	drawTitle 169, 64, 6, 23, 13         ;draw N
	drawTitle 169, 64, 19, 6, 13
	drawTitle 183, 64, 6, 23, 13
	
	drawTitle 195, 65, 6, 23, 8         ;draw U shadow
	drawTitle 195, 82, 19, 6, 8
	drawTitle 209, 65, 6, 23, 8
	drawTitle 194, 64, 6, 23, 13        ;draw U
	drawTitle 194, 81, 19, 6, 13
	drawTitle 208, 64, 6, 23, 13
	
	ret 
drawMenuText endp 

menu proc
	;---redefine the variables---
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

	;---prints the menus---
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
	
	call drawSelect                       ;draws the underline on the currently selected menu option 

	select:
		mov ah, 00h                       ;reads keyboard input 
		int 16h
		cmp soundOn, 1                    ;checks if sound is enabled (soundOn=1)
		jne noSound2                      ;if not, skip the beep sound 
		call beep
		
		noSound2:                        
		cmp ax, 4800h                     ;checks if up-arrow key is pressed 
		je up1                            ;if yes, jump to up1
		cmp ax, 5000h                     ;checks if down-arrow key is pressed 
		je down1
		cmp ax, 1C0Dh                     ;checks if enter key is pressed 
		je selected1
		
		;---if down is pressed---
		down1:
			cmp opt, 4                    ;checks if the currently selected option is the last option on the menu
			je back1                      ;if yes, jump to back1 
			
			add opt, 1                    ;if not, increase the opt var by 1, indicating that the next option is selected
			call deleteSelect             ;deletes the underline on the menu 
			add yloc, 16                  ;changes the y-loc of the underline 
			call drawSelect               ;draws underline at new position (under new selected option)
			jmp select                    ;jump to selct to check next key input 
		
		;---if up is pressed---
		up1:
			cmp opt, 1                    ;checks if the currently selected option is first option on the menu
			je next1                      ;if yes, jump to next1 
			
			sub opt, 1                    ;if not, decrease opt by 1, indicating that the previous option is selected
			call deleteSelect
			sub yloc, 16
			call drawSelect
			jmp select
			
		;---if last option is currently selected && down is pressed---
		back1:
			mov opt, 1                    ;sets opt to 1, indicating the first opt is currently selected
			call deleteSelect
			mov yloc, 129                 ;129 -> y-loc of first underline 
			call drawSelect
			jmp select
		
		;---if first option is currently selected && up is pressed---
		next1:
			mov opt, 4                    ;sets opt to 4, indicating that the last option is currently selected
			call deleteSelect
			mov yloc, 177                 ;177 -> y-loc of last underline  
			call drawSelect
			jmp select
		
	;---if enter is pressed---
	selected1:
		cmp opt, 1                        ;checks if selected option is the first option 
		je start_level                    ;if yes, jump to start_level to call the next page 
		cmp opt, 2
		je start_timed
		cmp opt, 3
		je go_options
		cmp opt, 4
		je terminate
		
	start_level:
		call levelMenu                    ;calls the level menu for level mode 
		ret
	
	start_timed:
		call timedMenu                    ;calls the level menu for timed mode 
		ret
		
	go_options:
		call optionsPage                  ;calls the options page to enable/disable sound 
		call enable                       ;calls the menu for options page 
		ret
	
	terminate:
		call setVideoMode                 ;clears screen
		mov ah, 4Ch                       ;terminate the program 
		int 21h
	
	none:
		ret
menu endp


; ----------------------------------------
;             Options Page
; ----------------------------------------
optionsPage proc
    call setVideoMode

	;---prints the "ENABLE SOUNDS?" text
    drawTitle 90, 36, 6, 30, 13           ;draw E
    drawTitle 96, 36, 12, 6, 13
    drawTitle 96, 48, 6, 6, 13
    drawTitle 96, 60, 12, 6, 13    
  
    drawTitle 114, 36, 6, 30, 13          ;draw N 
    drawTitle 120, 36, 6, 6, 13
    drawTitle 126, 36, 6, 30, 13

    drawTitle 138, 36, 12, 6, 13          ;draw A 
    drawTitle 150, 36, 6, 30, 13
    drawTitle 138, 48, 12, 6, 13
    drawTitle 138, 54, 6, 6, 13
    drawTitle 138, 60, 12, 6, 13

    drawTitle 162, 36, 6, 30, 13          ;draw B 
    drawTitle 168, 48, 6, 6, 13
    drawTitle 168, 60, 6, 6, 13
    drawTitle 174, 48, 6, 18, 13

    drawTitle 186, 36, 6, 30, 13          ;draw L
    drawTitle 192, 60, 12, 6, 13
   
    drawTitle 210, 36, 6, 30, 13          ;draw E  
    drawTitle 216, 36, 6, 6, 13
    drawTitle 216, 48, 6, 6, 13
    drawTitle 216, 60, 12, 6, 13
    drawTitle 222, 36, 6, 18, 13

    drawTitle 78, 72, 18, 6, 13           ;draw S 
    drawTitle 78, 84, 18, 6, 13
    drawTitle 78, 96, 18, 6, 13
    drawTitle 78, 78, 6, 6, 13
    drawTitle 90, 90, 6, 6, 13

    drawTitle 102, 72, 6, 30, 13          ;draw O
    drawTitle 108, 72, 6, 6, 13
    drawTitle 108, 96, 6, 6, 13
    drawTitle 114, 72, 6, 30, 13

    drawTitle 126, 72, 6, 30, 13          ;draw U 
    drawTitle 132, 96, 6, 6, 13
    drawTitle 138, 72, 6, 30, 13

    drawTitle 150, 72, 6, 30, 13          ;draw N 
    drawTitle 156, 72, 6, 6, 13
    drawTitle 162, 72, 6, 30, 13

    drawTitle 186, 72, 6, 30, 13          ;draw D 
    drawTitle 174, 84, 6, 18, 13
    drawTitle 180, 84, 6, 6, 13
    drawTitle 180, 96, 6, 6, 13
 
    drawTitle 198, 72, 18, 6, 13          ;draw S 
    drawTitle 198, 84, 18, 6, 13
    drawTitle 198, 96, 18, 6, 13
    drawTitle 198, 78, 6, 6, 13
    drawTitle 210, 90, 6, 6, 13
   
    drawTitle 5, 5, 4, 188, 13            ;draw border 
    drawTitle 309, 5, 4, 188, 13
    drawTitle 9, 5, 300, 4, 13
    drawTitle 9, 189, 300, 4, 13

    drawTitle 234, 72, 6, 18, 13          ;draw ?
    drawTitle 222, 72, 12, 6, 13
    drawTitle 228, 84, 6, 6, 13
    drawTitle 228, 96, 6, 6, 13

	call enable                           ;calls the options page menu 

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
	
	mov optSound, 1                       ;sets currently selectiod option to the first option 
	mov xloc, 149
	mov yloc, 129          
	mov wid, 20
	call drawSelect        

	;---checks which menu option is selected---
	selectMusicOption:    
		mov ah, 00h                      
		int 16h
		cmp soundOn, 1                   
		jne noSound1                     
		call beep
		
		noSound1:
		cmp ax, 4800h                    
		je upOption
		cmp ax, 5000h                    
		je downOption
		cmp ax, 1C0Dh                     
		je handleMusicSelection  

		downOption:
			cmp optSound, 3              
			je backToTopOption            

			add optSound, 1               
			call deleteSelect      
			add yloc, 16            
			call drawSelect         
			jmp selectMusicOption  

		upOption:
			cmp optSound, 1      
			je nextToBottomOption   

			sub optSound, 1       
			call deleteSelect      
			sub yloc, 16             
			call drawSelect         
			jmp selectMusicOption   

		backToTopOption:      
			mov optSound, 1       
			call deleteSelect     
			mov yloc, 129          
			call drawSelect
			jmp selectMusicOption  

		nextToBottomOption:   
			mov optSound, 3      
			call deleteSelect
			mov yloc, 161          
			call drawSelect
			jmp selectMusicOption  
	
		handleMusicSelection:          
			cmp optSound, 1
			je enableMusic
			cmp optSound, 2
			je disableMusic
			cmp optSound, 3        
			je returnToMenu

		enableMusic:
		  	mov soundOn, 1                ;enables sound 
			jmp returnToMenu

		disableMusic:
		  	mov soundOn, 0                ;disables sound 
			jmp returnToMenu
		  
		returnToMenu:
		  	call StartPage                ;returns to main menu
		  	ret
enable endp


; ----------------------------------------
;              Gameplay Menu
; ----------------------------------------
levelMenu proc
	push ax
	push bx
	push dx
	push cx
	
	call setVideoMode
	call drawBorder
	call drawBg
	call printName 
	
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
	mov xloc, 142
	mov yloc, 73
	mov wid, 20
	call drawSelect                

	;---checks which level is chosen---
	selectLevel:
		mov ah, 00h              
		int 16h
		cmp soundOn, 1
		jne noSound3
		call beep
		
		noSound3:
		cmp ax, 4800h            
		je upLevel
		cmp ax, 5000h              
		je downLevel
		cmp ax, 1C0Dh              
		je selectedLevel
		
		downLevel:
			cmp optLevel, 6            
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
			mov yloc, 73          
			call drawSelect
			jmp selectLevel
		
		nextLevel:
			mov optLevel, 6
			call deleteSelect
			mov yloc, 153         
			call drawSelect
			jmp selectLevel
		
	selectedLevel:
		cmp optLevel, 6                   ;checks if back is selected 
		je backMenu
		
	level1:
		mov gamemode, 0                   ;sets gamemode to 0, indicating that level mode is chosen 
		call levelmode                    ;calls levelmode to prepare the gameplay 
		ret
	
	backMenu:
		call StartPage                    ;if back is selected, call main menu 
		ret 
	
	pop ax
	pop bx
	pop dx
	pop cx
levelMenu endp

timedMenu proc
	push ax
	push bx
	push dx
	
	call setVideoMode
	call drawBorder
	call drawBg
	call printName
	
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
	mov xloc, 142
	mov yloc, 73
	mov wid, 20
	call drawSelect               

	;---checks which option is selected--- 
	selectTimed:
		mov ah, 00h                
		int 16h
		cmp soundOn, 1
		jne noSound4
		call beep
		
		noSound4:
		cmp ax, 4800h           
		je upTimed
		cmp ax, 5000h          
		je downTimed
		cmp ax, 1C0Dh          
		je selectedTimed
		
		downTimed:
			cmp optLevel, 6           
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
			mov yloc, 73          
			call drawSelect
			jmp selectTimed
		
		nextTimed:
			mov optLevel, 6
			call deleteSelect
			mov yloc, 153          
			call drawSelect
			jmp selectTimed
		
	selectedTimed:
		cmp optLevel, 6                   ;checks if back is selected 
		je backMenu1
		
	timed1:
		mov gamemode, 1                   ;indicates that timed mode is selected 
		call levelmode                    ;prepares gameplay 
		ret
		
	backMenu1:
		call StartPage                    ;if back is selected, go to main menu
		ret
		
	pop ax
	pop bx
	pop dx
timedMenu endp

levelmode proc
	call setVideoMode
	call drawBoundary
	call drawBorder
	mov begin, 1                          ;indicates that the game is set to begin 
	mov lives, 3                          ;sets lives count to 3 

	;---checks which level is selected
	cmp optLevel, 1                       
	cmp optLevel, 2
	je level2Game
	cmp optLevel, 3
	je level3Game
	cmp optLevel, 4
	je level4Game
	cmp optLevel, 5
	je level5Game

	level1Game:
		call levelOne                     ;sets the bricks layout 
		mov innerDelay, 0                 ;sets the speed of the ball 
		mov fastball, 0
		jmp next                          ;jumps to next 
	
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
		mov innerDelay, 1
		mov fastball, 1
		jmp next
		
	level5Game:
		call levelFive
		mov innerDelay, 2
		mov fastball, 2
		jmp next

	next:
		call BuildB                       ;builds the bricks on the screen 
		call printName                    ;prints player's name 
		redrawStriker 13                  ;draws striker 
		redrawBall 15                     ;draws ball 
		call gameLoop                     ;starts gameloop 
	ret
levelmode endp

playNext proc
	;---redefines the variables--- 
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
	
	;---checks which options is currently selected---
	cmp optLevel, 1                       
	je playLevel2
	cmp optLevel, 2
	je playLevel3
	cmp optLevel, 3
	je playLevel4
	cmp optLevel, 4
	je playLevel5
	cmp optLevel, 5
	je playMore
	
	;sets optLevel to the succeeding level of the current optLevel   
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
		
	;---if the last level is the current optLevel---
	playMore:
		cmp gamemode, 1                   ;checks if timed mode was chosen 
		je goToMain                       ;if yes, jump to goToMain 
		
		mov gamemode, 1                   ;if not, switch to timed mode
		mov optLevel, 1                   ;sets optLevel to 1
		call levelmode                    ;prepares game to play level 1 of timed mode 
		ret 
		
		;---if level 5 of timed mode was playing--- 
		goToMain:
			call StartPage                ;goes back to the main menu          
			ret
		
	play:
		call levelmode
	ret
playNext endp


; ----------------------------------------
;              Bricks Layout
; ----------------------------------------
;---sets the x and y-locations of the bricks---
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


; ----------------------------------------
;                 Bricks
; ----------------------------------------
BuildB proc	
	;---passes bricks coordinates and color to the BuildBrick macro---
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

AddBrick proc
    push ax
    push bx    
	
    mov startx, ax                        ;sets the x-loc of the brick based on the argument passed to BuildB proc 
    mov ax, bx                            ;moves the y-loc of the brick to the ax register 
    mov bx, startx                        ;moves the value of startx to the bx register  
    add bx, 35                            ;adds brick's width to the x-loc of the brick 
    mov endx, bx                          ;sets the x-loc of the last pixel of the brick   
    
    mov starty, ax                        ;sets the y-loc of the brick based on the argument passed to BuildB proc
    mov bx, starty                        ;moves the value of starty to the bx register 
    add bx, 7                             ;adds brick's height to the y-loc of the brick 
    mov endy, bx                          ;sets the y-loc of the last pixel of the brick 
     
    call draw                             ;draws the brick 
	
    pop bx
    pop ax 
    ret
AddBrick endp

CollideB proc
	;---passes bricks coordinates to the BrickCollision macro---
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

RemoveBrick proc 
    push ax
    push bx
    push cx
    push dx
    
	;---ax/bx -> x-loc/y-loc of the brick to be removed based on the arguments passed on the BrickCollision macro---
    mov startx, ax                     
    mov color, 0                          ;changes the color of the brick to black, similar to the background's color   
    mov ax, bx
    mov bx, startx   
    add bx, 35
    mov endx, bx
    
    mov starty, ax 
    mov bx, starty
    add bx, 7
    mov endy,bx
 
    call draw                             ;draws the brick as black, making it invisible on the screen 
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
RemoveBrick endp


; ----------------------------------------
;                  Ball
; ----------------------------------------
drawball proc
    push bx
	
    ;---draws the ball with the color based on the argument passed to the redrawball macro 
	;to determine if the ball will be added/visible or removed/invisible---
	mov bx, ballX
    mov startx, bx
    add bx, 5                             ;5 -> width of the ball 
    mov endx,   bx
	
    mov bx, ballY
    mov starty, bx
    add bx, 5                             ;5 -> height of the ball
    mov endy,   bx
	
    pop bx
    
    call draw
ret
drawball endp

Collisionwall proc     
    mov bx, ballX                         ;moves the current x-location of the ball to bx  
    mov cx, ballY                         ;moves the current y-location of the ball to cx 
    
    checkLeftRight:
		cmp bx, 25                        ;checks if the ball hits the left wall/reaches the left boundary (25 -> x-loc of the left wall)
		jl goRight                        ;if yes, jump to goRight 
		cmp bx, 290                       ;check if the ball hits the right wall
		jg goLeft
		jmp checkUpDown                   ;if ball hits none of the left and right walls, check the up and bottom walls
		
    goRight:
		mov ballLeft, 0                   ;sets ballLeft to 0, indicating that the ball will now move to the right
		jmp checkUpDown
		
    goLeft:
		mov ballLeft, 1                   ;indicates that the ball will now move to the left 
	
    checkUpDown:
		cmp cx, 25                        ;checks if the ball hits the top wall
		jl goDown
		cmp cx, 175                       ;check if ball hits the bottom wall
		jg goUp
   
	jmp noInput1                          
	
    goUp:                                            
		mov ballUp, 1                     ;indicates that the ball will now move upwards  
		jmp noInput1                      
	
    goDown: 
		mov ballUp, 0                     ;indicates that the ball will now move downwards
  
	noInput1:
    ret
Collisionwall endp

CollisionStriker proc    
    push ax
    push bx
    push cx
    push dx
    
    mov dx, ballY                         ;moves current y-location of ball to dx register 
    cmp dx, 165                           ;checks if the ball misses the striker 
    jl movement                           ;if not, continue moving the ball
    cmp dx, 170                           ;checks if the ball hits the bottom wall
    jg check1                            
    
    mov cx, strikerX                      ;moves the current x-loc of striker to cx register
    mov ax, ballX                         ;moves the current x-loc of ball to ax register 
    cmp ax, cx                            ;checks if the ball hits the striker 
    jl movement                           ;if ball's x-loc is less than the striker's, continue moving the ball (back to loop) 
    add cx, 40                            ;if greater than, add 40 (striker's width) to the striker's x-loc (cx)
    cmp ax, cx                            ;check again if the ball hits the striker 
    jg movement                           ;if ball's x-loc is greater than the striker's, continue moving the ball
										  ;if ball's x-loc is less than the striker's end then the ball is within the vicinity of the striker
    mov ballUp, 1                         ;indicates that the ball will now move upwards
    jmp movement                          ;continue moving the ball
    
	movement:
	pop dx
    pop cx
    pop bx
    pop ax
    ret
	
	check1:
		cmp gamemode, 1                   ;checks if timed mode is chosen 
		jl decLives1                      ;if not, jump to decLives1 
		redrawball 0                      ;if yes, then remove ball at current position 
		mov ballY, 163                    ;sets y-loc to the initial position 
		mov ballX, 158                    ;sets x-loc to the initial position 
		mov ballUp, 1                     ;moves the ball upwards 
		mov ballLeft, 1                   ;moves the ball to the left 
		redrawball 15                     ;draws the ball at initial location  
		call gameloop                     ;continues the loop 
		ret
		
	;---if level mode is chosen--- 
	decLives1:
		cmp lives, 0                      ;checks if lives=0       
		je finish                         ;if yes, then game over 
		call removeLives                  ;if not, then remove the hearts on the screen (will be drawn in the gameloop)
		call decLives                     ;decrements the lives count by one, and reset's ball's position
		ret
		
	;---if lives=0---
    finish:  
		mov begin, 0                      ;indicates that the game has ended 
		redrawball 0                      ;removes ball 
		redrawStriker 0                   ;removes striker 
		call GameOverPage	              ;calls game over page 
		ret 
CollisionStriker endp

movement1:
ret
ballMove proc  
	inc innerDelay                        ;increments the delay on the gameloop 
	cmp innerDelay, EXTERNDELAY           ;checks if the specified inner delay of the ball is equal to the external delay 
	jne movement1                         ;if not, loop to movement1, creating delay for the movement of the loop
	
	cmp fastBall, 0                       ;checks if fastBall is set to 0
	je slow                               ;if equal, jump to slow 
	cmp fastball, 1
	je fast1
	cmp fastBall, 2
	je fast2 
	
	slow:
		mov innerDelay, 0                 ;resets inner delay to 0
		jmp nextball 
	
	fast1:
		mov innerDelay, 1
		jmp nextball 
		
	fast2:
		mov innerDelay, 2
		
	nextball:
		redrawBall 0                      ;removes ball at current position 
    
	mov bx, ballX                         ;moves current ballX to bx register 
	cmp ballLeft, 1                       ;checks if ball is moving to the left
	je Left                               ;if yes, jump to Left 
	jne Right                             ;if not, jump to Right
	
	Left:   
		sub bx, 2                         ;subtract 2 from bx/ move ball to the left  
		jmp changeBall                    
		
	Right:   
		add bx, 2                         ;add 2 to bx/ move ball to the right 
	
	changeBall:
		mov ballX,  bx                    ;sets ball's x-loc to the value of bx 
		mov bx, ballY                     ;moves current ballY to bx 
		cmp ballUp, 1                     ;checks if ball is moving upwards 
		je Up                             
		jne Down
	
	Up:
		sub bx, 2                         ;subtract 2 from bx/ mvoe ball upwards 
		jmp moveBall
		
	Down:
		add bx, 2                         ;add 2 to bx/ move ball downwards 
		
	moveBall:
		mov ballY,  bx                    ;sets ball's y-loc to the value of bx 
		redrawBall 15                     ;draws the ball on the screen 
    
	ret
ballMove endp   

switcher proc
    cmp ballUp, 1                         ;check if ball is moving upwards when it hits a brick 
    je DownT                              ;if yes, jump to DownT 
    jne UpT                               ;if not, jump to UpT 
	
    UpT:
		inc ballUp                        ;(ballUp=0, ballUp++ => ballUp=1)
		ret
	
    DownT:
		dec ballUp                        ;(ballUp=1, ballUp-- => ballUp=0)
		ret
	ret
switcher endp


; ----------------------------------------
;                 Striker
; ----------------------------------------
drawStriker proc
    push bx
    push cx
 
    mov bx, strikerX                      ;moves striker's x-loc to bx register 
    mov cx, strikerY                      ;moves striker's y-loc to cx register 
    mov startx, bx                        ;sets startx to the x-loc of striker 
    add bx, 40                            ;adds 40 (strker's width) to the x-loc of striker 
    mov endx, bx                          ;sets endx to the value of bx 
	
    mov starty, cx                        ;sets starty to the y-loc of the striker 
    mov endy, 175                         ;sets endy to 175 (y-loc of the last row of pixels of the striker) 
    call draw                             ;draws the striker 
    
    pop cx
    pop bx
    ret
drawStriker endp


; ----------------------------------------
;                 Lives
; ----------------------------------------
drawLives proc
	cmp lives, 3                          ;checks if lives=3
	jne twoLives                          ;if not, jump to twoLives 
	
	;---if lives=3---
	mov tempLifeX, 290                    ;sets tempLifeX to 290 (x-loc of the third heart)                    
	mov tempLifeY, 181                    ;sets tempLifeY to 181 (y-loc of the third heart)
	call drawLife                         ;draws the heart 
	
	;---if lives!=3---
	twoLives:
		cmp lives, 2                      ;checks if lives=2
		jl oneLife                        ;if less than 2, jump to oneLife 
		mov tempLifeX, 270                ;if greater than or equal, set tempLifeX and tempLifeY 
		mov tempLifeY, 181                
		call drawLife

	;---if lives<2---
	oneLife:
		cmp lives, 0                      ;checks if lives=0
		je noLives                        ;if yes, jump to noLives 
		mov tempLifeX, 250                ;if greater than, set tempLifex and tempLifeY
		mov tempLifeY, 181
		call drawLife
	
	noLives:
	ret
drawLives endp

drawLife proc
	mov cx, tempLifeX                     ;moves the value of tempLifeX to cx 
	mov dx, tempLifeY
	mov si, offset life                   ;sets the source index to the offset of life bitmap variable 
	
	;---loop to draw the pixel one by one---
	drawLife1:
		mov ah, 0Ch                       ;draw pixel instruction 
		mov al, [si]                      ;draws the pixel of the current offset to the screen 
		mov bh, 00h                       
		int 10h
		
		inc si                            ;moves to the next offset of the bmp 
		inc cx                            ;moves the x-loc position on the screen 
		mov ax, cx                        ;moves current x-position to ax register 
		sub ax, tempLifeX                 ;subracts the value of tempLifeX from the value of ax (at first, it will be 0)
		cmp ax, 15                        ;checks if the current value of ax (at first 0) is equal to 15 (width of bitmap)
		jne drawLife1                     ;if not, loop to drawLife1
		
		mov cx, tempLifeX                 ;if yes, move tempLifeX to the cx register
		inc dx                            ;move to the next line/row on the screen 
		mov ax, dx                        ;moves current y-position to ax register 
		sub ax, tempLifeY                 ;subtracts the value of tempLifeY from the value of ax (at first 0) 
		cmp ax, 15                        ;checks if the current value of ax is equal to 15 (height of the bitmap)
		jne drawLife1                     ;if not, continue loop 
	ret 
drawLife endp

decLives proc
	dec lives                             ;decrements current lives count by 1 
	redrawball 0                          ;removes ball 
	mov ballY, 163                        ;resets ball's position 
	mov ballX, 158
	mov ballUp, 1                         ;resets ball's direction 
	mov ballLeft, 1
	redrawball 15                         ;draws ball 
	call gameloop
	ret
decLives endp

removeLives proc
	drawTitle 249, 181, 60, 19, 0         ;removes all three hearts (draws a black rectangle on the hearts' position)
	ret
removeLives endp


; ----------------------------------------
;                 Timer
; ----------------------------------------
printTime proc
	push ax
	push dx
	push cx
	
	;---sets timer's position---
	mov ah, 02h                           
	mov dh, 01h                           
	mov dl, 13h
	int 10h
	
	show:
		cmp ones, 48                      ;checks if ones is equal to 48 (one value below the ASCII value of '0')
		je tenths                         ;if yes, jump to tenths 
		
		;---if not print the values of tens and ones--- 
		mov ah, 02h                       ;char output instruction
		mov dx, tens
		int 21h
		
		mov ah, 02h
		mov dx, ones
		int 21h
	
	;---deletes the timer on the screen---
	mov cx, 02h                           ;sets counter for backspace 
	backspace:
		mov ah, 02h         
		mov dl, 8h                        ;prints backspace 
		int 21h
		dec cx                            ;decrements counter 
		jnz backspace                     ;if not 0, loop to backspace
	
	pop cx
	pop ax
	pop dx
	ret
	
	;---if ones is done counting down from 9 to 0---
	tenths:
		dec tens                          ;decrements tens value (9=>8...)
		mov ones, 57                      ;resets ones' value to '9'
		jmp show                          ;prints the new values 
printTime endp

stopTime proc
	cmp tens, 48                          ;checks if tens=0      
	je checkOnes                          ;if yes, jump to checkOnes 
	ret                                   ;if not, timer is not set to end yet 
	
	;---if tens=0---
	checkOnes:
		cmp ones, 48                      ;checks if ones=0
		je stop                           ;if yes, then timer is at '00', so game is over 
		ret
	
	stop:
		call GameOverPage
stopTime endp


; ----------------------------------------
;                Game Loop
; ----------------------------------------
repeat:
gameLoop:   
	inc timeCtr                           ;increments time counter
	call checkKeyboard                    ;checks keyboard inputs (left and right)
	cmp begin, 1                          ;check if game is set to start
	jne repeat                            ;restarts game loop if begin=0
   
	cmp gamemode, 0                       ;checks if level mode is chosen 
	je none1                              ;if yes, then skip timer 
   
	cmp timeCtr, 100                      ;if not, check if time counter is 100 
	jne none1                             ;if not, jump to none1 as timer is yet to be printed
	dec ones                              ;if timeCtr=100, decrease the value of ones 
	mov timeCtr, 0                        ;resets timeCtr
	call stopTime                         ;checks if time is set to stop 
	call printTime                        ;prints the time on the screen 
	
	;---if timer is not set to print---
	none1:
		cmp gamemode, 0                   ;checks if level mode is chosen 
		jne noLives1                      ;if not, do not draw lives 
		call drawLives                    ;if yes, draw lives 
	
	noLives1:
		call Collisionwall                ;checks if the ball hits the walls
		call CollisionStriker             ;checks if the ball hits the striker
		call CollideB                     ;checks if tha ball hits the bricks 
		call ballMove                     ;moves the ball 
		call sleep                        ;continues the gameloop
		jmp gameLoop                      ;loops the game
    
exit:
    ret

checkKeyboard proc
    mov ah, 1h                          
    int 16h                               ;checks for keypress
    jz noInput                            ;if none, jump to noInput 
	
    mov ah, 0h                            ;checks keyboard input
    int 16h
    cmp ax, 4D00h                         ;checks if the right-key arrow is pressed
    je  rightKey
    cmp ax, 4B00h		                  ;checks if the left-key arrow is pressed
    je leftKey
	cmp ax, 011Bh                         ;checks if the escape key is pressed 
	je exitGame
    
    noInput:
		ret  

    rightKey:     
		mov bx, boundaryEnd               ;moves the value of boundaryEnd to the bx register 
		cmp strikerX, bx	              ;checks if the striker reaches the wall  
		jg  noInput                       ;if striker reaches the wall, stop receiving input
		redrawStriker 0                   ;removes striker at current position 
		add strikerX, 5                   ;moves the striker 5px to the right
		redrawStriker 13                  ;draws striker at new position 
		cmp begin, 0                      ;checks if game is set to loop 
		jz moveBallRight                  ;ensures the ball does not stop moving even when pressing the key
		jmp noInput
    
    leftKey:   
		mov bx, boundaryStart                            
		cmp strikerX, bx 
		jl noInput
		redrawStriker 0
		sub strikerX, 5                   ;moves the striker 5px to the left 
		redrawStriker 13
		cmp begin, 0
		jz moveBallLeft
		jmp noInput
		
	exitGame:
		call StartPage                    ;goes back to the main menu
		ret
    
	;---moves ball to the right---
	moveBallRight:
		redrawBall 0
		add ballX, 5
		redrawBall 15
		jmp noInput
	
	;---moves ball to the left---
    moveBallLeft:
		redrawBall 0
		sub ballX, 5
		redrawBall 15
		jmp noInput
checkKeyboard endp


; ----------------------------------------
;                 Score
; ----------------------------------------
DrawScores proc
    push dx
    push ax
       
	;---prints "Time Consumed:" text 
    mov ah, 02h
	mov dh, 0Eh 
    mov dl, 0Ch
    int 10h
    
    lea dx, score_text
    mov ah, 09h
    int 21h
    
    call printScore                       ;prints score after the text 

    pop ax
    pop dx
    ret
DrawScores endp

computeScore proc
	push ax 
	push cx
	
	mov ax, 5                             ;sets the value of the ax register to 5
	sub tens, 48                          ;subtracts 48 from the current value of tens (e.g. tens=52 (ASCII of 4) - 48 (ASCII of 0) => tens=4)
	sub ax, tens                          ;subtracts the value of tens from 5 (tens=4 -> 5-4=1)
	mov cx, 10                            ;sets the value of the cx register to 10
	mul cx                                ;multiplies the value of ax and cx (ax=1 -> 1*10 => ax=10)
	mov timeScore, ax	                  ;moves the product to timeScore 
	
	mov ax, 10                            ;sets ax to 10
	sub ones, 48                          ;subtracts 48 from the current value of ones (e.g. ones=55 (ASCII of 7) - 48 => ones=7)
	sub ax, ones                          ;subtracts the value of ones from 10 (ones=7 -> 10-7=3)
	add timeScore, ax                     ;adds the value of ax to timeScore (e.g. ax=3, timeScore=10 -> 3+10=13 (timed consumed))
	
	pop ax 
	pop cx
	ret
computeScore endp

printScore proc
    push ax
    push bx
    push cx
    push dx
    
    mov cx, 0                             ;sets cx to 0
    mov ax, timeScore                     ;moves the value of timeScore to ax
	
    fetch:                              
		mov bx, 10                        ;sets bx to 10
		mov dx, 0                         ;sets dx to 0 
		div bx                            ;divides the value of ax to bx, stores the quotient in ax, and the remainder in dx
		push dx                           ;pushes the value of dx (remainder) to the stack 
		inc cx                            ;increments cx (ctr for print loop) 
		cmp ax, 0                         ;checks if ax=0
		jne fetch                         ;if not, jump to fetch 
    
    print:                              
		pop dx                            ;pops the top of the stack
		mov ah, 02h                       ;char output instruction 
		add dl, '0'                       ;adds 48 (ASCII of 0) to the value of dx to ensure that the number will be printed 
		int 21h
		loop print                        ;loops to print until cx is 0
    
    pop dx
    pop cx
    pop bx
    pop ax
    
    ret
printScore endp


; ----------------------------------------
;            Game Result Page
; ----------------------------------------
GameCompletedPage proc
	push ax
	push bx
	push dx
	
	call setVideoMode
	call drawBorder
	call drawBg
	
	;---prints "YOU DID IT!" text 
	drawTitle 67, 24, 5, 19, 13          ;draw Y
    drawTitle 73, 37, 13, 6, 13
    drawTitle 87, 24, 5, 19, 13
    drawTitle 77, 44, 6, 13, 13 
	
	drawTitle 98, 24, 6, 33, 13          ;draw O
    drawTitle 115, 24, 4, 33, 13
    drawTitle 120, 24, 0, 32, 13
    drawTitle 105, 24, 9, 6, 13
    drawTitle 105, 52, 9, 5, 13

	drawTitle 127, 24, 6, 33, 13         ;draw U
    drawTitle 144, 24, 6, 33, 13
    drawTitle 127, 52, 23, 6, 13
	
	drawTitle 168, 24, 5, 33, 13         ;draw D
    drawTitle 174, 24, 14, 6, 13
    drawTitle 174, 52, 14, 5, 13
    drawTitle 184, 28, 6, 27, 13  
	
	drawTitle 197, 24, 23, 6, 13         ;draw I
    drawTitle 197, 52, 23, 5, 13
    drawTitle 206, 31, 6, 20, 13
	
	drawTitle 227, 24, 5, 33, 13         ;draw D
    drawTitle 233, 24, 14, 6, 13
    drawTitle 233, 52, 14, 5, 13
    drawTitle 243, 28, 6, 27, 13 
	
	drawTitle 130, 67, 23, 6, 13         ;draw I
    drawTitle 130, 94, 23, 5, 13
    drawTitle 139, 73, 6, 20, 13 
	
	drawTitle 159, 67, 26, 6, 13         ;draw T
    drawTitle 169, 74, 6, 25, 13
	
	drawTitle 191, 67, 6, 23, 13         ;draw !
    drawTitle 191, 94, 6, 5, 13
	
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
    
	call drawTrophy                       ;draws trophy on the screen 
	
	;---sets variables to required values---
	mov xloc, 145
	mov yloc, 145
	mov wid, 25
    call drawSelect
	
	cmp gamemode, 1                       ;checks if timed mode is chosen 
	jne congratulations                   ;if not, jump to congratulations 
	
	call computeScore                     ;computes the score for timed mode  
	call DrawScores                       ;draws the score on the screen 
	jmp selectCompleted
	
	;---if level mode is chosen--- 
	congratulations:
		call message                      ;prints the congratulatory message 
	
	;---checks which menu option is selected---
	selectCompleted:
		mov ah, 00h                
		int 16h
		cmp soundOn, 1
		jne noSound5
		call beep
		
		noSound5:
		cmp ax, 4800h                     ;up-arrow key 
		je upCompleted
		cmp ax, 5000h                     ;down-arrow key
		je downCompleted
		cmp ax, 1C0Dh                     ;enter key
		je selectedCompleted
		
		downCompleted:
			cmp optCompleted, 3            
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
			mov yloc, 145          
			call drawSelect
			jmp selectCompleted
		
		nextCompleted:
			mov optCompleted, 3
			call deleteSelect
			mov yloc, 177          
			call drawSelect
			jmp selectCompleted
		
	selectedCompleted:
		cmp optCompleted, 1
		je nextLevel1
		cmp optCompleted, 2
		je backMain
		cmp optCompleted, 3
		je quit

	nextLevel1:
		call playNext                     ;prepares the next level
		ret

	backMain:
		call StartPage                    ;goes to the main menu 
		ret
		
	quit:
		call setVideoMode                 ;terminates the program 
		mov ah, 4Ch
		int 21h
		
	pop ax 
	pop bx
	pop dx
	ret
GameCompletedPage endp

message proc
	push dx
    push ax
    
	;---prints "Congratulations, [player's name]" text 
    mov ah, 02h
	mov dh, 0Eh 
    mov dl, 09h
    int 10h
    
    lea dx, congratulations_text
    mov ah, 09h
    int 21h
    
    mov ah, 02h
	mov dh, 0Eh 
    mov dl, 1Ah
    int 10h
    
    lea dx, playername
    mov ah, 09h
    int 21h

    pop ax
    pop dx
	ret 
message endp 

drawTrophy proc
	mov cx, 20                            ;x-location of trophy 
	mov dx, 130                           ;y-loc 
	mov si, offset trophy                 ;sets source to the offset of trophy
	
	;---prints the trophy on the screen pixel by pixel---
	drawTrophy1:
		mov ah, 0Ch 
		mov al, [si]
		mov bh, 00h
		int 10h
		
		inc si 
		inc cx 
		mov ax, cx
		sub ax, 20
		cmp ax, 50
		jne drawTrophy1 
		
		mov cx, 20
		inc dx
		mov ax, dx
		sub ax, 130
		cmp ax, 50
		jne drawTrophy1 
	ret 
drawTrophy endp 

GameOverPage proc
	push ax
	push bx
	push dx
	
	call setVideoMode
	call drawBorder
	call drawBg
	  
	drawTitle 91, 32, 30, 6, 5            ;draw G 
	drawTitle 115, 38, 6, 6, 5  
	drawTitle 91, 38, 6, 35, 5  
	drawTitle 97, 67, 25, 6, 5  
	drawTitle 107, 53, 15, 6, 5  
	drawTitle 116, 59, 6, 8, 5  

    drawTitle 127, 32, 6, 41, 5           ;draw A 
    drawTitle 133, 32, 18, 6, 5  
	drawTitle 152, 32, 6, 41, 5  
	drawTitle 133, 50, 18, 6, 5  

    drawTitle 163, 32, 6, 41, 5           ;draw M 
    drawTitle 169, 32, 18, 6, 5  
	drawTitle 175, 38, 6, 18, 5  
	drawTitle 188, 32, 6, 41, 5  

    drawTitle 199, 32, 6, 41, 5           ;draw E 
    drawTitle 205, 32, 25, 6, 5  
	drawTitle 205, 49, 22, 6, 5  
	drawTitle 205, 67, 25, 6, 5  
  
    drawTitle 91, 78, 6, 41, 5            ;draw O 
    drawTitle 97, 78, 19, 6, 5  
	drawTitle 116, 78, 6, 41, 5  
	drawTitle 97, 113, 19, 6, 5  

    drawTitle 127, 78, 6, 35, 5           ;draw V 
    drawTitle 152, 78, 6, 35, 5  
	drawTitle 133, 113, 19, 6, 5  

    drawTitle 163, 78, 6, 41, 5           ;draw E 
    drawTitle 169, 78, 25, 6, 5  
	drawTitle 169, 95, 22, 6, 5  
	drawTitle 169, 113, 25, 6, 5  

    drawTitle 199, 78, 6, 41, 5           ;draw R
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
    
	;---sets variables to required values--- 
	mov xloc, 145
	mov yloc, 161
	mov wid, 25
    call drawSelect
	
	;---checks which menu optionis selected---
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
		cmp optOver, 1
		je backMain1
		cmp optOver, 2
		je quit1

	backMain1:
		call StartPage              
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


; ----------------------------------------
;                 Misc
; ----------------------------------------
setVideoMode proc
    ;---sets video mode to VGA---
	mov ah, 00h                              
    mov al, 13h 
    int 10h     
    
	;---sets background color to black---
	mov ah, 0Bh                           ;sets background color to black 
	mov bh, 13h
	mov bl, 00h
	int 10h
	
    ret
setVideoMode endp

AddRec proc
	mov cx, xlocRec                       ;moves the value of xlocRec (based on the drawTitle macro) to cx 
	mov dx, ylocRec                       ;moves the valueof ylocRec to dx 
	
	drawLoopRec:
		mov ah, 0Ch                       
		mov al, color                     ;sets the color of the pixel based on the argument passed to drawTitle 
		mov bh, 00h                      
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

drawSelect proc
	;---draws the underline---
	mov cx, xloc
	mov dx, yloc
	
	drawLoop:
		mov ah, 0Ch
		mov al, 0Dh                       ;color -> light magenta
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
	;---draws the underline in black to make it invisible--- 
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

drawBoundary proc
	mov color, 07h                        ;sets the color to light gray 
    
	;---top---
    mov startx, 22                        ;sets the starting x-loc to 22 
    mov endx, 300                         ;sets the ending x-loc of the line to 300 
    mov starty, 22                        ;sets the starting y-loc to 22
    mov endy, 23                          ;sets the ending y-loc of the line to 23 (height of line=1px)
    call draw

	;---right---
    mov startx, 299                     
    mov endx, 300
    mov starty, 22
    mov endy, 180
    call draw
    
	;---left--- 
    mov startx,22                       
    mov endx,23
    mov starty,22
    mov endy,180
    call draw
 
	;---bottom---
    mov startx, 22                      
    mov endx, 300
    mov starty,179
    mov endy,180
    call draw 
   
    ret
drawBoundary endp

drawBorder proc
	;---draws pixels outside of the border---
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
	;---draws pixels inside the border---
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
     
	mov cx, startx                        ;starts drawing element from startx
    mov dx, starty                        ;starts drawing element from starty
    mov ah, 0Ch                           ;draw pixel instruction 
    mov al, color
	
    pixel:                              
		inc cx                            ;increments the x-loc of the element 
		int 10h                           ;draws the pixel 
		cmp cx, endx                      ;checks if the current x-loc value reaches the defined endx 
		jne pixel                         ;if not, loop pixel 

		mov cx, startx                    ;resets x-loc to the defined startx 
		inc dx                            ;sets the cursor to the next line/row 
		cmp dx, endy                      ;checks if the current y-loc value reaches the defined endy
		jne pixel                         ;if not, loop pixel
    
    pop dx
    pop cx
    pop ax
    ret
draw endp

sleep proc
	mov cx, 111111111111111b              ;sets counter for continuous loop

	l:
		loop l
		ret
sleep endp

beep proc
    push ax
    push bx
    push cx
    push dx
		
        mov al, 182                       ;sets al to 182
        out 43h, al                       ;sends the value of al to port 43h
        mov ax, 400                       ;sets ax to 400 
                                
        out 42h, al                       ;sends the lower bits of ax to port 42h 
        mov al, ah                        ;moves the higher bits to al
        out 42h, al                       ;sends the bits to port 42h 
        in al, 61h                        ;reads input from port 16 and stores it in al 
                                
        or al, 00000011b                  ;enables speaker output 
        out 61h, al                       ;sends the value of al to port 61h
        mov bx, 2                         ;sets loop ctr 
		
	.pause1:
        mov cx, 65535                     ;sets cx to the max number of a 16-bit register 
		
	.pause2:
        dec cx                            ;decrements cx 
        jne .pause2                       ;if cx!=0, kump to pause2 
        dec bx                            ;decrements bx 
        jne .pause1                       ;if bx!=0, jump to pause1 
        in al, 61h                        ;reads input from port 61h and stores it in al 
                                
        and al, 11111100b                 ;disables the speaker output 
        out 61h, al                       ;sends the value of al to port 61h

    pop dx
    pop cx
    pop bx
    pop ax

	ret
beep endp
end main
