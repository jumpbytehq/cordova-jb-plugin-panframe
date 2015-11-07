package com.jb.plugin.panframe;

import android.content.Context;
import android.content.Intent;
import android.util.Log;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

public class PanframePlugin extends CordovaPlugin {
    public static final String ACTION_INITIALIZE = "init";
    private static final String TAG = PanframePlugin.class.getName();

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals(ACTION_INITIALIZE)) {
            this.init(callbackContext, args);
            return true;
        }
        return false;
    }

    private void init(final CallbackContext callbackContext, final JSONArray args) {
        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                try {
                    // Getting Parameters
                    Context context = cordova.getActivity().getApplicationContext();
                    Intent playerIntent = new Intent(context, SimpleStreamPlayerActivity.class);
                    String videoUrl = args.getString(0);
                    playerIntent.putExtra("videoUrl", videoUrl);

                    if (args.getString(1) != null && !args.getString(1).equalsIgnoreCase("null") && !args.getString(1).equalsIgnoreCase("undefined")) {
                        int viewMode = Integer.parseInt(args.getString(1));
                        playerIntent.putExtra("viewMode", viewMode);
                    }
                    if (args.getString(2) != null && !args.getString(2).equalsIgnoreCase("null") && !args.getString(2).equalsIgnoreCase("undefined")) {
                        float aspectRatio = Float.parseFloat(args.getString(2));
                        playerIntent.putExtra("aspectRatio", aspectRatio);
                    }
                    playerIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

                    context.startActivity(playerIntent);
                    Log.i(TAG, "Activity should get started...");
                    callbackContext.success();
                } catch (Exception e) {
                    callbackContext.error("Error while starting VR Player.");
                    e.printStackTrace();
                }
            }
        });
    }
}