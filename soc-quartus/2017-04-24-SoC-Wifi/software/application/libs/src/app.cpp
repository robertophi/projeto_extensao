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
	//O valor recebido para o compasso é o ângulo que o celular faz com o norte
	//Os valores são planejados para o celular 'flat', com a tela virada para cima
	//Range final é [-180;180].
		//Valores negativos indicam o celular rotacioado no sentido anti-horário em relação ao norte
		//Valores positivos indicam uma rotação no sentido horário
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
	int setorDaDirecao, coluna;
	int tamanhoSetor = 180/4;
    if(direction<=25 && direction >= -25){
    	//Se o celular está apontando para o norte, ou próximo o suficiente, ligar as duas colunas do meio
		motors->write( 0 | 255 <<16 | 3 <<8 | 100 );
		motors->write( 0 | 255 <<16 | 4 <<8 | 100 );
		motors->write( 0 | 1 <<16 | 3 <<8 | 255 );
		motors->write( 0 | 2 <<16 | 3 <<8 | 255 );
		motors->write( 0 | 1 <<16 | 4 <<8 | 255 );
		motors->write( 0 | 2 <<16 | 4 <<8 | 255 );
    }

    else{
    	 //Para os outros casos, vamos definir quão longe o ângulo está do norte
		//Dividimos o angulo em setores de 45 (180 graus divididos em 4 setores de 45 graus)
		//Dependendo do setor resultante, liga-se um motor em relação ao centro
		//Adiciona-se um fator de +20 ao ângulo durante o cálculo, caso contrário haveria discontinuidade
			//no limite entre próximo/distante, e também quase nunca se ligaria a ultima coluna do colete
    	if(direction > 25){
			setorDaDirecao = (direction+20)/45;
			coluna = 3 + setorDaDirecao;
    	}
    	else if(direction < -25){
			setorDaDirecao = (-direction+20)/45;
			coluna = 4 - setorDaDirecao;
		}
		motors->write( 0 | 1 <<16 | coluna <<8 | 255 );
		motors->write( 0 | 2 <<16 | coluna <<8 | 255 );
    }
}


void App::writeGyroscope(int xAngle, int yAngle, int potenciaGyros) {
	//Define como a posição do smartphone deve ser representada no colete
	//O primeiro valor indica a rotação x "lateral" do celular
	    //quando em zero, indica que não há inclinação
		//valores positivos indicam inclinação para direita
		//negativos para esquerda
	//O segundo valor, quando em zero, indica que o celular está plano com o chão
		//em relação ao eixo y "vertical"
		//valores positivos indicam inclinação para tráz
		//valores negativos indicam inclinação para frente
	//Os valores tem range de [-180,180]


		motors->write( 0 | 255<<16 | 255<<8 | 0 );
		find_x(xAngle);
		find_y(yAngle);
	}
void App::find_x(int xAngle){
	//Definir como a rotação lateral do smartphone deve ser represnetada
	//Liga sempre os motores laterais, de acordo com a rotação do celular
	//Quanto maior o angulo, maior a potencia no motor
	//Se o angulo for maior que 45 graus, liga um pouco a coluna adjacente


	if(xAngle > 5){
	    motors->write( 0 | 255 | 7 | xAngle);
	    if(xAngle>45){
	    	motors->write( 0 | 1 | 6 | xAngle-45);
	    	motors->write( 0 | 2 | 6 | xAngle-45);
	    }
	}
	if(xAngle < -5){
	    motors->write( 0 | 255 | 0 | -xAngle);
	    if(xAngle<-45){
	    	motors->write( 0 | 1 | 1 | (-xAngle)-45);
	    	motors->write( 0 | 2 | 1 | (-xAngle)-45);
	    }
	}
}


