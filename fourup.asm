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



;======================================================================================================================

ScorePlayr2 proc
	;printing player 2 
	mov ah,02h       ;setting position to show score
	mov bh,0
	mov dh,4    ;row
	mov dl,55   ;col
	int 10h

	mov ah,09h
	lea dx,msg3
	int 21h
	
	mov ah,02h
	mov bh,0
	mov dh,5
	mov dl,63
	int 10h
	
	mov ah,02h
	mov dl,'('
	int 21h
	mov ah,02h
	mov dl,'X'
	int 21h
	mov ah,02h
	mov dl,')'
	int 21h
	
	
	mov ah,02h
	mov bh,0
	mov dh,30
	mov dl,100
	int 10h
	
	mov ah,02h
	mov dl,'X'
	int 21h
	
	;it is to diplay the symbol to avoid confusion
	
	mov ah,02h
	mov bh,0      ;setting position to show score
	mov dh,5   ;row   
	mov dl,59  ;col
	int 10h
	
	
	
	;;;;;;;;;;printing  Base
	mov ah,02h
	mov bh,0      ;setting position to show score
	mov dh,6   ;row   
	mov dl,59  ;col
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
	mov dl,59   ;col
	int 10h
	
	mov ah,09h
	lea dx,msg8
	int 21h
	
	;displaying score
	mov ax,player2Score
	call doubledigit

	
	cmp turn,2
	jne skip3                 ;turn is equal to 2 and at his turn check is row is found then add score
	cmp rowOccured,1
	jne skip3
	add player2Score,100
	mov rowOccured,0      ;making sure that is not added to 2nd player as both calling at the same time
	
	skip3:
		
		cmp flag,0
		je skip4
		
		mov ax,player1Score  ;criteria is like this subtrct the score earned by the other from total and you have
		mov bx,totalScore            ;earned that score
		sub bx,ax
		mov EarnedScore,bx
	skip4:

		;printing earned score
		mov ah,02h
		mov bh,0      ;setting position to show score
		mov dh,8  ;row   
		mov dl,59   ;col
		int 10h
		
		mov ah,09h
		lea dx,msg9
		int 21h
	
		mov ax,EarnedScore
		call doubledigit

ret
ScorePlayr2 endp

;||||||||||||||||||||||||||||||||||||||||END OF Score|||||||||||||||||||||||||||||||||||||||||||||||||||||||||


;||||||||||||||||||||||||||||||||||||||||Start OF Assigning|||||||||||||||||||||||||||||||||||||||||||||||||||||||||


asgn_Coor proc
;this pro is used to define the coordinates wehre to fill the values
;start (1,2),(1,6)
;next  (3,2),(3,6)
;filling values column wise
mov cx,7
mov cor_c,2
mov si,0
L3:
	mov col,0
	mov cor_r,1
		L2:
		
		
			mov bp,col
			mov al,cor_r
			mov coordinates[si].x_axis[bp],al
			mov al,cor_c
			mov coordinates[si].y_axis[bp],al
											
			
			add cor_r,2 ; increasing row value to 2
			inc col
			cmp col,6
			jb L2
			
			
			add cor_c,4   ;setting coordinated col are increasing 4 time
			
			add si,type coordinates ;to move to the next srtruct
			
			
		loop L3
	
    ret
asgn_Coor endp

;||||||||||||||||||||||||||||||||||||||||End OF Assigning_|||||||||||||||||||||||||||||||||||||||||||||||||||||||||








;=====================================Check Proc==================================================
checks proc 

			call Horizontal_check
			call Vertical_check
			call Diagonal_Check
			
			ret
checks endp

;=====================================End Check Proc==============================================


;||||||||||||||||||||||||||||||||||||||||Horizontal Checks |||||||||||||||||||||||||||||||||||||||||||||||||||||||||

Horizontal_check proc
	push si
	
	mov row,0
	mov col,0 
	mov index1,0
	
	outer:
		mov col,0
		inner:
		
			mov ah,0
			mov al,7
			
			mul row

			mov bh,0
			mov bl,al
			
			add bx,col   ;index=7*row+col
			
			
			;taking 4 indexes to compare
			mov index1,bx
			
			inc bx
			mov index2,bx
			
			inc bx
			mov index3,bx
			
			inc bx
			mov index4,bx
			
			
		
				call CheckFour
				
				cmp rowOccured,1
				jne HorizontalRowNotFound
				
				mov si,index1
			
				;if score is not calculated there beore yet then add the score other wise
				cmp horizontalTrack[si],'0'
				jne alreadyCalcultedScore
				
				call Score
				mov horizontalTrack[si],1
				
				alreadyCalcultedScore:
				
				
				
				;if not found then it wil miss this calls
				call HandleWin
				
				HorizontalRowNotFound:
					mov rowOccured,0
				
				
				
			
			
			
		
		
			inc col
			cmp col,4   ;Column-3
 			jb inner
		
		inc row
		cmp row,6
		jb outer
	
	
	
	pop si
	
	
	
