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


