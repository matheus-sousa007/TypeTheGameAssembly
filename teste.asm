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

tamanhoPalavra: var #1
	static tamanhoPalavra + #0, #9

palavraAtual:	var #40

corAtualdaPalavra: var #1

linhaAtualdaPalavra: var #1

nPalavrasResolvidas: var #1

tabelaRandpos: var #1



Rand : var #24			; Tabela de nr. Randomicos entre 1 - 25 (para pegar as palavras de maneira randomica)
	static Rand + #0, #13
	static Rand + #1, #5
	static Rand + #2, #8
	static Rand + #3, #14
	static Rand + #4, #2
	static Rand + #5, #4
	static Rand + #6, #7
	static Rand + #7, #9
	static Rand + #8, #24
	static Rand + #9, #16
	static Rand + #10, #12
	static Rand + #11, #17
	static Rand + #12, #1
	static Rand + #13, #19
	static Rand + #14, #22
	static Rand + #15, #11
	static Rand + #16, #18
	static Rand + #17, #21
	static Rand + #18, #6
	static Rand + #19, #20
	static Rand + #20, #23
	static Rand + #20, #15
	static Rand + #21, #25
	static Rand + #22, #3
	static Rand + #23, #10

main:
	call ApagaTela
	loadn r1, #tela1Linha0        ; endereco onde comeca a primeira linha do cenario!!
	loadn r2, #1536  			  ; cor branca!
	call ImprimeTela    		  ; rotina de Impresao de Cenario na Tela Inteira
	
	loadn r1, #palavra1
	loadn r3, #41
	loadn r5, #25
	main_Loop:
		call interage_palavra
		add r1, r1, r3
		load r4, nPalavrasResolvidas
		cmp r4, r5
		jle main_Loop

	jmp fimDoJogo 


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
	loadn r1, #0			; 
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
	

; Descrição: imprime uma mensagem na tela até encontrar o '\0'
; Parâmetros: r0 -> posição da tela em que o primeiro caractere da mensagem será impresso
;             r1 -> endereço da mensagem
;             r2 -> cor da mensagem
ImprimeStrInteira:	
	
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
		add r4, r2, r4	; soma a cor
		outchar r4, r0	; imprime o caractere na tela
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



Delay:		; Função de delay para a palavra
	; Protegendo o conteúdo dos registradores:
	push r0
	push r1
	push r2

	; Loop de delay:
	loadn r0, #40000
	loadn r1, #25
    load r2, nPalavrasResolvidas
	
	sub r1, r1, r2

	Delay_volta2:
        Delay_volta: 
	        dec r0					
	        jnz Delay_volta	
	    dec r1
	    jnz Delay_volta2
	
	; Recuperando o valor anterior dos registradores:
	pop r2
	pop r1
	pop r0
	
	rts ; return

move_palavra:	; função que move a palavra no vídeo
	; Proteção de dados dos registradores
	push r0 	
	push r2
	push r4		
	push r1
	
	load r0, palavra
	loadn r2, #25 		; limite máximo da linha da palavra

	cmp r0, r2			; if(r0 == r2){ O jogo termina }
	jeq fimDoJogo
	
	loadn r1, #tela0Linha0	; endereço inicial de uma linha vazia
	
	push r0

	loadn r4, #40
	mult r0, r0, r4			; r0 *= r4 (posicão inicial para imprimir na tela)
	loadn r2, #0000			; cor branca para inserção da palavra na tela
	
	call ImprimeStrInteira
	
	pop r0					; r0 = (r0 + 1) * r4 (próxima posição da palavra)
	inc r0
	mult r0, r0, r4
	
	loadn r1, #palavraAtual
	call ImprimeStrInteira

	pop r1
	pop r4
	pop r2
	pop r0

	rts		; return

nova_palavra:		; funcão que imprime uma nova palavra
					; Parâmetros:
					;	r1 -> endereço inicial da nova palavra a ser inserida
	push r0
	push r1
	push r2

	call mudarPalavraAtual

	loadn r1, #palavraAtual	; endereço inicial da palavra
	loadn r0, #0	; posição inicial da palavra
	loadn r2, #0000 ; cor branca para impressão da palavra

	call ImprimeStrInteira

	load r0, nPalavrasResolvidas
	inc r0
	store nPalavrasResolvidas, r0

	pop r2
	pop r1
	pop r0

	rts ; return

DigLetra:	; Espera que uma tecla seja digitada e salva na variavel global "Letra"		;	Parâmetros:
			;		r1 -> Próxima letra esperada da palavra
	push r0
	push r1

   DigLetra_Loop:
		inchar r0			; Le o teclado, se nada for digitado = 255
		cmp r0, r1			; compara r0 com a letra esperada
		jne DigLetra_Loop	; Caso não seja a letra esperada fica nesse loop até que seja digitada pelo usuário

	store letraDigitada, r0			; Salva a tecla na variavel global "Letra"

	pop r1
	pop r0
	rts


