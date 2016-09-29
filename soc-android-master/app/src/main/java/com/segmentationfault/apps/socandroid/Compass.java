package com.segmentationfault.apps.socandroid;

import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.util.Log;

public class Compass extends Sensor implements SensorEventListener {

    private float[] gravity = new float[3];
    private float[] geomagnetic = new float[3];
    private  byte[] data;

    Compass(SensorManager sensorManager) {
        super(R.string.compass, R.mipmap.ic_compass, (byte) 'c');
        sensorManager.registerListener(this, sensorManager.getDefaultSensor(android.hardware.Sensor.TYPE_MAGNETIC_FIELD), SensorManager.SENSOR_DELAY_GAME);
        sensorManager.registerListener(this, sensorManager.getDefaultSensor(android.hardware.Sensor.TYPE_ACCELEROMETER), SensorManager.SENSOR_DELAY_GAME);

        data = new byte[2];
        data[0] = identifier;
    }

    @Override
    public void onSensorChanged(SensorEvent event) {
        float[] smoothed;
        double heading;
        float[] rotation = new float[9];
        float[] orientation = new float[3];

        // get accelerometer data
        if (event.sensor.getType() == android.hardware.Sensor.TYPE_ACCELEROMETER) {
            // we need to use a low pass filter to make data smoothed
            smoothed = lowPass(event.values, gravity);
            gravity[0] = smoothed[0];
            gravity[1] = smoothed[1];
            gravity[2] = smoothed[2];
        } else if (event.sensor.getType() == android.hardware.Sensor.TYPE_MAGNETIC_FIELD) {
            smoothed = lowPass(event.values, geomagnetic);
            geomagnetic[0] = smoothed[0];
            geomagnetic[1] = smoothed[1];
            geomagnetic[2] = smoothed[2];
        }

        // get rotation matrix to get gravity and magnetic data
        SensorManager.getRotationMatrix(rotation, null, gravity, geomagnetic);
        // get bearing to target
        SensorManager.getOrientation(rotation, orientation);
        // east degrees of true North
        heading = orientation[0];
        // convert from radians to degrees
        heading = Math.toDegrees(heading);

        if (heading < 0)
            heading += 360;

        data[1] = (byte) ((255.0/360.0)*heading);
    }

    @Override
    public void onAccuracyChanged(android.hardware.Sensor sensor, int accuracy) {

    }

    @Override
    public byte[] getData() {
        Log.d("Compass", "onSensorChanged: " + (int) data[1]);

        return data;
    }

    @Override
    public void onToggle() {
        status = status == ON ? OFF:ON;
    }

    protected float[] lowPass( float[] input, float[] output ) {
        float ALPHA = 0.25f;

        if ( output == null )
            return input;

        for ( int i=0; i<input.length; i++ ) {
            output[i] = output[i] + ALPHA * (input[i] - output[i]);
        }

        return output;
    }
}
