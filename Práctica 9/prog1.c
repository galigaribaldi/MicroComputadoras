#include <16f877.h>  //Librer�a del microcontrolador
#fuses HS, NOPROTECT,
#device ADC = 8   //Convertidor A/D indica resoluci�n de 8 bits
#use delay(clock = 20000000) //Frec. de Osc. 20Mhz
//Configuraci�n del Puerto Serial
#use rs232(baud = 9600, xmit = PIN_C6, rcv = PIN_C7)
#org 0x1F00, 0x1FFF void loader16F877(void) {}

int var; // Variable tipo entero 
float volt; //Variable tipo flotante

void main() {
   
   setup_port_a(ALL_ANALOG);  //Configuraci�n del Puerto A como anal�gico 
   setup_adc(ADC_CLOCK_INTERNAL); //Reloj interno del Convertidor A/D
   set_adc_channel(0);    //Selecci�n del canal 0 

   while (1) {     
      delay_us(20);   // Retardo de 20 microsegundos 
      var = read_adc(); // Se asigna a var la lectura del Canal 0  
      volt= var/51.0;   //Conversi�n de var a volts
      delay_us(20);   // Retardo de 20 microsegundos
      output_b(var);  // Se muestra  var en el puerto B 
      printf(" Valor= %u   Valor= %x    Voltaje= %f\n\r", var, var, volt);   // Se imprime en pantalla lo que contiene var
      
   }
}
