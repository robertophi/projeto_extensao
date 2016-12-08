#ifndef DATA_HANDLER_H_
#define DATA_HANDLER_H_

#include "../abstraction/pattern_manager.h"
#include "time_multiplexer.h"

class DataHandler {
 public:
	DataHandler(TimeMultiplexer* multiplexer,
			unsigned short num_rows,
			unsigned short num_cols, unsigned short row_offs,
			unsigned short col_offs);
	virtual ~DataHandler();
	void handle(char* message);
    void notify(bool beginTimeSlice);

 private:
    void writeMotorCommand(unsigned int command,
    		unsigned int row, unsigned int col, unsigned int data);
    virtual void do_handle() = 0;
    void set_configuration();

 private:
	DataHandler* next;
	TimeMultiplexer* _multiplexer;
	PatternManager* pattern;
	char* lastMessage;
	bool enabled;
	char messageType;
	unsigned short num_cols, num_rows, col_offs, row_offs;
};

#endif
