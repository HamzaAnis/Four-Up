title i140535
;include \test.inc
.model small
.stack 200h

; a struct to save the axis when printing the numbers
axis struct
placed db 0
filled dw 6 ; to move downward
x_axis db 6 dup(0)
y_axis db 6 dup(0)
axis ends



.data

remove db '0'
RollNo db "(i14-0535)",'$'
GameName db "CONNECT FOUR",'$'
msg db "Enter choice from 1 to 7  : ",'$'
Welcome db "Welcome to the NUCES Game of Aar ya Paar :D",'$'
warning db "                      ",1," Not valid number.Turn Lost! ",1,'$'
choiceMsg db "Enter your choice : ",'$'
Symblwrng db "Enter Valid Input   ",'$'
Multiplyermessage  db "Enter 1 to play with Computer",'$'
Multiplyermessage2 db "Enter 2 to play Multiplayer ",'$'
playerMode db 0  ;1 for the computer and 2 for the multiplayer
computerTurn db 0 ; to see when will be the omputer turn and he places the value

choiceMsg1 db "                      Enter 1 for X                        ",10,13,"                      Enter 2 for 0                         ",'$'
Rules db "Rules:",'$'
Rules1 db "Enter valid choice otherwise turn will be lost :D",'$'
startMessage db "Let the Game Begin in  ",'$'
winmsg1 db "Player 1 (Symbol=X)",'$'
winmsg2 db "Player 2 (Symbol=0)",'$'
drawMsg db "Draw! Start again(Y/N)?  ",'$'
turn db 1   ;a variable to get track of the turns
symbol db 0       ;to print on a turn
endGame dw 0     ;Will see when the game blocks are filled
row db 0
col dw 0
cor_r db 0
cor_c db 0
count_d db 0

;for checking the values thes are used
;;;;;
temp dw 0
height db 0
index1 dw 0
index2 dw 0
index3 dw 0
index4 dw 0
multiplicand db 0   
diagonal_left db 0
diagonal_right db 0
;for AI
indext1 dw 0
indext2 dw 0
indext3 dw 0
indext4 dw 0
toCompareIndex dw 0
toCompareValue db 0
tackleFlag db 0
;;;;
Axisx db 0
Axisy db 0

col_choice db 0  ;column number where to place the character
msg2 db 0f4h," Player 2 Score ",0f5h,'$'
msg3 db 0f4h," Player 1 Score ",0f5h,'$'
singlePlayer db 243,"SINGLEPLAYER",242,'$'
doublePlayr db 243,"Against AI",242,'$'
msg4 db "                   	 Player 1's TURN (Symbol = ",'$'
msg5 db "                   	 Player 2's TURN (Symbol = ",'$'
msg6 db "ScoreBoard",'$'
msg7 db "Base   ",'$'
msg8 db "Row    ",'$'
msg9 db "Total  ",'$'
flag db 0
rowOccured db 0 ; a flag to check which is occured vertical ,horizontal or diagonal

xAxis dw 100
yAxis dw 100

player1Score dw 0   ;when a row  occured this is updated
player2Score dw 0
totalScore dw 10000  ;from whic the score will be deducted
EarnedScore dw 0     ;Total score - the score earned by the opposite player which is deduced in WInCondition
				 
				 
grid db "+---+---+---+---+---+---+---+",10,13,
        "|   |   |   |   |   |   |   |",10,13,
        "+---+---+---+---+---+---+---+",10,13,
		"|   |   |   |   |   |   |   |",10,13,
		"+---+---+---+---+---+---+---+",10,13,
		"|   |   |   |   |   |   |   |",10,13,
		"+---+---+---+---+---+---+---+",10,13,
		"|   |   |   |   |   |   |   |",10,13,'$'	
grd2 db "+---+---+---+---+---+---+---+",10,13,
        "|   |   |   |   |   |   |   |",10,13,
		"+---+---+---+---+---+---+---+",10,13, 
		"|   |   |   |   |   |   |   |",10,13,
        "+---+---+---+---+---+---+---+",10,13,'$'
		
		
		peace db    " 	  ",10,13,
					" 	|  |   /  / ",10,13,
					" 	|  |  /  /",10,13,
					" 	|  | /  /",10,13,
					" 	|  |/  ;-._",10,13,
					" 	}  ` _/  / ;",10,13,
					" 	|  /` ) /  /",10,13,
					" 	| /  /_/\_/\",10,13,
					" 	|/  /      |",10,13,
					" 	(  ' \ '-  |",10,13,
					" 	 \    `.  /",10,13,
					"  	 |      |",10,13,
					"  	 |      |",'$'
