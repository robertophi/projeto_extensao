package com.segmentationfault.apps.socandroid;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.media.AudioFormat;
import android.media.AudioRecord;
import android.media.MediaRecorder;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;

import static java.lang.System.arraycopy;

public class Microphone extends Sensor {

    private int rate;
    private int channel;
    private int format;
    private int size_buffer;
    private AudioRecord recorder;
    private byte[] data;
    private Context context;

    public Microphone(Context context) {
        super(R.string.audio, R.mipmap.ic_mic, (byte) 'a');

        this.context = context;
        this.rate = 8000;
        this.channel = AudioFormat.CHANNEL_CONFIGURATION_MONO;
        this.format = AudioFormat.ENCODING_PCM_16BIT;
        this.size_buffer = AudioRecord.getMinBufferSize(rate, channel, format);

        data = new byte[size_buffer + 1];
        data[0] = identifier;
    }

    @Override
    void onToggle() {
        // Requests Record Audio permission
        if (ContextCompat.checkSelfPermission(context,
                Manifest.permission.RECORD_AUDIO)
                != PackageManager.PERMISSION_GRANTED) {
            if (ActivityCompat.shouldShowRequestPermissionRationale((Activity) context,
                    Manifest.permission.RECORD_AUDIO)) {
            } else {
                ActivityCompat.requestPermissions((Activity) context,
                        new String[]{Manifest.permission.RECORD_AUDIO}, 1);
            }

            return;
        }

        if (getStatus() != ON) {
            recorder = new AudioRecord(MediaRecorder.AudioSource.MIC, rate, channel, format, size_buffer * 10);
            status = ON;
            return;
        }

        status = OFF;
        recorder.release();
    }

    @Override
    byte[] getData() {
        byte[] buffer = new byte[size_buffer];

        try {
            recorder.startRecording();
            recorder.read(buffer, 0, buffer.length);
            recorder.stop();
        }catch (Exception e) {
            return null;
        }

        arraycopy(buffer, 0, data, 1, size_buffer);

        return data;
    }
}