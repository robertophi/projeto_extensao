#ifndef WIFI_H
#define WIFI_H

#include "sys/alt_stdio.h"
#include <string.h>

class WiFi {
public:
	~WiFi();
	static WiFi *getSingleton();
	void config(char* name, char* password);
	void startServer();
	void stopServer();
	void receive(unsigned char* data, unsigned int *size);

private:
	WiFi();
	void sendInstruction(char* instruction);
	void write(char* buffer, int size);

	static WiFi *wifi;
};

#endif
