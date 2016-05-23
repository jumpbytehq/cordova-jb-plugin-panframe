//
//  Panframe media library
//
//  For more information visit www.panframe.com
//  Subject to license agreements. May not be re-sold or re-packaged.
//
//  Copyright © 2010-2014 Mindlight. All rights reserved.
//
//  PFView
//  PFView interface suitable for handling PFAsset based media
//

#ifndef PFView_h
#define PFView_h

#import <UIKit/UIKit.h>

@class PFAsset;

enum PFNAVIGATIONMODE {
    PF_NAVIGATION_MOTION = 0,
    PF_NAVIGATION_TOUCH = 1
    };

enum PFBLINDSPOTLOCATION {
    PF_BLINDSPOT_NONE = 0,
    PF_BLINDSPOT_BOTTOM = 1,
    PF_BLINDSPOT_TOP = 2
};


/** The PFHotspot protocol for view-dependent hotspot objects.*/
@protocol PFHotspot

/** Set the current size of the hotspot. Defaults to 1.0
 @param radius Size as a radius.
 */
- (void) setSize:(float) radius;

/** Set the current size of the hitspot of the hotspot. Defaults to 1.2 times the size of the hotspot radius.
 @param radius Size as a radius.
 */
- (void) setHitRadius:(float) radius;

/** Set the polar coordinates of the hotspot in degrees.
 @param rotY rotation around the y-axis, moving the hotspot left or right on the screen (0 to 360 degrees).
 @param rotX rotation around the x-axis, moving the hotspot up or down on the screen (-90 to 90 degrees).
 @param rotZ rotation around the z-axis, not supported at the moment.
 */
- (void) setCoordinates:(float)rotY andX:(float)rotX andZ:(float)rotZ;

/** Tag the hotspot with a int.
 @param tag The tag for the hotspot.
 */
- (void) setTag:(int)tag;

/** Retrieve the tag for the hotspot.
 */
- (int) getTag;

/** Set the selector to trigger when the hotspot is touched. The selector should be in the form -(void)method:(id<PFHotspot>)hotspot;
 @param target The target class.
 @param action The selector to call.
 */
- (void) addTarget:(id)target action:(SEL)action;

/** Set an alpha value for the hotspot
 @param alpha The alpha value from 0.0f to 1.0f.
 */
- (void) setAlpha:(float) alpha;

/** Retrieve the alpha value for the hotspot.
 */
- (float) getAlpha;

/** Animate the hotspot. This is a fixed animation for now.
 */
- (void) animate;

/** Hotspot state
 */
- (int) getState;


@end

/** An PFView is responsable for rendering the contents of PFAsset instances.*/
@interface PFView : UIView

/** Set the current user interface orientation in order to let the view track touch events properly
 @param orientation The current or desired UIInterfaceOrientation
 */
- (void)setInterfaceOrientation:(UIInterfaceOrientation) orientation;

/** Set the asset to be rendered upon this view. An asset can only be viewed on one PFView object at a time.
 @param asset The PFAsset to be rendered.
 */
- (void) displayAsset : (PFAsset *) asset;

/** Injects a panoramic image into the view to be displayed. Resolution and format depend on the specific device.
 @param image The UIImage to be injected.
 */
- (void) injectImage:(UIImage*)image;

/** Start rendering the view
 */
- (void) run;

/** Stop rendering the view
 */
- (void) halt;

/** Clear the current video frame (if any) being displayed
 */
- (void) clear;

/** Set view orientation input to motion or touch input.
 @param mode Set the navigation mode to either PF_NAVIGATION_MOTION or PF_NAVIGATION_TOUCH.
 */
- (void) setNavigationMode: (enum PFNAVIGATIONMODE) mode;

/** Set the optional image for the blindspot. Pass nil or PF_BLINDSPOT_NONE for no blindspot.
 @param resourceImageName The name of the PNG image file as included in the project resources
 */
- (void) setBlindSpotImage:(NSString *)resourceImageName;

/** Set the location for the blindspot image.
 @param location The location of the blindspot image.
 */
- (void) setBlindSpotLocation:(enum PFBLINDSPOTLOCATION) location;

/** Set the field of view in degrees
 @param fov Set the field of view for the 3D view. This defaults to 75.0
 */
- (void) setFieldOfView:(float) fov;

/** Returns the current relative rotation around the X-axis. This currently does not include PF_NAVIGATION_MOTION based navigation.
 @return The rotation in degrees
 */
- (float) getRotationX;

/** Returns the current relative rotation around the Y-axis. This currently does not include PF_NAVIGATION_MOTION based navigation.
 @return The rotation in degrees
 */
- (float) getRotationY;

/** Returns the current relative rotation around the Z-axis. This currently does not include PF_NAVIGATION_MOTION based navigation.
 @return The rotation in degrees
 */
- (float) getRotationZ;

/** Set the current relative view rotation around the X-axis.
 @param rx The rotation around the x-axis in degrees
 */
- (void) setRotationX:(float)rx;

/** Set the current relative view rotation around the Y-axis
 @param ry The rotation around the y-axis in degrees
 */
- (void) setRotationY:(float)ry;

/** Set the current relative view rotation around the Z-axis
 @param rz The rotation around the z-axis in degrees
 */
- (void) setRotationZ:(float) rz;

/** Set the current view mode
 @param mode The view mode. Options: 0 for spherical, 1 for flat, 2 for cylindrical, 3 for side-by-side VR (non-stereoscopic), 4 for top-down VR formatted content (stereoscopic).
 @param aspect The aspect ratio (for flat view).
 */
- (void) setViewMode:(int)mode andAspect:(float)aspect;

/** Reset the view direction (motion & touch) to default initial settings
 */
- (void) resetView;

/** Create a hotspot in the scene using an UIImage
 @param image The UIImage supporting transparancy (PNG)
 */
- (id) createHotspot:(UIImage *)image;

/** Create a hotspot in the scene using an UIImage
 @param view The UIView to be used as hotspot image
 */
- (id) createHotspotWithView:(UIView *)view;

/** Remove a hotspot from the scene
 @param hotspot The hotspot to be removed
 */
- (void) removeHotspot:(id<PFHotspot>) hotspot;

/** Autolevel the view to its logical horizon after a number of seconds. Defaults to autoleveling within 2.5 seconds after touch end.
 @param autolevel Set to true (default) to auto-level the
 @param seconds The number of seconds after the last touch
 */
- (void) setAutoLevel:(BOOL) autolevel afterSeconds:(float) seconds;

/** Enable or disable stereo mode viewing
 @param bStereo Flag to indicate splitscreen stereo view display
 */
- (void) setStereo:(BOOL)bStereo;

/** Enable hitting of hotspots on focus (center)
 @param bfocus Set true for hit on focus, false to interact only with touch.
 */
- (void) setHitOnFocus:(BOOL)bfocus;

@end

@class PFView;

@class PFHotspot;

#endif
