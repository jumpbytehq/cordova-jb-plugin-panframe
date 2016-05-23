//
//  Panframe media library
//
//  For more information visit www.panframe.com
//  Subject to license agreements. May not be re-sold or re-packaged.
//
//  Copyright © 2010-2015 Mindlight. All rights reserved.
//
//  PFAssetReader
//  PFAssetReader interface for use with the soundengine
//

#import <Foundation/Foundation.h>
#include "PFSoundEngine.h"

@interface PFAssetReader : NSObject

- (id) initWithURL:(const char *)strPathToFile andDestination:(LPPFASSETOPTIONSCALLBACK)sinkCB withTarget:(id)target;
- (id) initWithAssets:(NSArray *)assets andDestination:(LPPFASSETOPTIONSCALLBACK)sinkCB withTarget:(id)target;

- (void) readMetadata;
- (bool) buildReader:(LPPFASSETREADEROPTIONS)pPFAssetReaderOptions;
- (bool) cleanReader;
- (bool) nextFrame;
- (void) cleanup;

- (PFSoundProducer *) getProducer;

@end
