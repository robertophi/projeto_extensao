package com.segmentationfault.apps.socandroid;

import android.app.Activity;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.Spinner;
import android.widget.TextView;

public class Interface extends Activity implements OnItemSelectedListener {
    private TextView titulo;
    private TextView sub_titulo;

    private TextView angulo_text;
    private TextView angulo_value;

    private Button iniciar_transmitir;
    private Button parar_transmitir;

    private Spinner spinner;
    private FrameLayout f_layout;

    public Interface() {}

    public void iniciarTransmissao() {
        this.iniciar_transmitir.setVisibility(View.INVISIBLE);
        this.parar_transmitir.setVisibility(View.VISIBLE);

        String titulo;
        titulo = this.getTitulo();

        if (titulo.equals("Câmera")) {
            this.titulo.setVisibility(View.INVISIBLE);
            this.sub_titulo.setVisibility(View.INVISIBLE);
            this.f_layout.setVisibility(View.VISIBLE);
        } else {
            if (titulo.equals("Bússola")) {
                this.angulo_text.setVisibility(View.VISIBLE);
                this.angulo_value.setVisibility(View.VISIBLE);
            }

            this.sub_titulo.setText(R.string.status_transmitindo);
        }

        this.spinner.setVisibility(View.INVISIBLE);
    }

    public void pararTransmissao() {
        this.iniciar_transmitir.setVisibility(View.VISIBLE);
        this.parar_transmitir.setVisibility(View.INVISIBLE);

        this.sub_titulo.setText(R.string.status_nao_transmitindo);
        this.sub_titulo.setVisibility(View.VISIBLE);

        this.titulo.setVisibility(View.VISIBLE);
        this.spinner.setVisibility(View.VISIBLE);

        this.angulo_text.setVisibility(View.INVISIBLE);
        this.angulo_value.setVisibility(View.INVISIBLE);

        this.f_layout.setVisibility(View.INVISIBLE);
    }

    public void setFrameLayout(FrameLayout f) {
        this.f_layout = f;
    }
    public void setAngulo(TextView text, TextView value) {
        this.angulo_text = text;
        this.angulo_value = value;
    }

    public void setTitulo(TextView t) {
        this.titulo = t;
    }
    public void setSubTitulo(TextView t) {
        this.sub_titulo = t;
    }
    public void setIniciarTransmitir(Button b) {
        this.iniciar_transmitir = b;
    }
    public void setPararTransmitir(Button b) {
        this.parar_transmitir = b;
    }
    public void setComboBox(Spinner s) {
        this.spinner = s;
    }

    public String getTitulo() {
        return (String) this.titulo.getText();
    }

    public void onItemSelected(AdapterView<?> parent, View view, int pos, long id) {
        this.titulo.setText((CharSequence) parent.getSelectedItem());
    }
    public void onNothingSelected(AdapterView<?> parent) {}

}
