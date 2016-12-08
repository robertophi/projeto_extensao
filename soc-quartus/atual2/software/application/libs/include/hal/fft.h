#ifndef FFT_H
#define FFT_H

#include "system.h"
#define matrixAddress 0x9028
#define fftAddress 0x9038

class FFT {
 public:
    FFT();
    ~FFT();

    static FFT *getSingleton();
    void write(int *input, int samples);
    int* read();

 private:
    static FFT *fft;
    volatile int data,*writeFFT,*readFFT;
};

#endif
