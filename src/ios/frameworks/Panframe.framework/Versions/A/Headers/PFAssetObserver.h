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

#import "PFAsset.h"

@class PFAsset;


/** An object which implements the PFAssetObserver protocol for monitoring asset status.*/
@protocol PFAssetObserver <NSObject>
/** The callback called during PFAsset status updates
 @param asset The asset where the messag originated from.
 @param m The status change of the PFAsset
 */
- (void) onStatusMessage : (PFAsset *) asset message:(enum PFASSETMESSAGE) m;
@end

#endif