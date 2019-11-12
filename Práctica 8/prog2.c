#include <16f877.h>  //Libreria del microprocesador
#fuses HS,NOPROTECT,    //Configuración fusibles: Frec. del Oscilador; quitamos protección del controlador
#use delay(clock=20000000) //Valor del cristal
#org 0x1F00, 0x1FFF void loader16F877(void) {}  //Reservamos espacio de memoria
void main(){   
	while(1){
 		output_b(0xFF);  //Se enciende el bit 0 del puerto B
 		delay_ms(1000);  //Se hace un retardo de 1 seg
	 	output_b(0x00);  //Se apagan todos los bits del puerto B
 		delay_ms(1000);  //Se hace un retardo de 1 seg
	}//while
}//main
