//
//  MediaDownloader.h
//  Squire
//
//  Created by Prem Pratap Singh on 19/04/18.
//  Copyright © 2018 AppData. All rights reserved.
//

@interface MediaDownloader : NSObject <NSURLSessionDelegate>

@property NSURLSession *session;

- (void)download:(NSString *)from;

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite;
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location;
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error;

@end
