package com.segmentationfault.apps.socandroid;

import android.app.Activity;
import android.content.Context;
import android.content.res.Resources;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.SeekBar;
import android.widget.TextView;

import java.util.ArrayList;


/**
 * Created by nakayama on 7/12/16.
 */
public class ListViewAdapter extends ArrayAdapter<Sensor> {
    Context context;
    ArrayList<Sensor> data = null;
    View view;

    public ListViewAdapter(Context context, int layoutResourceId, ArrayList<Sensor> data) {
        super(context, layoutResourceId, data);
        this.context = context;
        this.data = data;
    }

    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        if(convertView == null)
        {
            LayoutInflater inflater = ((Activity)context).getLayoutInflater();
            convertView = inflater.inflate(R.layout.sensor_view, parent, false);
        }

        view = convertView;

        TextView sensorName = (TextView) convertView.findViewById(R.id.sensor_name);
        ImageView sensorImage = (ImageView) convertView.findViewById(R.id.sensor_image);
        Button sensorActionButton = (Button) convertView.findViewById(R.id.sensor_action_button);
        SeekBar seekBar = (SeekBar) convertView.findViewById(R.id.seekBar);

        final Sensor sensor = getItem(position);
        sensorName.setText(sensor.getNameId());
        sensorImage.setImageResource(sensor.getImage());
        sensorActionButton.setText(R.string.Start);
        seekBar.setVisibility(View.INVISIBLE);

        if(sensor.getStatus() == Sensor.ON) {
            sensorActionButton.setText(R.string.Stop);

            if(sensor.identifier == 'v')
                sensorImage.setImageBitmap(Camera.getBitmapIcon());
        }

        if(sensor.identifier == 'm') {
            Resources res = context.getResources();
            String name = res.getString(sensor.getNameId());

            sensorName.setText((name + ' ' + ((Motor)sensor).getLine() + 'x' + ((Motor)sensor).getColumn()));
            sensorActionButton.setText(R.string.Send);
            seekBar.setVisibility(View.VISIBLE);

            seekBar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
                @Override
                public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                    ((Motor)sensor).setPotency(progress);
                }

                @Override
                public void onStartTrackingTouch(SeekBar seekBar) {

                }

                @Override
                public void onStopTrackingTouch(SeekBar seekBar) {
                }
            });
        }

        sensorActionButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                sensor.toggle();
                update(data);
            }
        });

        return convertView;
    }

    public void clear(){
        this.data.clear();
    }

    public void update(ArrayList<Sensor> data){
        this.data = data;
        this.notifyDataSetChanged();
    }
}
