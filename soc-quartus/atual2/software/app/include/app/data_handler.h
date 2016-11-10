#ifndef DATA_HANDLER_H_
#define DATA_HANDLER_H_

#include "../abstraction/pattern_manager.h"

class DataHandler {
 public:
	DataHandler(TimeMultiplexer* multiplexer, unsigned short num_cols, num_rows, col_offs, row_offs) {
	    if (multiplexer != null) {
	      multiplexer->addObserver(&this->notify);
	    }
	    this_>num-cols= nul_cols;
	    ...
	}
	
	
	virtual ~DataHandler();
	void handle(char* message) {
	   if (char[0]==mychar) {
             lastMessage = message;
	     if (enabled) {
		do_handle(char* message[1..]);
	   } else {
	     next->handle(message);
	   }
	}

 private:
    void writeMotorCommand(col, row, command, data) {
      mmv->writecommand(col+col_offs, row+row_offs, command, data);
    }
    
    virtual void do_handle() = 0;
    void set_configuration();
    void notify(bool beginTimeSlice) {
	if (beginTimeSlice) {
	  set_configuration();
	  handle(lastMessage);
	}
	enabled = beginTimeSlice;
    }
 private:
	MMV* mmv;
	DataHandler* next;
	TimeMultiplexer* _multiplexer;
	char* lastMessage;
	bool enabled;
	char mychar;
	unsigned short num_cols, num_rows, col_offs, row_offs
};

#endif
