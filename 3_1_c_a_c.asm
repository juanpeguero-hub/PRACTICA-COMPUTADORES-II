        .module m_c_a_c

        .area CODE6 (ABS)
        .org 0x7000



bufer_morse: .asciz "     "; como asciz acaba la cadena en \0, es útil para lo que buscamos en esta opcion
                           ; pero la jodienda es que hay que limpiar el bufer en cada caracter para que no se
                           ; quede basura de la opcion anterior

err_dim:     .asciz "ERROR LOGITUD ENTRADA"  ; muestra esto y vuelve al menu anterior
err_car:     .asciz "ERROR CARACTER ENTRADA"
err_val:     .asciz "CODIGO NO VALIDO"

limite_car:  .byte #5

pantalla    .equ 0xFF00
teclado     .equ 0xFF02



            .globl imprime_cadena
            .globl tabla_morse
            .globl m_car_a_car
            .globl compara
            .globl compara_cadenas



m_car_a_car:    
        
        limpiar_bufer: ; apuntamos al bufer, cargamos D con 2 espacios y escribimos lo almacenado en D
                       ; en donde este apuntando X, con incremento de 2 bytes   

            ldx #bufer_morse

            lda #' 
            sta ,x+
            sta ,x+
            sta ,x+
            sta ,x+
            sta ,x+
            

            ldb #'\0 ; terminamos el caracter
            stb ,x      

            
        ldx #bufer_morse ; ponemos el puntero otra vez al inicio del bufer
        ldb #0           ; uso el registro b como contador, inicializandolo a 0

        


        input:
        

        
        lda teclado  
        cmpa #'-
        beq buen_caracter
        cmpa #'.
        beq buen_caracter
        cmpa #' 
        beq fin_ASCII
        cmpa #'\n
        beq fin_ASCII
        bra error_caracter ; si llega aqui sin saltar a buen_caracter, es que es un caracter invalido 
                           ; (no es ni punto ni raya ni espacio/enter)


         
        fin_ASCII: 
                ldy #bufer_morse
                ldx #tabla_morse
                ldb #0

                buscar: 
                        
                        jsr compara_cadenas

                        tsta
                        beq traduccion

                        leax 6, x ; le sumamos 6 para que empieze en el siguiente caracter de morse para comparar
                        incb
                        cmpb #36
                        blo buscar
                        cmpb #36
                        bge imprimir_error_valido






        buen_caracter: 
                ; el caracter introducido es valido, lo guardamos, comprobamos el límite y pedimos otro
                

                sta ,x+
                incb
                cmpb limite_car
                bls input
                cmpb limite_car
                bgt imprimir_error_dim

        error_caracter:

                cmpa #'0
                bls imprimir_error_car 
                cmpa #'Z
                bls imprimir_error_car

                imprimir_error_car:
                        
                        ldx #err_car
                        jsr imprime_cadena

                        rts

                imprimir_error_dim:

                        ldx #err_dim
                        jsr imprime_cadena

                        rts

                imprimir_error_valido:

                        ldx #err_val
                        jsr imprime_cadena

                        rts


        
        traduccion: ; tengo en b el caracter con el indice de la tabla
                    ; ahora hay que imprimir su equivalente, detectando qué es exactamente en b
                    ; letra o numero
        

                cmpb #25
                bls es_let
                
                subb #26
                addb #'0
                bra fin_trad

                es_let:
                        addb #'A


                fin_trad:
                        stb pantalla

                        lda #'\n
                        sta pantalla

                        lbra limpiar_bufer

