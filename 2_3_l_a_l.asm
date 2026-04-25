    .module l_a_l

    .area CODE5 (ABS)
    .org 0x6000

linea:   .blkb 100


pantalla  .equ 0xFF00
teclado    .equ 0xFF02

            .globl imprime_cadena
            .globl tabla_morse
            .globl lin_a_lin

lin_a_lin:

    nueva_linea:    
        ldx #linea

    pedir_linea:
        
        lda teclado
        beq pedir_linea

        cmpa #'\n
        beq enter
        cmpa #' 
        beq valido
        cmpa #'0
        blo falla
        cmpa #'9
        bls valido
        cmpa #'A
        blo falla
        cmpa #'Z
        bls valido
        bra falla

        valido:
                
            sta ,x+
            bra pedir_linea
            ; el caracter es valido, lo guardamos en el registro X y pedimos otro caracter
        
        enter:
            ldy #linea
            clr ,x
            lda #'\n
            sta pantalla
            sta pantalla


        traduccion:   
                lda ,y+
                cmpa #'\0
                beq fin_linea
                cmpa #' 
                beq espacio

                cmpa #'9
                bls es_numero
        
            es_letra:

            suba #'A
            bra buscar_morse

    
            es_numero:
                suba #'0
                adda #26
                bra buscar_morse 

            espacio:

                lda #' 
                sta pantalla
                bra traduccion

            buscar_morse:  

                ldx #tabla_morse
                ldb #6
                mul

                leax d, x
                jsr imprime_cadena
                

                bra traduccion




        fin_linea:
            lda #'\n
            sta pantalla
            sta pantalla
            sta pantalla
            
            
            bra nueva_linea
            
        falla:
            rts

        