#ifndef APP_H
#define APP_H
#define NULL 0

#include "sys/alt_timestamp.h"
#include "sys/alt_stdio.h"
#include "motors.h"
#include "fft.h"
#include "wifi.h"

#define MAX_SIZE 1024

struct run_param {
    char* possible;
    char current;
    int iterator;

    void init() {
        possible = "macg";
        current = possible[0];
        iterator = 0;
    }
    void next() {
        iterator = (iterator +1)%4;
        current = possible[iterator];
    }
};

class App {
public:
    App();
    ~App();

    void setup();
    void run();

private:
    int compass_vib_value;
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
    void writeCompass(int direction);
    void compass4(int direction);
    void compass8(int direction);
    void writeGyroscope(int xAngle, int yAngle, int zAngle);
    int defineIndex(int value, int size);
    int oddMotors(int value, int size);
    int evenMotors(int value, int size);
    void writeAudio(int* freq, int samples);

    void update_motors_settings() {
        switch(this->running.current) {
            case 'a':
                motors->write((1<<24)| 255 | 255 | 5 );
                motors->write((2<<24)| 255 | 255 | 1 );
                break;
            case 'c':
                motors->write((int)( 1 | 255 | 255 | 5 ));
                motors->write((int)( 2 | 255 | 255 | 1 ));
                break;
            case 'g':
                motors->write(( (1 << 24) | 255 | 255 | 15 ));
                motors->write(( (2 << 24) | 255 | 255 | 5 ));
                break;
            default:
                motors->write(( (1 << 24) | 255 | 255 | 25 ));
                motors->write(( (2 << 24) | 255 | 255 | 10 ));
                break;
        }
    }

    static void fftHandler(unsigned int output);
    static Motors *motors;
    static FFT *fft;
    static Buffer buffer;
    run_param running;
    unsigned int samples;

    WiFi *wifi;};

#endif