ENDL DB 10,13,'$'		
extra dw 0  ;used when reching to the index
iterator db 0  ; iterator for loop
coordinates axis 7 dup(< >)    ;A struct initialization to store coord to print number
placed db 6 dup(7 dup (0))  ;An array to etect that value is replaced which is further decided to compute computer decision
values db 6 dup(7 dup ('$'))
verticalTrack db 6 dup(7 dup ('0'))
horizontalTrack db 6 dup(7 dup ('0'))
diagonal1Track db 6 dup(7 dup ('0'))   ;3 arrays to track that score is calculated there yet
diagonal2Track db 6 dup(7 dup ('0'))






.code
mov ax,@data
mov ds,ax



;||||||||||||||||||||||||||||||||||||||||||||||||||Main Proc ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
main proc 


	;printing menu for the user 
	call Menu
	
	;For Background
	call printGrid
	
	call asgn_Coor
    ;CALL Display_Asgn_Coor


	; row is increased 2 times  column is increased 4 times.  (1,2)=>(3,6)
	Input:
	   
	   ;where user is inputtting columns and it further call other procedures
	   call Game
	   ;score of the players
	   call Score
	   
	   cmp endGame,42  ;when one value is filled it increments
	   jb Input
	   
	   ;Check To handle whether the box os filled
	   cmp endGame,42
	   je PlayAgain
	    
	
 
 ;when all function done return control to the console
jmp endprog
 
main endp
;||||||||||||||||||||||||||||||||||||||||END OF MAIN|||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||















;||||||||||||||||||||||||||||||||||||||||Background|||||||||||||||||||||||||||||||||||||||||||||||||||||||||

printGrid proc   ; a and b in this case are strings which is passed from the main

	;setting video mode
	mov ah,0h
	mov al,12h
	int 10h
 
    ;clearing the screen
    mov ah,0h
	mov al,3h
    int 10h

	;disable blinking
	mov ax,1003h
	mov bx,0
	int 10h

	;settig the background colour
	mov ah,06h
	mov al,0
	mov ch,0   ;upper coordinates
	mov cl,0
	mov dh,18h ;lower coordinates   ;cx=0000h  and dx=184f
	mov dl,4fh
	mov bh,0F5h
	int 10h
	
	
	
	;GameBoard Background
	mov ah,06h
	mov al,0
	mov ch,0
	mov cl,0
	mov dh,13
	mov dl,28
	mov bh,0F0h ;3 foreground F for white text
	int 10h
	
	
	
	;LowerBoard Background
	mov ah,06h
	mov al,0
	mov ch,15
	mov cl,20
	mov dh,20
	mov dl,56
	mov bh,070h ;0 for black 
	int 10h
	
	;boundaries
	mov ah,06h
	mov al,0
	mov ch,15
	mov cl,20
	mov dh,20
	mov dl,21
	mov bh,0A0h
	int 10h
	
	mov ah,06h
	mov al,0
	mov ch,15
	mov cl,55
	mov dh,20
	mov dl,56
	mov bh,0A0h
	int 10h
	
	

	;printing the grid string
	mov ah,09h
	lea dx,grid
	int 21h

	;as the grid was large so devided in to two
	mov ah,09h
	lea dx,grd2
	int 21h
	
	
	;=========Printing the numbers at the end of the screen
	    ;spaces for identations
		mov ah,02h
		mov dl,' '
		int 21h
		
		mov ah,02h
		mov dl,' '
		int 21h
	
		mov bl,49   ;bl=1
		mov cx,7
		Number:
			mov ah,02h
			mov dl,bl
			int 21h
			
			mov ah,02h
			mov dl,' '
			int 21h
			
			mov ah,02h
			mov dl,' '
			int 21h
			
			mov ah,02h
			mov dl,' '
			int 21h
			
			inc bl
		loop Number
		
		;pritning roll no
	mov ah,02h
	mov bh,0
	mov dh,24
	mov dl,68
	int 10h
	
	mov ah,09h
	lea dx,RollNo
	int 21h
	
	;Prinitn mode
	mov ah,02h
	mov bh,0
	mov dh,24
	mov dl,30
	int 10h
	
	cmp playerMode,1
	jne A
		mov ah,09h
		lea dx,doublePlayr
		int 21h
		jmp skipit
	
	A:
	mov ah,09h
	lea dx,singlePlayer
	int 21h
		
	;=====================================================================

	skipit:
	ret
