#ifndef WIFI_MEDIATOR_H_
#define WIFI_MEDIATOR_H_

#include "../mediator/observable.h"
#include "uart_mediator.h"

class WifiMediator : public Observable {
 public:
	WifiMediator();
	virtual ~WifiMediator();
	void setIP();
	void connect();

 private:
	UARTMediator* uart;
};

#endif
