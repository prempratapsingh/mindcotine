//
//  SimplePlayerViewController.m
//  SimplePlayer
//
//  Created by Ron Bakker on 18-06-13.
//  Copyright (c) 2013 Mindlight. All rights reserved.
//

#import "SimplePlayerViewController.h"
#import <Panframe/Panframe.h>
#import <Google/Analytics.h>
#import <AVFoundation/AVFoundation.h>

@interface SimplePlayerViewController () <PFAssetObserver, PFAssetTimeMonitor>
{
    PFView * pfView;
    id<PFAsset> pfAsset;
    enum PFNAVIGATIONMODE currentmode;
    bool touchslider;
    NSTimer *slidertimer;
    int currentview;
    
    IBOutlet UIButton *playbutton;
    IBOutlet UIButton *stopbutton;
    IBOutlet UIButton *navbutton;
    IBOutlet UIButton *viewbutton;
    IBOutlet UISlider *slider;
    IBOutlet UILabel *labelTime;
    
    IBOutlet UIButton *bigPlayButton;
    IBOutlet UILabel *labelTotalTime;
    IBOutlet UIActivityIndicatorView *seekindicator;
    
    UIImage *pauseImage;
}

- (void) onStatusMessage : (PFAsset *) asset message:(enum PFASSETMESSAGE) m;
- (void) onPlayerTime:(id<PFAsset>)asset hasTime:(CMTime)time;

@end

@implementation SimplePlayerViewController

- (void)viewDidLoad
{
     [[AVAudioSession sharedInstance]     setCategory: AVAudioSessionCategoryPlayback     error: nil];
    
    _isHiddenBottomView = NO;
    
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    slider.value = slider.minimumValue;
    slider.enabled = false;
    
    slidertimer = [NSTimer scheduledTimerWithTimeInterval: 0.5
                                                   target: self
                                                 selector:@selector(onPlaybackTime:)
                                                 userInfo: nil repeats:YES];
    
    seekindicator.hidden = TRUE;
    [_bottomView setBackgroundColor:[UIColor colorWithRed:0.31 green:0.31 blue:0.31 alpha:0.70]];
    [_topView setBackgroundColor:[UIColor colorWithRed:0.31 green:0.31 blue:0.31 alpha:0.70]];
    currentmode = PF_NAVIGATION_MOTION;
    currentview = 3;
    [self normalButton:viewbutton];
  //  [self normalButton:navbutton];
   // [self normalButton:playbutton];
    [self normalButton:stopbutton];
    
    pauseImage = [UIImage imageNamed:@"pausescreen.png"];
    
    [self.navigationController.navigationBar setHidden:NO];
   // [self.navigationController setHidesBarsOnTap:YES];
    
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeRight]
                                forKey:@"orientation"];
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
   
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeRight]
                                forKey:@"orientation"];
//    [UIViewController attemptRotationToDeviceOrientation];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"PlayerViewController"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self stop];
    [self.navigationController.navigationBar setHidden:YES];
}

-(void)onPlaybackTime:(NSTimer *)timer
{
    // retrieve the playback time from an asset and update the slider
    
    if (pfAsset == nil)
        return;
    if (!touchslider && [pfAsset getStatus] != PF_ASSET_SEEKING)
    {
        CMTime t = [pfAsset getPlaybackTime];
                NSLog(@"%f",CMTimeGetSeconds([pfAsset getPlaybackTime]));
       // CMTime durationV = videoAVURLAsset.duration;
        
        NSUInteger dTotalSeconds = CMTimeGetSeconds([pfAsset getPlaybackTime]);
        
        
        NSUInteger dHours = floor(dTotalSeconds / 3600);
        NSUInteger dMinutes = floor(dTotalSeconds % 3600 / 60);
        NSUInteger dSeconds = floor(dTotalSeconds % 3600 % 60);
        
        NSString *videoDurationText = [NSString stringWithFormat:@"%lu:%02lu:%02lu",(unsigned long)dHours, (unsigned long)dMinutes, (unsigned long)dSeconds];
        labelTime.text = videoDurationText;
        
        NSUInteger dTotalSeconds2 = CMTimeGetSeconds([pfAsset getDuration]);
        
        NSUInteger dHours2 = floor(dTotalSeconds2 / 3600);
        NSUInteger dMinutes2 = floor(dTotalSeconds2 % 3600 / 60);
        NSUInteger dSeconds2 = floor(dTotalSeconds2 % 3600 % 60);
        
        NSString *videoDurationText2 = [NSString stringWithFormat:@"%lu:%02lu:%02lu",(unsigned long)dHours2, (unsigned long)dMinutes2, (unsigned long)dSeconds2];
        labelTotalTime.text = videoDurationText2;
        
        
        
        
        slider.value = CMTimeGetSeconds(t);
    }
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    [self resetViewParameters];
}

- (void) resetViewParameters
{
    // set default FOV
//    [pfView setFieldOfView:75.0f];
    // register the interface orientation with the PFView
    [pfView setInterfaceOrientation:self.interfaceOrientation];
    switch(self.interfaceOrientation)
    {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
            // Wider FOV which for portrait modes (matter of taste)
//            [pfView setFieldOfView:90.0f];
            break;
        default:
            break;
    }
}

- (void) createHotspots
{
    // create some sample hotspots on the view and register a callback
   /*
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
    
    [hp1 setSize:4];
    
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
    [hp6 addTarget:self action:@selector(onHotspot:)];*/
}

