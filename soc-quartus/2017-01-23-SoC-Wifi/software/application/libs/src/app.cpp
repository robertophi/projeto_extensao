#include "app.h"
#include "system.h"
#include "sys/alt_stdio.h"
#include <unistd.h>

#define SSID "ColeteWifi"
#define PASSWORD "12345678"
#define COLUMNS 8
#define LINES 4
//Senha não pode ter menos de 8 caracteres

/*Static*/
Motors	*App::motors = Motors::getSingleton();
FFT	*App::fft = FFT::getSingleton();
App::Buffer	App::buffer;

App::App() {
	wifi = WiFi::getSingleton();
	compass_vib_value = 255;
	gyroscope_vib_value = 255;
	running.init();
}

App::~App() {
	wifi->stopServer();
}

void App::setup() {
	wifi->config(SSID, PASSWORD);
	//retirando fft    fft->setInterruptHandler(App::fftHandler);
}

void App::fftHandler(unsigned int output) {

	//	motors->write(output);
	fft->read();

	if(buffer.length() > 0)
		fft->write(buffer.pop());
}


void App::writeCompass(int direction) {
	motors->write((0<<24)|(255<<16)|(255<<8)|(0));
	if(COLUMNS >= 8) {
        return compass8(direction);
    } else if(COLUMNS >= 4) {
        return compass4(direction);
    }
}

void App::compass4(int direction) {
    if(direction < 5 || direction > 355) {
        motors->write( 0 | (LINES-2) << 16 | ((COLUMNS-1)/2) <<8 | compass_vib_value );
        if(direction < 5 && direction != 0)
            motors->write( 0 | (LINES-1) <<16| 1<<8 | compass_vib_value/2 );
        else if(direction > 355 && direction != 360)
            motors->write( 0 | (LINES-1) <<16 | (COLUMNS-2) << 8 | compass_vib_value/2 );
        return;
    }
    int motor;
    if(direction < 180){
    	motor = direction < 90 ? 1:0;
    	}
    else{
    	motor = direction < 270 ? COLUMNS-1 : COLUMNS-2;
    }
    //int motor = direction < 180 ? (direction < 90 ? 1 : 0) : (direction < 270 ? COLUMNS-2 : COLUMNS-1);
    motors->write( 0 | LINES-1 << 16 | motor << 8 | compass_vib_value );
}

