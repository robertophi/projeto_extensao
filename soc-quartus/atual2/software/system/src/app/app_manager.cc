#include "../../include/app/app_manager.h"

AppManager::AppManager() {}

AppManager::~AppManager() {}

void AppManager::run() {}

void AppManager::notify(char* message) {}

//AppManager::AppManager() {
//  timeMultplexer = new ...
//
//  audioDataHandler = new AudioHandler(timeMultiplexer, 5,5, 0,0);
//  compassDataHandler = New CompassHandler(timeMultiplexer, 5,2, 0,0);
//  aceceroneterDataHandler = New AceceroneterHandler(null, 5,3, 0,2);
//
//  audioDataHandler->setNext(compassDataHandler);
//  compassDataHandler->setNext(aceceroneterDataHandler);
//
//  handlers
//  ...
//}
//
