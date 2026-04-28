            .module  holamundo
            .include "morse_table.inc"

            .area CODE1 (ABS)

            ;definimos las constantes que va a usar el programa

pantalla    .equ    0xFF00
teclado     .equ    0xFF02
fin         .equ    0xFF01

            .org    0x1000
            

            ; MENU PRINCIPAL
menu_0:     .ascii "PrActica MORSE v0.1\n\n"
            .ascii "1)Ver tabla\n"
            .ascii "2)Texto a Morse\n"
            .ascii "3)Morse a Texto\n"
            .ascii "S)Salir\n\n"
            .asciz ">>Teclee una opcion: \n\n"

            

            ; SUBMENÚ 1: TEXTO A MORSE
submenu2:   .ascii "\n\n 2) TEXTO A MORSE\n\n"
            .ascii "1)Caracter a caracter\n"
            .ascii "2)Palabra a palabra\n"
            .ascii "3)Linea a linea\n"
            .ascii "S)Volver\n\n"
            .asciz ">>Teclee una opcion: \n\n"

submenu3:   .ascii "\n\n 3) MORSE A TEXTO \n\n"
            .ascii "1)Caracter a caracter\n"
            .ascii "2)Palabra a palabra\n"
            .ascii "3)Linea a linea\n"
            .ascii "S)Volver\n\n"
            .asciz ">>Teclee una opcion: \n\n"

            ; cabecera de la primera opcion del menu, solo mostrar la tabla 
ver_tabla:  .asciz "\n\n 1) TABLA MORSE: \n\n"

            ; cabeceras de las opciones de cada opcion del submenu 2 
            
c_a_c:      .asciz "\n\n 2.1) TEXTO A MORSE (Caracter a Caracter): \n\n"
p_a_p:      .asciz "\n\n 2.2) TEXTO A MORSE (Palabra a Palabra): \n\n"
l_a_l:      .asciz "\n\n 2.3) TEXTO A MORSE (Linea a Linea): \n\n"

m_c_a_c:    .asciz "\n\n 3.1) MORSE A TEXTO (Caracter a Caracter): \n\n"
m_p_a_p:    .asciz "\n\n 3.2) MORSE A TEXTO (Palabra a Palabra): \n\n"
m_l_a_l:    .asciz "\n\n 3.3) MORSE A TEXTO (Linea a Linea): \n\n"



            ; cabeceras de las opciones de la tercera opcion del menu principal



            .globl programa 
            .globl imprime_cadena ; imprime una cadena hasta el \0
            .globl imprime_tabla ; subrutina de la opcion numero 1 del menu (imprime la tabla de morse completa)
            .globl car_car ; subrutina de la opcion 2.1 del menú (caracter a caracter)
            .globl pal_pal ; subrutina de la opcion 2.2 del menú (palabra a palabra)
            .globl lin_a_lin ; subrutina de la opcion 2.3 del menú (línea a línea)
            .globl m_car_a_car ; subrutina de la opcion 3.1 del menú (caracter a caracter)
programa: 

            lds #0xFF00     ;inicializar la pila
nucleo:     ldx #menu_0
            jsr imprime_cadena 



            lda teclado
            cmpa #'1
            beq mostrar_submenu1
            cmpa #'2
            beq mostrar_submenu2
            cmpa #'3
            beq mostrar_submenu3
            cmpa #'S
            lbeq acabar
            cmpa #'s
            lbeq acabar
            bra nucleo

            



mostrar_submenu1:   ;salto a la subrutina del submenu 1

    ldx #ver_tabla
    jsr imprime_cadena 

    jsr imprime_tabla
    lda #'\n
    sta pantalla
    sta pantalla
    sta pantalla

    bra nucleo

            
mostrar_submenu2: 

    ldx #submenu2
    jsr imprime_cadena



    lda teclado
    cmpa #'1
    beq caracter_a_caracter
    cmpa #'2
    beq palabra_a_palabra
    cmpa #'3
    beq linea_a_linea
    cmpa #'S
    beq nucleo
    cmpa #'s
    bra nucleo
   

    

        caracter_a_caracter:

            ldx #c_a_c
            jsr imprime_cadena ; imprimimos el titulo de la opcion y saltamos a la subrutina

            jsr car_car

            bra mostrar_submenu2
            
            
            


        palabra_a_palabra: 

            ldx #p_a_p
            jsr imprime_cadena

            jsr pal_pal

            bra mostrar_submenu2

        linea_a_linea:

            ldx #l_a_l
            jsr imprime_cadena

            jsr lin_a_lin

            bra mostrar_submenu2
            
            bra nucleo
        
            

            
            
mostrar_submenu3:
        ldx #submenu3
        jsr imprime_cadena

        lda teclado
        cmpa #'1
        beq m_caracter_a_caracter
        cmpa #'2
        beq m_palabra_a_palabra
        cmpa #'3
        beq m_linea_a_linea
        cmpa #'s
        lbeq nucleo
        cmpa #'S
        lbra nucleo

            m_caracter_a_caracter:
            ldx #m_c_a_c
            jsr imprime_cadena

            jsr m_car_a_car
            ;llamada a la subrutina que haga la opcion 3.1 del menú principal

            bra mostrar_submenu3
            
            m_palabra_a_palabra:
            ldx #m_p_a_p
            jsr imprime_cadena

            ; llamada a la subrutina que haga la opcion 3.2 del menú principal

            bra mostrar_submenu3

            m_linea_a_linea:

            ldx #m_l_a_l
            jsr imprime_cadena

            ; llamada ala subrutna que haga la opcion 3.3 del menu ppal

            bra mostrar_submenu3
            
            lbra nucleo
         
    acabar:
    clra 
    sta fin

    .area   PROG(ABS)
    .org    0xFFFE
    .word   programa