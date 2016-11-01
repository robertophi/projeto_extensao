
#include "sys/alt_stdio.h"
#include "system.h"
#define matrixAddress FFT_DUMMY_0_BASE
#define fftAddress MATRIZIP_0_BASE

int main()
{
  volatile unsigned int *data,*writeFFT,*readFFT;
  unsigned int x,result;

  data = (volatile unsigned int*) matrixAddress;
  writeFFT =(volatile unsigned int*) fftAddress;
  readFFT = (volatile unsigned int*) fftAddress+4;

//----------------
  //Desliga todos os motores
  *data = ((1<<24)|(255<<16)|(255<<8)|(0));
  *data = ((2<<24)|(255<<16)|(255<<8)|(0));
  *data = ((0<<24)|(255<<16)|(255<<8)|(0));
  //Liga todos os motores
  *data = ((1<<24)|(255<<16)|(255<<8)|(5));
  *data = ((2<<24)|(255<<16)|(255<<8)|(5));
  *data = ((0<<24)|(255<<16)|(255<<8)|(255));
  usleep(300);
//---------------------


x=0;
  while (1){

	  *writeFFT = x;
	  result = *readFFT;
	  printf("feedback da FFT: %d \n",result);
	  usleep(100000);
	  x=x+1;
  }

  return 0;
}
