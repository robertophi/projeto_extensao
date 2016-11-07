#ifndef APP_MANAGER_H_
#define APP_MANAGER_H_

#include "observer.h"
#include "connect_manager.h"
#include "data_handler.h"

class AppManager : public Observer {
 public:
	AppManager();
	virtual ~AppManager();
	void run();
	void notify(char* message);

 private:
	ConnectManager* connect;
	DataHandler* message;
};

#endif
