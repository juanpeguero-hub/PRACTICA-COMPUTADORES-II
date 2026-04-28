        .module cadenas

        
cadenas_iguales: .asciz "IGUALES"
cadenas_dif:     .asciz "DISTINTAS"


pantalla    .equ    0xFF00
teclado     .equ    0xFF02
fin         .equ    0xFF01

        
            .globl imprime_cadena
            .globl compara_cadenas
            .globl compara


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
;
;   compara_cadenas
;
;       compara la cadena X e Y que deben tener el mismo tamanio
;       ademas, la cadena de X debe estar terminada por un \0
;          
;       Entrada: X-direccion de comienzo de la cadena X
;                Y-direccion de comienzo de la cadena Y
;       Salida: A=0 iguales, distinto diferentes
;       Registros afectados: , CC.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


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
;
;   compara
;
;       compara la cadena X e Y que deben tener el mismo tamanio
;       ademas, la cadena de X debe estar terminada por un \0
;       y saca por pantalla un mensaje diciendo si son iguales
;       o distintas
;          
;       Entrada: X-direccion de comienzo de la cadena X
;                Y-direccion de comienzo de la cadena Y
;       Salida: 
;       Registros afectados: , CC.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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


;;;;;; SUBRUTUNA DE TRADUCCION, SOBRE TODO PARA LA TERCERA OPCION DEL MENU
