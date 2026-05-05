


El código para ensamblar es:

ensambla kernel cadenas 1Mostrar 2Car 2Lin 2Pal 3Pal 3Car 3Lin morse_table





Los modulos son los siguientes:


kernel.asm


Contiene las cadenas de los menús, las cabeceras, y los saltos a subrutina dependiendo de qué tecla se haya pulsado.
Estas subrutinas enseñan la cabecera utilizando una subrutina contenida en cadenas.asm, y entonces saltan a las subrutinas principales de cada función del programa, guardadas en módulos secundarios(mostrar_tabla, 2_1_c_a_c, 2_2_p_a_p, 2_3_l_a_l, 3_1_c_a_c, 3_2_p_a_p, 3_3_l_a_l).
A continuación se profundizará en los módulos secundarios.
Al salir de las subrutinas principales, se vuelve al módulo principal para volver a enseñar el menú.
También está la subrutina para terminar el programa.

1Mostrar:


Se corresponde con la opción de mostrar la tabla de morse.
La subrutina saca por pantalla la tabla de correspondencias del código morse proporcionada en el enunciado de la práctica mediante dos bucles, uno para las letras de la A-Z y otro para los números del 1-9.    
Entrada: nada .
Salida: nada.
Registros afectados: A, B, X, S.


2Car:
Se corresponde con la opción de traducir texto a morse carácter a carácter. La subrutina recoge un carácter por teclado y lo clasifica para posteriormente calcular un índice que se va a emplear para buscar su equivalente en la tabla morse proporcionada, o en el caso del espacio, lo cambiará por dos.
Entrada: nada.
Salida: nada.
Registros afectados: A, B, X, S.




2Pal:


		Se corresponde con la opción de traducir texto a morse palabra a palabra.
La subrutina reserva memoria en la que guardar caracteres de una palabra, que recoge uno a uno.
Verifica si son válidos: si es válido, se incrementa el índice de la memoria y se guarda el carácter. Si es espacio, se añade un \0, y recorriendo los caracteres desde #palabra hasta el \0, buscamos su traducción al morse.
Si es inválido, se sale de la traducción.
		Entrada: nada.
		Salida: nada.
		Registros afectados: A, B, X, Y, S.


		

2Lin:
Se corresponde con la opción de traducir texto a morse línea a línea.
La subrutina reserva memoria en la que guardar caracteres de una línea, que recoge uno a uno.
Verifica si son válidos: si es válido, se incrementa el índice de la memoria y se guarda el carácter. Si es enter/return, se añade un \0, y recorriendo los caracteres desde #linea hasta el \0, buscamos su traducción al morse.
Si es inválido, se sale de la traducción.
		Entrada: nada.
		Salida: nada.
		Registros afectados: A, B, X, Y.

		
3Car:

	
	Se corresponde con la opción de traducir morse a texto caracter a caracter.
La subrutina reserva espacio para un búfer, y llama a una subrutina en cadenas.asm que lo limpia.
Posteriormente, comprueba si se ha introducido un punto/raya, un espacio/retorno, o ninguno de los anteriores, saltando a una subrutina diferente para cada una de las 3 opciones.
Si es un punto o raya, almacena lo introducido en el búfer, y comprueba si se ha superado el límite de símbolos. Si no se ha superado, vuelve a leer, mientras que si se ha superado, salta un error por dimensión inválida.
Si es un espacio o retorno, llama a una subrutina en cadenas.asm que busca la cadena en la tabla. Si no la encuentra, salta un error de código inválido
Si es un carácter inválido, salta un mensaje de error.
Para traducir, comprueba si el índice de cadenas por las que ha tenido que buscar corresponde con una letra o un número, y lo convierte en el ASCII que corresponde. Por último, vuelve a la línea donde se llama a la subrutina que limpia el búfer.
Posteriormente, comprueba si se ha introducido un punto o raya. Si es así, lo guarda en el búfer, verificando que no se haya superado el límite de 5 símbolos. Si es un espacio o retorno, traduce el carácter guardado en el búfer. Si no es ninguno de los anteriores, salta a una subrutina que enseña el mensaje de error para carácteres inválidos.
Entrada: nada.
Salida: nada.
Registros afectados: A, B, X, Y.



