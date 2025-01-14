#include <stdio.h>
#include "sys/alt_stdio.h"

#include "fifoed_avalon_uart_regs.h"
#include "fifoed_avalon_uart.h"
#include "fifoed_avalon_uart_fd.h"
#include "sys/alt_irq.h"
#include "alt_types.h"
#include "system.h"

#define UART_WIFI_BASE 0x0
#define UART_WIFI_IRQ 1


void wifi_init();
void serial_init();
void writeCommand();
static void readUART();
void waitForStatusReady();



volatile char *data_ptr;

static char buffer[64]="";
static int check = 0;

int main()
{

	serial_init();
	wifi_init();





	while(1){
		usleep(1000000);
	}
	return 0;
}



void wifi_init(){
	usleep(1000000);

	//Wifi mode - mode 2 = AP mode (host)
	writeCommand("AT+CWMODE=2");
	usleep(1000000);

	//Set multiple connection or not - mode 1 = multiple conn. enable
	writeCommand("AT+CIPMUX=1");
	usleep(1000000);

	//Set IP address of ESP8266 softAP
	writeCommand("AT+CIPAP=\"192.168.4.1\"");
	usleep(1000000);

	//Generic configuration - ssid, pwd, ch, ecn
	writeCommand("AT+CWSAP=\"ColeteWifi\",\"123456789\",5,3");
	usleep(2000000);

	//Configure as a server - mode 1 = create server
	//						- port 80 (default 333)
	writeCommand("AT+CIPSERVER=1,80");
	usleep(1000000);

	//Server timeout, max7200 segundos
	writeCommand("AT+CIPSTO=600");
	usleep(1000000);

	//----------
	//telnet 192.168.4.1 80
	//para mandar dados para o wifi

}


void serial_init()
{
	//recast do ponteiro para (void) [requesito do alt_ir_register() ]
    void* read_ptr = (void*) data_ptr;
	//select interrupt sources -receive ready e enable all
	IOWR(UART_WIFI_BASE, 3, (FIFOED_AVALON_UART_CONTROL_RRDY_MSK|FIFOED_AVALON_UART_CONTROL_E_MSK));
	// flush os caractéres no buffer de escrita, por precaução
	IORD(UART_WIFI_BASE, 0);
	IORD(UART_WIFI_BASE, 0);
	IORD(UART_WIFI_BASE, 0);
	IORD(UART_WIFI_BASE, 0);
	//reset most of the status register bits
	IOWR(UART_WIFI_BASE, 2, 0x00);
	// install IRQ service routine

	alt_irq_register(UART_WIFI_IRQ, read_ptr, readUART);
	// enable irq da uart para Rx. */
}


//Função chamada pela interrupçao da uart
void readUART(void* context, alt_u32 id){
	char ch;
	int i=0;

	do{
		waitForStatusReady(FIFOED_AVALON_UART_STATUS_RRDY_MSK);
		ch = IORD_FIFOED_AVALON_UART_RXDATA(UART_WIFI_BASE);
		alt_putchar(ch);
	}while(ch !='\n' && ch != ':');

	if(ch == ':'){
		alt_putchar('\n');
		do{
			waitForStatusReady(FIFOED_AVALON_UART_STATUS_RRDY_MSK);
			ch = IORD_FIFOED_AVALON_UART_RXDATA(UART_WIFI_BASE);
			alt_putchar(ch);
		}while(ch != '\n');
		alt_putchar('\n');
		alt_putchar('\n');
	}


}



//Função usada para enviar os comandos para o módulo
//Envia os caractéres de final de comando (\r e \n) automáticamente
void writeCommand(char message[]){
	int i=0;
	char M=message[i];
	//disable interrupts
	IOWR(UART_WIFI_BASE, 3, 0);


	while(M != '\0'){
		//Envia todos os caractéres do comando, até encontrar \0
		waitForStatusReady(FIFOED_AVALON_UART_STATUS_TRDY_MSK);
		IOWR_FIFOED_AVALON_UART_TXDATA(UART_WIFI_BASE,M);
		i=i+1;
		M=message[i];
	}

	//Send end of package characters
	//Padrão do esp8266
		//Send '\r'
		waitForStatusReady(FIFOED_AVALON_UART_STATUS_TRDY_MSK);
		IOWR_FIFOED_AVALON_UART_TXDATA(UART_WIFI_BASE,'\r');
		//Send '\n'
		waitForStatusReady(FIFOED_AVALON_UART_STATUS_TRDY_MSK);
		IOWR_FIFOED_AVALON_UART_TXDATA(UART_WIFI_BASE,'\n');

	//re-enable interrupts
	IOWR(UART_WIFI_BASE, 3, (FIFOED_AVALON_UART_CONTROL_RRDY_MSK|FIFOED_AVALON_UART_CONTROL_E_MSK));

}


//Para esperar o término do envio ou recebimento
//O registrador de status é o mesmo para os dois casos, só muda a mask a ser comparada
void waitForStatusReady(unsigned int mask){
	char status;
	do{
		status = IORD_FIFOED_AVALON_UART_STATUS(UART_WIFI_BASE);
		status = status & mask;
	}while(status==0x00);

}
