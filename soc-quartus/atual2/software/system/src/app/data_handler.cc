#include "../../include/app/data_handler.h"

/* public */
DataHandler::DataHandler(TimeMultiplexer* multiplexer,
		unsigned short int num_rows, unsigned short int num_cols,
		unsigned short int row_offs, unsigned short int col_offs) {
	if (multiplexer != 0) {
//	      multiplexer->addObserver(&DataHandler::notify, this);
    }
    this->num_cols = num_cols;
}

DataHandler::~DataHandler() {}

void DataHandler::handle(char* message) {
	if (message[0] == messageType) {
		lastMessage = message;
		if (enabled) {
//				do_handle(message]);
		} else {
			next->handle(message);
		}
	}
}

void DataHandler::notify(bool beginTimeSlice) {
	if (beginTimeSlice) {
		set_configuration();
		handle(lastMessage);
	}
	enabled = beginTimeSlice;
}

/* private */
void DataHandler::writeMotorCommand(unsigned int command,
		unsigned int row, unsigned int col, unsigned int data) {}

void DataHandler::do_handle() {}

void DataHandler::set_configuration() {}
