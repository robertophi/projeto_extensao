#ifndef OBSERVABLE_H_
#define OBSERVABLE_H_

#include "../app/observer.h"

class Observable {
 public:
	Observable();
	virtual ~Observable();
	void addObserver(Observer* obs);
};

#endif
