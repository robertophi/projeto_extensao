#ifndef PATTERN_MANAGER_H_
#define PATTERN_MANAGER_H_

#include "../mediator/motor_matrix.h"

class PatternManager {
 public:
	PatternManager();
	virtual ~PatternManager();
	void setPower(int x, int y, int power);
	void setVariation(int x, int y, int variation);

 private:
	MotorMatrix* matrix;
};

#endif
