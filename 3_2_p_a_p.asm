        .module m_p_a_p

palabra: .blkb 100
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
    .globl m_pal_a_pal
    .globl limpiar_bufer
    .globl traducir_morse
   


    m_pal_a_pal:

        ldu #palabra
        
        lda #'\n
        sta pantalla
        sta pantalla

        nueva_letra:
            ldx #bufer_morse
            jsr limpiar_bufer
            ldb #0 ; reiniciamos el contador


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
            bhi imprimir_error_dimII

            bra decidir_entrada


        espacio:    ;en espacio, tenemos dos opciones : o se mete otro espacio y 
                    ;terminamos la palabra y pedimos otra o se mete otro ./- y 
                    ;continuamos con la traduccion
           
           
        tstb
        beq doble_espacio
        ; si no salto antes, solo hay un espacio, traducimos y pedimos sig.
        
        traduction:
            ldy #bufer_morse
            jsr traducir_morse

            tsta 
            beq imprimir_error_validoII

            sta ,u+
            bra nueva_letra

                 
        doble_espacio:
            clr ,u
            ldx #palabra
            jsr imprime_cadena

            lda #' 
            sta pantalla

            ldu #palabra
            bra nueva_letra

        fin_opc:

            tstb
            beq quit

            ldy #bufer_morse
            jsr traducir_morse
            tsta
            beq imprimir_error_validoII

            sta ,u+
            clr ,u
            ldx #palabra
            jsr imprime_cadena
            bra quit



       
        errores:

                ldx #err_car
                jsr imprime_cadena
                rts

                imprimir_error_carII:
                        
                        ldx #err_car
                        jsr imprime_cadena

                        rts

                imprimir_error_dimII:

                        ldx #err_dim
                        jsr imprime_cadena

                        rts

                imprimir_error_validoII:

                        ldx #err_val
                        jsr imprime_cadena

                        rts


            quit:

                lda #'\n
                sta pantalla
                rts




    
