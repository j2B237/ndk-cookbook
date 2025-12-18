package com.example.myndkapp;
import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;
//import androidx.appcompat.app.AppCompatActivity;


public class MainActivity extends Activity {
    
    // Chargement de la lib JNI
    static {
        System.loadLibrary("native-lib");
    }

    @Override
    protected void onCreate(Bundle savedInstance) {

        super.onCreate(savedInstance);
        
        setContentView(R.layout.activity_main);

        TextView tv = findViewById(R.id.textView);

        int res = addFromNDK(2, 3);
        tv.setText("Resultat: " + res);
    }

    public static native int addFromNDK(int a, int b);
};
