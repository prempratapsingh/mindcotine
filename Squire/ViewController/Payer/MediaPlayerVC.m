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
#import <AVFoundation/AVAudioPlayer.h>

@interface MediaPlayerVC ()
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@end

@implementation MediaPlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //_playButton.imageView =
    NSString *targetDirectory = [NSHomeDirectory() stringByAppendingPathComponent: MINDCOTINE_DIRECTORY];
    NSString *downloadFilePathStr = [targetDirectory stringByAppendingPathComponent:_mediaFileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:downloadFilePathStr] == YES) {
        NSLog(@"Initializing playback for %@", _mediaFileName);
        NSURL *url = [NSURL URLWithString:downloadFilePathStr];
        NSData *data = [NSData dataWithContentsOfURL:url];
        _audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
        [_audioPlayer play];
    } else {
        NSLog(@"Couldn't file media for %@", _mediaFileName);
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (IBAction)didClickOnBackButton:(id)sender {
    if(_audioPlayer.isPlaying) {
        [_audioPlayer stop];
    }
    
    VideoListViewController *videoListViewController = [self.storyboard instantiateViewControllerWithIdentifier: @"videoListViewController"];
    [self presentViewController:videoListViewController animated:YES completion:nil];
}

- (IBAction)didClickOnPlayButton:(id)sender {
}
@end