interage_palavra:	;	Função que interage com a palavra 
					; Parâmetros:
					;	r1 -> endereço inicial da palavra nova
	push r0
	push r1
	push r2
	push r3
	push r4

	call nova_palavra

	loadn r0, #16
	add r0, r0, #palavraAtual	; r0 = #palavraAtual + #16 (posição da primeira letra na variavel global)
	loadn r2, #25
	add r2, r2, #palavraAtual	; posição final da palavra

	loadn r4, #0				; contador de linha para a palavra
	interage_palavra_Loop:
		loadi r1, r0			; Obtém a letra da palavra que deve ser digitada

		call DigLetra			; Chama a DigLetra para pegar o input do usuário

		load r3, letraDigitada	; Resgata o input do usuário

		cmp r1, r3				; Caso o input seja a devida letra a ser digitada
		ceq deletaLetra			; chama a função deletaLetra
		ceq mudaCorPalavra

		cmp r0, r2				; contador para o loop
		inc r0
		push r0
		loadi r0, r4			; posição atual da palavra
		call move_palavra		
		call Delay

		inc r4
		pop r0
		jle interage_palavra_Loop

	pop r4
	pop r3
	pop r2
	pop r1
	pop r0

	rts


deletaLetra:		; Função que deleta a letra da palavra atual
					; Parâmetros:
					;	r0 -> posição da letra a ser deletada
	; Protegendo o conteúdo dos registradores
	push r0
	push r1

	loadn r1, #' '			; Caractere espaço ' ' (ASCII = 32)

	storei r0, r1

	pop r1
	pop r0

	rts

mudaCorPalavra:		; Função que muda a cor da palavra
					; Parâmetros:
					;	r0 -> nova cor da palavra

	push r0

	store corAtualdaPalavra, r0	; armazena a nova cor

	pop r0

	rts		; return


mudarPalavraAtual:		; Função que altera a palavra atual
						; Parâmetros:
						;	r1 -> endereço inicial para a nova palavra
	push r0
	push r1
	push r2
	push r3

	loadn r0, #0000		; cor branca para impressão da palavra

	call mudaCorPalavra	; muda a cor da palavra

	loadn r0, #palavraAtual 	; Endereço inicial de palavraAtual
	loadn r2, #40				; tamanho total da string
	loadn r3, #0				; contador para escrever a palavra
	mudarPalavraAtual_Loop:
		storei r0, r1
		
		cmp r3, r2
		inc r0
		inc r3
		jle mudarPalavraAtual_Loop

	pop r3
	pop r2
	pop r1
	pop r0

	rts

fimDoJogo:		; Printa a tela de fim de jogo
	push r0
	push r1
	push r2

	load r0, nPalavrasResolvidas
	loadn r1, #25
	cmp r0, r1
	jeq fimDoJogo_Ganhou

	fimDoJogo_Perdeu:
		loadn r1, #tela4Linha0
		loadn r2, #2304

		call ImprimeTela
		jmp fim

	fimDoJogo_Ganhou:
		loadn r1, #tela4Linha0
		loadn r2, #2560

		call ImprimeTela
	pop r2
	pop r1
	pop r0

	fim:
		halt


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
tela1Linha26 : string "                     ^                  "
tela1Linha27 : string "                   /  \\                 "
tela1Linha28 : string "                  |^  ^|                "
tela1Linha29 : string "                  |____|                "

; TELA 2 = tela inicial do joguinho
tela2Linha0  : string "                                        "
tela2Linha1  : string "                                        "
tela2Linha2  : string "                                        "
tela2Linha3  : string "                                        "
tela2Linha4  : string "    ._____.  __      __  _____ _____    "
tela2Linha5  : string "    |_   _|  \\ \\  / / || * | |____|     "
tela2Linha6  : string "      | |     \\ \\/ /  ||---- |____      "
tela2Linha7  : string "      | |       |   |   ||     |____|   "
tela2Linha8  : string "      | |       |   |   ||     |____    "
tela2Linha9  : string "      |_|       |___|   ||     |____|   "
tela2Linha10 : string "                                        "
tela2Linha11 : string "                                        "
tela2Linha12 : string "       _______  _     _   _____         "
tela2Linha13 : string "       |_   _| | |   | |  |____|        "
tela2Linha14 : string "         | |   | |___| |  |____         "
tela2Linha15 : string "         | |   |  ___  |  |____|        "
tela2Linha16 : string "         | |   | |   | |  |____         "
tela2Linha17 : string "         |_|   |_|   |_|  |____|        "
tela2Linha18 : string "                                        "
tela2Linha19 : string "                                        "
tela2Linha20 : string "   ___               _     _   ______   "
tela2Linha21 : string "  //__|     /\\     | \\  / |  |_____|    "
tela2Linha22 : string " //  __    /  \\    |  \\/  |  |_____     "
tela2Linha23 : string "||  |__|  / /\\ \\  | |\\_/| | |_____|     "
tela2Linha24 : string "||   //  /_/  \\_\\ | |   |_|  |_____     "
tela2Linha25 : string " \\_//  /_/     \\_\\ |_|   |_||_____|     "
tela2Linha26 : string "                                        "
tela2Linha27 : string "                                        "
tela2Linha28 : string "                                        "
tela2Linha29 : string "                                        "




