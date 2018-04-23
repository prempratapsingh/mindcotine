//
//  URLs.h
//  Squire
//
//  Created by Prem Pratap Singh on 19/04/18.
//  Copyright © 2018 AppData. All rights reserved.
//

@interface URLs : NSObject

extern NSString *MINDCOTINE_AWS;
extern NSString *TAG_VIDEO;
extern NSString *TAG_AUDIO;
extern NSString *TAG_EN;
extern NSString *TAG_ES;
extern NSString *TAG_MALE;
extern NSString *TAG_FEMALE;
extern NSString *TAG_PLATFORM;
extern NSString *MINDCOTINE_DIRECTORY;

+(NSMutableArray*)getAudioFiles;
+(NSMutableArray*)getVideoFiles;
+(NSString*) getDownloadURL:(NSString *)forMedia;

@end
