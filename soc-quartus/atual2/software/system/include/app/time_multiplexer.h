#ifndef TIMEMULT_H_
#define TIMEMULT_H_

#include "observer.h"
#include "data_handler.h"

class TimeMultiplexer {
 public:
	TimeMultiplexer();
	virtual ~TimeMultiplexer();
	void addObserver();

 private:
	void timerInterruptHandler();

 private:
	unsigned short currentObserver;
//  struct node* observers;
};

#endif