printGrid endp
;||||||||||||||||||||||||||||||||||||||||Background Ends|||||||||||||||||||||||||||||||||||||||||||||||||||||||||




;||||||||||||||||||||||||||||||||||||||||START OF Menu|||||||||||||||||||||||||||||||||||||||||||||||||||||||||
Menu proc
	
	mov ah,0h
	mov al,12h
	int 10h
	
	;clearing the screen 
	mov ah,0h
	mov al,3h
	int 10h
	
	;disable blinking
	mov ax,1003h
	mov bx,0
	int 10h

	;background
	mov ah,06h
	mov al,0
	mov ch,0
	mov cl,0
	mov dh,18h
	mov dl,4fh
	mov bh,08Eh ;White colour (F) for text and 'C' colour for backgrounf  
	int 10h
	
	;connect four background
	mov ah,06h
	mov al,0
	mov ch,0
	mov cl,33
	mov dh,1
	mov dl,44
	mov bh,09Eh 
	int 10h
	
	
	
	;printing CONNET FOUR
	mov ah,02h
	mov bh,0
	mov dh,1
	mov dl,33
	int 10h
	
	mov ah,09h
	lea dx,GameName
	int 21h
	
	
	
	;setting cursor position
	mov ah,02h
	mov bh,0
	mov dh,3
	mov dl,20
	int 10h
	

	mov ah,09h
	lea dx,welcome
	int 21h
	
	
	;rules background 
	mov ah,06h
	mov al,0
	mov ch,21
	mov cl,17
	mov dh,22
	mov dl,65
	mov bh,09Eh ;White colour (F) for text and 'C' colour for backgrounf  
	int 10h
	
	;ptint rules message 
	mov ah,02h
	mov bh,0
	mov dh,20
	mov dl,38
	int 10h
	

	mov ah,09h
	lea dx,Rules
	int 21h

	mov ah,02h
	mov bh,0
	mov dh,21
	mov dl,17
	int 10h
	

	mov ah,09h
	lea dx,Rules1
	int 21h
	
	;Boundaries
	mov ah,06h
	mov al,0
	mov ch,0
	mov cl,0
	mov dh,30
	mov dl,1
	mov bh,07Eh ;7 grey foreground F for white text
	int 10h
	
	mov ah,06h
	mov al,0
	mov ch,0
	mov cl,78
	mov dh,30
	mov dl,79
	mov bh,07Eh ;7 grey foreground F for white text
	int 10h
	


	;setting Multiplayer message position
	mov ah,02h
	mov bh,0
	mov dh,6
	mov dl,15
	int 10h
	
	mov ah,09h
	lea dx,Multiplyermessage
	int 21h
	
	mov ah,02h
	mov bh,0
	mov dh,7
	mov dl,15
	int 10h
	
	mov ah,09h
	lea dx,Multiplyermessage2
	int 21h
	
	
					
				EnterV:
				;Input but first setting position
				mov ah,02h
				mov bh,0
				mov dh,9
				mov dl,20
				int 10h
				
				mov ah,09h
				lea dx,choiceMsg
				int 21h
					
				mov ah,01h
				int 21h
				sub al,48
				
				;as the input should be 1 and 0 so seting check here
				cmp al,1
				je CorrectInput

				cmp al,2
				je CorrectInput	

				;setting postion for warnign message
				mov ah,02h
				mov bh,0
				mov dh,9
				mov dl,20
				int 10h
				
				
				mov ah,09h
				lea dx,Symblwrng
				int 21h
				  ;delay to show warning message
					
					call Sound
					call delay
					call delay
					call delay
					call delay
					call delay
					call Sound
				
				
				
				
				jmp  EnterV1
			
			CorrectInput:
				mov playerMode,al
	
	;setting cursor position
	mov ah,02h
	mov bh,0
	mov dh,6
	mov dl,0
	int 10h

	
	mov ah,09h
	lea dx,choiceMsg1
	int 21h	
	
	EnterV1:
		;Input but first setting position
		mov ah,02h
		mov bh,0
		mov dh,9
		mov dl,20
		int 10h
		
		mov ah,09h
		lea dx,choiceMsg
		int 21h
		
		;to replace the previous input
		mov ah,02h
		mov dl,' '
		int 21h
			
		mov ah,01h
		int 21h
		sub al,48
		
		;as the input should be 1 and 0 so seting check here
		cmp al,1
		je CorrectInput1

		cmp al,2
		je CorrectInput1	

		;setting postion for warnign message
		mov ah,02h
		mov bh,0
		mov dh,9
		mov dl,20
		int 10h
		
		
		mov ah,09h
		lea dx,Symblwrng
		int 21h
		  ;delay to show warning message
		  	call Sound
			call delay
			call delay
			call delay
			call delay
			call delay
			call Sound

		
		
		
		jmp  EnterV1
	
	CorrectInput1:
	
		
		cmp al,1
		je X
	
		mov turn,2
		mov computerTurn,1
		jmp res
	
	;a useto label
	X: 
		mov turn,1
		mov computerTurn,2
	
	;resume for here
	res:
	
		mov ah,09h
		lea dx,peace
		int 21h
		
		;count_d here is display the message  for 5 seconds
		mov count_d,5
		mov Axisy,34
	CountDown:
	;setting cursor position
		mov ah,02h
		mov bh,0
		mov dh,11
		mov dl,30
		int 10h
		
		mov ah,09h
		lea dx,startMessage
		int 21h
		
		mov ah,02h
		mov dl,count_d
		add dx,48
		int 21h
		
		
				call delay
				call delay
				call delay
				call delay
				call delay
				call delay
				
				
					mov ah,06h
					mov al,0
					mov ch,14
					mov cl,24
					mov dh,14
					mov dl,Axisy
					mov bh,0FAh ;7 grey foreground F for white text
					int 10h
				
					add Axisy,10
				
				;to display
				mov bx,100
				outer:	
					mov ah,0ch
					mov al,5
					mov bh,0
					mov cx,xAxis
					mov dx,yAxis
					int 10h
					
					inc xAxis
					inc yAxis
					dec bx
					cmp bx,0
					ja outer
					
					
		dec count_d
		cmp count_d,0
		ja CountDown
		
		
		

