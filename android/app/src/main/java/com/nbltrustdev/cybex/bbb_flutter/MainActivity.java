package com.nbltrustdev.bbb_flutter;

import android.hardware.biometrics.BiometricPrompt;
import android.os.Bundle;

import androidx.lifecycle.DefaultLifecycleObserver;

import io.flutter.app.FlutterActivity;
import io.flutter.app.FlutterFragmentActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterFragmentActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
  }
}
