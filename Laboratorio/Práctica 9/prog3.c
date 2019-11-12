#include <16f877.h>  //Librería del microcontrolador
#device ADC = 8   //Convertidor A/D indica resolución de 8 bits
#fuses HS, NOPROTECT,
#use delay(clock = 20000000) //Frec. de Osc. 20Mhz
//Configuración Puerto SERIAL
#use rs232(baud = 9600, xmit = PIN_C6, rcv = PIN_C7)
#org 0x1F00, 0x1FFF

void loader16F877(void) {}
float volt; //Variable tipo flotante
//Definición de variables 
int var; //Variable tipo entero
int16 contador = 0;

#int_rtcc      //Rutina de interrupción del Timer0

clock_isr() {   //Rutina de atención a la interrupción por Timer0
   contador++;
   if (contador == 2310) {
      printf("\nLaboratorio de Micromputadoras\n");
      contador = 0;
   }
}

void main() {
   setup_port_a(ALL_ANALOG);     //Configura PORTA como analógico
   setup_adc(ADC_CLOCK_INTERNAL);//Reloj interno de Conv. A/D
   set_adc_channel(0);           //Selección del Canal 0
   set_timer0(0);                //Inicia el Timer0 en 00H
   setup_counters(RTCC_INTERNAL, RTCC_DIV_256); //Fuente de reloj y pre-divisor
   enable_interrupts(INT_RTCC);//Habilita interrupción por Timer0
   enable_interrupts(GLOBAL); //Habilita interrupciones generales

   while (1) {
      delay_us(20);     //Retardo 
      var = read_adc();   //Lee el resultado de la Conversión
      volt= var/51.0;   //Conversión de var a volts
      delay_us(20);     //Retardo
      printf(" Valor = %u     Valor = %x     Voltaje = %f\n\r", var, var, volt);   //Imprime en pantalla el resultado 
      delay_ms(100);    //Retardo
   }
}
