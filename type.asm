; Comentários temporários:
; - Cores das mensagens:
;   0000 branco
;   0256 marrom
;   0512 verde
;   0768 oliva
;   1024 azul marinho
;   1280 roxo
;   1536 teal
;   1712 prata
;   2048 cinza
;   2304 vermelho
;   2560 lima
;   2816 amarelo
;   3072 azul
;   3328 rosa
;   3584 aqua
;   3840 preto

jmp main

corAtualdaPalavra: var #1
nPalavrasResolvidas: var #1
palavraAtual: var #41
posAtualdaPalavra: var #1

main:

    loadn r1, #tela1Linha0      ; endereço inicial para a tela inicial do jogo
    loadn r2, #2304             ; cor vermelha para impressão da tela
    call ImprimeTela
	call DelayFixo
	call ApagaTela
	
	loadn r1, #tela2Linha0		; endereço inicial da tela com a nave
	loadn r2, #1280				; cor roxa para impressão da tela
	call ImprimeTela

	loadn r1, #2560
	store corAtualdaPalavra, r1

;	loadn r1, #palavra1
;	loadn r0, #0
;	call mudarPalavraAtual
;	loadn r1, #palavraAtual
;	loadn r0, #0
	;breakp
;	call ImprimeStr
;	call DelayFixo

	loadn r3, #0
	loadn r6, #palavra1
	loadn r4, #41
	loadn r5, #24
	loadn r0, #0

	main_Loop:
		;breakp
		loadn r0, #0
		mov r1, r6
		call mudarPalavraAtual
		loadn r1, #palavraAtual
		loadn r0, #0
		load r2, corAtualdaPalavra
		call ImprimeStr
		call DelayFixo
		push r5
		push r6
		loadn r5, #0
		loadn r6, #25
		move_palavra_Loop:
			call move_palavra
			call DelayFixo
			inc r5
			cmp r5, r6
			jne move_palavra_Loop
		pop r6
		pop r5
		add r6, r6, r4
		cmp r3, r5
		inc r3
		jne main_Loop

    halt

;********************************************************
;                       IMPRIME TELA
;********************************************************	

ImprimeTela: 	;  Rotina de Impresao de Cenario na Tela Inteira
		;  r1 = endereco onde comeca a primeira linha do Cenario
		;  r2 = cor do Cenario para ser impresso

	push r0	; protege o r3 na pilha para ser usado na subrotina
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	push r5	; protege o r4 na pilha para ser usado na subrotina

	loadn R0, #0  	; posicao inicial tem que ser o comeco da tela!
	loadn R3, #40  	; Incremento da posicao da tela!
	loadn R4, #41  	; incremento do ponteiro das linhas da tela
	loadn R5, #1200 ; Limite da tela!
	
   ImprimeTela_Loop:
		call ImprimeStr
		add r0, r0, r3  	; incrementaposicao para a segunda linha na tela -->  r0 = R0 + 40
		add r1, r1, r4  	; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
		cmp r0, r5			; Compara r0 com 1200
		jne ImprimeTela_Loop	; Enquanto r0 < 1200

	pop r5	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
				
;---------------------

;---------------------------	
;********************************************************
;                   IMPRIME STRING
;********************************************************
	
ImprimeStr:	;  Rotina de Impresao de Mensagens:     
													; 	Parâmetros:
													;	r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso;
													;  	r1 = endereco onde comeca a mensagem
													; 	r2 = cor da mensagem.
													;   Obs: a mensagem sera' impressa ate' encontrar "/0"
	push r0	; protege o r0 na pilha para preservar seu valor
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	
	loadn r3, #'\0'	; Criterio de parada

   ImprimeStr_Loop:	
		;breakp
		loadi r4, r1
		;breakp
		cmp r4, r3		; If (Char == \0)  vai Embora
		jeq ImprimeStr_Sai
		add r4, r2, r4	; Soma a Cor
		outchar r4, r0	; Imprime o caractere na tela
		inc r0			; Incrementa a posicao na tela
		inc r1			; Incrementa o ponteiro da String
		jmp ImprimeStr_Loop
	
   ImprimeStr_Sai:	
	;breakp
	pop r4	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r3
	pop r2
	pop r1
	pop r0
	rts


DelayFixo:		; Função de delay para a palavra
				; Protegendo o conteúdo dos registradores:
	push r0
	push r1
	push r2

	loadn r1, #200
	loadn r2, #0
	Delay_volta2:
		loadn r0, #40000
        Delay_volta: 
	        dec r0
			cmp r0, r2					
	        jnz Delay_volta	
	    dec r1
		cmp r1, r2
	    jnz Delay_volta2
	
	; Recuperando o valor anterior dos registradores:
	pop r2
	pop r1
	pop r0
	
	rts ; return


