              ORG  0000H      ;Origen del reset
              JP   0100H      ;Direccion del programa principal
;**************************
              ORG  0100H      ;Programa principal
INICIO:       LD   SP,27FFH   ;Dirección de pila
              LD   A,089H     ;PA = Salida, PB = Salida, PC = Entrada
              OUT  (03H),A    ;Configura el PPI
;**************************
CONFIG:      LD   HL,0200H    ;Posicion de la tabla de comandos
OTROCOM:     LD   A,(HL)      ;Recupera valor de comando
             CP   '$'         ;Checa si es el fin de la tabla
             JP   Z,LINEA1    ;Salta a escribir en la primera linea
             OUT  (00H),A     ;Escribe el comando en el puerto
             CALL COMANDO     ;Ejecuta la subrutina para envio al LCD
             INC  HL          ;Incrementa el indice de la tabla
             JP   OTROCOM     ;Ejecuta el siguinte comando
;**************************
LINEA1:      LD   HL,0250H    ;Posicion del primer mensaje
             CALL OTRALET     ;Checa si hay mas letras
LINEA2:      LD   A,0C0H      ;Cambia a segunda linea del display
             OUT  (00H),A     ;Envia el comando
             CALL COMANDO     ;Ejecuta la subrutina para envio al LCD
;**************************
             LD   HL,0260H    ;Poscion del segundo mensaje
             CALL OTRALET     ;Checa si hay mas letras
;**************************
FIN:         LD   A,18H       ;Mueve el letrero hacia la izquierda
             OUT  (00H),A     ;Envia el comando al LCD
             CALL COMANDO     ;Ejecuta la subrutina para el envio del LCD
             JP   FIN         ;Realiza un ciclo infinito
;**************************
OTRALET:     LD   A,(HL)      ;Lee el dato de la memoria
             CP   '$'         ;Checa si es el final de la cadena
             RET  Z           ;Si es el final termina la subrutina
             OUT  (00H),A     ;Envia el comando hacia el LCD
             CALL DATO        ;Ejecuta la subrutina de envio de caracter
             INC  HL          ;Incrementa el indice de la tabla
             JP   OTRALET     ;Repite el proceso letra por letra
;**************************
COMANDO:     LD   A,00H       ;Activa RS=0 y E=0
             OUT  (01H),A
             LD   A,01H       ;Activa RS=0 y E=1
             OUT  (01H),A
             LD   A,00H       ;Activa RS=0 y E=0
             OUT  (01H),A
             CALL TIEMPO      ;Consume 10 ms de tiempo
             RET
;**************************
DATO:        LD   A,02H       ;Activa RS=1 y E=0
             OUT  (01H),A
             LD   A,03H       ;Activa RS=1 y E=1
             OUT  (01H),A
             LD   A,02H       ;Activa RS=1 y E=0
             OUT  (01H),A
             CALL TIEMPO      ;Consume 10 ms de tiempo
             RET
;**************************
TIEMPO:      LD   A,05H       ;Decrementa 2 registros en
CICLO2:      LD   B,05H       ;forma recursiva
CICLO:       DEC  B           ;Decrementa 255 veces el
             JP   NZ,CICLO    ;numero 255
             DEC  A
             JP   NZ,CICLO2
             RET
;**************************
             ORG  0200H       ;Direccion de tabla de comandos
             DB   01H         ;Limpia el display
             DB   02H         ;Regreso al origen
             DB   06H         ;Insercion de datos con incermento
                              ;y display fijo
	     DB   0FH         ;Display, cursor y parpadeo encendido
	     DB   38H         ;8 bits, 2 lineas y caracteres de 5x7
	     DB   080H        ;Primer caracter de linea 1
	     DB   '$'         ;Indicador de fin de tabla
;**************************
             ORG  0250H       ;Tabla de caracteres de linea 1
             DB   "Laboratorio de$"
             ORG  0260H       ;Tabla de caracteres de linea 2
             DB   "Microprocesadore"
             ORG  0270H       ;continuacion de linea 2
             DB   "s ITSE$"
             END