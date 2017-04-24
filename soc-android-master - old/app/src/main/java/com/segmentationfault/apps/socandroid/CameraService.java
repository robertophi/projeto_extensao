package com.segmentationfault.apps.socandroid;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.util.List;

import android.app.Service;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.graphics.PixelFormat;
import android.graphics.Rect;
import android.graphics.SurfaceTexture;
import android.graphics.YuvImage;
import android.hardware.Camera;
import android.hardware.Camera.Size;
import android.os.IBinder;
import android.view.SurfaceHolder;
import android.view.SurfaceView;

/**
 * Created by nakayama on 8/2/16.
 */
public class CameraService extends Service {

    private SurfaceTexture texture;
    private static SurfaceHolder surfaceHolder;
    private static Camera camera;
    private static byte[] lastFrame;
    private int width;
    private int height;

    @Override
    public void onCreate() {
        super.onCreate();
        texture = new SurfaceTexture(0);
        startRecording();
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onDestroy() {
        stopRecording();
        super.onDestroy();
    }

    public boolean startRecording(){
        safeCameraOpen(0);
        Camera.Parameters p = camera.getParameters();

        final List<Size> listSize = p.getSupportedPreviewSizes();
        Size mPreviewSize = listSize.get(listSize.size() - 1);
        width = listSize.get(listSize.size() - 1).width;
        height = listSize.get(listSize.size() - 1).height;

        p.setPreviewSize(mPreviewSize.width, mPreviewSize.height);
        p.setPreviewFormat(PixelFormat.YCbCr_420_SP);

        camera.setParameters(p);

        try {
            camera.setPreviewTexture(texture);
//            camera.setPreviewDisplay(surfaceHolder);
            camera.setPreviewCallback(new Camera.PreviewCallback() {
                @Override
                public void onPreviewFrame(byte[] data, Camera camera) {
                    Camera.Parameters parameters = camera.getParameters();

                    YuvImage yuv = new YuvImage(data, parameters.getPreviewFormat(), width, height, null);

                    ByteArrayOutputStream out = new ByteArrayOutputStream();
                    yuv.compressToJpeg(new Rect(0, 0, width, height), 50, out);

                    byte[] bytes = out.toByteArray();
                    Bitmap bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.length);
                    bitmap = Bitmap.createScaledBitmap(bitmap, 64, 64, false);
                    Matrix matrix = new Matrix();

                    matrix.postRotate(90);
                    bitmap = Bitmap.createBitmap(bitmap , 0, 0, bitmap .getWidth(), bitmap .getHeight(), matrix, true);

                    com.segmentationfault.apps.socandroid.Camera.setBitmapIcon(bitmap);
//PNG
//                    ByteArrayOutputStream blob = new ByteArrayOutputStream();
//                    bitmap.compress(Bitmap.CompressFormat.PNG, 0 , blob);
//                    byte[] color = blob.toByteArray();
                    int b = bitmap.getByteCount();

                    ByteBuffer buffer = ByteBuffer.allocate(b); //Create a new buffer
                    bitmap.copyPixelsToBuffer(buffer); //Move the byte data to the buffer

                    lastFrame = buffer.array();
                }
            });
            camera.startPreview();
        }
        catch (IOException e) {
            e.printStackTrace();
        }

        return true;
    }

    public void stopRecording() {
        try {
            camera.reconnect();
        } catch (IOException e) {
            e.printStackTrace();
        }

        camera.stopPreview();

        camera.release();
        camera = null;
    }

    public static byte[] getLastFrame() {
        byte[] aux = lastFrame;
        lastFrame = null;
        return aux;
    }

    private boolean safeCameraOpen(int id) {
        boolean qOpened = false;

        try {
            releaseCameraAndPreview();
            camera = Camera.open(id);
            qOpened = (camera != null);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return qOpened;
    }

    private void releaseCameraAndPreview() {
        setCamera(null);
        if (camera != null) {
            camera.release();
            camera = null;
        }
    }

    private void setCamera(Camera camera) {
        if (CameraService.camera == camera) { return; }

        stopRecording();

        CameraService.camera = camera;

        if (CameraService.camera != null) {
            try {
                CameraService.camera.setPreviewTexture(texture);
//                CameraService.camera.setPreviewDisplay(surfaceHolder);
            } catch (IOException e) {
                e.printStackTrace();
            }

            CameraService.camera.startPreview();
        }
    }

    public static void updateSurfaceView(SurfaceView surfaceView) {
        surfaceHolder = surfaceView.getHolder();
    }
}
