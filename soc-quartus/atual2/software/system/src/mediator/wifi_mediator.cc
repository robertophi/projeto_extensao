#include "../../include/mediator/wifi_mediator.h"

/* static */

WifiMediator *WifiMediator::wifi = 0;

/* public */
WifiMediator::~WifiMediator() {
}

WifiMediator *WifiMediator::getSingleton() {
	if (wifi == 0)
		wifi = new WifiMediator();
	return wifi;
}

void WifiMediator::config(char* name, char* password) {
	char modeConfig[] = "AT+CWMODE=2";
	sendInstruction(modeConfig);

	char *apConfig;
	int apSize = 18 + strlen(name) + strlen(password);
	apConfig = new char[apSize];
	strcpy(apConfig, "AT+CWSAP=\"");
	strcat(apConfig, name);
	strcat(apConfig, "\",\"");
	strcat(apConfig, password);
	strcat(apConfig, "\",5,3");
	sendInstruction(apConfig);

	char mux[] = "AT+CIPMUX=1";
	sendInstruction(mux);

	char ip[] = "AT+CIPAP=\"192.168.4.1\"";
	sendInstruction(ip);
}

void WifiMediator::connect() {
	char server[] = "AT+CIPSERVER=1,80";
	sendInstruction(server);
}

void WifiMediator::disconnect() {
	char stop[] = "AT+CIPSERVER=0";
	char rst[] = "AT+RST";
	sendInstruction(stop);
	sendInstruction(rst);
}

void WifiMediator::receive(unsigned char* data, unsigned int *size) {
	char c;
	unsigned int i;
	i = 0;

	do {
		c = alt_getchar();
		i = i + 1;
	} while (c != '+' and i < 1024);
	do {
		c = alt_getchar();
		i = i + 1;
	} while (c != ',' and i < 1024);

	do {
		c = alt_getchar();
		i = 1 + i;
	} while (c != ',' and i < 1024);

	*size = 0;

	c = alt_getchar();

	while (c != ':' and i < 1024) {
		*size = *size * 10 + c - '0';
		c = alt_getchar();
		i = i + 1;
	}

	unsigned int j, max;
	j = 0;
	max = *size;
	if (max > 2048) {
		max = 2048;
	}

	for (j = 0; j < max; j += 1) {
		data[j] = alt_getchar();
	}

	data[j] = '\0';
}

/* private */
WifiMediator::WifiMediator() {
}

void WifiMediator::sendInstruction(char * instruction) {
	write(instruction, (int) strlen(instruction));
	write("\r\n", 2);

	char k;
	do {
		k = alt_getchar();
		alt_printf("%c", k);
	} while (k != 'K');
}

void WifiMediator::write(char * msg, int size = -1) {
	for (int i = 0; i < size; i++) {
		alt_putchar(msg[i]);
	}
}
