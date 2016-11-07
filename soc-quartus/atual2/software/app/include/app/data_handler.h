#ifndef DATA_HANDLER_H_
#define DATA_HANDLER_H_

#include "../abstraction/pattern_manager.h"

class DataHandler {
 public:
	DataHandler();
	virtual ~DataHandler();
	void handle(char* message);

 private:
	PatternManager* pattern;
	DataHandler* next;
};

#endif
