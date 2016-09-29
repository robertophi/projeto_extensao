package com.segmentationfault.apps.socandroid;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;

import java.nio.ByteBuffer;

import static java.lang.System.arraycopy;

/**
 * Created by nakayama on 8/2/16.
 */
public class Camera extends Sensor {
    private Context context;
    private Intent intent;
    private static Bitmap bitmapIcon;

    public Camera(Context context) {
        super(R.string.camera, R.mipmap.ic_camera, (byte) 'v');
        this.context = context;
    }

    public static void setBitmapIcon(Bitmap bitmapIcon) {
        Camera.bitmapIcon = bitmapIcon;
    }

    public static Bitmap getBitmapIcon() {
        return bitmapIcon;
    }

    @Override
    void onToggle() {
        //Request camera permission
        if (ContextCompat.checkSelfPermission(context,
                Manifest.permission.CAMERA)
                != PackageManager.PERMISSION_GRANTED) {
            if (ActivityCompat.shouldShowRequestPermissionRationale((Activity) context,
                    Manifest.permission.CAMERA)) {
            } else {
                ActivityCompat.requestPermissions((Activity) context,
                        new String[]{Manifest.permission.CAMERA}, 1);
            }

            return;
        }

        if (getStatus() != ON) {
            intent = new Intent(context, CameraService.class);
            context.startService(intent);
            status = ON;
            return;
        }

        context.stopService(intent);
        status = OFF;
    }

    public void destroyService() {
        if(status == ON)
            context.stopService(intent);
    }

    @Override
    byte[] getData() {
        byte[] frame = CameraService.getLastFrame();

        if(frame == null)
            return null;

        byte[] data = new byte[5 + frame.length];
        data[0] = identifier;
        byte[] size = ByteBuffer.allocate(4).putInt(frame.length).array();


        arraycopy(size, 0, data, 1, size.length);
        arraycopy(frame, 0, data, 5, frame.length);

        return data;
    }
}