; Descrição: Apaga a tela inteira, preenchendo-a com espaços (' ')
ApagaTela:

    ; Protegendo os conteúdos dos registradores:
	push r0
	push r1
	push r2
	
	; Carregando constantes:
	loadn r0, #1200		  ; total de posicoes da tela
	loadn r1, #' '		  ; 32 (ASCII espaço)
	loadn r2, #0		  ; valor inteiro 0

	; Loop (r0=1200; r0>=0;  r0--)
	ApagaTela_Loop:	    
		dec r0            ; r0--
		outchar r1, r0    ; preenche espaço
		cmp r0, r2
		jnz ApagaTela_Loop
 
 	; Recuperando os valores anteriores dos registradores:
	pop r2
	pop r1
	pop r0
	
	rts ; return


mudaCorPalavra:		; Função que muda a cor da palavra

	push r0
	push r1
	push r2

	loadn r0, #0000 	; cor branca
	loadn r1, #2560		; cor verde lima
	load r2, corAtualdaPalavra		; r2 = corAtualdaPalavra
	
	cmp r2, r0
	jmp MudaCorBranca
	MudaCorLima:
		store corAtualdaPalavra, r0
		jmp fimMudaCor
	MudaCorBranca:
		store corAtualdaPalavra, r1
	fimMudaCor:

	pop r2
	pop r1
	pop r0

	rts		; return


mudarPalavraAtual:		; Função que altera a palavra atual
						; Parâmetros:
						;	r1 -> endereço inicial para a nova palavra
	push r0
	push r1
	push r2
	push r3
	push r5
	
	call mudaCorPalavra	; muda a cor da palavra

	loadn r0, #palavraAtual 	; Endereço inicial de palavraAtual
	;breakp
	loadn r2, #40				; tamanho total da string
	loadn r3, #0				; contador para escrever a palavra
	store posAtualdaPalavra, r3
	mudarPalavraAtual_Loop:
		;breakp
		loadi r5, r1
		storei r0, r5
		inc r0
		inc r1
		inc r3
		cmp r3, r2
		jle mudarPalavraAtual_Loop

	loadn r3, #'\0'				; acrescentar o '\0' na string
	storei r0, r3
	;breakp

	pop r5
	pop r3
	pop r2
	pop r1
	pop r0

	rts


move_palavra:	; função que move a palavra no vídeo
	; Proteção de dados dos registradores
	push r0 	
	push r2
	push r4		
	push r1
	
	load r0, posAtualdaPalavra
;	loadn r2, #25 		; limite máximo da linha da palavra

	;cmp r0, r2			; if(r0 == r2){ O jogo termina }
	;jeq fimDoJogo
	
	loadn r1, #tela0Linha0	; endereço inicial de uma linha vazia
	
	push r0

	loadn r4, #40
	mul r0, r0, r4						; r0 *= r4 (posicão inicial para imprimir na tela)
	loadn r2, #0000			; cor branca para inserção da palavra na tela
	
	call ImprimeStr
	
	pop r0					; r0 = (r0 + 1) * r4 (próxima posição da palavra)

	inc r0
	store posAtualdaPalavra, r0
	mul r0, r0, r4
	
	loadn r1, #palavraAtual
	load r2, corAtualdaPalavra
	call ImprimeStr

	pop r1
	pop r4
	pop r2
	pop r0

	rts		; return



; TELA 0 = tela vazia
tela0Linha0  : string "                                        "
tela0Linha1  : string "                                        "
tela0Linha2  : string "                                        "
tela0Linha3  : string "                                        "
tela0Linha4  : string "                                        "
tela0Linha5  : string "                                        "
tela0Linha6  : string "                                        "
tela0Linha7  : string "                                        "
tela0Linha8  : string "                                        "
tela0Linha9  : string "                                        "
tela0Linha10 : string "                                        "
tela0Linha11 : string "                                        "
tela0Linha12 : string "                                        "
tela0Linha13 : string "                                        "
tela0Linha14 : string "                                        "
tela0Linha15 : string "                                        "
tela0Linha16 : string "                                        "
tela0Linha17 : string "                                        "
tela0Linha18 : string "                                        "
tela0Linha19 : string "                                        "
tela0Linha20 : string "                                        "
tela0Linha21 : string "                                        "
tela0Linha22 : string "                                        "
tela0Linha23 : string "                                        "
tela0Linha24 : string "                                        "
tela0Linha25 : string "                                        "
tela0Linha26 : string "                                        "
tela0Linha27 : string "                                        "
tela0Linha28 : string "                                        "
tela0Linha29 : string "                                        "


