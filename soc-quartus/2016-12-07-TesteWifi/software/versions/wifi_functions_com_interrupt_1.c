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

//Volatile pra evitar erros do compilador
volatile char dataPtr;



int main()
{
	int Send=68;
	char message[] = "Hello world";
while(1)
{
	serial_init();


	IOWR_ALTERA_AVALON_UART_TXDATA(UART_0_BASE,Send);
	usleep(300);
	IOWR_ALTERA_AVALON_UART_TXDATA(UART_0_BASE,Send+1);
	usleep(300);
	IOWR_ALTERA_AVALON_UART_TXDATA(UART_0_BASE,Send+2);
	usleep(300);
	IOWR_ALTERA_AVALON_UART_TXDATA(UART_0_BASE,Send+3);
	writeMessage(message);
	alt_printf("send: %c\n",Send);

	 while(1){
	 }


}
}
//Função de inicialização do serial
//Gera a interrupção de recebimento
void serial_init()
{
    void* read_ptr = (void*) &dataPtr;
	//inhibit all UART IRQ sources
	IOWR(UART_0_BASE, 3, 0x00);
	// flush any characters sitting in the holding register
	IORD(UART_0_BASE, 0);
	IORD(UART_0_BASE, 0);
	//reset most of the status register bits
	IOWR(UART_0_BASE, 2, 0x00);
	// install IRQ service routine
	//recast do ponteiro para (void) [requesito do alt_ir_register() ]
	alt_irq_register(UART_0_IRQ, read_ptr, readMessage);
	// enable irq for Rx. */
	IOWR(UART_0_BASE, 3, 0x0080);
}


//Fazer a função continuar lendo até encontrar um char '\0' ?

static void readMessage(void* context, alt_u32 id){
	char status;
	char ch;
	//Recasting do contexto (void) para um ponteiro (char)
	volatile char* read_ptr = (volatile int*) context;
	//Lendo o status, vendo se tem data rx e lendo
	//Talvez não seja mais necessário, porque a interrupção só é ativada quando TEM data rx
	status = IORD_ALTERA_AVALON_UART_STATUS(UART_0_BASE);
	IOWR_ALTERA_AVALON_UART_STATUS(UART_0_BASE,0);
	if((status&0x80)==0x80){
		//Lê o registrador rx e manda pro ponteiro
		*read_ptr = IORD_ALTERA_AVALON_UART_RXDATA(UART_0_BASE);
		ch = *read_ptr;
		alt_printf("Recebido: %c \n",ch);
		}

	}



void writeMessage(char message[]){
	int i=0;
	char M = message[i];
	while(M != '\0'){
		IOWR_ALTERA_AVALON_UART_TXDATA(UART_0_BASE,M);
		usleep(100);
    i=i+1;
    M=message[i];
	}
	return ;
	//Rotina não causa problemas, mas pode ser importante testar o bit "TRDY" (bit 6 do registrador
	//de status), pra checar se o último caractere já foi enviado ou não.
	//Acho que isso pode causar algum problema de temporização (overload do tx)
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



// send 4 bytes via UART0 (with waiting 100us)
IOWR_ALTERA_AVALON_UART_TXDATA(UART_0_BASE,0xFF);
usleep(100);
IOWR_ALTERA_AVALON_UART_TXDATA(UART_0_BASE,0xAA);
usleep(100);
IOWR_ALTERA_AVALON_UART_TXDATA(UART_0_BASE,count/256);
usleep(100);
IOWR_ALTERA_AVALON_UART_TXDATA(UART_0_BASE,count%2 56);
usleep(100);


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


char readMessage(){
	char message[];
	char status;
	status = IORD_ALTERA_AVALON_UART_STATUS(UART_0_BASE)
	if((status&0x80)==0x80)){
		message = IORD_ALTERA_AVALON_UART_RXDATA(UART_0_BASE);
		//Devolver a mensagem de alguma maneira
		//Ficar recebende mensagem e colocar num buffer até encontra r'\0'?
		//Usar ponteiros ou não?

	}

}
*/
