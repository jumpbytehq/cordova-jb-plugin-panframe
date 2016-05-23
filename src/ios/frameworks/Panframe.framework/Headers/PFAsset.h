//
//  Panframe media library
//
//  For more information visit www.panframe.com
//  Subject to license agreements. May not be re-sold or re-packaged.
//
//  Copyright © 2010-2014 Mindlight. All rights reserved.
//
//  PFAsset
//  Abstract Panframe asset protocol
//

#import <CoreMedia/CoreMedia.h>

enum PFASSETMESSAGE {
    PF_ASSET_LOADED = 1,
    PF_ASSET_PLAYING   = 2,
    PF_ASSET_PAUSED = 3,
    PF_ASSET_STOPPED = 4,
    PF_ASSET_COMPLETE = 5,
    PF_ASSET_DOWNLOADING = 6,           // depricated
    PF_ASSET_DOWNLOADED = 7,            // depricated
    PF_ASSET_DOWNLOADCANCELLED = 8,     // depricated
    PF_ASSET_ERROR = 9,
    PF_ASSET_SEEKING = 10,
    PF_ASSET_BUFFER_EMPTY = 11,
    PF_ASSET_BUFFER_FULL = 12,
    PF_ASSET_BUFFER_KEEPING_UP = 13
};
@protocol PFAsset;

/** A protocol for monitoring the progress of the playback of an asset */
@protocol PFAssetTimeMonitor <NSObject>

/** The callback called when a new video frame arrives
 @param asset The asset where the message originated from.
 @param time The playback time that was monitored
 */
- (void) onPlayerTime:(id<PFAsset>)asset hasTime:(CMTime)time;

@end

@class PFAssetObserver;

/** An object which implements the PFAsset protocol delivers playback control for 360 video assets. An PFAsset can be instantiated within Panframe by using the appropriate PFObjectFactory method.*/
@protocol PFAsset <NSObject>

/** Playback of the asset */
- (void) play;

/** Playback of the asset, starting at a specific time
 @param start The position from the start of the asset to begin playback.
 @param keyframe By specifying yes, you allow the seek operation to jump to the nearest keyframe for faster operation.
 */
- (void) playWithSeekTo:(CMTime)start onKeyFrame:(BOOL)keyframe;

/** Pause the playback of the asset */
- (void) pause;

/** Stops the playback of the asset */
- (void) stop;

/** Get the current timerange of playback 
 @return Returns a CMTimeRange of the configured start time of playback and duration
 */
- (CMTimeRange) getTimeRange;

/** Set the current timerange of playback. Use this to skip to a specific part in the asset.
 @param start The position from the start of the asset to begin playback.
 @param duration The duration of the playback from the start
 @param keyframe By specifying yes, you allow the seek operation to jump to the nearest keyframe for faster operation.
 */
- (void)        setTimeRange:(CMTime)start duration:(CMTime)duration onKeyFrame:(BOOL)keyframe;

/** Get the current time in playback 
 @return Returns a CMTime of the current position in playback of the asset.
 */
- (CMTime)      getPlaybackTime;

/** Get the duration of the asset 
 @return Returns the total duration of the asset.
 */
- (CMTime)    getDuration;

/** Get URL of the asset
 @return Returns the url of the asset.
 */
- (NSURL *)     getUrl;

/** Add an observer to the asset
 @param observer The observer implementing the PFAssetObserver protocol to be added
 */
- (void)     addObserver: (PFAssetObserver *) observer;

/** Remove an observer to the asset
 @param observer The observer implementing the PFAssetObserver protocol to be removed
 */
- (void)     removeObserver: (PFAssetObserver *) observer;

/** Returns the status of the asset
 @return The status of the asset
 */
- (enum PFASSETMESSAGE) getStatus;

/** Returns the download progress of the asset
 @return The the download progress (when dowloading assets) in a range from 0.0 to 1.0
 */
- (float) getDownloadProgress;

/** Add a time monitor to the asset, which is fired every time a video frame arrives
 @param monitor Time monitor delegate to receive updates
 @return Return true when the monitor can be set
 */
- (bool) setTimeMonitor:(id<PFAssetTimeMonitor>) monitor;
/** Set the volume of the asset's audio track
 @param volume The volume on a scale of 0.0 to 1.0
 */
- (void) setVolume:(float)volume;

@end

@class PFAsset;