#ifndef CONFIGURATION_STATUS_HANDLER_H_
#define CONFIGURATION_STATUS_HANDLER_H_

#include "connect_manager.h"
#include "../mediator/fft_mediator.h"
#include "data_handler.h"

class ConfigurationStatusHandler : public DataHandler {
 public:
	ConfigurationStatusHandler();
	virtual ~ConfigurationStatusHandler();
	void handle(char* message);

 private:
	ConnectManager* connection;
	FFTMediator* fft;
};

#endif
