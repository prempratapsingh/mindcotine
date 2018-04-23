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
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@end

@implementation MediaPlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
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
        [_audioPlayer play];
    } else {
        NSLog(@"Couldn't find file media for %@", _mediaFileName);
    }
    
    [self setPlayButtonState];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    }
    
    VideoListViewController *videoListViewController = [self.storyboard instantiateViewControllerWithIdentifier: @"videoListViewController"];
    [self presentViewController:videoListViewController animated:YES completion:nil];
}

- (IBAction)didClickOnPlayButton:(id)sender {
    if(_audioPlayer == nil) {
        [self playMedia];
    } else {
        if(_audioPlayer.isPlaying == YES) {
            [_audioPlayer pause];
        } else {
            [_audioPlayer play];
        }
        [self setPlayButtonState];
    }
}
@end
