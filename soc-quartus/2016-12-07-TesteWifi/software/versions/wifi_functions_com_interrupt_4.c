#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include "sys/alt_stdio.h"
#include "system.h"
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
			IOWR_ALTERA_AVALON_UART_TXDATA(UART_WIFI_BASE,Send++);
			usleep(3000);



			while(1){
				//ch = *data_ptr;
				//printf("%c",ch);
				//IOWR_ALTERA_AVALON_UART_TXDATA(UART_WIFI_BASE,ch);
				//usleep(100000);

			}


		}
}
//Função de inicialização do serial
//Gera a interrupção de recebimento
void serial_init()
{
    void* read_ptr = (void*) &data_ptr;
	//inhibit all UART IRQ sources
	IOWR(UART_WIFI_BASE, 3, 0x080);
	// flush any characters sitting in the holding register
	IORD(UART_WIFI_BASE, 0);
	IORD(UART_WIFI_BASE, 0);
	//reset most of the status register bits
	IOWR(UART_WIFI_BASE, 2, 0x00);
	// install IRQ service routine
	//recast do ponteiro para (void) [requesito do alt_ir_register() ]
	alt_irq_register(UART_WIFI_IRQ, read_ptr, readMessage);
	// enable irq for Rx. */
	//IOWR(UART_WIFI_BASE, 3, 0x0080);
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
		status = IORD_ALTERA_AVALON_UART_STATUS(UART_WIFI_BASE);
		IOWR_ALTERA_AVALON_UART_STATUS(UART_WIFI_BASE,0);
		//0x80 = mask RXREADY (verificar se realmente chegou caracter, necessário?)
		if((status&0x80)==0x80){
			//Lê o registrador rx e manda pro ponteiro
			ch = IORD_ALTERA_AVALON_UART_RXDATA(UART_WIFI_BASE);
			*read_ptr = ch;
			IOWR_ALTERA_AVALON_UART_TXDATA(UART_WIFI_BASE,ch);

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
		status = IORD_ALTERA_AVALON_UART_STATUS(UART_WIFI_BASE);
		status = status & ALTERA_AVALON_UART_STATUS_TRDY_MSK;
		if(status != 0x0){
			M=message[i];
			IOWR_ALTERA_AVALON_UART_TXDATA(UART_WIFI_BASE,M);
			i=i+1;
			usleep(300);

		}

	}
}