ret
Menu endp


;||||||||||||||||||||||||||||||||||||||||START OF Menu|||||||||||||||||||||||||||||||||||||||||||||||||||||||||


;||||||||||||||||||||||||||||||||||||||||START OF PROCS|||||||||||||||||||||||||||||||||||||||||||||||||||||||||

Game proc

	;setting cursor position
	mov ah,02h
	mov bh,0
	mov dh,16
	mov dl,0
	int 10h

	cmp turn,2  ;see which plyer has turn 
	je Player1
	
	Player2:

		mov ah,09h
		lea dx,msg4
		int 21h
		
		;assigning symbol to user 1 which further prints
		mov symbol,'X'
		
		
		mov turn, 2	   ;one the turn is done give the turn to player1
		
		jmp resume
		
	Player1:	
		
		mov ah,09h
		lea dx,msg5
		int 21h
		
		
		;assigning symbol to user 1 which further prints
		mov symbol,'O'
		
		
		mov turn,1  ;giving turn next time to 1
		
	
	resume:
		
		mov ah,02h
		mov dl,symbol
		int 21h               ;prints "symbol)"
		
		mov ah,02h
		mov dl,')'
		int 21h
		
		mov ah,02h
		mov bh,0
		mov dh,18
		mov dl,24
		int 10h
		
		mov ah,09h
		lea dx,msg   ;msg = Enter number from 1-7
		int 21h
		
		
		;*****************************************
		;check if the mode is computer or multiplayer
		cmp  playerMode,1
		jne User
		;here detecting that when there's computer turn
		mov al,computerTurn
		cmp al,turn
		jne computerDecision  
		
		;********************************************
		User:
			;here is all the user ener his choice
			mov ah,01h
			int 21h
			sub al,48
			mov col_choice,al
			dec col_choice  ; as index start from 0 and i am taking 1 so decrementing
			
			cmp col_choice,7
			jb columnFillCheck   ;if the user enter the number which is not in the range print the user a warning message and lost his turn
			jmp lostTurMessage  ;as the value will be greater si no need to check the strucutre so diplaying message and losting his turn
			
					columnFillCheck:
						;now checking that the user entered column is filled or not
						;as the values are in struct . here making sure that computer select that column which is not filled
						mov ah,0
						mov al,col_choice
						mov bl,type coordinates
						mul bl

						mov si,ax

						
						mov bx,coordinates[si].filled
						
						cmp bx,0
						jna lostTurMessage ;if the column is filled so displaying warning  message and losting turn
						
						jmp valid     ; player column is valid 
				
				
			lostTurMessage:	
				;setting cursor position
				mov ah,02h
				mov bh,0
				mov dh,16
				mov dl,0
				int 10h
				
				mov ah,09h
				lea dx,warning
				int 21h
				
				
	
				;to display the message for some time
				call Sound
				call delay
				call delay
				call delay
				call delay
				call Sound
				call delay
				call delay
				call delay
				call delay
				call Sound
				
				
				
				jmp resume1   ;as the user enterd value greate than 7 so not callling the game proc
				
				computerDecision:
					call computerMove
					
					
					;here just making sure that the computer selected the tright column 
					
			cmp col_choice,7
			jb columnFillCheck1  ;if the user enter the number which is not in the range print the user a warning message and lost his turn
			jmp lostTurMessage1 ;as the value will be greater si no need to check the strucutre so diplaying message and losting his turn
			
					columnFillCheck1:
						;now checking that the user entered column is filled or not
						;as the values are in struct . here making sure that computer select that column which is not filled
						mov ah,0
						mov al,col_choice
						mov bl,type coordinates
						mul bl

						mov si,ax

						
						mov bx,coordinates[si].filled
						
						cmp bx,0
						jna lostTurMessage1 ;if the column is filled so displaying warning  message and losting turn
						
						jmp valid     ; player column is valid 
				
				
			lostTurMessage1:	
				;setting cursor position
				mov ah,02h
				mov bh,0
				mov dh,16
				mov dl,0
				int 10h
				
				mov ah,09h
				lea dx,warning
				int 21h
				
				;to display the message for some time
				call delay
				call delay
				call delay
				call delay
				call delay
				call delay
				call delay
				call delay
				
				
				jmp resume1   ;as the user enterd value greate than 7 so not callling the game proc
				
				valid:	
					
						
					call Move
			
					
			
			resume1:
				ret
