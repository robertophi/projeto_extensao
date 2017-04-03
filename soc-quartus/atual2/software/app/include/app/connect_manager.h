#ifndef CONNECT_MANAGER_H_
#define CONNECT_MANAGER_H_

#include "observer.h"
#include "../mediator/observable.h"
#include "../mediator/wifi_mediator.h"

class ConnectManager : public Observer, public Observable {
 public:
	ConnectManager();
	virtual ~ConnectManager();
	void setConnection();
	void init();
	void notify(char* message = "");
	void AddObserver();

 private:
	WifiMediator* wifi;
};

#endif
