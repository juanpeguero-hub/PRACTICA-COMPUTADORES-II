        .module m_p_a_p

palabra:   .blkb 100
limite_car:.byte #5

pantalla .equ 0xFF00
teclado  .equ 0xFF02

    .globl imprime_cadena
    .globl compara_cadenas
    .globl tabla_morse
    .globl compara
    .globl m_pal_a_pal


    m_pal_a_pal:

        ldx #palabra
        lda #'\n
        sta pantalla
        sta pantalla


        decidir_entrada:
            lda teclado
            cmpa #'-
            beq valido
            cmpa #'.
            beq valido
            cmpa #' 
            beq espacio
            cmpa #'\0
            beq fin_palabra
            bra errores



        valido:

            sta ,x+
            bra decidir_entrada


        espacio:    ;en espacio, tenemos dos opciones : o se mete otro espacio y 
                    ;terminamos la palabra y pedimos otra o se mete otro ./- y 
                    ;continuamos con la traduccion
           
           
           bra traduccion  
           lda teclado     
           cmpa #' 
           beq decidir_entrada
         
                 
        

            
            

       
            
        traduccion:  ; hay que hacer una subrutina de esto en cadenas o donde sea

        errores:




        fin_palabra:

        rts