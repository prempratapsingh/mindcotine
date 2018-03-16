//
//  PlayerViewController.m
//  Squire
//
//  Created by Héctor Cuevas Morfín on 4/26/16.
//  Copyright © 2016 AppData. All rights reserved.
//

#import "PlayerViewController.h"
#import "GCSVideoView.h"
#import "GCSCardboardView.h"
#import "FileDownloadInfo.h"


@interface PlayerViewController ()<GCSVideoViewDelegate,GCSCardboardViewDelegate,GCSWidgetViewDelegate>

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet GCSVideoView *player;
@property (nonatomic,strong) GCSCardboardView *viewCardboard ;
@property (weak, nonatomic) IBOutlet UILabel *timerRunning;
@property (weak, nonatomic) IBOutlet UIView *toopBar;
@property (weak, nonatomic) IBOutlet UILabel *totalTime;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@end

@implementation PlayerViewController{
    BOOL _isPaused;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _player.delegate = self;
   // _player.enableFullscreenButton = YES;
    _player.enableCardboardButton = YES;
    _isPaused = NO;
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileName = @"AppStore.m4v";
    NSString* fileAtPath = [filePath stringByAppendingPathComponent:fileName];
    NSURL* URL = [NSURL fileURLWithPath:fileAtPath];
    //[_player loadFromUrl:[NSURL URLWithString:@"http://www.kolor.com/360-videos-files/noa-neal-graffiti-360-music-video-full-hd.mp4"]];
    
    [_player loadFromUrl:URL];
    [_bottomView setBackgroundColor:[UIColor clearColor]];
    [_toopBar setBackgroundColor:[UIColor colorWithRed:0.31 green:0.31 blue:0.31 alpha:0.70]];
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - GCSVideoViewDelegate

- (void)widgetViewDidTap:(GCSWidgetView *)widgetView {
    if (_isPaused) {
        //[_player resume];
        [_playButton setHidden:YES];
        [_toopBar setHidden:YES];
        [_bottomView setHidden:NO];
        [_slider setHidden: YES];
        [_timerRunning setHidden:YES];
        [_totalTime setHidden:YES];
        
    } else {
       // [_player pause];
        [_playButton setHidden:NO];
        [_toopBar setHidden:NO];
        [_slider setHidden: NO];
        [_timerRunning setHidden:NO];
        [_totalTime setHidden:NO];
        [_bottomView setHidden:YES];
    
    }
    _isPaused = !_isPaused;
}

- (void)widgetView:(GCSWidgetView *)widgetView didLoadContent:(id)content {
    NSLog(@"Finished loading video");
}

- (void)widgetView:(GCSWidgetView *)widgetView
didFailToLoadContent:(id)content
  withErrorMessage:(NSString *)errorMessage {
    NSLog(@"Failed to load video: %@", errorMessage);
}


- (void)videoView:(GCSVideoView*)videoView didUpdatePosition:(NSTimeInterval)position {
    // Loop the video when it reaches the end.
    if (position == videoView.duration) {
        [_player seekTo:0];
        [_player resume];
    }
    
    _slider.maximumValue = videoView.duration;
    _slider.minimumValue = 0;
    
    _slider.value = position;
    
    NSInteger minutes = floor(position/60);
    NSInteger seconds = round(position - minutes * 60);
 
    NSUInteger dHours = floor(position / 3600);
    NSUInteger dMinutes = minutes;
    NSUInteger dSeconds = seconds;
    
    NSLog(@"%@",[NSString stringWithFormat:@"%lu:%02lu:%02lu",(unsigned long)dHours, (unsigned long)dMinutes, (unsigned long)dSeconds]);
    NSString *videoDurationText = [NSString stringWithFormat:@"%lu:%02lu:%02lu",(unsigned long)dHours, (unsigned long)dMinutes, (unsigned long)dSeconds];
    _timerRunning.text = videoDurationText;
    
    
    NSInteger minutes2 = floor([_player duration]/60);
    NSInteger seconds2 = round([_player duration] - minutes2 * 60);
    
    NSUInteger dHours2 = floor([_player duration] / 3600);
    NSUInteger dMinutes2 = minutes2;
    NSUInteger dSeconds2 = seconds2;
    
    NSLog(@"%@",[NSString stringWithFormat:@"%lu:%02lu:%02lu",(unsigned long)dHours, (unsigned long)dMinutes, (unsigned long)dSeconds]);
    NSString *videoDurationText2 = [NSString stringWithFormat:@"%lu:%02lu:%02lu",(unsigned long)dHours2, (unsigned long)dMinutes2, (unsigned long)dSeconds2];
    _totalTime.text = videoDurationText2;
    
    
    [_playButton setHidden:YES];
    //labelTime.text = videoDurationText;
}
-(void)cardboardView:(GCSCardboardView *)cardboardView didFireEvent:(GCSUserEvent)event
{
    
    NSLog(@"event from user");
}
-(void)cardboardView:(GCSCardboardView *)cardboardView drawEye:(GCSEye)eye withHeadTransform:(GCSHeadTransform *)headTransform
{
    
}
- (IBAction)slideChanged:(id)sender {
    
    
     [_player seekTo:_slider.value];
    
}
- (IBAction)doPlayButton:(id)sender {
    
    [_player resume];
    [_playButton setHidden:YES];
    [_toopBar setHidden:YES];
    [_slider setHidden: YES];
    [_timerRunning setHidden:YES];
    [_totalTime setHidden:YES];
}
- (IBAction)shareButton:(id)sender {
    NSMutableArray *sharingItems = [NSMutableArray new];
    
    [sharingItems addObject:[NSURL URLWithString:@"http://www.esquirelat.com"]];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    
    [self presentViewController:activityController animated:YES completion:nil];
}
- (IBAction)doGoBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
