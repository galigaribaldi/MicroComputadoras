#include <16f877.h>  //Librer�a del microcontrolador
#device ADC = 8   //Convertidor A/D indica resoluci�n de 8 bits
#fuses HS, NOPROTECT,
#use delay(clock = 20000000)  //Frec. de Osc. 20Mhz
//Configuraci�n del Puerto Serial
#use rs232(baud = 9600, xmit = PIN_C6, rcv = PIN_C7)
#org 0x1F00, 0x1FFF void loader16F877(void) {}

int var; //Variable tipo entero
float volt; //Variable tipo flotante
int16 contador = 0;

#int_rtcc   //Desbordamiento del TIMER0
clock_isr() {  //Rutina de interrupci�n por TIMER0
   contador++; //Incrementa contador 
   if (contador == 770) {
      output_b(var);  //Se muestra  resultado como salida 
      printf(" Valor = %u     Valor = %x     Voltaje = %f\n\r", var, var, volt);   //Imprime en pantalla  resultado 
      contador = 0;  //Inicializa contador, se reinicia  
   }
}
void main() {

   setup_port_a(ALL_ANALOG);  //Configuraci�n del Puerto A como anal�gico
   setup_adc(ADC_CLOCK_INTERNAL);   //Configuraci�n del reloj interno ADC
   set_adc_channel(0);  //Configuraci�n del Canal 0 

   set_timer0(0);   //Inicia TIMER0 en 00H

   setup_counters(RTCC_INTERNAL, RTCC_DIV_256); //Fuente de reloj y pre-divisor

   enable_interrupts(INT_RTCC);  //Habilita interrupci�n TIMER0
   enable_interrupts(GLOBAL); //Habilita interrupciones generales

   while (1) {                
      delay_us(20);  //Retardo de 20 microsegundos
      var = read_adc(); //var = valor de ADC 
      volt= var/51.0;   //Conversi�n de var a volts
      delay_us(20);  //Retardo de 20 microsegundos
   }
}
