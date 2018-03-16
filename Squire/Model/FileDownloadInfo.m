//
//  FileDownloadInfo.m
//  Squire
//
//  Created by Héctor Cuevas Morfín on 5/3/16.
//  Copyright © 2016 AppData. All rights reserved.
//

#import "FileDownloadInfo.h"

@implementation FileDownloadInfo


-(id)initWithFileTitle:(NSString *)title andDownloadSource:(NSString *)source{
    if (self == [super init]) {
        self.fileTitle = title;
        self.downloadSource = source;
        self.downloadProgress = 0.0;
        self.isDownloading = NO;
        self.downloadComplete = NO;
        self.taskIdentifier = -1;
    }
    
    return self;
}

@end
