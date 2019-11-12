#include <16f877.h>  //Se incluye la libreria con las funciones del PIC
#fuses HS,NOPROTECT, //Configuración fusibles: Frec. del Oscilador; quitamos protección del controlador
#use delay(clock=20000000) //Se establece la frecuencia de oscilación de 20 MHz
#use rs232(baud=38400, xmit=PIN_C6, rcv=PIN_C7)   //Se configura y habilita el puerto serie para el baud rate establecido
#org 0x1F00, 0x1FFF void loader16F877(void) {}  //Reservamos espacio de memoria
void main(){
   char c;            //Variable tipo char para el switch
   int i,dato;         //Variables enteras para contador y dato
   output_b(0x00);      //Se limpia el puerto B
   while(1){
      c=getch();      //Se lee el caracter del teclado
      putc(c);      //Se coloca el caracter leido en la terminal
      switch (c) 
      {
         case ('0'):
         {
            output_b(0x00);   //Se apagan todos los leds del puerto B
            printf(" Todos los leds apagados \n\r");
            delay_ms(500);   //Retardo de medio segundo
            break;
         }
         case ('1'):
         {
            output_b(0xFF);   //Se prenden todos los leds del puerto B
            printf(" Todos los leds encendidos \n\r");
            delay_ms(500);    //Retardo de medio segundo
            break;
         }
         case ('2'):
         {
            printf(" Corrimiento a la derecha \n\r");
            dato=0x80;      //Dato inicial: '10000000'
            output_b(dato);   //Se coloca en el puerto B
            delay_ms(500);    //Retardo de medio segundo
            for(i=0;i<7;i++)   //Ciclo for para hacer corrimiento 7 veces
            {
               dato=(dato>>1);   //Se realiza corrimiento a la derecha
               output_b(dato);   //Se carga el nuevo dato en el puerto B
               delay_ms(500);    //Retardo de medio segundo
            }
            break;
         }
         case ('3'):
         {
            printf(" Corrimiento a la izquierda \n\r");
            dato=0x01;      //Dato inicial: '00000001'
            output_b(dato);   //Se coloca en el puerto B
            delay_ms(500);     //Retardo de medio segundo
            for(i=0;i<7;i++)   //Ciclo for para hacer corrimiento 7 veces
            {
               dato=(dato<<1);   //Se realiza corrimiento a la izquierda
               output_b(dato);   //Se carga el nuevo dato en el puerto B
               delay_ms(500);     //Retardo de medio segundo
            }
            break;
         }
         case ('4'):
         {
            printf(" Corrimiento a la derecha e izquierda \n\r");
            dato=0x80;      //Dato inicial: '10000000'
            output_b(dato);   //Se coloca en el puerto B
            delay_ms(500);     //Retardo de medio segundo
            for(i=0;i<7;i++)   //Ciclo for para hacer corrimiento 7 veces
            {
               dato=(dato>>1);   //Se realiza corrimiento a la derecha
               output_b(dato);   //Se carga el nuevo dato en el puerto B
               delay_ms(500);     //Retardo de medio segundo
            }
            for(i=0;i<7;i++)   //Ciclo for para hacer corrimiento 7 veces
            {
               dato=(dato<<1);   //Se realiza corrimiento a la izquierda
               output_b(dato);   //Se carga el nuevo dato en el puerto B
               delay_ms(500);     //Retardo de medio segundo
            }
            break;
         }
         case ('5'):
         {
            output_b(0xFF); //Se prenden todos los leds del puerto B
            printf(" Todos los leds encendidos \n\r");
            delay_ms(500);     //Retardo de medio segundo
            output_b(0x00);   //Se apagan todos los leds del puerto B
            printf("  Todos los leds apagados \n\r");
            delay_ms(500);     //Retardo de medio segundo
            break;
            }
         default:   //Caso por defecto si se aprieta un caso no valido
         {
            output_b(0x00);
            printf(" Por favor elige un caso valido\n\r");
            delay_ms(500);     //Retardo de medio segundo
            break;
         }
      }
   }
}