Game endp

;||||||||||||||||||||||||||||||||||||||||Game proc ends|||||||||||||||||||||||||||||||||||||||||||||||||||||||||



;||||||||||||||||||||||||||||||||||||||||Moving|||||||||||||||||||||||||||||||||||||||||||||||||||||||||

Move proc

;doing all of this to  move to th strcutre index
	mov ah,0
	mov al,col_choice
	mov bl,type coordinates
	mul bl

	mov si,ax

	;mov  si,0

	mov bx,coordinates[si].filled
	mov col,bx

	mov bp,0

;mov ah,02h
;mov dl,coordinates[si].x_axis[bp]
;add dl,48
;int 21h

	call Sound
	cmp col,0
	ja L4
	jmp DontMOve
	L4:
			mov ah,02h
			mov dh,coordinates[si].x_axis[bp]
			mov dl,coordinates[si].y_axis[bp]
			int 10h
			
			;priting symbols
			mov ah,02h
			mov dl,symbol
			int 21h
			
							;i delay called here
						    call delay
							;call delay
			
			
			;again setting position
			mov ah,02h
			mov dh,coordinates[si].x_axis[bp]
			mov dl,coordinates[si].y_axis[bp]
			int 10h
			
			cmp col,1
			ja A3
			jmp A4
			
			
			
			A3:	
				mov ah,02h    ; as th value is entered so to create visulaztion delting it as space is entered
				mov dl,' '
				int 21h
				
			A4:
		
				inc bp	
				dec col
				cmp col,0
				ja L4
				
				;After moving on the display assigning value in the othe array background to check the conditions
				mov bx,coordinates[si].filled
				mov col,bx                       ;memory to memory not possible
				dec col
				
				
				mov bx,offset values      ;values is an array 
				
				
				mov ax,col                 ;rows filled in the selected column
				mov row,7					;row*7
				mul row   ; as the array is of 6X7 index
				
				 
				add bx,ax  ; as the multipliand in is ax
				
				mov ch,0       ;no value sholuld be in ch 
				mov cl,symbol   ;till her cx has symbol
				
				
				mov ah,0
				mov al,col_choice
				mov extra,ax 
				
				
				push si  ;backing up
				
				mov si,extra
				
				
				;bx(rowfilled*7)+extra(col_choice)
				;bx has offset of values
				mov [bx+si],cl ;cl has symbol
				
				;***********************************placed array
							mov bx,offset placed
							mov ax,col                 ;rows filled in the selected column
							mov row,7					;row*7
							mul row   ; as the array is of 6X7 index
							
							 
							add bx,ax  ; as the multipliand in is ax
				
						
							
							mov ah,0
							mov al,col_choice
							mov extra,ax 
									
							mov si,extra
							mov al,1
							mov [bx+si],al   ;An array to detect that value is replaced which is further decided to compute computer decision
								
							
				;***********************************placed array
				pop si
				
				call Checks
					
					; all done to decrement in a struct value (filled)
				mov cx,coordinates[si].filled
				mov extra,cx
				dec extra
				mov bx,extra
				mov coordinates[si].filled,bx  ; as 1 value is filled so dec
				
				inc endGame ; as 1 block is filled so increment when 42 then all will be filled and and game will be draw
			
			DontMOve:

			
			;call Displayrray
			
	ret
