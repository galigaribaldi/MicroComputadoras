#include <16f877.h>
#fuses HS,NOPROTECT,
#use delay(clock=20000000)
#use rs232(baud=9600, xmit=PIN_C6, rcv=PIN_C7)  //Se configura y habilita el puerto serie para el baud rate establecido
#org 0x1F00, 0x1FFF void loader16F877(void) {} //for the 8k 16F876/7
void main(){
	while(1){
 		output_b(0xff);  //Se encienden todos los bits del puerto B
 		printf(" Todos los bits encendidos \n\r");  //Se muestra el mensaje en la terminal
 		delay_ms(1000);
 		output_b(0x00);  //Se apagan todos los bits del puerto B
 		printf(" Todos los leds apagados \n\r"); //Se muestra el mensaje en la terminal
 		delay_ms(1000);
	}//while
}//main
