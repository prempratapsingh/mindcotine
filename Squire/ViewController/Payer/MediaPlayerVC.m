//
//  MediaPlayerVC.m
//  Squire
//
//  Created by Prem Pratap Singh on 21/04/18.
//  Copyright © 2018 AppData. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MediaPlayerVC.h"
#import "GlobalModal.h"
#import "URLs.h"
#import "VideoListViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface MediaPlayerVC ()
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *elapsedTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *progressBarSlider;


@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation MediaPlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    
    _progressBarSlider.minimumValue = 0;
    _progressBarSlider.value = 0;
    UIImage *sliderThumb = [UIImage imageNamed:@"slider-thumb-small"];
    [_progressBarSlider setThumbImage:sliderThumb forState:UIControlStateNormal];
    [_progressBarSlider setThumbImage:sliderThumb forState:UIControlStateHighlighted];
    _elapsedTimeLabel.text = @"00:00";
    _totalTimeLabel.text = @"00:00";
    
    [self playMedia];
}

-(void)playMedia {
    NSString *targetDirectory = [NSHomeDirectory() stringByAppendingPathComponent: MINDCOTINE_DIRECTORY];
    NSString *downloadFilePathStr = [targetDirectory stringByAppendingPathComponent:_mediaFileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:downloadFilePathStr] == YES) {
        NSLog(@"Initializing playback for %@", _mediaFileName);
        NSURL *soundUrl = [NSURL fileURLWithPath:downloadFilePathStr];
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
        _progressBarSlider.maximumValue = _audioPlayer.duration;
        [_audioPlayer setCurrentTime: 0];
        [_audioPlayer play];
        [self startTimer];
    } else {
        NSLog(@"Couldn't find file media for %@", _mediaFileName);
    }
    
    [self setPlayButtonState];
}

-(void)setPlayButtonState {
    if(_audioPlayer == nil) {
        [_playButton setImage:[UIImage imageNamed:@"playButtonWhite"] forState : UIControlStateNormal];
    } else {
        if(_audioPlayer.isPlaying == YES) {
            [_playButton setImage:[UIImage imageNamed:@"pauseButtonWhite"] forState : UIControlStateNormal];
        } else {
            [_playButton setImage:[UIImage imageNamed:@"playButtonWhite"] forState : UIControlStateNormal];
        }
    }
}

- (IBAction)didClickOnBackButton:(id)sender {
    if(_audioPlayer.isPlaying) {
        [_audioPlayer stop];
        [_timer invalidate];
    }
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)didClickOnPlayButton:(id)sender {
    if(_audioPlayer == nil) {
        [self playMedia];
        [self startTimer];
    } else {
        if(_audioPlayer.isPlaying == YES) {
            [_audioPlayer pause];
            [_timer invalidate];
        } else {
            [_audioPlayer play];
             [self startTimer];
        }
        [self setPlayButtonState];
    }
}

- (IBAction)didClickOnSeekButton:(id)sender {
    if(_audioPlayer.isPlaying == YES) {
        NSTimeInterval playerDuration = _audioPlayer.currentTime;
        [_audioPlayer setCurrentTime: playerDuration + 10];
    }
}

- (IBAction)didChangeProgressSlider:(id)sender {
    [_audioPlayer setCurrentTime: _progressBarSlider.value];
}



-(void) startTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                              target:self
                                            selector:@selector(updateViewsWithTimer:)
                                            userInfo:nil
                                             repeats:YES];
}

-(void)updateViewsWithTimer:(NSTimer *)timer {
    [self updateViews];
}

-(void)updateViews {
    
    NSInteger elapsedTime = (NSInteger)_audioPlayer.currentTime;
    NSInteger elapsedSeconds = elapsedTime % 60;
    NSInteger elapsedMinutes = (elapsedTime / 60) % 60;
    _elapsedTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)elapsedMinutes, (long)elapsedSeconds];
    
    NSInteger totalTime = (NSInteger)_audioPlayer.duration;;
    NSInteger totalSeconds = totalTime % 60;
    NSInteger totalMinutes = (totalTime / 60) % 60;
    _totalTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)totalMinutes, (long)totalSeconds];
    
    if(elapsedTime == totalTime - 1) {
        [_audioPlayer stop];
        [_audioPlayer setCurrentTime: 0];
         _progressBarSlider.value = 0;
        _elapsedTimeLabel.text = @"00:00";
        [_timer invalidate];
        [self setPlayButtonState];
    } else {
        _progressBarSlider.value = (float)_audioPlayer.currentTime;
    }
}

@end
