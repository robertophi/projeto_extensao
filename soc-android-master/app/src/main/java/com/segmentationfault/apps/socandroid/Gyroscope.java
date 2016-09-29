package com.segmentationfault.apps.socandroid;

import android.hardware.SensorManager;

/**
 * Created by nakayama on 7/12/16.
 */
public class Gyroscope extends Sensor {

    private byte[] data;

    public Gyroscope(SensorManager sensorManagerm) {
        super(R.string.gyroscope, R.mipmap.ic_gyro, (byte) 'g');

        data = new byte[4];
        data[0] = identifier;
    }

    @Override
    void onToggle() {
        status = status == ON ? OFF:ON;
    }

    @Override
    byte[] getData() {
        data[1] = 'y';
        data[2] = 'r';
        data[3] = 'o';

        return data;
    }
}
