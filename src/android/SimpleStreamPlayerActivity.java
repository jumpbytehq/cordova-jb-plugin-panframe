/*
 * SimpleStreamPlayer
 * Android example of Panframe library
 * The example plays back an panoramic movie from a resource.
 * 
 * (c) 2012-2013 Mindlight. All rights reserved.
 * Visit www.panframe.com for more information. 
 * 
 * MODIFIED BY JUMPBYTE
 * 
 */

package com.jb.plugin.panframe;

import android.app.ProgressDialog;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.SeekBar;

import com.panframe.android.lib.PFAsset;
import com.panframe.android.lib.PFAssetObserver;
import com.panframe.android.lib.PFAssetStatus;
import com.panframe.android.lib.PFNavigationMode;
import com.panframe.android.lib.PFObjectFactory;
import com.panframe.android.lib.PFView;

import java.util.Timer;
import java.util.TimerTask;

public class SimpleStreamPlayerActivity extends FragmentActivity implements PFAssetObserver, SeekBar.OnSeekBarChangeListener {

    public static final String TAG = "SimpleStream";
    private ProgressDialog progressDialog;

    PFView _pfview;
    PFAsset _pfasset;
    PFNavigationMode _currentNavigationMode = PFNavigationMode.MOTION;

    boolean _updateThumb = true;
    Timer _scrubberMonitorTimer;

    ViewGroup _frameContainer;
    Button _stopButton;
    Button _playButton;
    Button _touchButton;
    Button vogglzButton;
    SeekBar _scrubber;

    // Default Values
    int viewMode = 2;
    float aspectRatio = 16/9;
    String videoUrl = "";

    /**
     * Creation and initalization of the Activitiy.
     * Initializes variables, listeners, and starts request of a movie list.
     *
     * @param savedInstanceState a saved instance of the Bundle
     */

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
        setContentView(R.layout.simple_stream_player);

        _frameContainer = (ViewGroup) findViewById(R.id.framecontainer);
        _frameContainer.setBackgroundColor(0xFF000000);

        _playButton = (Button) findViewById(R.id.playbutton);
        _stopButton = (Button) findViewById(R.id.stopbutton);
        _touchButton = (Button) findViewById(R.id.touchbutton);
        vogglzButton = (Button) findViewById(R.id.vogglzButton);
        _scrubber = (SeekBar) findViewById(R.id.scrubber);

        _playButton.setOnClickListener(playListener);
        _stopButton.setOnClickListener(stopListener);
        _touchButton.setOnClickListener(touchListener);
        vogglzButton.setOnClickListener(vogglezListner);
        _scrubber.setOnSeekBarChangeListener(this);

        _scrubber.setEnabled(false);

        videoUrl = getIntent().getStringExtra("videoUrl");
        viewMode = getIntent().getIntExtra("viewMode", 2);
        aspectRatio = getIntent().getFloatExtra("aspectRatio", 16/9);
        Log.i(TAG, "Getting View Mode - " + viewMode + " & Aspect Ratio - " + aspectRatio);

        loadVideo();

