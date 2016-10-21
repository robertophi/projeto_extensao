#ifndef APP_H
#define APP_H

#include "sys/alt_stdio.h"
#include "motors.h"
#include "fft.h"
#include "wifi.h"

#define MAX_SIZE 1024

class App {
public:
	App();
	~App();

	void setup();
	void run();

private:
	class Buffer {
		public:
			Buffer(){
				size = 10;
				buffer = new unsigned char*[size];
				begin = -1;
				end = 0;
				len = 0;
			}

			Buffer(unsigned int size){
				this->size = size;
				buffer = new unsigned char*[this->size];
				begin = -1;
				end = 0;
				len = 0;
			}

			void push(unsigned char * data) {
				if(end == begin || begin == -1) {
					begin++;
				}

				buffer[end++] = data;

				len = ++len%size;
				end %= size;
			}

			unsigned char * pop() {
				if(begin == -1)
					return NULL;

				begin = ++begin&size;

				if(begin == end) {
					end = 0;
					begin = -1;
					len = 0;
					return NULL;;
				}

				len--;

				return buffer[(begin - 1)];
			}

			int length() {
				return len;
			}

		private:
			unsigned int size;
			unsigned int len;
			int begin;
			int end;
			unsigned char **buffer;
		};

	void vibrate(void *arg);
	void writeCompass(unsigned char direction);
	void writeGyroscope(int xAngle, int yAngle);

	static void fftHandler(unsigned int output);
	static Motors *motors;
	static FFT *fft;
	static Buffer buffer;

	WiFi *wifi;};

#endif
