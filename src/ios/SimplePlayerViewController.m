//
//  SimplePlayerViewController.m
//  SimplePlayer
//
//  Created by Ron Bakker on 18-06-13.
//  Copyright (c) 2013 Mindlight. All rights reserved.
//

#import "SimplePlayerViewController.h"
#import <Panframe/Panframe.h>


@interface SimplePlayerViewController () <PFAssetObserver, PFAssetTimeMonitor>
{
    PFView * pfView;
    id<PFAsset> pfAsset;
    enum PFNAVIGATIONMODE currentmode;
    bool touchslider;
    NSTimer *slidertimer;
    int currentview;
    NSString *videoURL;
    int viewMode;
    
    IBOutlet UIButton *playbutton;
    IBOutlet UIButton *stopbutton;
    IBOutlet UIButton *navbutton;
    IBOutlet UIButton *viewbutton;
    IBOutlet UISlider *slider;
    
    IBOutlet UIActivityIndicatorView *seekindicator;
    
    UIImage *pauseImage;
}

- (void) onStatusMessage : (PFAsset *) asset message:(enum PFASSETMESSAGE) m;
- (void) onPlayerTime:(id<PFAsset>)asset hasTime:(CMTime)time;

@end

@implementation SimplePlayerViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelVR)];
    self.title = @"VR Player";
    slider.value = 0;
    slider.enabled = false;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(aMethod:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Show View" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
//    [self.view addSubview:button];
    
    slidertimer = [NSTimer scheduledTimerWithTimeInterval: 0.1
                                                   target: self
                                                 selector:@selector(onPlaybackTime:)
                                                 userInfo: nil repeats:YES];
    
    seekindicator.hidden = TRUE;
    
    currentmode = PF_NAVIGATION_MOTION;
    currentview = 0;
    [self normalButton:viewbutton];
    [self normalButton:navbutton];
    [self normalButton:playbutton];
    [self normalButton:stopbutton];
    
    pauseImage = [UIImage imageNamed:@"pausescreen.png"];
    
}

// added for custom back
- (void) cancelVR {
    [self stop];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];    
    NSLog(@"Cancel VR called:");
}

- (void)aMethod:(UIButton*)button
{
    NSLog(@"Button  clicked.");
}

