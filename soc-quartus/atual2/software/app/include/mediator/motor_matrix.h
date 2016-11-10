#ifndef MOTOR_MATRIX_H_
#define MOTOR_MATRIX_H_

class MotorMatrix {
 public:
	MotorMatrix();
	virtual ~MotorMatrix();
	void writecommand(col, row, command, data);
};

#endif
