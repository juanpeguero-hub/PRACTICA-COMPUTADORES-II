        .module p_a_p

        
        
        

palabra:        .blkb 100
max_tam:        .word 0

pantalla        .equ 0xFF00
teclado         .equ 0xFF02

                .globl imprime_cadena
                .globl tabla_morse
                .globl pal_pal
                .globl toupper

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                         ;
;   pal_pal                                               ;
;                                                         ;
;       Se corresponde con la opción de traducir texto    ;
;       a morse palabra a palabra. La subrutina reserva   ;
;       memoria para guardar caracteres de una palabra    ;
;       recogidos uno a uno. Verifica si son válidos:     ;
;       si lo es, incrementa el índice y guarda el        ;
;       carácter. Si es espacio, añade un \0 y traduce    ;
;       desde #palabra hasta el fin de cadena. Si es      ;
;       inválido, finaliza la traducción.                 ;
;                                                         ;
;       Entrada: nada.                                    ;
;       Salida: nada.                                     ;
;       Registros afectados: A, B, X, Y, S.               ;
;                                                         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


        pal_pal:
                
                        ldx #palabra
                        lda #'\n
                        sta pantalla
                        sta pantalla

                comparar_caracter:
                        lda teclado
                        jsr toupper

                        cmpa #'  
                        beq espacio
                        cmpa #'0
                        blo falla_car
                        cmpa #'9
                        bls valido
                        cmpa #'A
                        blo falla_car
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
                        bls es_numero_car


                es_letra_car:

                        suba #'A
                        bra buscar_morse

                es_numero_car:

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

                falla_car:
                        rts  ;volvemos al menu

        