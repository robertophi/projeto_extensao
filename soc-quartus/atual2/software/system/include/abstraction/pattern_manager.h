#ifndef PATTERN_MANAGER_H_
#define PATTERN_MANAGER_H_

#include "../mediator/motor_matrix.h"

class PatternManager {
 public:
	PatternManager();
	virtual ~PatternManager();
	void setPower(short x, short y, short power);
	void setVariation(short x, short y, short variation);
	void setDecrease(short x, short y, short dec);

 private:
	MotorMatrix* matrix;
};

#endif
