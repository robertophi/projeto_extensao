#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include "sys/alt_stdio.h"
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "altera_avalon_pio_regs.h"
#include "altera_avalon_uart_regs.h"
#include "altera_avalon_uart.h"

static void readMessage();




int main()
{
	char rxch;
	int Send=68;
	char message[] = "At+1234567";
	int i=0;
while(1)
{

	alt_irq_register(UART_0_IRQ, 0, readMessage);

	IOWR_ALTERA_AVALON_UART_TXDATA(UART_0_BASE,Send);
	//IOWR_ALTERA_AVALON_UART_CONTROL(UART_0_BASE,Send);
	 alt_printf("send: %c\n",Send);

	 while(1){}

	 usleep(3000);

	 Send +=1;

}


}
void writeMessage(char message[]){
	int i=0;
	char M = message[i];
	while(M != '\0'){
		IOWR_ALTERA_AVALON_UART_TXDATA(UART_0_BASE,M);
    i=i+1;
    M=message[i];
	}
	return ;
	//Rotina não causa problemas, mas é importante testar o bit "TRDY" (bit 6 do registrador
	//de status), pra checar se o último caractere já foi enviado ou não.
}

static void readMessage(void* context, alt_u32 id){
	char ch='a';
	//char status;
	//status = IORD_ALTERA_AVALON_UART_STATUS(UART_0_BASE);
	//IOWR_ALTERA_AVALON_UART_STATUS(UART_0_BASE,0);
	//if((status&0x80)==0x80){
		ch = IORD_ALTERA_AVALON_UART_RXDATA(UART_0_BASE);
	//	}
	 alt_printf("received: %c \n",ch);


		//Devolver a mensagem de alguma maneira
		//Ficar recebende mensagem e colocar num buffer até encontra r'\0'?
		//Usar ponteiros ou não?

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
