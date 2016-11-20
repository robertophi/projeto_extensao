#ifndef MOTOR_MATRIX_H_
#define MOTOR_MATRIX_H_
#define MATRIX_ADDRESS 0x00002068

class MotorMatrix {
 public:
	virtual ~MotorMatrix();
	static MotorMatrix* getSingleton();
	void writeCommand(unsigned int command, unsigned int row, unsigned int col,
			unsigned int value);
	void writeCommand(unsigned int fullCommand);
	void shiftRowsDown();
	void shiftColumnsRight();

 private:
	unsigned volatile int* data;
	unsigned volatile int* status;
	static MotorMatrix *motors;

 private:
	MotorMatrix();
	unsigned int read();
};

#endif
