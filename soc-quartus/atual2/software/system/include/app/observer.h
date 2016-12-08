#ifndef OBSERVER_H_
#define OBSERVER_H_

class Observer {
 public:
	Observer();
	virtual ~Observer();
	virtual void notify(char* message) = 0;
};

#endif
