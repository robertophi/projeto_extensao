#include "system.h"

#ifndef FFT_MEDIATOR_H_
#define FFT_MEDIATOR_H_

#define matrixAddress 0x9028
#define fftAddress 0x9038

class FFTMediator {
 public:
	FFTMediator();
	virtual ~FFTMediator();
	void write(unsigned char *input);
	int* read();

 private:
	volatile unsigned int *data,*writeFFT,*readFFT;
};

#endif
