#include "fft.h"

/* static */
FFT *FFT::fft = 0;

/* public */
FFT::FFT() {
	processing = false;
}

FFT::~FFT() {
}

FFT *FFT::getSingleton() {
	if (fft == 0)
		fft = new FFT();
	return fft;
}

void FFT::setInterruptHandler(handler h) {
	int_handler = h;
}

void FFT::write(unsigned char *input) {
	alt_printf("%s\n", input);

	processing = true;
	int_handler(3);

	delete input;
}

unsigned int FFT::read() {
	processing = false;
	return 0;
}

bool FFT::isProcessing() {
	return processing;
}
