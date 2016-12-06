#include "app.h"
#define SSID "ColeteWifi"
#define PASSWORD "12345678"
#define COLUMNS 5
#define LINES 8
//Senha não pode ter menos de 8 caracteres

/*Static*/
Motors  *App::motors = Motors::getSingleton();
FFT *App::fft = FFT::getSingleton();
App::Buffer App::buffer;

App::App() {
    wifi = WiFi::getSingleton();
    compass_vib_value = 25;
    running.init();
    samples = 1024;
}

App::~App() {
    wifi->stopServer();
}

void App::setup() {
    wifi->config(SSID, PASSWORD);
    wifi->startServer();
    //fft->setInterruptHandler(App::fftHandler);
}

//void App::fftHandler(unsigned int output) {
//
//  //  motors->write(output);
//  fft->read();
//
//  if(buffer.length() > 0)
//      fft->write((int*)buffer.pop(), samples);
//}

//If we have 5 motors in a column, each motor is responsible for 72� each; We receive a float in (-180�, 180�]. To simplify we add 180 to it.
void App::writeCompass(int direction) {
    if(COLUMNS >= 8) {
        compass8(direction);
    } else if(COLUMNS >= 4) {
        compass4(direction);
    }
}

void App::compass4(int direction) {
    if(direction < 5 || direction > 355) {
        motors->write( 0 | LINES-2 | (COLUMNS-1)/2 | compass_vib_value );
         if(direction < 5 && direction != 0)
            motors->write( 0 | LINES-1 | 1 | compass_vib_value/2 );
         else if(direction > 355 && direction != 360)
            motors->write( 0 | LINES-1 | COLUMNS-2 | compass_vib_value/2 );
        return;
    }
    int motor = direction < 180 ? (direction < 90 ? 1 : 0) : (direction < 270 ? COLUMNS-1 : COLUMNS-2);
    motors->write( 0 | LINES-1 | motor | compass_vib_value );
}

void App::compass8(int direction) {
    if(direction < 5 || direction > 355) {
        motors->write( 0 | LINES-2 | (COLUMNS-1)/2 | compass_vib_value );
         if(direction < 5 && direction != 0)
            motors->write( 0 | LINES-1 | 3 | compass_vib_value/2 );
         else if(direction > 355 && direction != 360)
            motors->write( 0 | LINES-1 | COLUMNS-4 | compass_vib_value/2 );
        return;
    }
    int motor;
    if(direction <= 180) {
        if(direction <= 90) {
            motor = direction <= 45 ? 3 : 2;
        } else {
            motor = direction <= 135 ? 1 : 0;
        }
    } else {
        if(direction < 270) {
            motor = direction < 225 ? COLUMNS-1 : COLUMNS-2;
        } else {
            motor = direction < 315 ? COLUMNS-3 : COLUMNS-4;
        }
    }
    motors->write( 0 | LINES-1 | motor | compass_vib_value );
}

void App::writeGyroscope(int xAngle, int yAngle, int zAngle) {
    int x = defineIndex(xAngle, COLUMNS) << 16;
    int y = defineIndex(yAngle, LINES) << 8;
    zAngle = zAngle < 0 ? zAngle*(-1) : zAngle;
    zAngle = zAngle > 240 ? 240 : zAngle;
    zAngle += 10;
    motors->write( 0 | x | y | zAngle );
}

int App::defineIndex(int value, int size) {
        if(size%2 == 0) {
            return evenMotors(value, size);
        }
        return oddMotors(value, size);
    }

int App::oddMotors(int value, int size) {
    float line_int = 200.0/(size-2);
    int half_mot = (size-1)/2;
    float half_int_end = line_int*(half_mot-1)/2.0;
    if((-1)*half_int_end < value && value < half_int_end) {
        return half_mot;
    }
    float mot_int_beg;
    int x = -1;
    if(value > 0) {
        mot_int_beg = half_int_end;
        for(int i = half_mot+1; i < size - 1 && x == -1; i++) {
            if(mot_int_beg <= value && value < mot_int_beg + line_int) {
                x = i;
            } else {
                mot_int_beg += line_int;
            }
        }
        if (x == -1) {
            return size-1;
        }
        return x;
    }
    mot_int_beg = half_int_end*(-1);
    for(int i = half_mot-1; i > 0 && x == -1; i--) {
        if(mot_int_beg - line_int < value && value <= mot_int_beg) {
            x = i;
        } else {
            mot_int_beg -= line_int;
        }
    }
    if (x == -1) {
        return 0;
    }
    return x;
}

int App::evenMotors(int value, int size) {
    float line_int = 200.0/(size-2);
    if(value <= -100) {
        return 0;
    }
    if(value >= 100) {
        return size-1;
    }
    float int_beg = -100;
    int x = -1;
    for(int i = 1; i < size-1 && x == -1; i++) {
        if(int_beg < value && value <= int_beg + line_int) {
            x = i;
        } else {
            int_beg += line_int;
        }
    }
    return x;
}

void App::writeAudio(int* freq, int samples) {
    int commom = samples/COLUMNS;
    int summation = 0;
    int pos = 0;
    motors->write_to_next_line();
    for(int i = 0; i < samples; i++) {
        summation += freq[i];
        if(i%commom == commom - 1) {
            motors->write((  0   | 0 | (pos << 8) | summation/commom ));
            pos++;
            summation = 0;
        }
    }
    delete freq;
}

void App::run() {
    unsigned char *data;
    unsigned int *size;

    //Shift amount de 10, Decaimento de 15 e potencia de 255 em cada motor, durante inicialização do programa.
    motors->write((1<<24)|(255<<16)|(255<<8)|(10));
    motors->write((2<<24)|(255<<16)|(255<<8)|(15));
    motors->write((0<<24)|(255<<16)|(255<<8)|(255));

    alt_timestamp_start();

    while (1) {

        wifi->receive(data, size);
        char type = data[0];
        if(alt_timestamp() >= 500) {
            running.next();
            motors->write( 1 << 24 | 255 << 16 | 255 << 8 | 0); // setting shift amount to instantaneous
            motors->write( 0 | 255 << 16 | 255 << 8 | 0); // setting all motors to not vibrate
            alt_timestamp_start();
            update_motors_settings();
        }
        if(running.current != type) {
            continue;
        }
        switch (type) {
        case 'm': { /* motors */
            int cmd = (int)(data[1]);
            int linha = (int)(data[2]);
            int coluna = (int)(data[3]);
            int valor = (int)(data[4]);
            int command = (  (cmd << 24) | (linha << 16) | (coluna << 8) | (valor) );
            motors->write(command);
        }
            break;
        case 'a': { /*audio*/
            int* c = new int[this->samples];
            for(int i = 0; i <= samples; i++) {
                c[i] = data[i+1];
            }
            fft->write(c, this->samples);
            int* freq = fft->read();
            writeAudio(freq, this->samples/2);
        }
            break;
        case 'c': { /*compass*/
            writeCompass((int)data[1]);
        }
            break;
        case 'g': { /*gyroscope*/
            writeGyroscope(int(data[1]), int(data[2]), int(data[3]));
        }
            break;
        }
    }
}
