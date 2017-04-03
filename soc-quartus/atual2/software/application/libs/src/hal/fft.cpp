#include "fft.h"

/* static */
FFT *FFT::fft = 0;

/* public */
FFT::FFT() {
	data = (volatile unsigned int*) matrixAddress;
	writeFFT =(volatile unsigned int*) fftAddress;
	readFFT = (volatile unsigned int*) fftAddress+4;
}

FFT::~FFT() {
}

FFT *FFT::getSingleton() {
	if (fft == 0)
		fft = new FFT();
	return fft;
}

void FFT::write(unsigned char *input) {
	writeFFT = (unsigned int*)input;
	delete input;
}

int* FFT::read() {
	return (int*)readFFT;
}
