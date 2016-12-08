#include "fft.h"

/* static */
FFT *FFT::fft = 0;

/* public */
FFT::FFT() {
    data = (volatile int) matrixAddress;
    writeFFT =(volatile int*) fftAddress;
    readFFT = (volatile int*) fftAddress+4;
}

FFT::~FFT() {
}

FFT *FFT::getSingleton() {
    if (fft == 0)
        fft = new FFT();
    return fft;
}

void FFT::write(int *input, int samples) {
    writeFFT = (volatile int*)input;
    data = (volatile int)samples;
    input = 0;
}

int* FFT::read() {
    readFFT = new int[data/2];
    int j = 0;
    for(int i = 0; i < data; i=i+2) {
        readFFT[j] = writeFFT[i];
        j++;
    }
    if(j < data/2) {
        readFFT[j] = 0;
    }
    delete writeFFT;
    return (int*) readFFT;
}
