        .module cadenas

        
cadenas_iguales: .asciz "IGUALES"
cadenas_dif:     .asciz "DISTINTAS"


pantalla    .equ    0xFF00
teclado     .equ    0xFF02
fin         .equ    0xFF01

        
            .globl imprime_cadena
            .globl compara_cadenas
            .globl compara
            .globl limpiar_bufer
            .globl traducir_morse
            .globl tabla_morse_Char ;26
            .globl tabla_morse_Number ;10
            .globl tabla_morse_Total ; 36
            .globl tabla_morse
            .globl toupper

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;   imprime_cadena
;       saca por pantalla la cadena acabada en '\0
;       apuntada por X
;          
;       Entrada: X-direccion de comienzo de la cadena 
;       Salida: void
;       Registros afectados: x, C.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

imprime_cadena:
    pshs    a

sgte:
        lda ,x+
        beq ret_imprime_cadena
        sta pantalla
        bra sgte
    
ret_imprime_cadena:
    puls    a
    rts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                         ;
;   compara_cadenas                                       ;
;                                                         ;
;       compara la cadena X e Y que deben tener el        ;
;       mismo tamanio ademas, la cadena de X debe         ;
;       estar terminada por un \0                         ;
;                                                         ;
;       Entrada: X-direccion de comienzo de la cadena X   ;
;                Y-direccion de comienzo de la cadena Y   ;
;       Salida: A=0 iguales, distinto diferentes          ;
;       Registros afectados: , CC.                        ;
;                                                         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

compara_cadenas:

        pshs x,y
        

        compara_cadenas_bucle:
                lda  ,x+
                cmpa ,y+
                bne distintas
                
                tsta 
                bne compara_cadenas_bucle

            

                iguales:
                        lda #0
                        bra compara_cadenas_fin

                distintas:
                        lda #1



        compara_cadenas_fin:

                puls x,y
                rts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                         ;
;   compara                                               ;
;                                                         ;
;       compara la cadena X e Y que deben tener           ;
;       el mismo tamanio ademas, la cadena de X           ;
;       debe estar terminada por un \0 y saca             ;
;       por pantalla un mensaje diciendo si son           ;
;       iguales o distintas                               ;
;                                                         ;
;       Entrada: X-direccion de comienzo de la cadena X   ;
;                Y-direccion de comienzo de la cadena Y   ;
;       Salida:                                           ;
;       Registros afectados: , CC.                        ;
;                                                         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

compara:

        pshs x,y,d

        jsr compara_cadenas
        tsta
        beq compara_iguales
        ldx #cadenas_dif
        jsr imprime_cadena
        lda #'\n
        sta pantalla
        bra compara_fin
        compara_iguales:
                ldx #cadenas_iguales
                jsr imprime_cadena
                lda #'\n
                sta pantalla
                bra compara_fin

        compara_fin:
                puls x,y,d
                rts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                         ;
;   limpiar_bufer                                         ;
;                                                         ;
;       teniendo memoria reservada que funciona como      ;
;       un bufer, esta subrutina se encarga de limpiar    ;
;       ese bufer, cargando espacios en el registro A     ;
;       y copiandolos donde apunte el registro X          ;
;       (al bufer)                                        ;
;                                                         ;
;       Entrada: puntero a la direccion que se quiera     ;
;                borrar (X)                               ;
;       Salida: void                                      ;
;       Registros afectados: A, X                         ;
;                                                         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
limpiar_bufer:

            pshs a, x

            lda #' 
            sta ,x+
            sta ,x+
            sta ,x+
            sta ,x+
            sta ,x+

            ldb #'\0 ; terminamos el caracter
            clr ,x  

            puls a, x
            rts







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                         ;
;   traducir_morse                                        ;
;                                                         ;
;       busca la cadena apuntada por Y en la tabla        ;
;       de morse proporcionada                            ;
;                                                         ;
;       Entrada: Y - direccion de inicio del bufer        ;
;                a traducir                               ;
;       Salida:  A - caracter ascii traducido o 0         ;
;                si hay error                             ;
;       Registros afectados: A.                           ;
;                                                         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


traducir_morse:

        pshs x,b

        ldx #tabla_morse
        ldb #0

        buscar_loop:
                jsr compara_cadenas ; si A=0 entonces son iguales
                tsta
                beq obtener_letra

                leax 6,x
                incb
                cmpb tabla_morse_Total
                blo buscar_loop

                ; si llega aqui es un error

                clra
                bra fin_trad


        obtener_letra:

                cmpb tabla_morse_Char
                blo its_letra
                
                ;aqui es un numero
                subb tabla_morse_Char
                addb #'0
                bra guardar_indice

        its_letra:
                addb #'A

        guardar_indice:
                tfr b,a

        fin_trad:
                puls x,b
                rts



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                         ;
;   toupper (VERSION ASM)                                 ;
;                                                         ;
;       pasa a mayusculas la letra minuscula              ;
;       introducida por el teclado                        ;
;                                                         ;
;       Entrada: A                                        ;
;       Salida:  A                                        ;
;                                                         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        toupper:
                cmpa #'a
                blo not_lower
                cmpa #'z
                bhi not_lower ; si esta o por encima o por debajo del rango de las letras, no nos intersa
                suba #32


                not_lower:
                rts