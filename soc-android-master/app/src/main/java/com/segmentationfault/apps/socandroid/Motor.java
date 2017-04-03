package com.segmentationfault.apps.socandroid;

/**
 * Created by nakayama on 8/3/16.
 */

public class Motor extends Sensor {
    private int column;
    private int line;
    private int potency;

    public Motor(int line, int column) {
        super(R.string.motor, R.mipmap.ic_gear, (byte) 'm');
        this.line = line;
        this.column = column;
    }

    @Override
    void onToggle() {
        status = ON;
    }

    @Override
    byte[] getData() {
        status = OFF;
        return ("m" + ((char)line) + ((char)column) + ((char)potency)).getBytes();
    }

    public int getColumn() {
        return column;
    }

    public int getLine() {
        return line;
    }

    public int getPotency() {
        return potency;
    }

    public void setPotency(int potency) {
        this.potency = potency;
    }
}
