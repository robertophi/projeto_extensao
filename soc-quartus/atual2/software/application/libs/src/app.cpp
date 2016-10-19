#include "app.h"

#define SSID "ColeteWifi"
#define PASSWORD "12345678"
//Senha não pode ter menos de 8 caracteres

/*Static*/
Motors	*App::motors = Motors::getSingleton();
FFT	*App::fft = FFT::getSingleton();
App::Buffer	App::buffer;

App::App() {
	wifi = WiFi::getSingleton();
}

App::~App() {
	wifi->stopServer();
}

void App::setup() {
	wifi->config(SSID, PASSWORD);
	wifi->startServer();
	alt_putstr("Setup done\n");
	//fft->setInterruptHandler(App::fftHandler);
}

void App::fftHandler(unsigned int output) {
	alt_printf("Got FFT output %d\n", output);

	//	motors->write(output);
	alt_printf("%i\n", buffer.length());
	fft->read();

	if(buffer.length() > 0)
		fft->write(buffer.pop());
}

void App::writeCompass(unsigned char direction) {
	switch(direction) {
		case 'N':
			alt_putstr("Sending direction as North.\n");
			break;
		case 'W':
			alt_putstr("Sending direction as West.\n");
			break;
		case 'E':
			alt_putstr("Sending direction as East.\n");
			break;
		case 'S':
			alt_putstr("Sending direction as South.\n");
			break;
	}
}

void App::writeGyroscope(int xAngle, int yAngle) {
	alt_putstr("Sending angle to vest.\n");
	alt_printf("%i\n", xAngle);
	alt_printf("%i\n", yAngle);
}

void App::run() {
	unsigned char *data;
	unsigned int *size;

	//Shift amount de 10, Decaimento de 15 e potencia de 255 em cada motor, durante inicialização do programa.
	motors->write((1<<24)|(255<<16)|(255<<8)|(10));
	motors->write((2<<24)|(255<<16)|(255<<8)|(15));
	motors->write((0<<24)|(255<<16)|(255<<8)|(255));

	while (1) {
		alt_putstr("Waiting for data...\n");

		wifi->receive(data, size);
		char type = data[0];
		switch (type) {
		case 'm': { /* motors */
			int cmd = (int)(data[1]);
			int linha = (int)(data[2]);
			int coluna = (int)(data[3]);
			int valor = (int)(data[4]);
			alt_putstr("Motors received. Sending it to the motors...\n");
			int command = (  (cmd << 24) | (linha << 16) | (coluna << 8) | (valor) );
			alt_printf("Comando: %d %d %d %d = %d\n" ,cmd, linha, coluna, valor, command );
			motors->write(command);
		}
			break;
		case 'a': { /*audio*/
			alt_putstr("Audio received. Sending it to the FFT...\n");
			alt_printf("%s\n", data);
			//buffer.push(data);

			//if(!fft->isProcessing()) {
			//	fft->write(buffer.pop());
			//}
		}
			break;
		case 'c': { /*compass*/
			alt_putstr("Compass received. Sending to the motors...\n");
			alt_printf("%s\n", data);
			writeCompass(data[1]);
		}
			break;
		case 'g': { /*gyroscope*/
			alt_putstr("Gyroscope received. Sending to the motors...\n");
			alt_printf("%s\n", data);
			writeGyroscope(int(data[1]), int(data[2]));
		}
			break;
		default: {
			alt_putstr("Some data received. Don't know what to do...\n");
			alt_printf("%s\n", data);
		}
			break;
		}
	}
}