-(void)onPlaybackTime:(NSTimer *)timer
{
    // retrieve the playback time from an asset and update the slider
    
    if (pfAsset == nil)
        return;
    if (!touchslider && [pfAsset getStatus] != PF_ASSET_SEEKING)
    {
        CMTime t = [pfAsset getPlaybackTime];
        
        slider.value = CMTimeGetSeconds(t);
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight) || (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    [self resetViewParameters];
}

- (void) resetViewParameters
{
    // set default FOV
    [pfView setFieldOfView:75.0f];
    // register the interface orientation with the PFView
    [pfView setInterfaceOrientation:self.interfaceOrientation];
    switch(self.interfaceOrientation)
    {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
            // Wider FOV which for portrait modes (matter of taste)
            [pfView setFieldOfView:90.0f];
            break;
        default:
            break;
    }
}

- (void) createHotspots
{
    // create some sample hotspots on the view and register a callback
    
    id<PFHotspot> hp1 = [pfView createHotspot:[UIImage imageNamed:@"hotspot.png"]];
    id<PFHotspot> hp2 = [pfView createHotspot:[UIImage imageNamed:@"hotspot.png"]];
    id<PFHotspot> hp3 = [pfView createHotspot:[UIImage imageNamed:@"hotspot.png"]];
    id<PFHotspot> hp4 = [pfView createHotspot:[UIImage imageNamed:@"hotspot.png"]];
    id<PFHotspot> hp5 = [pfView createHotspot:[UIImage imageNamed:@"hotspot.png"]];
    id<PFHotspot> hp6 = [pfView createHotspot:[UIImage imageNamed:@"hotspot.png"]];
    
    [hp1 setCoordinates:0 andX:0 andZ:0];
    [hp2 setCoordinates:40 andX:5 andZ:0];
    [hp3 setCoordinates:80 andX:1 andZ:0];
    [hp4 setCoordinates:120 andX:-5 andZ:0];
    [hp5 setCoordinates:160 andX:-10 andZ:0];
    [hp6 setCoordinates:220 andX:0 andZ:0];
    
    [hp3 setSize:2];
    [hp3 setAlpha:0.5f];
    
    [hp1 setTag:1];
    [hp2 setTag:2];
    [hp3 setTag:3];
    [hp4 setTag:4];
    [hp5 setTag:5];
    [hp6 setTag:6];
    
    [hp1 addTarget:self action:@selector(onHotspot:)];
    [hp2 addTarget:self action:@selector(onHotspot:)];
    [hp3 addTarget:self action:@selector(onHotspot:)];
    [hp4 addTarget:self action:@selector(onHotspot:)];
    [hp5 addTarget:self action:@selector(onHotspot:)];
    [hp6 addTarget:self action:@selector(onHotspot:)];
}

- (void) onHotspot:(id<PFHotspot>) hotspot
{
    // log the hotspot triggered
    NSLog(@"Hotspot triggered. Tag: %d", [hotspot getTag]);
    
    // animate the hotspot to show the user it was clicked
    [hotspot animate];
}

- (void) createView
{
    // initialize an PFView
    pfView = [PFObjectFactory viewWithFrame:[self.view bounds]];
    pfView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    // set the appropriate navigation mode PFView
    [pfView setNavigationMode:currentmode];
    
    // set an optional blackspot image
//    [pfView setBlindSpotImage:@"blackspot.png"];
    //[pfView setBlindSpotLocation:PF_BLINDSPOT_BOTTOM];
    
    //Options: 0 for spherical, 1 for flat, 2 for cylindrical, 3 for side-by-side VR (non-stereoscopic), 4 for top-down VR formatted content (stereoscopic).
    [pfView setViewMode: viewMode andAspect:16.0/9.0];
    // add the view to the current stack of views
    [self.view addSubview:pfView];
    [self.view sendSubviewToBack:pfView];

    // Set some parameters
    [self resetViewParameters];
    
    // start rendering the view
    [pfView run];

}


- (void) deleteView
{
    // stop rendering the view
    [pfView halt];
    
    // remove and destroy view
    [pfView removeFromSuperview];
    pfView = nil;
}

- (void) createAssetWithUrl:(NSURL *)url
{
    touchslider = false;
    
    // load an PFAsset from an url
    pfAsset = (id<PFAsset>)[PFObjectFactory assetFromUrl:url observer:(PFAssetObserver*)self];
    [pfAsset setTimeMonitor:self];
    // connect the asset to the view
    [pfView displayAsset:(PFAsset *)pfAsset];
}

- (void) deleteAsset
{
    if (pfAsset == nil)
        return;
    
    // disconnect the asset from the view
    [pfAsset setTimeMonitor:nil];
    [pfView displayAsset:nil];
    // stop and destroy the asset
    [pfAsset stop];
    pfAsset  = nil;
}

- (void) onPlayerTime:(id<PFAsset>)asset hasTime:(CMTime)time
{
}

- (void) onStatusMessage : (id<PFAsset>) asset message:(enum PFASSETMESSAGE) m
{
    switch (m) {
        case PF_ASSET_SEEKING:
            NSLog(@"Seeking");
            seekindicator.hidden = FALSE;
            break;
        case PF_ASSET_PLAYING:
            NSLog(@"Playing");
            seekindicator.hidden = TRUE;
            CMTime t = [asset getDuration];
            slider.maximumValue = CMTimeGetSeconds(t);
            slider.minimumValue = 0.0;
            [playbutton setTitle:@"pause" forState:UIControlStateNormal];
            slider.enabled = true;
            break;
        case PF_ASSET_PAUSED:
            NSLog(@"Paused");
            [playbutton setTitle:@"play" forState:UIControlStateNormal];
            break;
        case PF_ASSET_COMPLETE:
            NSLog(@"Complete");
            [asset setTimeRange:CMTimeMakeWithSeconds(0, 1000) duration:kCMTimePositiveInfinity onKeyFrame:NO];
            break;
        case PF_ASSET_STOPPED:
            NSLog(@"Stopped");
            [self stop];
            slider.value = 0;
            slider.enabled = false;
            break;
        default:
            break;
    }
}


- (void) stop
{
    // stop the view
    [pfView halt];
    
    // delete asset and view
    [self deleteAsset];
    [self deleteView];
    
    [playbutton setTitle:@"play" forState:UIControlStateNormal];
}

- (IBAction) stopButton:(id) sender
{
    [self normalButton:sender];
    /*
    if (pfAsset == nil)
        return;
    */
    [self stop];
}

- (IBAction) playButton:(id) sender
{
    [self normalButton:sender];
    
    if (pfAsset != nil)
    {
        [pfAsset pause];
        [pfView injectImage:pauseImage];
        return;
    }
    
    // create a Panframe view
    [self createView];
    NSLog(@"setting view mode to --- %d", viewMode);
    [pfView setViewMode:viewMode andAspect:16/9];

    // create some hotspots
    //[self createHotspots];
    
    
    // create a Panframe asset
    [self createAssetWithUrl:[NSURL URLWithString:videoURL]];
    
   // [self createAssetWithUrl:[NSURL URLWithString:@"http://199.217.117.12/demi_1920_960.mp4"]];
    //[self createAssetWithUrl:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"PANO1" ofType:@"m4v"]]];
    
    if ([pfAsset getStatus] == PF_ASSET_ERROR)
        [self stop];
    else
        [pfAsset play];
}

- (IBAction) toggleNavigation:(id) sender
{
    // change navigation mode
    
    if (pfView != nil)
    {
        if (currentmode == PF_NAVIGATION_MOTION)
        {
            currentmode = PF_NAVIGATION_TOUCH;
            [navbutton setTitle:@"touch" forState:UIControlStateNormal];
        }
        else
        {
            currentmode = PF_NAVIGATION_MOTION;
            [navbutton setTitle:@"motion" forState:UIControlStateNormal];
        }
        [pfView setNavigationMode:currentmode];
    }
    
    [self normalButton:navbutton];
}

- (IBAction) toggleView:(id) sender
{
    if (pfView != nil)
    {
        if (currentview == 0)
        {
            currentview = 1;
            [viewbutton setTitle:@"flat" forState:UIControlStateNormal];
        }
        else
        {
            currentview = 0;
            [viewbutton setTitle:@"sphere" forState:UIControlStateNormal];
        }
        [pfView setViewMode:currentview andAspect:2.0/1.0];
    }
    
    [self normalButton:viewbutton];
}

- (IBAction) hiliteButton:(id) sender
{
    UIButton *b = (UIButton *) sender;
    b.backgroundColor = [UIColor colorWithRed:53.0/255.0 green:72.0/255.0 blue:160.0/255.0 alpha:1.0];
}

- (IBAction) normalButton:(id) sender
{
    UIButton *b = (UIButton *) sender;
    b.backgroundColor = [UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1.0];
}

- (IBAction) sliderChanged:(id) sender
{    
}

- (IBAction) sliderUp:(id) sender
{
    if (pfAsset != nil)
        [pfAsset setTimeRange:CMTimeMakeWithSeconds(slider.value, 1000) duration:kCMTimePositiveInfinity onKeyFrame:NO];
    touchslider = false;
}

- (IBAction) sliderDown:(id) sender
{
    touchslider = true;
}

- (void) initParams:(NSString*)url mode:(int)mode {
    videoURL = url;
    viewMode = mode;
    [pfView setViewMode:mode andAspect:16.0/9.0];
    NSLog(@"view mode has been set to mode: %d & video url set to: %@", viewMode, videoURL);
}


@end
