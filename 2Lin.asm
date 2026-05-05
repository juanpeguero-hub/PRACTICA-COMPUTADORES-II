    .module l_a_l

    

linea:   .blkb 100


pantalla  .equ 0xFF00
teclado    .equ 0xFF02

            .globl imprime_cadena
            .globl tabla_morse
            .globl lin_a_lin
            .globl toupper


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                         ;
;   lin_a_lin                                             ;
;                                                         ;
;       Se corresponde con la opción de traducir texto    ;
;       a morse línea a línea. La subrutina reserva       ;
;       memoria para guardar caracteres de una línea      ;
;       recogidos uno a uno. Verifica si son válidos:     ;
;       si lo es, incrementa el índice y guarda el        ;
;       carácter. Si es enter/return, añade un \0 y       ;
;       traduce desde #linea hasta el fin de cadena.      ;
;       Si es inválido, se sale de la traducción.         ;
;                                                         ;
;       Entrada: nada.                                    ;
;       Salida: nada.                                     ;
;       Registros afectados: A, B, X, Y.                  ;
;                                                         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

lin_a_lin:

    nueva_linea:    
        ldx #linea

    pedir_linea:
        
        lda teclado
        jsr toupper
        beq pedir_linea

        cmpa #'\n
        beq enter_return   
        cmpa #' 
        beq caracter_valido
        cmpa #'0
        blo falla_linea
        cmpa #'9
        bls caracter_valido
        cmpa #'A
        blo falla_linea
        cmpa #'Z
        bls caracter_valido
        bra falla_linea

        caracter_valido:
                
            sta ,x+
            bra pedir_linea
            ;el caracter es valido, lo guardamos en el registro X y pedimos otro caracter
        
        enter_return:
            ldy #linea
            clr ,x
            lda #'\n
            sta pantalla
            sta pantalla


        traduccion_linea:   
                lda ,y+
                cmpa #'\0
                beq fin_linea
                cmpa #' 
                beq espacio_linea
                cmpa #'9
                bls es_numero_linea
        
            es_letra_linea:

                suba #'A
                bra buscar_morse_linea

    
            es_numero_linea:
                suba #'0
                adda #26
                bra buscar_morse_linea

            espacio_linea:
                
                bra traduccion_linea

            buscar_morse_linea:  

                ldx #tabla_morse
                ldb #6
                mul

                leax d, x
                jsr imprime_cadena
                                
                

                bra traduccion_linea




        fin_linea:
            lda #'\n
            sta pantalla
            sta pantalla
            sta pantalla
            
            
            bra nueva_linea
            
        falla_linea:
            rts