#include <stdio.h>
#include "sys/alt_stdio.h"

#include "fifoed_avalon_uart_regs.h"
#include "fifoed_avalon_uart.h"
#include "fifoed_avalon_uart_fd.h"
#include "sys/alt_irq.h"
#include "alt_types.h"
#include "system.h"


void serial_init();
void writeCommand();
static void readUART();
void wifi_init();



volatile char* data_ptr;


int main()
{
	serial_init();
	wifi_init();






	while(1){
		//writeCommand("AT");
	}
	return 0;
}



void wifi_init(){
	usleep(1000000);
	writeCommand("AT+CWMODE=2");
	usleep(1000000);
	writeCommand("AT+CIPMUX=1");
	usleep(1000000);
	writeCommand("AT+CIPAP=\"192.168.4.1\"");
	usleep(1000000);
	writeCommand("AT+CWSAP=\"ColeteWifi\",\"123456789\",5,3");
	usleep(2000000);
	writeCommand("AT+CIPSERVER=1,80");
	usleep(1000000);
	//telnet 192.168.4.1 80
	//para mandar dados para o wifi

}


void serial_init()
{
    void* read_ptr = (void*) &data_ptr;
	//select interrupt sources -receive ready e enable all
	IOWR(UART_WIFI_BASE, 3, (FIFOED_AVALON_UART_CONTROL_RRDY_MSK|FIFOED_AVALON_UART_CONTROL_E_MSK));
	// flush any characters sitting in the holding register
	IORD(UART_WIFI_BASE, 0);
	IORD(UART_WIFI_BASE, 0);
	IORD(UART_WIFI_BASE, 0);
	IORD(UART_WIFI_BASE, 0);
	//reset most of the status register bits
	IOWR(UART_WIFI_BASE, 2, 0x00);
	// install IRQ service routine
	//recast do ponteiro para (void) [requesito do alt_ir_register() ]
	alt_irq_register(UART_WIFI_IRQ, read_ptr, readUART);
	// enable irq for Rx. */
}


//Função chamada pela interrupçao da uart
void readUART(void* context, alt_u32 id){
	char status;
	char ch;
	int i=0;
//Recasting do contexto (void) para um ponteiro (char)
	volatile char* read_ptr = (volatile char*) context;


	do{
		do{


				status = IORD_FIFOED_AVALON_UART_STATUS(UART_WIFI_BASE);
				IOWR_FIFOED_AVALON_UART_STATUS(UART_WIFI_BASE,0);
				//0x80 = mask RXREADY (verificar se realmente chegou caracter, necessário?)
			}while((status&0x80)!=0x80);

				//Lê o registrador rx e manda pro ponteiro
				ch = IORD_FIFOED_AVALON_UART_RXDATA(UART_WIFI_BASE);
				*read_ptr = ch;

				i+=1;
				//alt_putchar do caractere recebido, para debugging
				alt_putchar(ch);
	}while(ch !='\n');

}




void writeCommand(char message[]){
	int i=0;
	volatile char status;
	char M=message[i];
	char endCommand[] = "\r\n";

	//disable interrupts
	IOWR(UART_WIFI_BASE, 3, 0);


	while(M != '\0'){


		//registrador status tem um bit de TRDY (transmit ready)
		//Se TRDY = 1 -> pode transmitir
		//Se TRDY = 0 -> TX está sendo usado

		do{
			status = IORD_FIFOED_AVALON_UART_STATUS(UART_WIFI_BASE);
			status = status & FIFOED_AVALON_UART_STATUS_TRDY_MSK;
		}while(status==0x00);


			IOWR_FIFOED_AVALON_UART_TXDATA(UART_WIFI_BASE,M);
			i=i+1;
			M=message[i];
	}
	for(i=0;i<2;i++){
		do{
			status = IORD_FIFOED_AVALON_UART_STATUS(UART_WIFI_BASE);
			status = status & FIFOED_AVALON_UART_STATUS_TRDY_MSK;
		}while(status==0x00);
		IOWR_FIFOED_AVALON_UART_TXDATA(UART_WIFI_BASE,endCommand[i]);
	}

	//re-enable interrupts
	IOWR(UART_WIFI_BASE, 3, (FIFOED_AVALON_UART_CONTROL_RRDY_MSK|FIFOED_AVALON_UART_CONTROL_E_MSK));

}



void writeCharacter(char ch){
	volatile char status;
	//Check status do registrador tx
	do {
		status = IORD_FIFOED_AVALON_UART_STATUS(UART_WIFI_BASE);
		status = status & FIFOED_AVALON_UART_STATUS_TRDY_MSK;
	} while(status==0x00);
	IOWR_FIFOED_AVALON_UART_TXDATA(UART_WIFI_BASE,ch);
}