; TELA 1 = tela inicial do joguinho
tela1Linha0  : string "                                        "
tela1Linha1  : string "                                        "
tela1Linha2  : string "                                        "
tela1Linha3  : string "                                        "
tela1Linha4  : string "    ._____.   __    __   _____ _____    "
tela1Linha5  : string "    |_   _|   \\ \\  / /  || * | |____|   "
tela1Linha6  : string "      | |      \\ \\/ /   ||---- |____    "
tela1Linha7  : string "      | |       |   |   ||     |____|   "
tela1Linha8  : string "      | |       |   |   ||     |____    "
tela1Linha9  : string "      |_|       |___|   ||     |____|   "
tela1Linha10 : string "                                        "
tela1Linha11 : string "                                        "
tela1Linha12 : string "       _______  _     _   _____         "
tela1Linha13 : string "       |_   _| | |   | |  |____|        "
tela1Linha14 : string "         | |   | |___| |  |____         "
tela1Linha15 : string "         | |   |  ___  |  |____|        "
tela1Linha16 : string "         | |   | |   | |  |____         "
tela1Linha17 : string "         |_|   |_|   |_|  |____|        "
tela1Linha18 : string "                                        "
tela1Linha19 : string "                                        "
tela1Linha20 : string "   ___             __    __.  ______    "
tela1Linha21 : string "  //__|     /\\     | \\  /  |  |_____|   "
tela1Linha22 : string " //  __    /  \\    |  \\/   |  |_____    "
tela1Linha23 : string " || |__|  / /\\ \\   | |\\_/| |  |_____|   "
tela1Linha24 : string " ||  //  / /  \\ \\  | |   | |  |_____    "
tela1Linha25 : string "  \\_//  /_/    \\_\\ |_|   |_|  |_____|   "
tela1Linha26 : string "                                        "
tela1Linha27 : string "                                        "
tela1Linha28 : string "                                        "
tela1Linha29 : string "                                        "


; Tela 1 = Nave Sozinha
tela2Linha0  : string "                                        "
tela2Linha1  : string "                                        "
tela2Linha2  : string "                                        "
tela2Linha3  : string "                                        "
tela2Linha4  : string "                                        "
tela2Linha5  : string "                                        "
tela2Linha6  : string "                                        "
tela2Linha7  : string "                                        "
tela2Linha8  : string "                                        "
tela2Linha9  : string "                                        "
tela2Linha10 : string "                                        "
tela2Linha11 : string "                                        "
tela2Linha12 : string "                                        "
tela2Linha13 : string "                                        "
tela2Linha14 : string "                                        "
tela2Linha15 : string "                                        "
tela2Linha16 : string "                                        "
tela2Linha17 : string "                                        "
tela2Linha18 : string "                                        "
tela2Linha19 : string "                                        "
tela2Linha20 : string "                                        "
tela2Linha21 : string "                                        "
tela2Linha22 : string "                                        "
tela2Linha23 : string "                                        "
tela2Linha24 : string "                                        "
tela2Linha25 : string "                                        "
tela2Linha26 : string "                    /\\                  "
tela2Linha27 : string "                   /  \\                 "
tela2Linha28 : string "                  |^  ^|                "
tela2Linha29 : string "                  |____|                "


; palavras para o usuário digitar 
; COLOCAR DEPOIS AS PALAVRAS AQUI!!! 
palavra1  : string "                ambiguous               "
palavra2  : string "                automatic               "
palavra3  : string "                available               "
palavra4  : string "                catalogue               "
palavra5  : string "                chocolate               "
palavra6  : string "                catalogue               "
palavra7  : string "                detective               "
palavra8  : string "                economics               "
palavra9  : string "                effective               "
palavra10 : string "                essential               "
palavra11 : string "                formation               "
palavra12 : string "                intention               "
palavra13 : string "                invisible               "
palavra14 : string "                modernize               "
palavra15 : string "                parameter               "
palavra16 : string "                performer               "
palavra17 : string "                policeman               "
palavra18 : string "                practical               "
palavra19 : string "                president               "
palavra20 : string "                privilege               "
palavra21 : string "                secretary               "
palavra22 : string "                situation               "
palavra23 : string "                strategic               "
palavra24 : string "                treatment               "
palavra25 : string "                vegetable               "