void App::find_y(int yAngle){
	//Definir como a rotação 'vertical' do smartphone deve ser represnetada
	//Liga sempre os motores de cima ou de baixo, de acordo com a rotação do celular
	//Quanto maior o angulo, maior a potencia no motor
	//Se o angulo for maior que 45 graus, liga um pouco a linha adjacente

	if(yAngle > 5){
		    motors->write( 0 | 3 | 255 | yAngle);
		    if(yAngle>45){
		    	motors->write( 0 | 2 | 3 | yAngle-45);
		    	motors->write( 0 | 2 | 4 | yAngle-45);
		    }
		}
	if(yAngle < -5){
		motors->write( 0 | 0 | 255 | -yAngle);
		if(yAngle<-45){
			motors->write( 0 | 1 | 3 | (-yAngle)-45);
			motors->write( 0 | 1 | 4 | (-yAngle)-45);
		}
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
			for(i=0;i<=*sizePtr;i++){
				alt_putchar(data[i]);
			}
			alt_putchar('\n');

			type = data[0];

		}

		switch (type) {
		/* Comandos:
		   Para usar os comandos, deve-se escrever um 'z' antes e depois do comando
		     [g] - Giroscópio

		     [t,y,u,i,o,p] e [c] - Compasso
			 [q,w,e,r] - Ligar linhas individualmente
		 	 [1,2,3,4,5,6,7,8] - Ligar colunas individualmente
		 	 [0] - Desligar todos os motores
		 	 [s] - Colocar mínima variação/decaimento e potencia maxima na primeira coluna
		 	 [k] - Padrão de teste
		 	 [n(LINHA)(COLUNA)] - Liga apena o motor especificado
		 	 [j] - Ativa o último motor especificado pelo comando 'm'
		 	 	   inicialmente com potencia 0, e depois cada vez com 10 de potencia a mais.
			 exemplos: m13 liga o motor [1,3]
					  k liga o padrão de teste
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
			int x;
			x = (int)(data[1]*360)/125;
			x = x > 180 ? x-360:x;
			writeCompass(x);
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
			//O que fazer quando receber dados do giroscópio
			//O processo abaixo transforma o dado recebido de volta para graus em um range [-180;180]
			//A escala do valor recebido é [0;125], requisito necessário para transmissão dos valores
				//devido a alguns erros com valores maiores que 125 (são representados como números negativos)
			int x,y;
			x = (int)(data[1]*360)/125;
			x = x > 180 ? x-360:x;
			y = (int)(data[2]*360)/125;
			y = y > 180 ? y-360:y;
			writeGyroscope(x, y, 255);
			//data[1] é a rotação lateral do smartphone (esquerda/direita)
			//data[2] é a rotação 'vertical' (pra cima/baixo)

		}

			break;
		case '1': {
			motors->write((0<<24)|(255<<16)|(255<<8)|(0));
			motors->write((0<<24)|(255<<16)|(0<<8)|(255));		}
			break;
		case '2': {
			motors->write((0<<24)|(255<<16)|(255<<8)|(0));
			motors->write((0<<24)|(255<<16)|(1<<8)|(255));
		}
			break;
		case '3': {
			motors->write((0<<24)|(255<<16)|(255<<8)|(0));
			motors->write((0<<24)|(255<<16)|(2<<8)|(255));
		}
			break;
		case '4': {
			motors->write((0<<24)|(255<<16)|(255<<8)|(0));
			motors->write((0<<24)|(255<<16)|(3<<8)|(255));
		}
			break;
		case '5': {
			motors->write((0<<24)|(255<<16)|(255<<8)|(0));
			motors->write((0<<24)|(255<<16)|(4<<8)|(255));
			}
			break;
		case '6': {
			motors->write((0<<24)|(255<<16)|(255<<8)|(0));
			motors->write((0<<24)|(255<<16)|(5<<8)|(255));
			}
			break;
		case '7': {
			motors->write((0<<24)|(255<<16)|(255<<8)|(0));
			motors->write((0<<24)|(255<<16)|(6<<8)|(255));
			}
			break;
		case '8': {
			motors->write((0<<24)|(255<<16)|(255<<8)|(0));
			motors->write((0<<24)|(255<<16)|(7<<8)|(255));
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
