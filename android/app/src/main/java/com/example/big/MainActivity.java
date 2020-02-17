package com.example.big;
import java.util.HashMap;

import android.content.IntentSender;
import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.embedding.android.FlutterFragment;
import io.flutter.plugins.GeneratedPluginRegistrant;

import android.location.Location;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.PendingResult;
import com.google.android.gms.common.api.ResultCallback;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.location.LocationSettingsRequest;
import com.google.android.gms.location.LocationSettingsResult;
import com.google.android.gms.location.LocationSettingsStatusCodes;
import com.sangcomz.fishbun.BaseActivity;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
public class MainActivity extends FlutterActivity implements GoogleApiClient.ConnectionCallbacks,
        GoogleApiClient.OnConnectionFailedListener {
  private static final String CHANNEL = "samples.flutter.dev/gps";
  GoogleApiClient mGoogleApiClient ;
  final static int REQUEST_LOCATION = 199;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);


    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
            new MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall call, Result result) {
                if (call.method.equals("getLocation")) {
                  getLocation();


                  result.success(null);

                }  if (call.method.equals("dispose")) {
                  dispose();


                  result.success(null);

                }else {
                  result.notImplemented();
                }
              }
            });
  }

  public void getLocation() {
    // mGoogleApiClient = new GoogleApiClient.Builder(this)

    //         .addApi(LocationServices.API)
    //         .build();
    // mGoogleApiClient.connect();

    // if (mGoogleApiClient != null) {
    //   mGoogleApiClient.connect();


    //   LocationRequest locationRequest = LocationRequest.create();
    //   locationRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);
    //   locationRequest.setInterval(30 * 1000);
    //   locationRequest.setFastestInterval(5 * 1000);
    //   LocationSettingsRequest.Builder builder = new LocationSettingsRequest.Builder()
    //           .addLocationRequest(locationRequest);

    //   builder.setAlwaysShow(true);

    //   PendingResult<LocationSettingsResult> result =
    //           LocationServices.SettingsApi.checkLocationSettings(mGoogleApiClient, builder.build());
    //   result.setResultCallback(new ResultCallback<LocationSettingsResult>() {
    //     @Override
    //     public void onResult(LocationSettingsResult result) {
    //       final Status status = result.getStatus();
    //       switch (status.getStatusCode()) {
    //         case LocationSettingsStatusCodes.RESOLUTION_REQUIRED:
    //           try {
    //             // Show the dialog by calling startResolutionForResult(),
    //             // and check the result in onActivityResult().
    //             status.startResolutionForResult(MainActivity.this, REQUEST_LOCATION);

    //           } catch (IntentSender.SendIntentException e) {
    //             // Ignore the error.
    //           }
    //           break;
    //       }
    //     }
    //   });
    // }

  }
public  void dispose(){
   // mGoogleApiClient.disconnect();
}
  @Override
  public void onConnectionFailed(@NonNull ConnectionResult connectionResult) {

  }

  @Override
  public void onConnected(@Nullable Bundle bundle) {

  }

  @Override
  public void onConnectionSuspended(int i) {

  }
}