Move endp

;||||||||||||||||||||||||||||||||||||||||Moving |||||||||||||||||||||||||||||||||||||||||||||||||||||||||



;||||||||||||||||||||||||||||||||||||||||Start OF Score|||||||||||||||||||||||||||||||||||||||||||||||||||||||||
Score proc

	;ScoreBoard Background
	mov ah,06h
	mov al,0
	mov ch,1
	mov cl,32
	mov dh,10
	mov dl,75
	mov bh,09Eh ;7 grey foreground F for white text
	int 10h
	
	;left boundery
	mov ah,06h
	mov al,0
	mov ch,1
	mov cl,32
	mov dh,10
	mov dl,33
	mov bh,03Eh 
	int 10h
	
	;right boundRY
	mov ah,06h
	mov al,0
	mov ch,1
	mov cl,75
	mov dh,10
	mov dl,76
	mov bh,03Eh 
	int 10h
	
	;upper boundary
	mov ah,06h
	mov al,0
	mov ch,1
	mov cl,32
	mov dh,1
	mov dl,76
	mov bh,03Eh ;7 grey foreground F for white text
	int 10h
	
	;lower boundary
	mov ah,06h
	mov al,0
	mov ch,10
	mov cl,32
	mov dh,10
	mov dl,76
	mov bh,03Eh ;4 for red e is foreground
	int 10h
	
	;*******************************************************

	
	;print message ScoreBoard
	mov ah,02h
	mov bh,0      ;setting position to show score
	mov dh,3   ;row   
	mov dl,50   ;col
	int 10h
	
	mov ah,09h
	lea dx,msg6
	int 21h
	
	
	call ScorePlayr1
	call ScorePlayr2
	

ret
Score endp

;======================================================================================================================


ScorePlayr1 proc
	;player1 
	mov ah,02h
	mov bh,0      ;setting position to show score
	mov dh,4    ;row   
	mov dl,35   ;col
	int 10h

	mov ah,09h
	lea dx,msg2
	int 21h
	
	mov ah,02h
	mov bh,0
	mov dh,5
	mov dl,43
	int 10h
	
	mov ah,02h
	mov dl,'('
	int 21h
	mov ah,02h
	mov dl,'O'
	int 21h
	mov ah,02h
	mov dl,')'
	int 21h
	
	;printing Base
	mov ah,02h
	mov bh,0      ;setting position to show score
	mov dh,6   ;row   
	mov dl,39   ;col
	int 10h
	
	mov ah,09h
	lea dx,msg7
	int 21h
	
	mov ax,totalScore
	call doubledigit
	
	
	;printing space score

	mov ah,02h
	mov bh,0      ;setting position to show score
	mov dh,7  ;row   
	mov dl,39   ;col
	int 10h
	
	mov ah,09h
	lea dx,msg8
	int 21h
	
	mov ax,player1Score
	call doubledigit

	cmp turn,1
	jne skip
	cmp rowOccured,1
	jne skip
	add player1Score,100   ;adding 100 as one time th box is filled by player (But adding on turn)
	
	mov rowOccured,0      ;making sure that is not added to 2nd player as both calling at the same time
	skip:
		
		cmp flag,0
		je skip2
		
		mov ax,player2Score  ;criteria is like this subtrct the score earned by the other from total and you have
		mov bx,totalScore            ;earned that score
		sub bx,ax
		mov EarnedScore,bx
	skip2:

		;printing earned score
		mov ah,02h
		mov bh,0      ;setting position to show score
		mov dh,8  ;row   
		mov dl,39   ;col
		int 10h
		
		mov ah,09h
		lea dx,msg9
		int 21h
	
		mov ax,EarnedScore ;earned score has initially 0 it will compute when the 
		call doubledigit
		
		
	
		
	

ret
ScorePlayr1 endp
