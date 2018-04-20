//
//  URLs.m
//  Squire
//
//  Created by Prem Pratap Singh on 19/04/18.
//  Copyright © 2018 AppData. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLs.h"

@implementation URLs

NSString *MINDCOTINE_AWS = @"http://ec2-35-167-200-140.us-west-2.compute.amazonaws.com";
NSString *TAG_VIDEO = @"videos";
NSString *TAG_AUDIO = @"audios";
NSString *TAG_EN = @"en";
NSString *TAG_ES = @"es";
NSString *TAG_MALE = @"male";
NSString *TAG_FEMALE = @"female";
NSString *TAG_PLATFORM = @"android";
NSString *MINDCOTINE_DIRECTORY = @"mindcotine";

+(NSMutableArray*)getAudioUrls {
    
    NSMutableArray *audioUrls = [[NSMutableArray alloc] init];
    [audioUrls addObject:@"audio_vas_1.mp3"];
    [audioUrls addObject:@"audio_vas_2.mp3"];
    [audioUrls addObject:@"audio_vas_3.mp3"];
    [audioUrls addObject:@"audio_vas_4.mp3"];
    [audioUrls addObject:@"audio_vas_5.mp3"];
    [audioUrls addObject:@"audio_vas_6.mp3"];
    [audioUrls addObject:@"audio_vas_7.mp3"];
    
    return audioUrls;
}

+(NSArray*)getVideoUrls {
    NSMutableArray *videoUrls = [[NSMutableArray alloc] init];
    return videoUrls;
}

@end
