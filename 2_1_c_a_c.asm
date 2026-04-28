        .module c_a_c

        

        ;ctes
pantalla    .equ 0xFF00
teclado     .equ 0xFF02



        .globl imprime_cadena
        .globl tabla_morse
        .globl car_car



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;   car_car
;       recoge un caracter por teclado y lo clasifica para posteriormente
;       calcular un índice que se va a emplear para buscar su equivalente
;       en la tabla morse proporcionada 
;
;       Entrada: nada 
;       Salida: void
;       Registros afectados: A, B, X, S, C.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    car_car:
        
        lda teclado
        
        cmpa #' 
        beq es_espacio 
        cmpa #'0       ; si el caracter esta por debajo del 0 (<48), es invalido
        blo falla
        cmpa #'9        ; lo que hay en A es >= 0, entonces comprobamos el límite superior con bls
        bls es_numero
        cmpa #'A
        blo falla
        cmpa #'Z
        bls es_letra
        bra falla

        

        es_espacio:
            lda #' 
            sta pantalla
            sta pantalla; si es espacio, lo cambiamos por dos espacios
            bra car_car

        es_numero:

        tfr a, b
        suba #'0
        adda #26 ; como los numeros estan despues de las letras en la tabla, para conseguir el indice estamos sumando
                 ; 26. Ahora el caracter original esta en B y el indice que hemos creado esta en A
        bra imprimir
        

        es_letra:
        tfr a, b    ; en ambos casos (tanto si es numero como si es letra), guardamos 
                    ; el caracter original leido de teclado para imprimirlo al lado de su 
                    ; equivalente en morse en la siguiente subrutina

        suba #'A    ; restamos el ASCII de la A, que es 65. En este caso, si la letra es una C, 67-65 =2, que es el elemento 2 
                    ; de la tabla
        


        imprimir:   ; como tenemos en el registro A un indice inventado con la resta que hicimos(0,1,2..)
                    ; y en el registro B tenemos el caracter original que se introdujo
                    ; podemos usar la pila para ir imprimiendo cada caracter


        pshs a 
       
        
           
                     ; dejo el indice que he "fabricado" en la pila e imprimo cosas con el registro A 
        lda #'-
        sta pantalla
        lda #'>
        sta pantalla
        lda #'(
        sta pantalla
        puls a      ; saco el indice de la pila

        pshs b      ; para calcular la posicion del byte de la memoria donde empieza el morse del caracter
                    ; sabiendo que cada una de las cadenas de la tabla ocupa 6 bytes, podemos calcular el desplazamiento
                    ; multiplicando el indice * 6
        ldb #6  
        mul

        addd #tabla_morse
        tfr d, x

        jsr imprime_cadena

        lda #')
        sta pantalla
        lda #'\n
        sta pantalla

        puls b
        bra car_car         

        falla: ;volvemos al menu
            rts

    