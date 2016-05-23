//
//  Panframe media library
//
//  For more information visit www.panframe.com
//  Subject to license agreements. May not be re-sold or re-packaged.
//
//  Copyright © 2010-2014 Mindlight. All rights reserved.
//
//  PFObjectFactory
//  Object factory for instantiating PFView and PFAsset based objects
//

@class PFView;
@class PFAssetObserver;
class PFSoundEngine;

/** The PFObjectFactory can instantiate appropriate PFAsset instances and PFView instances  */
@interface PFObjectFactory : NSObject
    /** Instantiate an PFAsset object and load its contents from a local file URL or remote HTTP based url. Instantiation follows the 'create' rule.
     @param url The url The url of the asset to be loaded
     @param o The observer registered to observe asset status
     @return A PFAsset instance if the file was loaded, nil on error.
     */
    + (PFAsset *) assetFromUrl:(NSURL*)url observer:(PFAssetObserver*)o;
    /** Instantiate a PFView for rendering PFAsset instances. A frame rectangle is given to initialize the view with specific boundaries. Instantiation follows the 'create' rule.
         @param frame The frame of reference for the view instance to be created
         @return A PFView instance conforming to the frame requested.
     */
    + (PFView *) viewWithFrame:(CGRect)frame;

    + (PFSoundEngine *) PFCreateSoundEngine;

@end