3Pal:



Se corresponde con la opción de traducir morse a texto palabra a palabra.
Se reserva espacio para la palabra y el búfer. 
Posteriormente, comprueba si se ha introducido un punto/raya, un espacio, un retorno, o ninguno de los anteriores, saltando a una subrutina diferente para cada una de las 4 opciones.
Si es un punto o raya, almacena lo introducido en el búfer, y comprueba si se ha superado el límite de símbolos. Si no se ha superado, vuelve a leer, mientras que si se ha superado, salta un error por dimensión inválida.
Si es un espacio, comprueba si el anterior fue un espacio. Si no lo es, traduce lo introducido en el búfer. Si lo es, imprime la cadena almacenada en palabra.
Si es un enter, traduce e imprime lo que haya quedado sin traducir.
Si no es ninguno de los anteriores, salta un error por carácter de entrada inválido.
Entrada: nada.
Salida: nada.
Registros afectados:A, B, X, Y, U.


3Lin:



Se corresponde con la opción de traducir morse a texto línea a línea.
Se reserva espacio para la línea y el búfer. 
Posteriormente, comprueba si se ha introducido un punto/raya, un espacio, un retorno, o ninguno de los anteriores, saltando a una subrutina diferente para cada una de las 4 opciones.
Si es un punto o raya, almacena lo introducido en el búfer, y comprueba si se ha superado el límite de símbolos. Si no se ha superado, vuelve a leer, mientras que si se ha superado, salta un error por dimensión inválida.
Si es un espacio, comprueba si el anterior fue un espacio. Si no lo es, traduce lo introducido en el búfer y lo almacena en línea. Si lo es, introduce un espacio en la cadena línea.
Si es un enter, traduce e imprime la línea.
Si no es ninguno de los anteriores, salta un error por carácter de entrada inválido.
Entrada: nada.
Salida: nada.
Registros afectados:A, B, X, Y, U.


cadenas:


Tiene una función parecida a un archivo cabecera, conteniendo 6 subrutinas necesarias en varios módulos diferentes.
La primera imprime una cadena hasta llegar a un \0
Entrada: X:dirección de comienzo de la cadena 
Salida: nada.
Registros afectados: A, X.

La segunda compara dos cadenas, asumiendo que la nº2 es de mayor o igual longitud a la nº1, y que la nº1 termine en \0.
Entrada: X:dirección de comienzo de la cadena nº1, Y:dirección de comienzo de la cadena nº2
Salida: A=0 iguales, distinto diferentes
Registros afectados: A, X, Y, S.

La tercera llama a la segunda, e imprime un mensaje por pantalla diciendo si son iguales o no.
Entrada: X:dirección de comienzo de la cadena X, Y:dirección de comienzo de la cadena Y
Salida: nada.
Registros afectados: A, X, Y, S.

La cuarta resetea un búfer hasta que sea solo espacios y un \0. También resetea el registro que almacena la cantidad de símbolos introducidos
Entrada: X:puntero a la dirección con el búfer que borrar.
Salida:nada.
Registros afectados: A, B, X, S

La quinta recorre todas las cadenas en la tabla morse buscando una que sea igual a la introducida. Después obtiene la letra asociada si la hay, si no la hay, introduce un \0.
Entrada: Y - dirección de inicio del búfer a traducir
Salida: A - caracter ascii traducido o 0 si hay error
Registros afectados: A, B, X, S.

La última realiza una función similar a toupper() de C, convirtiendo el carácter introducido por teclado en su equivalente en mayúsculas, realizando las comprobaciones necesarias y restando el valor constante necesario para facilitar la entrada por teclado
Entrada: A
Salida: A
Registros afectados: 
morse_table.inc & morse_table.asm
Se tratan de los módulos proporcionados por el profesor, sin modificar.

