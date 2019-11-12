#include <16f877.h>  //Librería del microcontrolador
#fuses HS, NOPROTECT,
#use delay(clock = 20000000) //Frec. de Osc. 20Mhz
//Configuración Puerto SERIAL
#use rs232(baud = 9600, xmit = PIN_C6, rcv = PIN_C7)
#org 0x1F00, 0x1FFF

void loader16F877(void) {}

//Definición de variables 
int var; //Variable tipo entero
int var2;
int16 contador = 0;

#int_rb //Rutina de interrupción

port_rb() {

   var2 = input_b(); //Lee la entrada en el puerto B

   if (var2 == 0x80)  //Interrupción PB7 Activada?
      printf("Interrupcion PB7 activada\n\r");
   if (var2 == 0x40)  //Interrupción PB6 Activada?
      printf("Interrupcion PB6 activada\n\r");
   if (var2 == 0x20)  //Interrupción PB5 Activada?
      printf("Interrupcion PB5 activada\n\r");
   if (var2 == 0x10)  //Interrupción PB4 Activada?
      printf("Interrupcion PB4 activada\n\r");
   if (var2 == 0x00)  //Interrupción desactiada?
      printf("Pulso de bajada\n\r");
}

#int_rtcc      //Rutina de interrupción del Timer0

clock_isr() {   //Rutina de atención a la interrupción por Timer0
   contador++;
   if (contador == 770) {
      contador = 0;
   }
}

void main() {

   Enable_interrupts(INT_RB); //Habilita interrupción por cambio de nivel en los cuatro bits más significativos del puerto B

   set_timer0(0);             //Inicia Timer0 en 00H
   setup_counters(RTCC_INTERNAL, RTCC_DIV_256); //Fuente de reloj y pre-divisor
   enable_interrupts(INT_RTCC);//Habilita interrupción por Timer0
   enable_interrupts(GLOBAL);  //Habilita interrupciones generales

   while (1) {
     
   }
}