ret
Horizontal_check endp


;------------------------------------------------------------------------------------------------------------------------------

Vertical_check proc
	push si
	
	mov row,0
	mov col,0 
	mov index1,0
	mov height,7
	
	outer:
		mov col,0
		inner:
		
			mov ah,0
			mov al,7
			
			mul row

			mov bh,0
			mov bl,al
			
			add bx,col   ;index=7*row+col ;bx has index numbers
			
			
			;taking 4 indexes to compare
			mov index1,bx
			mov index2,bx
			mov index3,bx
			mov index4,bx
			
			mov ah,0
			mov al,height
			add index2,ax
			
			mov ah,0
			mov al,height
			mov multiplicand,2
			mul multiplicand
			add index3,ax
			
			mov ah,0
			mov al,height
			mov multiplicand,3
			mul multiplicand
			add index4,ax
			
			
			
		
			
			call CheckFour
			
			cmp rowOccured,1
				jne VerticalRowNotFound
				
				mov si,index1
				;if score is not calculated there beore yet then add the score other wise
				cmp verticalTrack[si],'0'
				jne alreadyCalcultedScoreVer
				
				call Score
				mov verticalTrack[si],1
				
				alreadyCalcultedScoreVer:
				
				;if not found then it wil miss this calls
				call HandleWin
				
				VerticalRowNotFound:
					mov rowOccured,0
			
			
			
			
			
		
		
			inc col
			cmp col,7  
 			jb inner
		
		inc row
		cmp row,3  ;row-3
		jb outer
	
	
	
	pop si
	
	
	
ret
Vertical_check endp

;------------------------------------------------------------------------------------------------------------------------------

Diagonal_Check proc
	push si
	
 	mov row,0
	mov col,0 
	mov index1,0
	mov diagonal_left,8
	mov diagonal_right,6
	mov count_d,0
	
	outer:
		mov col,0
		inner:
		
			mov ah,0
			mov al,7
			
			mul row

			mov bh,0
			mov bl,al
			
			add bx,col   ;index=7*row+col ;bx has index numbers
			
			
			;;diagonal left check
			cmp count_d,3
			jbe D1
			jmp D2
			
			D1:
				;taking 4 indexes to compare
				mov index1,bx
				mov index2,bx
				mov index3,bx
				mov index4,bx
				
				mov ah,0
				mov al,diagonal_left
				add index2,ax
				
				mov ah,0
				mov al,diagonal_left
				mov multiplicand,2
				mul multiplicand
				add index3,ax
				
				mov ah,0
				mov al,diagonal_left
				mov multiplicand,3
				mul multiplicand
				add index4,ax
				
				
				
						call CheckFour
					
						cmp rowOccured,1
						jne Diagonal1NotFound
						mov si,index1
			
						;if score is not calculated there beore yet then add the score other wise
						cmp diagonal1Track[si],'0'
						jne alreadyCalcultedScoreDiag1
						
						call Score
						mov diagonal1Track[si],1
						
						alreadyCalcultedScoreDiag1:
				
						;if not found then it wil miss this calls
						call HandleWin
						
						Diagonal1NotFound:
							mov rowOccured,0
						
				;*************************************
					
				
			D2:
			
				cmp count_d,3
				jae D3
				jmp D4
				
				D3:
					;taking 4 indexes to compare
					mov index1,bx
					mov index2,bx
					mov index3,bx
					mov index4,bx
					
					mov ah,0
					mov al,diagonal_right
					add index2,ax
					
					mov ah,0
					mov al,diagonal_right
					mov multiplicand,2
					mul multiplicand
					add index3,ax
					
					mov ah,0
					mov al,diagonal_right
					mov multiplicand,3
					mul multiplicand
					add index4,ax
					
							
						call CheckFour
					
						cmp rowOccured,1
						jne Diagonal2NotFound
						
							mov si,index1
			
							;if score is not calculated there beore yet then add the score other wise
							cmp diagonal2Track[si],'0'
							jne alreadyCalcultedScoreDiag2
							
							call Score
							mov diagonal2Track[si],1
							
							alreadyCalcultedScoreDiag2:
							
						;if not found then it wil miss this calls
						call HandleWin
						
						Diagonal2NotFound:
							mov rowOccured,0
					
				
				
				
			
			D4:
				inc count_d
				inc col
				cmp col,7  
				jb inner
		
		
		mov count_d,0
		inc row
		cmp row,3  ;row-3
		jb outer

	
	pop si
	
	
	
