#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include "sys/alt_stdio.h"
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "altera_avalon_uart_regs.h"
#include "altera_avalon_uart.h"


int main()
{

while(1)
{
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

void writeMessage(char message){
	int i=0;
	char M = message[i];
	while(M != '\0'){
    IOWR_ALTERA_AVALON_UART_TXDATA(UART_0_BASE,M);
    i=i+1;
    M=message[i];
	}
	return ;
}

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

	return message;
}
