#ifndef MOTORS_H
#define MOTORS_H

#define MATRIX_ADDRESS 0x00002068

class Motors {
public:
	~Motors();
	static Motors *getSingleton();
	void write_power(unsigned int linha, unsigned int coluna,
			unsigned int valor);
	void write_variation(unsigned int linha, unsigned int coluna,
			unsigned int valor);
	void write_delay(unsigned int linha, unsigned int coluna,
			unsigned int valor);
	void write(unsigned int comando, unsigned int linha, unsigned int coluna,
			unsigned int valor);
	void write(unsigned int v);
	void write_to_next_line();
	void write_to_next_collumn();

private:
	Motors();
	unsigned int read();

	unsigned volatile int* data;
	unsigned volatile int* status;
	static Motors *motors;
};

#endif
