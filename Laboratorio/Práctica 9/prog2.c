#include <16f877.h>  //Librería del microcontrolador
#device ADC = 8   //Convertidor A/D indica resolución de 8 bits
#fuses HS, NOPROTECT,
#use delay(clock = 20000000)  //Frec. de Osc. 20Mhz
//Configuración del Puerto Serial
#use rs232(baud = 9600, xmit = PIN_C6, rcv = PIN_C7)
#org 0x1F00, 0x1FFF void loader16F877(void) {}

int var; //Variable tipo entero
float volt; //Variable tipo flotante
int16 contador = 0;

#int_rtcc   //Desbordamiento del TIMER0
clock_isr() {  //Rutina de interrupción por TIMER0
   contador++; //Incrementa contador 
   if (contador == 770) {
      output_b(var);  //Se muestra  resultado como salida 
      printf(" Valor = %u     Valor = %x     Voltaje = %f\n\r", var, var, volt);   //Imprime en pantalla  resultado 
      contador = 0;  //Inicializa contador, se reinicia  
   }
}
void main() {

   setup_port_a(ALL_ANALOG);  //Configuración del Puerto A como analógico
   setup_adc(ADC_CLOCK_INTERNAL);   //Configuración del reloj interno ADC
   set_adc_channel(0);  //Configuración del Canal 0 

   set_timer0(0);   //Inicia TIMER0 en 00H

   setup_counters(RTCC_INTERNAL, RTCC_DIV_256); //Fuente de reloj y pre-divisor

   enable_interrupts(INT_RTCC);  //Habilita interrupción TIMER0
   enable_interrupts(GLOBAL); //Habilita interrupciones generales

   while (1) {                
      delay_us(20);  //Retardo de 20 microsegundos
      var = read_adc(); //var = valor de ADC 
      volt= var/51.0;   //Conversión de var a volts
      delay_us(20);  //Retardo de 20 microsegundos
   }
}