void App::compass8(int direction) {
    if(direction < 5 || direction > 355) {
        motors->write( 0 | (LINES-2) << 16 | ((COLUMNS-1)/2)<<8 | compass_vib_value );
        if(direction < 5 && direction != 0)
            motors->write( 0 | (LINES-1)<<16 | 3<<8 | compass_vib_value/2 );
        else if(direction > 355 && direction != 360)
            motors->write( 0 | (LINES-1)<<16 | (COLUMNS-4)<<8 | compass_vib_value/2 );
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
    motors->write( 0 | (LINES-1)<<16 | motor<<8 | compass_vib_value );
}


void App::writeGyroscope(int xAngle, int yAngle, int zAngle) {

		motors->write( 0 | 255<<16 | 255<<8 | 0 );
		find_x(xAngle);
		find_y(yAngle);


    }

void App::find_x(int xAngle){
	int maxAngle = 100;
	int div;
	int x;
	div = xAngle / (maxAngle/5); //Determina a dimensão do xAngle, em proporção à 20% de maxAngle
	div = div >= 0 ? div : (-1)*div; //Caso seja negativo
	div = div >= 5 ? 4 : div;  //Caso seja maior que 4
	div = 4-div;  //Neste caso o maior valor deve ficar nas extremidades

	x = xAngle >= 0 ? COLUMNS-1 - div  : div; //Lidar com os angulos negativos
	if(div < 4){
		motors->write( 0 | 1 << 16 | x << 8 | gyroscope_vib_value); //Liga as colunas determinadas
		motors->write( 0 | 2 << 16 | x << 8 | gyroscope_vib_value); //nas duas linhas do meio
		if(div == 0){
			motors->write( 0 | 0 << 16 | x << 8 | gyroscope_vib_value); //Caso o valor seja grande,
			motors->write( 0 | 3 << 16 | x << 8 | gyroscope_vib_value); //Ligar a coluna inteira
		}
	}
}

void App::find_y(int yAngle){
	int maxAngle = 100;
	int div;
	int y;
	int big, small;
	div = yAngle / (maxAngle/5);
	div = div >= 0 ? div : (-1)*div;
	div = div >= 5 ? 4 : div;
	div = 4-div;


	big  =  yAngle >= 0 ? 0 : LINES-1; //Determina qual é a linha de maior/menor valor (linhas 0 e 1, ou linhas 3 e 2,
	small = yAngle >= 0 ? 1 : LINES-2; //para os casos onde o angulo é positivo ou negativo
	if(div <= 1){
	    motors->write( 0 | big << 16 | 3 << 8 | gyroscope_vib_value);
	    motors->write( 0 | big << 16 | 4 << 8 | gyroscope_vib_value);
	}
	if(div == 0){
		motors->write( 0 | big << 16 | 5 << 8 | gyroscope_vib_value);
		motors->write( 0 | big << 16 | 2 << 8 | gyroscope_vib_value);
		motors->write( 0 | small << 16 | 3 << 8 | gyroscope_vib_value/2);
		motors->write( 0 | small << 16 | 4 << 8 | gyroscope_vib_value/2);
	}
	if(div == 1){
		motors->write( 0 | small << 16 | 3 << 8 | gyroscope_vib_value/2);
		motors->write( 0 | small << 16 | 4 << 8 | gyroscope_vib_value/2);
	}
	if(div == 2 || div == 3){
		motors->write( 0 | small << 16 | 3 << 8 | gyroscope_vib_value);
		motors->write( 0 | small << 16 | 4 << 8 | gyroscope_vib_value);
	}
	if(div == 2){
		motors->write( 0 | small << 16 | 2 << 8 | gyroscope_vib_value);
		motors->write( 0 | small << 16 | 5 << 8 | gyroscope_vib_value);

	}

}

void App::writeAudio(int* freq, int samples) {
	int commom = samples/COLUMNS;
	int summation = 0;
	int pos = 0;
	motors->write_to_next_line();
	motors->write( 0 | 0 | 255 | 0 );
	motors->write( 2 << 24 | 0 | 255 | 1 );
	for(int i = 0; i < samples; i++) {
		summation += freq[i];
		if(i%commom == commom - 1) {
			motors->write((1<<24)| 0 | (pos << 8) |(5));
			motors->write((  0   | 0 | (pos << 8) | summation/commom ));
			pos++;
			summation = 0;
		}
	}
}

void App::run() {
	char data[256];
	int size=0,i=0;
	char *dataPtr;
	int *sizePtr;
		dataPtr = &data[0];
		sizePtr = &size;
	char type;
	char readTerminalEclipse;
	int n;
	int lastColuna=0, lastLinha=0, lastPotencia=0;

	motors->write((1<<24)|(255<<16)|(255<<8)|(0));
	motors->write((2<<24)|(255<<16)|(255<<8)|(0));
	motors->write((0<<24)|(255<<16)|(255<<8)|(0));





	while (1) {
		type = 0;
		wifi->readUART(dataPtr,sizePtr);
		if(size != 0 ){
			for(i=0;i<*sizePtr;i++){
				alt_putchar(data[i]);
			}
			alt_putchar('\n');
			type = data[0];

		}

		switch (type) {
		/* Comandos:
		   Para usar os comandos, deve-se escrever um 'z' antes e depois do comando
		     [1~8] e [g] - Giroscópio
		     [t,y,u,i,o,p] e [c] - Compasso
			 [q,w,e,r] - Ligar linhas individualmente
		 	 [0] - Desligar todos os motores
		 	 [s] - Colocar mínima variação/decaimento e potencia maxima na primeira coluna
		 	 [k] - Padrão de teste
		 	 [n(LINHA)(COLUNA)] - Liga apena o motor especificado
		 	 [j] - Ativa o último motor especificado pelo comando 'm'
		 	 	   inicialmente com potencia 0, e depois cada vez com 10 de potencia a mais.
		 	 	 exemplo: zm13z liga o motor [1,3]
		 	 	 	 	  zkz liga o padrão de teste
		 */

		case '0':{
			motors->write((1<<24)|(255<<16)|(255<<8)|(0));
			motors->write((2<<24)|(255<<16)|(255<<8)|(0));
			motors->write((0<<24)|(255<<16)|(255<<8)|(0));
		}
		break;
		case 's':{
			motors->write((1<<24)|(255<<16)|(0<<8)|(1));
			motors->write((2<<24)|(255<<16)|(0<<8)|(1));
			motors->write((0<<24)|(255<<16)|(0<<8)|(255));
		}
		break;
		case 'k':{
			int i,j,k;
			motors->write((1<<24)|(255<<16)|(255<<8)|(0));
			motors->write((2<<24)|(255<<16)|(255<<8)|(0));

			for(i=0;i<8;i++){
				k=i;
				j=i;
				motors->write((0<<24)|(255<<16)|(255<<8)|(0));
				motors->write((0<<24)|(i<<16)|(i<<8)|(255));
				while(k>=0 && j < 8){
					k=k-1;
					j=j+1;
					motors->write((0<<24)|(j<<16)|(k<<8)|(255));
				}
				k=i;
				j=i;
				while(k<8 && j >=0){
					k=k+1;
					j=j-1;
					motors->write((0<<24)|(j<<16)|(k<<8)|(255));
				}
				usleep(200000);
			}

			for(i=0;i<4;i++){
				for(j=0;j<8;j++){
					motors->write((0<<24)|(255<<16)|(255<<8)|(0));
					motors->write((0<<24)|(i<<16)|(j<<8)|(255));
					usleep(150000);
				}
			}


			motors->write((0<<24)|(255<<16)|(255<<8)|(0));
			usleep(500000);

			for(i=0;i<4;i++){
				motors->write((0<<24)|(255<<16)|(255<<8)|(0));
				motors->write((0<<24)|(i<<16)|(255<<8)|(255));
				usleep(450000);
			}

			motors->write((0<<24)|(255<<16)|(255<<8)|(0));
			usleep(500000);

			for(j=0;j<8;j++){
				motors->write((0<<24)|(255<<16)|(255<<8)|(0));
				motors->write((0<<24)|(255<<16)|(j<<8)|(255));
				usleep(300000);
			}
			motors->write((0<<24)|(255<<16)|(255<<8)|(0));
			usleep(500000);



		}
			break;
		case 'q':{

			motors->write((0<<24)|(255<<16)|(255<<8)|(0));
			motors->write((0<<24)|(0<<16)|(255<<8)|(255));

		}
			break;
		case 'w':{

			motors->write((0<<24)|(255<<16)|(255<<8)|(0));
			motors->write((0<<24)|(1<<16)|(255<<8)|(255));
				}
			break;
		case 'e':{

			motors->write((0<<24)|(255<<16)|(255<<8)|(0));
			motors->write((0<<24)|(2<<16)|(255<<8)|(255));				}
			break;
		case 'r':{

			motors->write((0<<24)|(255<<16)|(255<<8)|(0));
			motors->write((0<<24)|(3<<16)|(255<<8)|(255));
				}
			break;
		case 'n': { /* motors */
			int linha = (int)(data[1]);
			int coluna = (int)(data[2]);
			lastLinha = linha;
			lastColuna = coluna;
			lastPotencia = 0;
			alt_putchar('\n');
			alt_putchar(linha);
			alt_putchar(coluna);
			alt_putchar('\n');
//			alt_putstr("Motors received. Sending it to the motors...\n");
			int command = (  (0 << 24) | ((linha-48) << 16) | ((coluna-48) << 8) | (255) );
//			alt_printf("Comando: %d %d %d %d = %d\n" ,cmd, linha, coluna, valor, command );
			motors->write(command);
		}
		break;
		case 'm': { /* motors */
					int linha = (int)(data[1]);
					int coluna = (int)(data[2]);
					int potencia = (int)(data[3]);
					alt_putchar('\n');
					alt_putchar(linha+48);
					alt_putchar(coluna+48);
					alt_putchar('\n');
					int command = (  (0 << 24) | ((linha) << 16) | ((coluna) << 8) | (potencia*(5/2)) );
					motors->write(command);
				}
		break;
		case 'j':{
			int command = (  (0 << 24) | ((lastLinha-48) << 16) | ((lastColuna-48) << 8) | (lastPotencia) );
			motors->write(command);
			lastPotencia += 10;
			if(lastPotencia > 255) lastPotencia =0;

		}
		break;

		case 'a': { /*audio*/
//			alt_putstr("Audio received. Sending it to the FFT...\n");
//			alt_printf("%s\n", data);
			//buffer.push(data);
			motors->write(4, 255, 255, 0);


//			|           _
//			|    _     / \
//		____|___/_\___/___\_____
//			|\_/   \_/     \   /
//			|               \_/

			//if(!fft->isProcessing()) {
			//	fft->write(buffer.pop());
			//}


		}
			break;
		case 'c': { /*compass*/
//			alt_putstr("Compass received. Sending to the motors...\n");
//			alt_printf("%s\n", data);
			writeCompass(data[1]);
		}
			break;
		case 't': {
		    writeCompass(0);
		}
			break;
		case 'y': {
		    writeCompass(60);
		}
			break;
		case 'u': {
			writeCompass(100);
		}
			break;
		case 'i': {
			writeCompass(180);
		}
			break;
		case 'o': {
		    writeCompass(240);
		}
			break;
		case 'p': {
			writeCompass(359);
		}
			break;
		case 'g': { /*gyroscope*/
//			alt_putstr("Gyroscope received. Sending to the motors...\n");
//			alt_printf("%s\n", data);
			writeGyroscope(0,0,255);
			//writeGyroscope(int(data[1]), int(data[2]), int(data[3]));
		}
			break;
		case '1': {
			writeGyroscope(-99,-100,240);
		}
			break;
		case '2': {
			writeGyroscope(-75,-75,240);
		}
			break;
		case '3': {
			writeGyroscope(-41,-45,240);
		}
			break;
		case '4': {
			writeGyroscope(-21,-23,240);
		}
			break;
		case '5': {
			writeGyroscope(3,-2,240);
			}
			break;
		case '6': {
			writeGyroscope(25,31,240);
			}
			break;
		case '7': {
			writeGyroscope(48,51,240);
			}
			break;
		case '8': {
			writeGyroscope(67,71,240);
			}
			break;
		case '9': {
			writeGyroscope(87,95,240);
			}
			break;
		default: {
//			alt_putstr("Some data received. Don't know what to do...\n");
//			alt_printf("%s\n", data);
		}
			break;
		}
	}
}
