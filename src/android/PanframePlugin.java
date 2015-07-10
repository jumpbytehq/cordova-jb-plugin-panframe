package com.jb.plugin.panframe;

import android.content.Context;
import android.content.Intent;

import com.panframe.android.samples.SimpleStreamPlayer.SimpleStreamPlayerActivity;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

public class PanframePlugin extends CordovaPlugin {
    public static final String ACTION_INITIALIZE = "init";
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
                    String videoUrl = args.getString(0);
                    int viewMode = Integer.parseInt(args.getString(1));
                    Context ctx = cordova.getActivity().getApplicationContext();
                    Intent playerIntent = new Intent(ctx, SimpleStreamPlayerActivity.class);
                    playerIntent.putExtra("videoUrl", videoUrl);
                    playerIntent.putExtra("viewMode", viewMode);
                    //i.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                    ctx.startActivity(playerIntent);
                    callbackContext.success();
                } catch (Exception e) {
                    callbackContext.error("Exception");
                }
            }
        });
    }
}