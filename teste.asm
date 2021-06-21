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

letraDigitada: var #1

posPalavra: var #1
posAntPalavra: var #1

posNave: var #1
posAntNave: var #1

posTiro: var #1			
posAntTiro: var #1		
FlagTiro: var #1

main:
	call ApagaTela
	loadn r1, #tela1Linha0        ; endereco onde comeca a primeira linha do cenario!!
	loadn r2, #1536  			  ; cor branca!
	call ImprimeTela    		  ; rotina de Impresao de Cenario na Tela Inteira
	call Delay
	jmp main


; Descrição: Apaga a tela inteira, preenchendo-a com espaços (' ')
ApagaTela:

    ; Protegendo os conteúdos dos registradores:
	push r0
	push r1
	
	; Carregando constantes:
	loadn r0, #1200		  ; total de posicoes da tela
	loadn r1, #' '		  ; 32 (ASCII espaço)
	
	; Loop (r0=1200; r0>=0;  r0--)
	ApagaTela_Loop:	    
		dec r0            ; r0--
		outchar r1, r0    ; preenche espaço
		jnz ApagaTela_Loop
 
 	; Recuperando os valores anteriores dos registradores:
	pop r1
	pop r0
	
	rts ; return

 
; Descrição: Imprime a tela inteira de um cenário
; Parâmetros: r1 -> endereco da primeira linha do cenário
;             r2 -> cor do cenário a ser impresso
ImprimeTela:
	
	; Protegendo os conteúdos dos registradores:
	push r0
	push r1
	push r2
	push r3
	push r4
	push r5
	push r6
	
	; Carregando constantes:
	loadn r0, #0  	        ; posicao inicial (início da tela)
	loadn r3, #40  	        ; largura da tela
	loadn r4, #41  	        ; largura da tela + 1
	loadn r5, #1200         ; largura * altura da tela 
	loadn r6, #tela0Linha0	; endereco em que começa a primeira linha do cenario
	
	; Loop para impressão da tela:
    ImprimeTela_Loop:
		call ImprimeStr
		add r0, r0, r3  	; incrementa posicao para a próxima linha na tela (r0 += 40)
		add r1, r1, r4  	; incrementa o ponteiro para o começo da próxima linha na memória (r1 += 41), 41 por causa do '\0'
		add r6, r6, r4  	; incrementa o ponteiro para o começo da próxima linha na memória (r6 += 41), 41 por causa dp '\0'
		cmp r0, r5			; while (r0 < 1200), continua no loop
		jne ImprimeTela_Loop

	; Recuperando os valores anteriores dos registradores:
	pop r6
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	
	rts ; return
			
				
; Descrição: imprime uma mensagem na tela até encontrar o '\0'
; Parâmetros: r0 -> posição da tela em que o primeiro caractere da mensagem será impresso
;             r1 -> endereço da mensagem
;             r2 -> cor da mensagem
ImprimeStr:	
	
	; Protegendo os conteúdos dos registradores:
	push r0	
	push r1	
	push r2
	push r3
	push r4
	push r5
	push r6
	
	; Carregando constantes:
	loadn r3, #'\0'	  ; terminador de string
	loadn r5, #' '	  ; 32 (ASCII espaço)

    ; Loop de impressão da string:
    ImprimeStr_Loop:	
		loadi r4, r1
		cmp r4, r3		; if (charAtual == '\0'), vai embora
		jeq ImprimeStr_Sai
		cmp r4, r5		; if (charAtual == ' '), pula para outchar do espaco para na apagar outros caracteres
		jeq ImprimeStr_Skip
		add r4, r2, r4	; soma a cor
		outchar r4, r0	; imprime o caractere na tela
    ImprimeStr_Skip:
		inc r0			; incrementa a posição da tela
		inc r1			; incrementa o ponteiro da string
		jmp ImprimeStr_Loop
	ImprimeStr_Sai:
	
	; Recuperando os valores anteriores dos registradores:	
	pop r6
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	
	rts ; return
	

Delay:
	
	; Protegendo o conteúdo dos registradores:
	push r0
	push r1
	
	; Loop de delay:
    Delay_volta2:
	    loadn r0, #5000
	    loadn r1, #50
        Delay_volta: 
	        dec r0					
	        jnz Delay_volta	
	    dec r1
	    jnz Delay_volta2
	
	; Recuperando o valor anterior dos registradores:
	pop r1
	pop r0
	
	rts ; return

	
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


; Tela 1 = Nave Sozinha (refazer pq tá feia kkkk)
tela1Linha0  : string "                                        "
tela1Linha1  : string "                                        "
tela1Linha2  : string "                                        "
tela1Linha3  : string "                                        "
tela1Linha4  : string "                                        "
tela1Linha5  : string "                                        "
tela1Linha6  : string "                                        "
tela1Linha7  : string "                                        "
tela1Linha8  : string "                                        "
tela1Linha9  : string "                                        "
tela1Linha10 : string "                                        "
tela1Linha11 : string "                                        "
tela1Linha12 : string "                                        "
tela1Linha13 : string "                                        "
tela1Linha14 : string "                                        "
tela1Linha15 : string "                                        "
tela1Linha16 : string "                                        "
tela1Linha17 : string "                                        "
tela1Linha18 : string "                                        "
tela1Linha19 : string "                                        "
tela1Linha20 : string "                                        "
tela1Linha21 : string "                                        "
tela1Linha22 : string "                                        "
tela1Linha23 : string "                                        "
tela1Linha24 : string "                                        "
tela1Linha25 : string "                                        "
tela1Linha26 : string "                                        "
tela1Linha27 : string "                    ^                   "
tela1Linha28 : string "                   / \\                  "
tela1Linha29 : string "                  |^|^|                 "
