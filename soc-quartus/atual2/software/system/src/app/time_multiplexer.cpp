#include "../../include/app/time_multiplexer.h"

/* public */
TimeMultiplexer::TimeMultiplexer() {}

TimeMultiplexer::~TimeMultiplexer() {}

void TimeMultiplexer::addObserver() {}

/* private */
void TimeMultiplexer::timerInterruptHandler() {
//		observers->elements[currentObserver][0].*observers->elements[currentObserver][1](false);
//		currentObserver = (++currentObserver) > observers->size ? 0 : currentObserver; //buffer circular
//		observers->elements[currentObserver][0].*observers->elements[currentObserver][1](true);
}
