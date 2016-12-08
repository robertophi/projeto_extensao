#include "../../include/mediator/motor_matrix.h"

/* cola:
 * | comando | linha | coluna | valor |
 * 0: ajustar a potencia
 * 1: ajustar a variacao
 * 2: ajustar o decaimento
 * : ajustar o envio para a proxima line
 * : ajustar o envio para a proxima column
 */

/* private */
MotorMatrix::MotorMatrix() {
	data = (unsigned int *) MATRIX_ADDRESS;
	status = (unsigned int *) (MATRIX_ADDRESS + 4);
}

MotorMatrix::~MotorMatrix() {

}

unsigned int MotorMatrix::read() {
	return *status;
}

/* static */
MotorMatrix *MotorMatrix::motors = 0;

/* public */
MotorMatrix* MotorMatrix::getSingleton() {
	if(!motors) {
		motors = new MotorMatrix();
	}
	return motors;
}

void MotorMatrix::writeCommand(unsigned int command, unsigned int row,
		unsigned int col, unsigned int value) {
	*data = (command << 24) + (row << 16) + (col << 8) + value;
}

void MotorMatrix::writeCommand(unsigned int fullCommand) {
	*data = fullCommand;
}

void MotorMatrix::shiftRowsDown() {
	writeCommand(3, 255, 255, 0);
}

void MotorMatrix::shiftColumnsRight() {
	writeCommand(4, 255, 255, 0);
}

