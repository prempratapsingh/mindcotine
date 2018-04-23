//
//  URLs.m
//  Squire
//
//  Created by Prem Pratap Singh on 19/04/18.
//  Copyright © 2018 AppData. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalModal.h"
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
NSString *MINDCOTINE_DIRECTORY = @"Documents";

+(NSMutableArray*)getAudioFiles {
    
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

+(NSArray*)getVideoFiles {
    NSMutableArray *videoUrls = [[NSMutableArray alloc] init];
    return videoUrls;
}

+(NSString*)getDownloadURL:(NSString *)forMedia {
    NSString *url = nil;
    if( [GlobalModal.deviceLanguage isEqualToString:@"en"] ) {
        url = [NSString stringWithFormat:@"%@/%@/%@/%@/%@", MINDCOTINE_AWS, TAG_VIDEO, TAG_PLATFORM, TAG_EN, forMedia];
    } else {
       url = [NSString stringWithFormat:@"%@/%@/%@/%@/%@", MINDCOTINE_AWS, TAG_VIDEO, TAG_PLATFORM, TAG_ES, forMedia];
    }
    
    return url;
}

@end
