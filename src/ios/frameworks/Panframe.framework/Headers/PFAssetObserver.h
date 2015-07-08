//
//  Panframe media library
//
//  For more information visit www.panframe.com
//  Subject to license agreements. May not be re-sold or re-packaged.
//
//  Copyright © 2010-2014 Mindlight. All rights reserved.
//
//  PFAssetObserver
//  Observer protocol for PFAsset objects
//

#ifndef PFAssetObserver_h
#define PFAssetObserver_h

@class PFAsset;
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
    PF_ASSET_SEEKING = 10
};

/** An object which implements the PFAssetObserver protocol for monitoring asset status.*/
@protocol PFAssetObserver <NSObject>
/** The callback called during PFAsset status updates
 @param asset The asset where the messag originated from.
 @param m The status change of the PFAsset
 */
- (void) onStatusMessage : (PFAsset *) asset message:(enum PFASSETMESSAGE) m;
@end

#endif