ret
Diagonal_Check endp

;------------------------------------------------------------------------------------------------------------------------------
;============================================================================
CheckFour proc
;return 1==2&&2==3&&3==4

	mov bx,offset values
	
	mov si,index1
	mov di,index2
	
	mov al,[bx+si]
	cmp [bx+di],al
	
	je Check2
	
	jmp NotFound
	
	Check2:
		mov si,index2
		mov di,index3
		
		mov al,[bx+si]
		cmp [bx+di],al
		
		je Check3
		jmp NotFound
	
	Check3:
		mov si,index3
		mov di,index4
		
		mov al,[bx+si]
		cmp [bx+di],al
		je Check4
		
		jmp NotFound
		
	Check4:
		mov si,index1
		mov al,'$'
		cmp [bx+si],al
		jne Found
		
		jmp NotFound
		
		
	Found:
		;jmp HandleWin
		mov rowOccured,1 ; as it is true so making
	
	NotFound:
	
	
		


ret
CheckFour endp


;-------------------------------------------------------------------------------------

;============================================Check4=================================

;||||||||||||||||||||||||||||||||||||||||computerDecision|||||||||||||||||||||||||||||||||||||||||||||||||||||||||
computerMove proc
push si

mov tackleFlag,0
call delay
call Vertical_checkCmptr
call Horizontal_checkCmptr
pop si
ret
computerMove endp



;||||||||||||||||||||||||||||||||||||||||computerDecision|||||||||||||||||||||||||||||||||||||||||||||||||||||||||


;||||||||||||||||||||||||||||||||||||||||Horizontal Checks |||||||||||||||||||||||||||||||||||||||||||||||||||||||||

Horizontal_checkCmptr proc
	push si
	
	mov row,0
	mov col,0 
	mov index1,0
	
	outer1:
		mov col,0
		inner1:
			mov ah,0
			mov al,7
			
			mul row

			mov bh,0
			mov bl,al
			
			add bx,col   ;index=7*row+col
			
			
			;taking 4 indexes to compare
			mov index1,bx
			
			inc bx
			mov index2,bx
			
			inc bx
			mov index3,bx
			
			inc bx
			mov index4,bx
			
			
		
				call decideComputerColumn
			
		
			inc col
			cmp col,4   ;Column-3
 			jb inner1
		
		inc row
		cmp row,6
		jb outer1
	
	
	
	pop si
	
	
	
ret
Horizontal_checkCmptr endp
;===============================================================================================================


Vertical_checkCmptr proc
	push si
	
	mov row,0
	mov col,0 
	mov index1,0
	mov height,7
	
	outer1:
		mov col,0
		inner1:
		
			mov ah,0
			mov al,7
			
			mul row

			mov bh,0
			mov bl,al
			
			add bx,col   ;index=7*row+col ;bx has index numbers
			
			
			;taking 4 indexes to compare
			mov index1,bx
			mov index2,bx
			mov index3,bx
			mov index4,bx
			
			mov ah,0
			mov al,height
			add index2,ax
			
			mov ah,0
			mov al,height
			mov multiplicand,2
			mul multiplicand
			add index3,ax
			
			mov ah,0
			mov al,height
			mov multiplicand,3
			mul multiplicand
			add index4,ax
			
			
			
		
			
			call decideComputerColumn
			
			
			
		
		
			inc col
			cmp col,7  
 			jb inner1
		
		inc row
		cmp row,3  ;row-3
		jb outer1
	
	
	
	pop si
	
	
	
ret
Vertical_checkCmptr endp

;------------------------------------------------------------------------------------------------------------------------------

