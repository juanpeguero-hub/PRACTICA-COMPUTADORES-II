        .module m_c_a_c

        



bufer_morse: .asciz "     "; como asciz acaba la cadena en \0, es útil para lo que buscamos en esta opcion
                           ; pero la jodienda es que hay que limpiar el bufer en cada caracter para que no se
                           ; quede basura de la opcion anterior

err_dim:     .asciz "ERROR LOGITUD ENTRADA"  ; muestra esto y vuelve al menu anterior
err_car:     .asciz "ERROR CARACTER ENTRADA"
err_val:     .asciz "CODIGO NO VALIDO"

limite_car:  .byte #5

pantalla    .equ 0xFF00
teclado     .equ 0xFF02



            .globl imprime_cadena
            .globl tabla_morse
            .globl m_car_a_car
            .globl compara
            .globl compara_cadenas
            .globl limpiar_bufer
            .globl traducir_morse
            
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                         ;
;   m_car_a_car                                           ;
;                                                         ;
;       Se corresponde con la opción de traducir morse    ;
;       a texto caracter a caracter. La subrutina         ;
;       reserva espacio para un búfer, y llama a una      ;
;       subrutina en cadenas.asm que lo limpia.           ;
;       Posteriormente, comprueba si se ha introducido    ;
;       un punto/raya, un espacio/retorno, o ninguno      ;
;       de los anteriores, saltando a una subrutina       ;
;       diferente para cada una de las 3 opciones.        ;
;       Si es un punto o raya, almacena lo introducido    ;
;       en el búfer, y comprueba si se ha superado el     ;
;       límite de símbolos. Si no se ha superado,         ;
;       vuelve a leer, mientras que si se ha superado,    ;
;       salta un error por dimensión inválida.            ;
;       Si es un espacio o retorno, llama a una           ;
;       subrutina en cadenas.asm que busca la cadena      ;
;       en la tabla. Si no la encuentra, salta un         ;
;       error de código inválido. Si es un carácter       ;
;       inválido, salta un mensaje de error.              ;
;       Para traducir, comprueba si el índice de          ;
;       cadenas por las que ha tenido que buscar          ;
;       corresponde con una letra o un número, y lo       ;
;       convierte en el ASCII que corresponde. Por        ;
;       último, vuelve a la línea donde se llama a la     ;
;       subrutina que limpia el búfer. Posteriormente,    ;
;       comprueba si se ha introducido un punto o         ;
;       raya. Si es así, lo guarda en el búfer,           ;
;       verificando que no se haya superado el límite     ;
;       de 5 símbolos. Si es un espacio o retorno,        ;
;       traduce el carácter guardado en el búfer. Si      ;
;       no es ninguno de los anteriores, salta a una      ;
;       subrutina que enseña el mensaje de error para     ;
;       carácteres inválidos.                             ;
;                                                         ;
;       Entrada: nada.                                    ;
;       Salida: nada.                                     ;
;       Registros afectados: A, B, X, Y.                  ;
;                                                         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


m_car_a_car:  

        
        
        llamar_bufer: ; apuntamos al bufer, cargamos X con 1 espacio y escribimos lo almacenado en A
                       ; en donde este apuntando X, con incremento de 1 byte

            ldx #bufer_morse
            jsr limpiar_bufer
            ldb #0           ; uso el registro b como contador, inicializandolo a 0

        


        input:
        

        
        lda teclado  
        cmpa #'-
        beq buen_caracter
        cmpa #'.
        beq buen_caracter
        cmpa #' 
        beq fin_ASCII
        cmpa #'\n
        beq fin_ASCII
        bra error_caracter ; si llega aqui sin saltar a ninguna de las otras subrutinas, es que es un caracter invalido 
                           ; (no es ni punto ni raya ni espacio/enter)


         
        fin_ASCII: 
           ldy #bufer_morse
           jsr traducir_morse

           tsta
           beq imprimir_error_valido


           sta pantalla

           lda #'\n
           sta pantalla

           lbra llamar_bufer






        buen_caracter: 
                ; el caracter introducido es valido, lo guardamos, comprobamos el límite y pedimos otro
                

                sta ,x+
                incb
                cmpb limite_car
                bls input
                cmpb limite_car
                bgt imprimir_error_dim

        error_caracter:

                cmpa #'0
                bls imprimir_error_car 
                cmpa #'Z
                bls imprimir_error_car

                imprimir_error_car:
                        
                        ldx #err_car
                        jsr imprime_cadena

                        rts

                imprimir_error_dim:

                        ldx #err_dim
                        jsr imprime_cadena

                        rts

                imprimir_error_valido:

                        ldx #err_val
                        jsr imprime_cadena

                        rts


