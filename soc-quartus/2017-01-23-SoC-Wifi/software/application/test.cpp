#include "system.h"
#include "app.h"

int main()
{
	App app;

	app.setup();
	while(1){

		app.run();
	}

	return 0;
}

