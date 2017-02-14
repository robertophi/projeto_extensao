#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include "sys/alt_stdio.h"
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "altera_avalon_pio_regs.h"
#include "altera_avalon_uart_regs.h"
#include "altera_avalon_uart.h"
#include "sys/alt_irq.h"
#include "alt_types.h"

static void readMessage();
void serial_init();
void writeMessage();

//Volatile pra evitar erros do compilador
volatile char* data_ptr;



int main()
{
	int Send=68;
	char message[] = "Teste 123 abcd.";


	char ch;
	serial_init();
	while(1)
		{



			//Escrevendo alguns caracteres para teste
			//Delay no meio pra evitar overload do TX
			IOWR_ALTERA_AVALON_UART_TXDATA(UART_0_BASE,Send++);
			usleep(3000);



			while(1){
				ch = *data_ptr;
				//printf("%c",ch);
				writeMessage(message);
				usleep(1000000);

			}


		}
}
//Função de inicialização do serial
//Gera a interrupção de recebimento
void serial_init()
{
    void* read_ptr = (void*) &data_ptr;
	//inhibit all UART IRQ sources
	IOWR(UART_0_BASE, 3, 0x080);
	// flush any characters sitting in the holding register
	IORD(UART_0_BASE, 0);
	IORD(UART_0_BASE, 0);
	//reset most of the status register bits
	IOWR(UART_0_BASE, 2, 0x00);
	// install IRQ service routine
	//recast do ponteiro para (void) [requesito do alt_ir_register() ]
	alt_irq_register(UART_0_IRQ, read_ptr, readMessage);
	// enable irq for Rx. */
	//IOWR(UART_0_BASE, 3, 0x0080);
}


//Fazer a função continuar lendo até encontrar um char '\0' ?

static void readMessage(void* context, alt_u32 id){
	char status;
	char ch;
	char buffer[64];
	int i=0;
	//Recasting do contexto (void) para um ponteiro (char)
	volatile char* read_ptr = (volatile char*) context;
	//Lendo o status, vendo se tem data rx e lendo
	//Talvez não seja mais necessário, porque a interrupção só é ativada quando TEM data rx


	//Garantir que é um caractere alfanumérico e que o numero de iterações é menor que 255
		status = IORD_ALTERA_AVALON_UART_STATUS(UART_0_BASE);
		IOWR_ALTERA_AVALON_UART_STATUS(UART_0_BASE,0);
		//0x80 = mask RXREADY (verificar se realmente chegou caracter, necessário?)
		if((status&0x80)==0x80){
			//Lê o registrador rx e manda pro ponteiro
			ch = IORD_ALTERA_AVALON_UART_RXDATA(UART_0_BASE);
			alt_printf("%c",ch);
			*read_ptr = ch;
		}
}




void writeMessage(char message[]){
	int i=0;
	volatile char status;
	char M=message[i];
	while(M != '\0'){
		//registrador status tem um bit de TRDY (transmit ready)
		//Se TRDY = 1 -> pode transmitir
		//Se TRDY = 0 -> TX está sendo usado
		status = IORD_ALTERA_AVALON_UART_STATUS(UART_0_BASE);
		status = status & ALTERA_AVALON_UART_STATUS_TRDY_MSK;
		if(status != 0x0){
			M=message[i];
			IOWR_ALTERA_AVALON_UART_TXDATA(UART_0_BASE,M);
			i=i+1;
			usleep(300);

		}

	}
}







//----------------------
//Método que eu encontrei na internet
//Tentando criar umas funções para ler/escrever
//---------------------
/*/ read bytes from UART and wait 20ms
rx_cnt=0;
for(n=0;n<1000;n++)
{ usleep(20);
ch = IORD_ALTERA_AVALON_UART_STATUS(UART_0_BASE);
// if received some byte, read it
if ((ch&0x80)==0x80)
{ ch = IORD_ALTERA_AVALON_UART_RXDATA(UART_0_BASE);
rx_buf[rx_cnt]= ch;
rx_cnt++;
}
}



// print the bytes to terminal
if (rx_cnt>0)
{ alt_printf("rx_data:");
for(n=0;n<rx_cnt;n++)
{ alt_printf("%x ",rx_buf[n]);
}
alt_printf("\n");
}

}
return 0;
}
*/
/*
 *
 * backup readmessage
//Fazer a função continuar lendo até encontrar um char '\0' ?
//Não dá pra fazer agora, porque o próprio processador envia e recebe,
//	precisa ter o envia feito por outro componente
static void readMessage(void* context, alt_u32 id){
	char status;
	char ch;
	//Recasting do contexto (void) para um ponteiro (char)
	volatile char* read_ptr = (volatile char*) context;
	//Lendo o status, vendo se tem data rx e lendo
	//Talvez não seja mais necessário, porque a interrupção só é ativada quando TEM data rx
	status = IORD_ALTERA_AVALON_UART_STATUS(UART_0_BASE);
	IOWR_ALTERA_AVALON_UART_STATUS(UART_0_BASE,0);
	if((status&0x80)==0x80){
		//Lê o registrador rx e manda pro ponteiro
		ch = IORD_ALTERA_AVALON_UART_RXDATA(UART_0_BASE);
		alt_printf("Recebido: %c \n",ch);
	}

}
*/
