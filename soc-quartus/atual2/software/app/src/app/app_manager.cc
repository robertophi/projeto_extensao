
AppManager::AppManager() {
  timeMultplexer = new ...
  
  audioDataHandler = new AudioHandler(timeMultiplexer, 5,5, 0,0);
  compassDataHandler = New CompassHandler(timeMultiplexer, 5,2, 0,0);
  compassDataHandler = New CompassHandler(null, 5,3, 0,2);
  ...
}
  