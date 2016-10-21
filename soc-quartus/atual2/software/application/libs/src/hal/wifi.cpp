#include "wifi.h"

/* static */
WiFi *WiFi::wifi = 0;

/* public */
WiFi::~WiFi() {
}

WiFi *WiFi::getSingleton() {
	if (wifi == 0)
		wifi = new WiFi();
	return wifi;
}

void WiFi::config(char* name, char* password) {
	alt_putstr("Configuring AP, wait......\n");

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

	alt_putstr("Done!\n");
}

void WiFi::startServer() {
	alt_putstr("Starting Server...\n");

	char server[] = "AT+CIPSERVER=1,80";
	sendInstruction(server);

	alt_putstr("Done!\n");
}

void WiFi::stopServer() {
	char stop[] = "AT+CIPSERVER=0";
	char rst[] = "AT+RST";
	sendInstruction(stop);
	sendInstruction(rst);
}

void WiFi::receive(unsigned char* data, unsigned int *size) {
	char c;
	unsigned int i;
	i=0;

	do {
		c = alt_getchar();
		i=i+1;
	} while (c != '+' and i<1024);
	do {
		c = alt_getchar();
		i=i+1;
	} while (c != ',' and i<1024);

	do {
		c = alt_getchar();
		i=1+i;
	} while (c != ',' and i<1024);

	*size = 0;

	c = alt_getchar();

	while (c != ':' and i<1024) {
		*size = *size * 10 + c - '0';
		c = alt_getchar();
		i=i+1;
	}

	unsigned int j,max;
	j = 0;
	max= *size;
	if(max>2048){
		max = 2048;
	}
	alt_printf("Size final = %d\n",max);

	for(j=0;j < max;j+=1){
		data[j] = alt_getchar();
	}
	//Finalmente. Função getc(file) estava mudando o valor de *size durante o loop
	//Alocar as condições de laço para j,max antes de iniciar resolveu

	//Outro problema: transmissão do audio / imagem: As vezes o size explode por algum motivo
	//Então coloquei um valor máximo para max (2048 ok? )
	data[j] = '\0';
}


/* private */
WiFi::WiFi() {
}

void WiFi::sendInstruction(char * instruction) {
	write(instruction, strlen(instruction));
	write("\r\n", 2);

	char k;
	do {
		k = alt_getchar();
		alt_printf("%c",k);
	} while (k != 'K');
}

void WiFi::write(char * msg, int size = -1) {
	for (int i = 0; i < size; i++) {
		alt_putchar(msg[i]);
	}
}