        showControls(true);
    }

    /**
     * Show/Hide the playback controls
     *
     * @param bShow Show or hide the controls. Pass either true or false.
     */
    public void showControls(boolean bShow) {
        int visibility = View.GONE;

        if (bShow)
            visibility = View.VISIBLE;

        _playButton.setVisibility(visibility);
        _stopButton.setVisibility(visibility);
        _touchButton.setVisibility(visibility);
        vogglzButton.setVisibility(visibility);
        _scrubber.setVisibility(visibility);
        if(viewMode <= 2) {
            _touchButton.setVisibility(View.GONE);
            vogglzButton.setVisibility(View.GONE);
        }
        if (_pfview != null) {
            if (!_pfview.supportsNavigationMode(PFNavigationMode.MOTION))
                _touchButton.setVisibility(View.GONE);
        }
    }


    /**
     * Start the video with a local file path
     */
    public void loadVideo() {

        progressDialog = ProgressDialog.show(this, "Initializing", "Please wait while Loading...");

        _pfview = PFObjectFactory.view(this);
        _pfasset = PFObjectFactory.assetFromUri(SimpleStreamPlayerActivity.this, Uri.parse(videoUrl), SimpleStreamPlayerActivity.this);

        // Setting up View Mode & Aspect Ratio : @JB
        // @TODO Fix if newer version of PAN FRAME releases
        _pfview.setMode((viewMode >= 2) ? 2 : viewMode, aspectRatio);

        _pfview.displayAsset(_pfasset);
        _pfview.setNavigationMode(_currentNavigationMode);

        _frameContainer.addView(_pfview.getView(), 0);
    }

    /**
     * Status callback from the PFAsset instance.
     * Based on the status this function selects the appropriate action.
     *
     * @param asset  The asset who is calling the function
     * @param status The current status of the asset.
     */
    public void onStatusMessage(final PFAsset asset, PFAssetStatus status) {
        switch (status) {
            case LOADED:
                Log.d(TAG, "Loaded");
                /*
                if (progressDialog != null) {
                    if (progressDialog.isShowing()) {
                        progressDialog.dismiss();
                    }
                }
                */
                // For Enabling AutoPlay when Starting the App
                _pfasset.play();
                break;
            case DOWNLOADING:
                Log.d(TAG, "Downloading 360� movie: " + _pfasset.getDownloadProgress() + " percent complete");
                break;
            case DOWNLOADED:
                Log.d(TAG, "Downloaded to " + asset.getUrl());
                break;
            case DOWNLOADCANCELLED:
                Log.d(TAG, "Download cancelled");
                break;
            case PLAYING:
                Log.d(TAG, "Playing");
                if (progressDialog != null) {
                    if (progressDialog.isShowing()) {
                        progressDialog.dismiss();
                    }
                }
                getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
                _scrubber.setEnabled(true);
                _playButton.setText("pause");
                _scrubberMonitorTimer = new Timer();
                final TimerTask task = new TimerTask() {
                    public void run() {
                        if (_updateThumb) {
                            _scrubber.setMax((int) asset.getDuration());
                            _scrubber.setProgress((int) asset.getPlaybackTime());
                        }
                    }
                };
                _scrubberMonitorTimer.schedule(task, 0, 33);
                break;
            case PAUSED:
                Log.d(TAG, "Paused");
                _playButton.setText("play");
                break;
            case STOPPED:
                Log.d(TAG, "Stopped");
                _playButton.setText("play");
                _scrubberMonitorTimer.cancel();
                _scrubberMonitorTimer = null;
                _scrubber.setProgress(0);
                _scrubber.setEnabled(false);
                getWindow().clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
                break;
            case COMPLETE:
                Log.d(TAG, "Complete");
                _playButton.setText("play");
                _scrubberMonitorTimer.cancel();
                _scrubberMonitorTimer = null;
                getWindow().clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
                break;
            case ERROR:
                Log.d(TAG, "Error");
                break;
        }
    }

    /**
     * Click listener for the play/pause button
     */
    private OnClickListener vogglezListner = new OnClickListener() {

        public void onClick(View v) {
//            stopPlay();
//            progressDialog.show();
            changeViewingMode();
        }
    };

    private void changeViewingMode() {
        Log.i(TAG, "Changing View Mode 1 - " + viewMode);
        if (viewMode == 2 || viewMode == 3) {
            viewMode = 0;
            vogglzButton.setText("vogglz");
        } else {
            viewMode = 2;
            vogglzButton.setText("spherical");
        }
        Log.i(TAG, "Changing View Mode 2 - " + viewMode);
        _pfview.setMode((viewMode >= 2) ? 2 : viewMode, aspectRatio);
//        _pfasset.play();
    }

    /**
     * Click listener for the play/pause button
     */
    private OnClickListener playListener = new OnClickListener() {

        public void onClick(View v) {
            if (_pfasset.getStatus() == PFAssetStatus.PLAYING) {
                _pfasset.pause();
            } else {
                if (_pfasset.getStatus() == PFAssetStatus.LOADED) {
                    progressDialog.show();
                }
                _pfasset.play();
            }
        }
    };

    /**
     * Click listener for the stop/back button
     */
    private OnClickListener stopListener = new OnClickListener() {
        public void onClick(View v) {
            stopPlay();
        }
    };

    private void stopPlay() {
        _pfasset.stop();

        // Resetting it for the next time.
        _pfasset = PFObjectFactory.assetFromUri(SimpleStreamPlayerActivity.this, Uri.parse(videoUrl), SimpleStreamPlayerActivity.this);
        _pfview.displayAsset(_pfasset);
    }

    /**
     * Click listener for the navigation mode (touch/motion (if available))
     */
    private OnClickListener touchListener = new OnClickListener() {
        public void onClick(View v) {
            if (_pfview != null) {
                Button touchButton = (Button) findViewById(R.id.touchbutton);
                if (_currentNavigationMode == PFNavigationMode.TOUCH) {
                    _currentNavigationMode = PFNavigationMode.MOTION;
                    touchButton.setText("motion");
                } else {
                    _currentNavigationMode = PFNavigationMode.TOUCH;
                    touchButton.setText("touch");
                }
                _pfview.setNavigationMode(_currentNavigationMode);
            }
        }
    };

// /**
//  * Setup the options menu
//  *
//  * @param menu The options menu
//  */
//    public boolean onCreateOptionsMenu(Menu menu) {
//        getMenuInflater().inflate(R.menu.activity_main, menu);
//        return true;
//    }

    /**
     * Called when pausing the app.
     * This function pauses the playback of the asset when it is playing.
     */
    public void onPause() {
        super.onPause();
        if (_pfasset != null) {
            if (_pfasset.getStatus() == PFAssetStatus.PLAYING)
                _pfasset.pause();
        }

        // Hide Dialog
        if (progressDialog != null) {
            if (progressDialog.isShowing()) {
                progressDialog.dismiss();
            }
        }
    }

    /**
     * Called when a previously created loader is being reset, and thus making its data unavailable.
     *
     * @param seekbar  The SeekBar whose progress has changed
     * @param progress The current progress level.
     * @param fromUser True if the progress change was initiated by the user.
     */
    public void onProgressChanged(SeekBar seekbar, int progress, boolean fromUser) {
    }

    /**
     * Notification that the user has started a touch gesture.
     * In this function we signal the timer not to update the playback thumb while we are adjusting it.
     *
     * @param seekbar The SeekBar in which the touch gesture began
     */
    public void onStartTrackingTouch(SeekBar seekbar) {
        _updateThumb = false;
    }

    /**
     * Notification that the user has finished a touch gesture.
     * In this function we request the asset to seek until a specific time and signal the timer to resume the update of the playback thumb based on playback.
     *
     * @param seekbar The SeekBar in which the touch gesture began
     */
    public void onStopTrackingTouch(SeekBar seekbar) {
        _pfasset.setPLaybackTime(seekbar.getProgress());
        _updateThumb = false;
    }

    @Override
    public void onBackPressed() {
        _pfasset.stop();
        super.onBackPressed();
        this.finish();
    }
}