; TELA 0 = tela vazia
tela3Linha0  : string "                                        "
tela3Linha1  : string "                                        "
tela3Linha2  : string "                                        "
tela3Linha3  : string "                                        "
tela3Linha4  : string "                                        "
tela3Linha5  : string "                                        "
tela3Linha6  : string "      ==========================        "
tela3Linha7  : string "     |                          |       "
tela3Linha8  : string "     |  V O C Ê   G A N H O U   |       "
tela3Linha9  : string "     |                          |       "
tela3Linha10 : string "     |    JOGAR  NOVAMENTE?     |       "
tela3Linha11 : string "     |                          |       "
tela3Linha12 : string "     | A - SIM         B - NÃO  |       "
tela3Linha13 : string "     |                          |       "
tela3Linha14 : string "      ==========================        "
tela3Linha15 : string "                                        "
tela3Linha16 : string "                                        "
tela3Linha17 : string "                                        "
tela3Linha18 : string "                                        "
tela3Linha19 : string "                                        "
tela3Linha20 : string "                                        "
tela3Linha21 : string "                                        "
tela3Linha22 : string "                                        "
tela3Linha23 : string "                                        "
tela3Linha24 : string "                                        "
tela3Linha25 : string "                                        "
tela3Linha26 : string "                                        "
tela3Linha27 : string "                                        "
tela3Linha28 : string "                                        "
tela3Linha29 : string "                                        "


; TELA 0 = tela vazia
tela4Linha0  : string "                                        "
tela4Linha1  : string "                                        "
tela4Linha2  : string "                                        "
tela4Linha3  : string "                                        "
tela4Linha4  : string "                                        "
tela4Linha5  : string "                                        "
tela4Linha6  : string "      ==========================        "
tela4Linha7  : string "     |                          |       "
tela4Linha8  : string "     |  V O C Ê   P E R D E U   |       "
tela4Linha9  : string "     |                          |       "
tela4Linha10 : string "     |    JOGAR  NOVAMENTE?     |       "
tela4Linha11 : string "     |                          |       "
tela4Linha12 : string "     | A - SIM         B - NÃO  |       "
tela4Linha13 : string "     |                          |       "
tela4Linha14 : string "      ==========================        "
tela4Linha15 : string "                                        "
tela4Linha16 : string "                                        "
tela4Linha17 : string "                                        "
tela4Linha18 : string "                                        "
tela4Linha19 : string "                                        "
tela4Linha20 : string "                                        "
tela4Linha21 : string "                                        "
tela4Linha22 : string "                                        "
tela4Linha23 : string "                                        "
tela4Linha24 : string "                                        "
tela4Linha25 : string "                                        "
tela4Linha26 : string "                                        "
tela4Linha27 : string "                                        "
tela4Linha28 : string "                                        "
tela4Linha29 : string "                                        "





; palavras para o usuário digitar
; COLOCAR DEPOIS AS PALAVRAS AQUI!!!
palavra1  : string "                ambiguous                 "
palavra2  : string "                automatic                 "
palavra3  : string "                available                 "
palavra4  : string "                catalogue                 "
palavra5  : string "                chocolate                 "
palavra6  : string "                catalogue                 "
palavra7  : string "                detective                 "
palavra8  : string "                economics                 "
palavra9  : string "                effective                 "
palavra10 : string "                essential                 "
palavra11 : string "                formation                 "
palavra12 : string "                intention                 "
palavra13 : string "                invisible                 "
palavra14 : string "                modernize                 "
palavra15 : string "                parameter                 "
palavra16 : string "                performer                 "
palavra17 : string "                policeman                 "
palavra18 : string "                practical                 "
palavra19 : string "                president                 "
palavra20 : string "                privilege                 "
palavra21 : string "                secretary                 "
palavra22 : string "                situation                 "
palavra23 : string "                strategic                 "
palavra24 : string "                treatment                 "
palavra25 : string "                vegetable                 "]
