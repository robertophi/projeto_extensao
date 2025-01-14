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
	printf("Setup done\n");
	//fft->setInterruptHandler(App::fftHandler);
}

void App::fftHandler(unsigned int output) {
	printf("Got FFT output %d\n", output);

	//	motors->write(output);
	printf("%i\n", buffer.length());
	fft->read();

	if(buffer.length() > 0)
		fft->write(buffer.pop());
}

void App::writeCompass(unsigned char direction) {
	switch(direction) {
		case 'N':
			printf("Sending direction as North.\n");
			break;
		case 'W':
			printf("Sending direction as West.\n");
			break;
		case 'E':
			printf("Sending direction as East.\n");
			break;
		case 'S':
			printf("Sending direction as South.\n");
			break;
	}
}

void App::writeGyroscope(int xAngle, int yAngle) {
	printf("Sending angle to vest.\n");
	printf("%i\n", xAngle);
	printf("%i\n", yAngle);
}

void App::run() {
	unsigned char *data;
	unsigned int *size;


	motors->write((1<<24)|(255<<16)|(255<<8)|(10));
	motors->write((2<<24)|(255<<16)|(255<<8)|(15));
	motors->write((0<<24)|(255<<16)|(255<<8)|(255));

	while (1) {
		printf("Waiting for data...\n");

		wifi->receive(data, size);
		char type = data[0];
		switch (type) {
		case 'm': { /* motors */
			int cmd = (int)(data[1]);
			int linha = (int)(data[2]);
			int coluna = (int)(data[3]);
			int valor = (int)(data[4]);
			printf("Motors received. Sending it to the motors...\n");
			int command = (  (cmd << 24) | (linha << 16) | (coluna << 8) | (valor) );
			printf("Comando: %d %d %d %d = %d\n" ,cmd, linha, coluna, valor, command );
			motors->write(command);
		}
			break;
		case 'a': { /*audio*/
			printf("Audio received. Sending it to the FFT...\n");
			printf("%s\n", data);
			//buffer.push(data);

			//if(!fft->isProcessing()) {
			//	fft->write(buffer.pop());
			//}
		}
			break;
		case 'c': { /*compass*/
			printf("Compass received. Sending to the motors...\n");
			printf("%s\n", data);
			writeCompass(data[1]);
		}
			break;
		case 'g': { /*gyroscope*/
			printf("Gyroscope received. Sending to the motors...\n");
			printf("%s\n", data);
			writeGyroscope(int(data[1]), int(data[2]));
		}
			break;
		default: {
			printf("Some data received. Don't know what to do...\n");
			printf("%s\n", data);
		}
			break;
		}
	}
}
