package com.segmentationfault.apps.socandroid;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.hardware.SensorManager;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.SurfaceView;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.NumberPicker;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.regex.Pattern;


public class MainActivity extends AppCompatActivity {

    private int activeSensors = 0;
    private ListView listView;
    private ListViewAdapter adapter;
    private ArrayList<Sensor> sensors;
    private int motorsMaxLine = 0;
    private int motorsMaxColumn = 0;
    private boolean isMotorsConfigured = false;
    private boolean[][] motors;

    private static final Pattern PARTIAl_IP_ADDRESS =
            Pattern.compile("^((25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[0-9])\\.){0,3}"+
                    "((25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[0-9])){0,1}$");


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        sensors = new ArrayList<>();
        final Gyroscope gyroscope = new Gyroscope((SensorManager) getSystemService(SENSOR_SERVICE));
        gyroscope.setOnToggleListener(
            new SensorObserver() {
                @Override
                public void onToggle() {
                    updateClient(gyroscope.getStatus());
                }
            }
        );

        final Compass compass = new Compass((SensorManager) getSystemService(SENSOR_SERVICE));
        compass.setOnToggleListener(
                new SensorObserver() {
                    @Override
                    public void onToggle() {
                        updateClient(compass.getStatus());
                    }
                }
        );

        final Microphone microphone = new Microphone(this);
        microphone.setOnToggleListener(
                new SensorObserver() {
                    @Override
                    public void onToggle() {
                        updateClient(microphone.getStatus());
                    }
                }
        );

        final Camera camera = new Camera(this);
        camera.setOnToggleListener(new SensorObserver() {
            @Override
            public void onToggle() {
                updateClient(camera.getStatus());
            }
        });

        sensors.add(gyroscope);
        sensors.add(compass);
        sensors.add(microphone);
        sensors.add(camera);

        adapter = new ListViewAdapter(this, R.layout.sensor_view, sensors);
        listView = (ListView)findViewById(R.id.list_view);
        listView.setAdapter(adapter);

        SharedPreferences connectionDetails = getSharedPreferences("connectionDetails", MODE_PRIVATE);

        if(!connectionDetails.contains("ip")){
            SharedPreferences.Editor edit = connectionDetails.edit();
            edit.clear();
            edit.putString("ip", TCPClient.getIp().trim());
            edit.putString("port", String.valueOf(TCPClient.getPort()));
            edit.apply();
        }

