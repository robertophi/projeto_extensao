#ifndef FFT_H
#define FFT_H

#include "sys/alt_stdio.h"
//#include "sys/alt_alarm.h"

typedef void ( *handler )(unsigned int);

class FFT {
public:
	FFT();
	~FFT();

	static FFT *getSingleton();
	void setInterruptHandler(handler h);
	void write(unsigned char *input);
	unsigned int read();
	bool isProcessing();

private:
	static FFT *fft;
	handler int_handler;
	bool processing;
};

#endif
