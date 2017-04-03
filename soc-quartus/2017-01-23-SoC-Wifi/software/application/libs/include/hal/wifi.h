#ifndef WIFI_H
#define WIFI_H

#include "sys/alt_stdio.h"
#include <string.h>
#include <stdio.h>

#include "fifoed_avalon_uart_regs.h"
#include "fifoed_avalon_uart.h"
#include "fifoed_avalon_uart_fd.h"
#include "sys/alt_irq.h"
#include "alt_types.h"
#include "system.h"
#include "unistd.h"

#define UART_WIFI_BASE 0x1040
#define UART_WIFI_IRQ 1

class WiFi {
public:
	~WiFi();
	static WiFi *getSingleton();
	void config(char* name, char* password);
	void stopServer();
	void readUART(char *data, int *size);
	void readUART2();

private:
	WiFi();
	volatile void writeCommand(char message[]);
	void waitForStatusReady(unsigned int mask);
	static WiFi *wifi;
};

#endif