        CameraService.updateSurfaceView((SurfaceView)findViewById(R.id.surfaceView));
    }

    @Override
    public void onDestroy() {
        for (Sensor sensor : sensors) {
            if(sensor.getIdentifier() == 'v')
                ((Camera)sensor).destroyService();
        }

        super.onDestroy();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();

        if (id == R.id.action_settings) {
            showSettingsPopup();
            return true;
        } else if(id == R.id.action_motors) {
            if(!isMotorsConfigured) {
                new ConfigMotorsTask(this).execute();
                return true;
            }

            showMotorsPopup(motorsMaxLine, motorsMaxColumn);
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    private void showSettingsPopup(){
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setMessage(R.string.dialog_message)
                .setTitle(R.string.dialog_title);

        final SharedPreferences connectionDetails = getSharedPreferences("connectionDetails", MODE_PRIVATE);
        final View view = LayoutInflater.from(getApplicationContext()).inflate(R.layout.connection_dialog, null);
        final EditText ipInput = (EditText) view.findViewById(R.id.ipInput);
        final EditText portInput = (EditText) view.findViewById(R.id.portInput);
        final Activity activity = this;

        ipInput.addTextChangedListener(new TextWatcher() {
            @Override public void onTextChanged(CharSequence s, int start, int before, int count) {}
            @Override public void beforeTextChanged(CharSequence s,int start,int count,int after) {}

            private String mPreviousText = "";
            @Override
            public void afterTextChanged(Editable s) {
                if(PARTIAl_IP_ADDRESS.matcher(s).matches()) {
                    mPreviousText = s.toString();
                } else {
                    s.replace(0, s.length(), mPreviousText);
                }
            }
        });

        builder.setView(view);

        ipInput.setText(connectionDetails.getString("ip", null));
        portInput.setText(connectionDetails.getString("port", null));

        builder.setPositiveButton(R.string.ok, new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int id) {
                SharedPreferences.Editor edit = connectionDetails.edit();
                edit.clear();
                edit.putString("ip", ipInput.getText().toString().trim());
                edit.putString("port", portInput.getText().toString().trim());
                edit.apply();

                Toast.makeText(activity, R.string.connection_saved, Toast.LENGTH_LONG).show();

                TCPClient.setIp(ipInput.getText().toString());
                TCPClient.setPort(Integer.parseInt(portInput.getText().toString()));
            }
        });

        builder.setNegativeButton(R.string.cancel, new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int id) {
                // User cancelled the dialog
            }
        });

        AlertDialog dialog = builder.create();

        dialog.show();
    }

    private void showMotorsPopup(final int maxLine, int maxColumn){
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setMessage(getString(R.string.motors_dialog_message))
                .setTitle(getString(R.string.motors));
        final int[] line = {0};
        final int[] column = {0};

        final View view = LayoutInflater.from(getApplicationContext()).inflate(R.layout.motors_dialog, null);
        final NumberPicker linePicker = (NumberPicker) view.findViewById(R.id.line_picker);
        final NumberPicker columnPicker = (NumberPicker) view.findViewById(R.id.column_picker);
        Button addButton = (Button) view.findViewById(R.id.add_button);
        Button removeButton = (Button) view.findViewById(R.id.remove_button);

        linePicker.setMinValue(0);
        linePicker.setMaxValue(maxLine - 1);
        columnPicker.setMinValue(0);
        columnPicker.setMaxValue(maxColumn - 1);

        linePicker.setOnValueChangedListener(new NumberPicker.OnValueChangeListener() {

            @Override
            public void onValueChange(NumberPicker picker, int oldVal, int newVal) {
                line[0] = newVal;
            }
        });

        columnPicker.setOnValueChangedListener(new NumberPicker.OnValueChangeListener() {

            @Override
            public void onValueChange(NumberPicker picker, int oldVal, int newVal) {
                column[0] = newVal;
            }
        });

        addButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                if(!motors[line[0]][column[0]]) {
                    final Motor motor = new Motor(line[0], column[0]);
                    motor.setOnToggleListener(new SensorObserver() {
                        @Override
                        public void onToggle() {
                            updateClient(motor.getStatus());
                        }
                    });

                    sensors.add(motor);
                    adapter.update(sensors);
                    motors[line[0]][column[0]] = true;
                }
            }
        });

        removeButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                for(Sensor sensor : sensors) {
                    if(sensor.getIdentifier() == 'm' && ((Motor)sensor).getLine() == line[0] && ((Motor)sensor).getColumn() == column[0]) {
                        sensors.remove(sensor);
                        adapter.update(sensors);
                        motors[line[0]][column[0]] = false;
                        break;
                    }
                }
            }
        });

        builder.setView(view);

        builder.setNegativeButton(R.string.exit, new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int id) {
                // User cancelled the dialog
            }
        });

        AlertDialog dialog = builder.create();

        dialog.show();
    }

    private void updateClient(Object status) {
        if(status == Sensor.ON) {
            if(++activeSensors == 1)
                new SendSensorsTask().execute();
            return;
        }

        activeSensors--;
    }

    private boolean checkCameraHardware(Context context) {
        if (context.getPackageManager().hasSystemFeature(PackageManager.FEATURE_CAMERA)){
            // this device has a camera
            return true;
        } else {
            // no camera on this device
            return false;
        }
    }

    private void updateCameraIcon() {
        adapter.update(sensors);
    }

    private class SendSensorsTask extends AsyncTask<Void, Void, Integer> {
        protected void onPreExecute() {
            //ToDo: Check for internet connection
        }

        protected Integer doInBackground(Void ...voids) {
            do {
                for(Sensor sensor : sensors) {
                    if (sensor.getStatus() == Sensor.ON) {
                        byte[] data = sensor.getData();

                        if(data != null) {
                            TCPClient.send(data);

                            if(sensor.identifier == 'v') {
                                runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        updateCameraIcon();
                                    }
                                });
                            }
                        }
                    }
                }

                try {
                    Thread.sleep(100);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }while (activeSensors > 0);

            return 0;
        }

        protected void onProgressUpdate(Void... voids) {
        }

        protected void onPostExecute(Integer status) {
        }
    }

    private class ConfigMotorsTask extends AsyncTask<Void, Void, Boolean> {
        private Activity activity;
        private ProgressDialog progress;

        public ConfigMotorsTask(Activity activity) {
            this.activity = activity;
        }

        protected void onPreExecute() {
            //ToDo: Check for internet connection
            progress = new ProgressDialog(activity);
            progress.setCancelable(false);
            progress.setTitle("Conectando");
            progress.setMessage("Espere enquanto o colete não responde...");
            progress.show();
        }

        protected Boolean doInBackground(Void ...voids) {
            byte[] data = TCPClient.send("m?".getBytes(), true);

            if(data != null && data.length >= 3 && data[0] == 'm'){
                motorsMaxLine = data[1];
                motorsMaxColumn = data[2];
                isMotorsConfigured = true;
                motors = new boolean[motorsMaxLine][motorsMaxColumn];
                return true;
            }

            return false;
        }

        protected void onProgressUpdate(Void... voids) {
        }

        protected void onPostExecute(Boolean status) {
            progress.dismiss();

            if(status) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        showMotorsPopup(motorsMaxLine, motorsMaxColumn);
                    }
                });
                return;
            }

            Toast.makeText(activity, R.string.connection_failed, Toast.LENGTH_LONG).show();
        }
    }
}