decideComputerColumn proc
	push si
	
	cmp tackleFlag,1
	je skipRandom
		
		mov ax,index1
		mov indext1,ax
		mov ax,index2
		mov indext2,ax
		mov ax,index3
		mov indext3,ax
		mov ax,index4
		mov indext4,ax
		
		cmp turn,1
		jne ValueMoveLabel
			mov toCompareValue,'0'  ;mov turn 2 symbol as it was changerd before
		ValueMoveLabel:
			mov toCompareValue,'X'  ;turn 1 symbol=X to compare with
		

		
		mov iterator,0 ;iterator
		Deciding:
			cmp iterator,0
			jne R2
			mov ax,indext1
			mov toCompareIndex,ax
			jmp callingCheck
			R2:
				cmp iterator,1
				jne R3
				mov ax,indext2
				mov toCompareIndex,ax
				jmp callingCheck
				R3:
					cmp iterator,2
					jne R4
					mov ax,indext3
					mov toCompareIndex,ax
					jmp callingCheck
					R4:
						mov ax,indext4
						mov toCompareIndex,ax
						
						callingCheck:
						;	call CheckFourComputerColumn
						
		inc iterator
		cmp iterator,4
		jb Deciding
						

	cmp tackleFlag,1
	je skipRandom
		

	toBeInrange:		
			mov ah,2ch
			int 21h
			mov ah,0
			mov al,dl
			mov bl,7
			div bl
			mov col_choice,ah
			;as the values are in struct . here making sure that computer select that column which is not filled
			mov ah,0
			mov al,col_choice
			mov bl,type coordinates
			mul bl

			mov si,ax

			
			mov bx,coordinates[si].filled
			
			cmp bx,0
			jna toBeInrange
			
	
	skipRandom:
	
	pop si
ret
decideComputerColumn endp

;||||||||||||||||||||||||||||||||||||||||End of Checks|||||||||||||||||||||||||||||||||||||||||||||||||||||||||

CheckFourComputerColumn proc
push si

cmp tackleFlag,1
je NotFound_1

	;mov bx,offset values
	
	mov si,indext1
	mov di,indext2
	
	cmp si,toCompareIndex
	jne skipIndex1
	mov al,toCompareValue
	jmp Res1
	
	
	skipIndex1:
		mov al,values[si]
		Res1:
			cmp di,toCompareIndex
			jne skipIndex2
			
			cmp toCompareValue,al
			je Check2_1
			jmp NotFound_1
			
			skipIndex2:
				cmp values[di],al
				je Check2_1			
				jmp NotFound_1
	
	Check2_1:
		mov si,indext2
		mov di,indext3
		
		cmp si,toCompareIndex
		jne skipIndex3
		mov al,toCompareValue
		jmp Res2
		
		
		skipIndex3:
			mov al,values[si]
			Res2:
				cmp di,toCompareIndex
				jne skipIndex4
				
				cmp toCompareValue,al
				je Check3_1
				jmp NotFound_1
				
				skipIndex4:
					cmp values[di],al
					je Check3_1			
					jmp NotFound_1	
	Check3_1:
		mov si,indext3
		mov di,indext4
		
		cmp si,toCompareIndex
		jne skipIndex5
		mov al,toCompareValue
		jmp Res3
		
		
		skipIndex5:
			mov al,values[si]
			Res3:
				cmp di,toCompareIndex
				jne skipIndex6
				
				cmp toCompareValue,al
				je Check4_1
				jmp NotFound_1
				
				skipIndex6:
					cmp values[di],al
					je Check4_1			
					jmp NotFound_1
		
	Check4_1:
		mov si,toCompareIndex
		mov al,1
		cmp placed[si],al
		jne Found_1
		
		jmp NotFound_1
		
		
	Found_1:
		mov ax,toCompareIndex
		mov bl,7
		div bl
		
		mov col_choice,ah
		mov tackleFlag,1 ; as it is true so making
		

	
	NotFound_1:
 




pop si
ret
CheckFourComputerColumn endp

;||||||||||||||||||||||||||||||||||||||||Handles|||||||||||||||||||||||||||||||||||||||||||||||||||||||||

HandleWin proc
	
	cmp endGame,41 
	jne terminate  ;mis them
	mov flag,1 ; a flag to calculate the final score

		mov ah,02h
		mov bh,0
		mov dh,20
		mov dl,27
		int 10h
		
		cmp turn,1
		je Player2
		jmp Player1
	
	Player1:
		mov ah,09h
		lea dx,winmsg1
		int 21h
		
		call ScorePlayr1  ;from here the score of player 1 which is winner will be calculated
		
	jmp terminate
	
	Player2:
		mov ah,09h
		lea dx,winmsg2
		int 21h
	
		call ScorePlayr2  ;from here the score of player 2 which is winner will be calculated

	terminate:
		;jmp endprog
ret
HandleWin endp

;------------------------------------------------------------------------------------------------------------------------------
PlayAgain proc
	mov endGame,0
	
	mov ah,02h
	mov bh,0
	mov dh,20
	mov dl,27
	int 10h
	
	mov ah,09h
	lea dx,drawMsg
	int 21h
	
	mov ah,01h
	int 21h

	cmp al,'Y'
	je wantToPlayAgain
	
	jmp endprog  ;user don't want toplay again so jump to return control
	
	wantToPlayAgain:
		call main
	
	
ret
PlayAgain endp


