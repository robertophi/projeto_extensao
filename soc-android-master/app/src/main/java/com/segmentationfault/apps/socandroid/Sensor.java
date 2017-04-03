package com.segmentationfault.apps.socandroid;

import java.util.ArrayList;

/**
 * Created by nakayama on 7/12/16.
 */
public abstract class Sensor {
    public static final Object ON = 0;
    public static final Object OFF = 1;
    
    private int imageId;
    private int nameId;
    private ArrayList<SensorObserver> observers;
    protected Object status;
    protected byte identifier;

    public Sensor(int nameId, int imageId, byte identifier) {
        this.imageId = imageId;
        this.nameId = nameId;
        this.identifier = identifier;
        status = OFF;
        observers = new ArrayList<>();
    }

    public int getImage() {
        return imageId;
    }

    public void setImage(int imageId) {
        this.imageId = imageId;
    }

    public int getNameId() {
        return nameId;
    }

    public void setName(int nameId) {
        this.nameId = nameId;
    }

    public Object getStatus() {
        return status;
    }

    public void toggle() {
        onToggle();

        for(SensorObserver sensorObserver : observers) {
            sensorObserver.onToggle();
        }
    }

    public byte getIdentifier() {
        return identifier;
    }

    public void setOnToggleListener(SensorObserver sensorObserver){
        observers.add(sensorObserver);
    }

    abstract void onToggle();
    abstract byte[] getData();
}
