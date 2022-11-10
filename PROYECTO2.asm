;********************************************************************
;Alumnno: Alejo Brites               DNI:44182530                   * 
;Fecha de entrega:11/11/2022                                        *
;Profesor: Roberto Garcia          PIC16F628A                       *
;En este programa encenderemos 4 leds varias veces, y de diferentes *
;maneras atraves de subrutinas                                      *
;Dispositivo: PIC16F628A                                            *
;********************************************************************

;********************************************************************
;                         DATOS                                     *
;********************************************************************

		__CONFIG 3F10
		LIST p=16F628A
		INCLUDE <p16F628A.INC>
		ERRORLEVEL -302 
;********************************************************************
;                          DEFINICIONES                             *
;********************************************************************

ACUMULADOR1 EQU 0x20 ;Reservamos espacio de memoria para la variable ACUMULADOR1
ACUMULADOR2 EQU 0x21 ;Reservamos espacio de memoria para la variable ACUMULADOR2
ACUMULADOR3 EQU 0x22 ;Reservamos espacio de memoria para la variable ACUMULADOR3
ACUMULADOR4 EQU 0x23 ;Reservamos espacio de memoria para la variable ACUMULADOR4

;********************************************************************

            ORG 0x00         

;********************************************************************
INICIO

		call CONFIGURACION_DE_PUERTOS
	
		call RETARDO_DE1S

		call PRENDER_LEDS  ;Prendo y apago los leds
		
		call RETARDO_DE1S   ;retardo de tres segundos para diferenciar
		call RETARDO_DE1S   ;las subrutinas
		call RETARDO_DE1S
	
     	call PRENDERYAPAGAR_LEDS ;Prendo y apago cada un segundo
		call RETARDO_DE1S
		call PRENDERYAPAGAR_LEDS
		call RETARDO_DE1S

		call RETARDO_DE1S
		call RETARDO_DE1S
		call RETARDO_DE1S
		
        call PRENDERYAPAGAR_LEDS  ;Prendo los leds 1 segundo
		call RETARDO_DE500ms   ;y los mantego apagados 500ms
		call PRENDERYAPAGAR_LEDS  ;...
		call RETARDO_DE500ms     ;...
		call PRENDERYAPAGAR_LEDS  ;...
		call RETARDO_DE500ms     ;...
		
		call RETARDO_DE1S
		call RETARDO_DE1S
		call RETARDO_DE1S

		call PRENDER_LEDS_DE_A_UNO  
	
		call APAGAR_LEDS_DE_A_UNO

		call RETARDO_DE500ms	

		goto INICIO
;********************************************************************
CONFIGURACION_DE_PUERTOS
			
		bsf    STATUS,RP0 ;Nos movemos al Banco 1 para
		movlw  B'11110000'  ;configurar los bits 0,1,2,3 del PORTB
		movwf  TRISB     ;como salida
		bcf    STATUS,RP0 ;Y volvemos al Banco 0 para
		movlw  B'00000000' ;setear en 0 el PORTB y matener los led apagados
		movwf  PORTB

;********************************************************************

PRENDER_LEDS

		bcf    STATUS,RP0   ;Nos movemos al banco 0 para
		movlw  b'00001111'  ;prender los leds de los bits 0,1,2,3
		movwf  PORTB        ;del PORTB
		call   RETARDO_DE500ms 
		clrf   PORTB       ;luego del delay con el clrf apago todos los leds

		return
;********************************************************************

PRENDERYAPAGAR_LEDS

		bcf    STATUS,RP0 ;Nos movemos al banco 0 y hacemos lo mismo que
		movlw  b'00001111' ;la subrutina PRENDER_LEDS, solamente que
		movwf  PORTB      ; en este quenero un retardo de 1seg
		call   RETARDO_DE1S
		clrf   PORTB

		return

;********************************************************************

PRENDER_LEDS_DE_A_UNO

		bcf    STATUS,RP0    ;con esta subrutina lo que hacemos es
		bsf	   PORTB,0       ;atravez del "bsf", poner en 1 los bits 
		call   RETARDO_DE500ms  ;0,1,2,3 del PORTB, uno por uno
		bsf	   PORTB,1         ;para que se vayan prendiendo de a uno
		call   RETARDO_DE500ms
		bsf	   PORTB,2 
		call   RETARDO_DE500ms 
		bsf	   PORTB,3 
		call   RETARDO_DE500ms
		
		return

;********************************************************************

APAGAR_LEDS_DE_A_UNO

		bcf    STATUS,RP0       ;en esta subrutina basicamente haremos 
		bcf	   PORTB,3          ;haremos los mismo que la subrutina 
		call   RETARDO_DE500ms  ;PRENDER_LEDS_DE_A_UNO pero, apagaremos los
		bcf	   PORTB,2          ;leds de a uno con el uso del "bcf" de abajo
		call   RETARDO_DE500ms   ;hacia arriba
		bcf	   PORTB,1 
		call   RETARDO_DE500ms 
		bcf	   PORTB,0 
		call   RETARDO_DE500ms
		
		return
		
;********************************************************************
;                           RETARDOS                                *
;********************************************************************
;son los mismos del primer ejercicio, agregnado el de 500 ms

RETARDO_DE1MS                  ;RETARDO PARA 1 MILISEGUNDO YA QUE 256 ES EL MAXIMO DEL PIC

		movlw d'250'            ;cargamos el registro de trabajo
		movwf ACUMULADOR1       ; para luego moverlo al ACUMULADOR1
RETARDOAUX1 
        nop
        decfsz ACUMULADOR1,F    ;con esta instruccion decremento el ACUMULADOR1 hacemos esto hasta que 
        goto RETARDOAUX1        ;se haya decrementado a 0, lo que significa 1ms de retardo
        RETURN
;********************************************************************

RETARDO_DE250MS                 ;con esta subrutina generaremos 250 ms
         movlw D'250'            ;Cantidad de veces que voy a llamar a la subrutina "RETARDOS_DE1MS"
         movwf ACUMULADOR2

RETARDOAUX2   
         call   RETARDO_DE1MS        ;llamamos al retardo de 1ms para por cada vuelta a RETARDOAUX2
         decfsz    ACUMULADOR2,F     ;vayamos decrementando en uno los 250 del ACUMULADOR1
         goto RETARDOAUX2            ;Lo repito hasta ACUMULADOR2 que quede en 0. Lo cual seria,250ms de retardo
         RETURN

;********************************************************************

RETARDO_DE500ms                    ;con esta subrutina generaremos 500 ms osea  0,5seg
         movlw     D'2'         ;Cantidad de veces que voy a llamar a la subrutina "RETARDO_DE250MS"
         movwf     ACUMULADOR3

RETARDOAUX3      
	     call  RETARDO_DE250MS     ;Al llamarlo 2 veces vamos a generar 0,5seg
         decfsz     ACUMULADOR3,F  ;decrementamos hasta que
         goto   RETARDOAUX3        ;ACUMULADOR3 quede en 0
         RETURN

;********************************************************************

RETARDO_DE1S                    ;con esta subrutina generaremos 1000 ms osea 1 seg
         movlw     D'2'         ;Cantidad de veces que voy a llamar a la subrutina "RETARDO_DE250MS"
         movwf     ACUMULADOR4

RETARDOAUX4      
	     call  RETARDO_DE500ms      ;Al llamarlo 4 veces vamos a generar 1seg
         decfsz     ACUMULADOR4,F  ;decrementamos hasta que
         goto   RETARDOAUX4        ;ACUMULADOR3 quede en 0
         RETURN



;********************************************************************
		END