#include <16f877.h>
#fuses HS,NOPROTECT,
#use delay(clock=20000000)
#org 0x1F00, 0x1FFF void loader16F877(void) {} //for the 8k 16F876/7
int var1;
void main(){
	while(1){
		var1=input_a();   //Guarda el contenido del puerto A en var1
		output_b(var1);   //El valor de var1 se pasa al puerto B
	}//while
}//main
