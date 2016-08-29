#include "motors.h"

/* cola:
 * | comando | linha | coluna | valor |
 * 0: ajustar a potencia
 * 1: ajustar a variacaoo
 * 2: ajustar o decaimento
 * : ajustar o envio para a proxima line
 * : ajustar o envio para a proxima column
 */

/* static */
Motors *Motors::motors = NULL;

/* public */
Motors::~Motors() {
}

Motors *Motors::getSingleton() {
	if (motors == NULL)
		motors = new Motors();
	return motors;
}

void Motors::write_power(unsigned int line, unsigned int column,
		unsigned int valor) {
	write(1, line, column, valor);
}

void Motors::write_variation(unsigned int line, unsigned int column,
		unsigned int valor) {
	write(2, line, column, valor);
}

void Motors::write_delay(unsigned int line, unsigned int column,
		unsigned int valor) {
	write(4, line, column, valor);
}

void Motors::write(unsigned int op, unsigned int line, unsigned int column,
		unsigned int valor) {
	*data = (op << 24) + (line << 16) + (column << 8) + valor;
}

void Motors::write(unsigned int valor) {
	*data = valor;
}

void Motors::write_to_next_line() {
	write(8, 0, 0, 0);
}

void Motors::write_to_next_collumm() {
	write(16, 0, 0, 0);
}

/* private */
Motors::Motors() {
	data = (unsigned int *) MATRIX_ADDRESS;
	status = (unsigned int *) (MATRIX_ADDRESS + 4);
}

unsigned int Motors::read() {
	return *status;
}
