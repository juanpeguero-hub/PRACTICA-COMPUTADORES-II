        .module m_l_a_l

linea: .blkb 100
bufer_morse: .asciz "     "
limite_car:.byte 5

err_dim:     .asciz "ERROR LOGITUD ENTRADA"  ; muestra esto y vuelve al menu anterior
err_car:     .asciz "ERROR CARACTER ENTRADA"
err_val:     .asciz "CODIGO NO VALIDO"

pantalla .equ 0xFF00
teclado  .equ 0xFF02

    .globl imprime_cadena
    .globl compara_cadenas
    .globl tabla_morse
    .globl compara
    .globl m_lin_a_lin
    .globl limpiar_bufer
    .globl traducir_morse
   


m_lin_a_lin:
    ldu #linea
        
        lda #'\n
        sta pantalla
        sta pantalla

        nueva_letra:
            ldx #bufer_morse
            jsr limpiar_bufer
            ldb #0


        decidir_entrada:
            lda teclado
            cmpa #'-
            beq valido
            cmpa #'.
            beq valido
            cmpa #' 
            beq espacio
            cmpa #'\n
            beq fin_opc
            bra errores
valido:

            sta ,x+
            incb
            cmpb limite_car
            bhi imprimir_error_dimIII

            bra decidir_entrada


        espacio:    
           
           
        tstb
        beq doble_espacio
        
        traduction:
            ldy #bufer_morse
            jsr traducir_morse

            tsta 
            beq imprimir_error_validoIII

            sta ,u+
            bra nueva_letra

                 
        doble_espacio:
            sta ,u+
            bra nueva_letra 

        fin_opc:

        tstb
        beq traducir_linea
        
            traducir_bufer_restante:
            ldy #bufer_morse
            jsr traducir_morse
            tsta
            beq imprimir_error_validoIII

            traducir_linea:
            sta ,u+
            clr ,u
            ldx #linea
            jsr imprime_cadena
            bra quit



       
        errores:

                ldx #err_car
                jsr imprime_cadena
                rts

                imprimir_error_carIII:
                        
                        ldx #err_car
                        jsr imprime_cadena

                        rts

                imprimir_error_dimIII:

                        ldx #err_dim
                        jsr imprime_cadena

                        rts

                imprimir_error_validoIII:

                        ldx #err_val
                        jsr imprime_cadena

                        rts


            quit:

                lda #'\n
                sta pantalla
                rts




    
