//
//  MediaDownloader.m
//  Squire
//
//  Created by Prem Pratap Singh on 19/04/18.
//  Copyright © 2018 AppData. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MediaDownloader.h"
#import "URLs.h"

@implementation MediaDownloader

-(void) download: (NSString *)mediaFileName {
    
    NSString *targetDirectory = [NSHomeDirectory() stringByAppendingPathComponent: MINDCOTINE_DIRECTORY];
    NSString *downloadFilePathStr = [targetDirectory stringByAppendingPathComponent:mediaFileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:downloadFilePathStr] == NO) {
        NSURL *url = [NSURL URLWithString:[URLs getDownloadURL:mediaFileName]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
        NSString *uuidStr = (__bridge_transfer NSString *) CFUUIDCreateString(kCFAllocatorDefault, uuid);
        CFRelease(uuid);
        NSString *randomSessionIdentifier = [uuidStr lowercaseString];
        NSURLSessionConfiguration* config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:randomSessionIdentifier];
        config.sessionSendsLaunchEvents = YES;
        config.allowsCellularAccess = YES;
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        NSURLSessionDownloadTask* task = [_session downloadTaskWithRequest:request];
        [task resume];
    } else {
        NSLog(@"%@ was already downloaded!", mediaFileName);
    }
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    NSLog(@"Download is in progress for %@", downloadTask.currentRequest.URL);
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSString *targetDirectory = [NSHomeDirectory() stringByAppendingPathComponent: MINDCOTINE_DIRECTORY];
    NSString *downloadFilePathStr = [targetDirectory stringByAppendingPathComponent:downloadTask.currentRequest.URL.lastPathComponent];
    NSURL *downloadFilePath = [NSURL fileURLWithPath:downloadFilePathStr];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *moveError = nil;
    [fileManager moveItemAtURL:location toURL:downloadFilePath error:&moveError];
    
    if(moveError == nil) {
        NSLog(@"File successfully downloaded and saved at %@", downloadFilePathStr);
    } else {
        NSLog(@"Download FAILED! Error:  %@", moveError.localizedDescription);
    }
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"Download FAILED! Error:  %@", error.localizedDescription);
}

-(void)downloadSmokeCravingAudios {
    NSMutableArray *audioFiles = URLs.getAudioFiles;
    for(NSString *audio in audioFiles) {
        [self download: audio];
    }
}

@end
