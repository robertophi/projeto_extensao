#ifndef WIFI_MEDIATOR_H_
#define WIFI_MEDIATOR_H_

#include "observable.h"
#include "uart_mediator.h"
#include <string.h>
#include "sys/alt_stdio.h"

class WifiMediator : public Observable {
 public:
	virtual ~WifiMediator();
	static WifiMediator *getSingleton();
	void setIP();
	void config(char* name, char* password);
	void connect();
	void disconnect();
	void receive(unsigned char* data, unsigned int *size);

 private:
	UARTMediator* uart;
	static WifiMediator *wifi;

 private:
	WifiMediator();
	void sendInstruction(char* instruction);
	void write(char* buffer, int size);
};

#endif
