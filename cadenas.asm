        .module cadenas

        .area CODE3 (ABS)
        .org 0x3000

        ;ctes

pantalla    .equ    0xFF00
teclado     .equ    0xFF02
fin         .equ    0xFF01

        
            .globl imprime_cadena


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

sgte:   lda ,x+
        beq ret_imprime_cadena
        sta pantalla
        bra sgte
    
ret_imprime_cadena:
    puls    a
    rts

