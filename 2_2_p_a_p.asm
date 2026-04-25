        .module p_a_p

        
        
        .area CODE4 (ABS)
        .org 0x5000

palabra:        .blkb 100
max_tam:        .word 0

pantalla        .equ 0xFF00
teclado         .equ 0xFF02

                .globl imprime_cadena
                .globl tabla_morse
                .globl pal_pal


        pal_pal:
                
                        ldx #palabra
                        lda #'\n
                        sta pantalla
                        sta pantalla

                comparar_caracter:
                        lda teclado

                        cmpa #'  
                        beq espacio
                        cmpa #'0
                        blo falla
                        cmpa #'9
                        bls valido
                        cmpa #'A
                        blo falla
                        cmpa #'Z
                        bls valido
                        rts



                valido: ; el caracter es valido, por lo que lo guardamos

                        sta  ,x+ 
                        bra  comparar_caracter 


                

                espacio:        ; lo que pasa cuando se pulsa el espacio
                
                        clr ,x        ; terminamos la palabra con el \0
                        lda #'\n
                        sta pantalla      

                        ldy #palabra                        

                traduccion:

                        lda ,y+         ;usamos el registro Y como puntero a los elementos almacenados en X
                        beq fin_palabra ; si se lee un 0, se da la palabra por terminada
                                        ; y se pasa a leer la siguiente palabra


                        cmpa #'9
                        bls es_numero


                es_letra:

                        suba #'A
                        bra buscar_morse

                es_numero:

                        suba #'0
                        adda #26


                buscar_morse:

                        ldb #6
                        mul

                        ldx #tabla_morse
                        leax d, x

                        jsr imprime_cadena
                        
                        bra traduccion



                fin_palabra:
                        bra pal_pal

                falla:
                        rts  ;volvemos al menu

        