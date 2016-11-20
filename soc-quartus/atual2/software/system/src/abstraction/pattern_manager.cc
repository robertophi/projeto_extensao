#include "../../include/abstraction/pattern_manager.h"

#define CMDPOWER 0
#define CMDVARIATION 1
#define CMDDECREASE 2

PatternManager::PatternManager() {
	this->matrix = MotorMatrix::getSingleton();
}

PatternManager::~PatternManager() {}

void PatternManager::setPower(short x, short y, short power) {
	this->matrix->writeCommand(CMDPOWER, x, y, power);
}

void PatternManager::setVariation(short x, short y, short variation) {
	this->matrix->writeCommand(CMDVARIATION, x, y, variation);
}

void PatternManager::setDecrease(short x, short y, short dec) {
	this->matrix->writeCommand(CMDDECREASE, x, y, dec);
}
