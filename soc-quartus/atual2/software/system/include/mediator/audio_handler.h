#ifndef AUDIO_HANDLER_H_
#define AUDIO_HANDLER_H_

#include "data_handler.h"
#include "fft_mediator.h"

class AudioHandler : public DataHandler {
 public:
	AudioHandler();
	virtual ~AudioHandler();
	void handle(char* message);

 private:
	FFTMediator fft_response;
};

#endif