- (void) onHotspotFocusIn:(id<PFHotspot>) hotspot
{
    NSLog(@"IN");
    [hotspot setSize:5];
}

- (void) onHotspotFocusOut:(id<PFHotspot>) hotspot
{
    NSLog(@"OUT");
    [hotspot setSize:4];
}


- (void) onHotspot:(id<PFHotspot>) hotspot
{
    NSLog(@"OUT - %d", [hotspot getTag]);
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
   // [pfView setBlindSpotImage:@"blackspot.png"];
//    [pfView setBlindSpotLocation:PF_BLINDSPOT_BOTTOM];
    
    // add the view to the current stack of views
    [self.view addSubview:pfView];
    [self.view sendSubviewToBack:pfView];
    
    [pfView setViewMode:currentview andAspect:16.0/9.0];
//    [pfView setHitOnFocus:false];
    [pfView setAutoLevel:false afterSeconds:10];
    // Set some parameters
    [self resetViewParameters];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTaped:)];
    [tapGesture setNumberOfTapsRequired:1];
    [pfView addGestureRecognizer:tapGesture];
    
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
    CMTime t = [asset getDuration];
    
    switch (m) {
        case PF_ASSET_SEEKING:
            NSLog(@"Seeking");
            seekindicator.hidden = FALSE;
            break;
        case PF_ASSET_PLAYING:
            NSLog(@"Playing");
            seekindicator.hidden = TRUE;
            slider.maximumValue = CMTimeGetSeconds(t);
            slider.minimumValue = 0.0;
            [playbutton setImage:[UIImage imageNamed:@"pauseButton"] forState:UIControlStateNormal];
          //  [playbutton setTitle:@"pause" forState:UIControlStateNormal];
            slider.enabled = true;
            break;
        case PF_ASSET_PAUSED:
            NSLog(@"Paused");
            [playbutton setImage:[UIImage imageNamed:@"playButton2"] forState:UIControlStateNormal];
          //  [playbutton setTitle:@"play" forState:UIControlStateNormal];
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
        case PF_ASSET_BUFFER_EMPTY:
            NSLog(@"Buffer empty");
            break;
        case PF_ASSET_BUFFER_FULL:
            NSLog(@"Buffer full");
            break;
        case PF_ASSET_BUFFER_KEEPING_UP:
            NSLog(@"Buffer keeping up");
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
    [bigPlayButton setHidden:YES];
   // [self normalButton:sender];
    
    if (pfAsset != nil)
    {
        [pfAsset pause];
        //[pfView injectImage:pauseImage];
        return;
    }
    
    // create a Panframe view
    [self createView];
    
    // create some hotspots
    [self createHotspots];
    
    // create a Panframe asset    
 //   [self createAssetWithUrl:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Esquire12" ofType:@"mp4"]]];
   // [self createAssetWithUrl:[NSURL URLWithString:@"http://mind-cotine.appdata.mx/videos/MINDCOTINE_VR_V2_English_1_3.mp4"]];
    [self createAssetWithUrl:[NSURL URLWithString:_urlForVideo]];
    if ([pfAsset getStatus] == PF_ASSET_ERROR)
        [self stop];
    else
    {
        [pfAsset play];
        [_bottomView setHidden:YES];
        [_topView setHidden:YES];
        _isHiddenBottomView  = !_isHiddenBottomView;
    }
    
    

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
    
   // [self normalButton:navbutton];
}

- (IBAction) toggleView:(id) sender
{
    if (pfView != nil)
    {
        if (currentview == 0)
        {
            currentview = 3;
           // [viewbutton setTitle:@"flat" forState:UIControlStateNormal];
            [navbutton setImage:[UIImage imageNamed:@"normal"] forState:UIControlStateNormal];
        }
        else
        {
            currentview = 0;
            [viewbutton setTitle:@"sphere" forState:UIControlStateNormal];
            [navbutton setImage:[UIImage imageNamed:@"card"] forState:UIControlStateNormal];
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
    NSLog(@"%f",slider.value);
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

-(void)didTaped:(id*)sender
{
    if(_isHiddenBottomView)
    {
        [_bottomView setHidden:NO];
        [_topView setHidden:NO];
        [self.navigationController.navigationBar setHidden:NO];
    }else
    {
        [_bottomView setHidden:YES];
        [_topView setHidden:YES];
         [self.navigationController.navigationBar setHidden:YES];
      
    }
      _isHiddenBottomView  = !_isHiddenBottomView;
    
}
- (IBAction)doGoBack:(id)sender {
    
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"videoListViewController"];
    [self presentViewController:controller animated:true completion:nil];
}

- (IBAction)shareButtonPressed:(id)sender {
    
    NSMutableArray *sharingItems = [NSMutableArray new];
    
    [sharingItems addObject:[NSURL URLWithString:@"http://www.esquirelat.com"]];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    
    [self presentViewController:activityController animated:YES completion:nil];
}

- (BOOL)shouldAutorotate
{
    //	(iOS 6)
    //	No auto rotating
    return false;
}

- (NSUInteger)supportedInterfaceOrientations
{
    //	(iOS 6)
    //	Only allow rotation to portrait
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    //	(iOS 6)
    //	Force to portrait
    return UIInterfaceOrientationLandscapeRight;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight) || (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end