;||||||||||||||||||||||||||||||||||||||||Handles(WIn,Draw)|||||||||||||||||||||||||||||||||||||||||||||||||||||||||

;||||||||||||||||||||||||||||||||||||||||Delay|||||||||||||||||||||||||||||||||||||||||||||||||||||||||
delay proc

	mov cx,64000
	dummyloop:
		loop dummyloop
	mov cx,64000
	dummyloop1:
		loop dummyloop1
	mov cx,64000
	dummyloop3:
		loop dummyloop3
	mov cx,64000
;	dummyloop4:
;		loop dummyloop4
;		mov cx,64000
;;;;;;;;;;;;;
;	dummyloop5:
;		loop dummyloop5
	;	mov cx,64000
	;dummyloop6:
	;	loop dummyloop6
	
ret
delay endp

;||||||||||||||||||||||||||||||||||||||||Delay |||||||||||||||||||||||||||||||||||||||||||||||||||||||||



;||||||||||||||||||||||||||||||||||||||||EXTRA|||||||||||||||||||||||||||||||||||||||||||||||||||||||||

;it display the values assined in they array
Displayrray proc

   ;clearing the screen
    mov ah,0h
	mov al,3h
    int 10h

	mov ah,02h
	mov bh,0
	mov dh,25
	mov dl,0
	int 21h


	mov row,6
	mov col,7
	mov bx,offset placed
	mov si,0
	Ae:
		mov col,7
				inne:
					mov ah,02h
					mov dl,[bx+si]	
					int 21h
					
					inc si
					
						mov ah,02h
						mov dl,' '
						int 21h
										mov ah,02h
						mov dl,' '
						int 21h
										mov ah,02h
						mov dl,' '
						int 21h
						
						dec col
						cmp col,0
						
						ja inne
						
						
						mov ah,09h
						lea dx, endl
						int 21h
						
						dec row
						cmp row,0

						ja Ae
					
ret
Displayrray endp

;================================================================
Display_Asgn_Coor proc
;this pro is used to define the coordinates wehre to fill the values
;start (1,2),(1,6)
;next  (3,2),(3,6)
;filling values column wise
mov cx,7
mov si,0
	mov col,0
L3:
	mov col,0
		L2:
								mov bp,col
					
								mov ah,02h
								mov dl,coordinates[si].x_axis[bp]
								add dl,48
								INT 21H
								
								MOV AH,02H
								MOV DX,' '
								INT 21H
								
								
								mov ah,02h
								mov dl,coordinates[si].y_axis[bp]
								add dl,48
								INT 21H
								
								MOV AH,02H
								MOV DX,' '
						        INT 21H
								
								MOV AH,02H
								MOV DX,' '
								INT 21H
								
			
			
			
			
			inc col
			cmp col,6
			jb L2
			
			MOV AH,09H
			LEA DX,ENDL
			INT 21H
			
			
			
				add si,type coordinates ;to move to the next srtruct
			
			
			
		loop L3
	
    ret
Display_Asgn_Coor endp



doubledigit proc


	  mov cx,0

	  mov dx,0

	  mov bx,10d

		loop1:
			mov dx,0	;ax: Quotient

			div bx	        
		
			push dx		;dx: Remainder

			inc cx
			cmp ax,0	;if ax!=0 then

			jnz loop1	;Loop will be repeated

		loop2:
			mov ah,02
			pop dx
		
		
			add dl,48
			int 21h

			dec cx

			cmp cx,0	;if cx!=0 then
			jnz loop2	;Loop will be repeated
ret 
doubledigit endp

Sound proc

mov     al, 182         ; Prepare the speaker for the
        out     43h, al         ;  note.
        mov     ax, 4560        ; Frequency number (in decimal)
                                ;  for middle C.
        out     42h, al         ; Output low byte.
        mov     al, ah          ; Output high byte.
        out     42h, al 
        in      al, 61h         ; Turn on note (get value from
                                ;  port 61h).
        or      al, 00000011b   ; Set bits 1 and 0.
        out     61h, al         ; Send new value.
        mov     bx, 15          ; Pause for duration of note.
pause1:
        mov     cx, 35535
pause2:
        dec     cx
        jne     pause2
        dec     bx
        jne     pause1
        in      al, 61h         ; Turn off note (get value from
                                ;  port 61h).
        and     al, 11111100b   ; Reset bits 1 and 0.
        out     61h, al         ; Send new value.

ret
Sound endp


endprog:

	;Cursor is on grid on terminatio so did this
	mov ah,02h
	mov bh,0
	mov dh,20
	mov dl,0
	int 10h

	mov ah,4ch
	int 21h
	end 
