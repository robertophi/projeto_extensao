#include "../../include/mediator/fft_mediator.h"

FFTMediator::FFTMediator() {
	data = (volatile unsigned int*) matrixAddress;
	writeFFT =(volatile unsigned int*) fftAddress;
	readFFT = (volatile unsigned int*) fftAddress+4;
}

FFTMediator::~FFTMediator() {
}

void FFTMediator::write(unsigned char *input) {
	writeFFT = (unsigned int*)input;
}

int* FFTMediator::read() {
	return (int*)readFFT;
}
