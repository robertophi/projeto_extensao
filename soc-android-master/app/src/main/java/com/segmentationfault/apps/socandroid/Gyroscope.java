package com.segmentationfault.apps.socandroid;

import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.util.Log;

public class Gyroscope extends Sensor implements SensorEventListener {

    private byte[] data;
    private float[] gravity = new float[3];
    private float[] geomagnetic = new float[3];
    private float[] orientation = new float[3];
    float[] rotation = new float[9];
    int tempOrientation;

    Gyroscope(SensorManager sensorManager) {
        super(R.string.gyroscope, R.mipmap.ic_gyro, (byte) 'g');
        sensorManager.registerListener(this, sensorManager.getDefaultSensor(android.hardware.Sensor.TYPE_MAGNETIC_FIELD), SensorManager.SENSOR_DELAY_GAME);
        sensorManager.registerListener(this, sensorManager.getDefaultSensor(android.hardware.Sensor.TYPE_ACCELEROMETER), SensorManager.SENSOR_DELAY_GAME);

        data = new byte[4];
        data[0] = identifier;
        data[3] = identifier;
    }

    @Override
    public void onSensorChanged(SensorEvent event) {
        float[] smoothed;
        if (event.sensor.getType() == android.hardware.Sensor.TYPE_ACCELEROMETER) {
            gravity[0] = event.values[0];
            gravity[1] = event.values[1];
            gravity[2] = event.values[2];
        } else if (event.sensor.getType() == android.hardware.Sensor.TYPE_MAGNETIC_FIELD) {
            geomagnetic[0] = event.values[0];
            geomagnetic[1] = event.values[1];
            geomagnetic[2] = event.values[2];
        }
        // get rotation matrix to get gravity and magnetic data
        SensorManager.getRotationMatrix(rotation, null, gravity, geomagnetic);
        // get bearing to target
        SensorManager.getOrientation(rotation, orientation);




        //orientation[0] = orientação Z
        //orientation[1] = orientação X
        //orientation[2] = orientação Y
        // A orientação será transformada de radianos para graus, e de ângulos negativos para positivos
        //Há um fator de escala 125/360, para que todos os valores estajam no intervalo [0;125]
        //Valores maiores que 128 resultam em erro na transmissão. A perda de precisão nos valores não é muito grande.
        tempOrientation = (int)Math.toDegrees(orientation[2]);
        if (tempOrientation < 0) {
            tempOrientation += 360;
        }
        data[1] = (byte) (125*tempOrientation/360); //primeiro valor representa a orientação "direta / esquerda"

        tempOrientation = (int)Math.toDegrees(orientation[1]);
        if (tempOrientation < 0) {
            tempOrientation += 360;
        }
        data[2] = (byte) (125*tempOrientation/360); //segundo valor representa a rotação "pra cima / pra baixo"

    }

    @Override
    byte[] getData() {
        int anguloTemp1, anguloTemp2;
        //Para fazer o log dos valores, está-se calculando de volta os valores originais
        anguloTemp1 = (360*((int)data[1]))/125;
        anguloTemp2 = (360*((int)data[2]))/125;
        anguloTemp1 = anguloTemp1 > 180 ? anguloTemp1-360 : anguloTemp1;
        anguloTemp2 = anguloTemp2 > 180 ? anguloTemp2-360 : anguloTemp2;
        Log.d("Log gyroscope", "onSensorChanged: Orientação :(" +
                        orientation[0]+
                " / " + orientation[1]+
                " / " + orientation[2]+
                ")          Ângulo em graus: (" + anguloTemp1+
                "/" + anguloTemp2+
                ")");
        return data;
    }



    @Override
    public void onAccuracyChanged(android.hardware.Sensor sensor, int accuracy) {

    }

    @Override
    void onToggle() {
        status = status == ON ? OFF:ON;
    }


}
