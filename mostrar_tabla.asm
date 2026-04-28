                .module mostrar_tabla

                

    ;constantes del prog


pantalla    .equ 0xFF00

            .globl imprime_tabla
            .globl imprime_cadena
            .globl tabla_morse


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;   imprime_tabla
;       saca por pantalla la tabla de correspondencias del 
;       código morse proporcionada en el enunciado de la 
;       práctica mediante dos bucles, uno para las letras de la A-Z
;       y otro para los numeros del 1-9
;          
;       Entrada: nada 
;       Salida: void
;       Registros afectados: x, C.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

imprime_tabla: 

    ldx #tabla_morse    

    lda #'A
    ldb #26 ; cargamos el registro A con el valor del primer caracter que
            ; nos interesa imprimir (A) y el b con el del límite de las letras
            ; y al final del bucle incrementamos el registro A y decrementamos el B
            
bucle_letras:
    sta pantalla
    pshs a
    lda #'-
    sta pantalla
    lda #'>
    sta pantalla
    puls a
    jsr imprime_cadena ; llamamos a imprime_cadena, ya que cada valor del morse
                       ; es un asciz, entonces podemos usar dicha subrutina
    pshs a
    lda #'\n
    sta pantalla
    puls a
    inca
    decb
    bne bucle_letras

    ;preparamos el terreno para el siguiente bucle, ya no necesitamos que A y B tengan
    ;letras, ahora ponemos los números con un bucle con la misma logica

    
    lda #'0
    ldb #10

bucle_numeros:

    sta pantalla 
    pshs a
    lda #'-
    sta pantalla
    lda #'>
    sta pantalla
    puls a
    jsr imprime_cadena
    pshs a
    lda #'\n
    sta pantalla
    puls a
    inca 
    decb
    bne bucle_numeros

    rts
    