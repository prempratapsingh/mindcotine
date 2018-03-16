//
//  DetailViewController.m
//  SimplePlayer
//
//  Created by Héctor Cuevas Morfín on 3/21/16.
//  Copyright © 2016 Mindlight. All rights reserved.
//

#import "DetailViewController.h"
#import <Foundation/Foundation.h>
#import "SimplePlayerViewController.h"
#import <Google/Analytics.h>
#import "FileDownloadInfo.h"

@interface DetailViewController ()<NSURLSessionDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFieldCode;
@property (nonatomic,strong) NSString *urlToSend;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *lastdivition;
@property (weak, nonatomic) IBOutlet UIImageView *bottomLogo;
@property (weak, nonatomic) IBOutlet UILabel *labelPercentaje;

//downloadinfo
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSMutableArray *arrFileDownloadData;
@property (nonatomic, strong) NSURL *docDirectoryURL;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
       [_activityIndicator setHidden:YES];
    if(self.view.frame.size.height < 568)
    {
        _lastdivition.hidden = _bottomLogo.hidden = YES;
    }
    
    //Download configuration
    [self initializeFileDownloadDataArray];
    NSArray *URLs = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    self.docDirectoryURL = [URLs objectAtIndex:0];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfiguration:@"com.BGTransferDemo"];
    sessionConfiguration.HTTPMaximumConnectionsPerHost = 5;
    
    self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                 delegate:self
                                            delegateQueue:nil];

    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"DetailViewController"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //	(iOS 6)
    //	Only allow rotation to portrait
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    //	(iOS 6)
    //	Force to portrait
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)doValidateCode:(id)sender {
    //XHGC98
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"doShowPlayer" sender:nil];
        
        
    });
 /*   [_activityIndicator setHidden:NO];
    [_activityIndicator startAnimating];
    [_activityIndicator setHidesWhenStopped:YES];
    UIButton *button = sender;
   // [button setEnabled:NO];
    if(_textFieldCode.text.length>0)
    {
        [_textFieldCode resignFirstResponder];
        NSDictionary *headers = @{ @"content-type": @"multipart/form-data; boundary=---011000010111000001101001",
                                   @"cache-control": @"no-cache",
                                   @"postman-token": @"d879c071-ceb9-773b-f5a6-8444c0f8ad07" };
        NSArray *parameters = @[ @{ @"name": @"code", @"value": _textFieldCode.text } ];
        NSString *boundary = @"---011000010111000001101001";
        
        NSError *error;
        NSMutableString *body = [NSMutableString string];
        for (NSDictionary *param in parameters) {
            [body appendFormat:@"--%@\r\n", boundary];
            if (param[@"fileName"]) {
                [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"; filename=\"%@\"\r\n", param[@"name"], param[@"fileName"]];
                [body appendFormat:@"Content-Type: %@\r\n\r\n", param[@"contentType"]];
                [body appendFormat:@"%@", [NSString stringWithContentsOfFile:param[@"fileName"] encoding:NSUTF8StringEncoding error:&error]];
                if (error) {
                    NSLog(@"%@", error);
                }
            } else {
                [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"\r\n\r\n", param[@"name"]];
                [body appendFormat:@"%@", param[@"value"]];
            }
        }
        [body appendFormat:@"\r\n--%@--\r\n", boundary];
        NSData *postData = [body dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://videos360.appdata.mx/get/video"]
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:10.0];
        [request setHTTPMethod:@"POST"];
        [request setAllHTTPHeaderFields:headers];
        [request setHTTPBody:postData];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if (error) {
                                                            NSLog(@"%@", error);
                                                        } else {
                                                            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                            NSLog(@"%@", httpResponse);
                                                            NSError *JSONerror = nil;
                                                            
                                                            NSDictionary *JSONDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&JSONerror];
                                                            NSLog(@"%@",JSONDict);
                                                            
                                                            if([JSONDict objectForKey:@"video"])
                                                            {
                                                                if(![[[JSONDict objectForKey:@"video"]objectForKey:@"ios"] isKindOfClass:[NSNull class]])
                                                                {
                                                                    
                                                                    _urlToSend =[[JSONDict objectForKey:@"video"]objectForKey:@"ios"];
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        [self performSegueWithIdentifier:@"doShowPlayer" sender:nil];
                                                                    
                                                                        
                                            });
                                                                    
                                                                }else
                                                                {
                                                                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Aviso" message:@"El código es incorrecto." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        [alert show];
                                                                        
                                                                    });
                                                                }
                                                            }
                                                            else
                                                            {
                                                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Aviso" message:@"El código es incorrecto." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    [alert show];
                                                                    
                                                                });
                                                            }
                                                            [button setEnabled:YES];
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [_activityIndicator stopAnimating];
                                                                
                                                            });
                                                        }
                                                    }];
        [dataTask resume];
        */
        /*
     if([_textFieldCode.text isEqualToString:@"XHGC98"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"doShowPlayer" sender:nil];
            });
            
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Aviso" message:@"El código es incorrecto." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [alert show];
                
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_activityIndicator stopAnimating];
            
        });*/
 /*   }
    else
    {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Aviso" message:@"Es necesario ingresar el código." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        dispatch_async(dispatch_get_main_queue(), ^{
              [alert show];
         [button setEnabled:YES];
         [_activityIndicator stopAnimating];
        });
    }
    */
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
     [self animateTextField:textField up:NO];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [self animateTextField:textField up:YES];
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    return YES;
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    
    int x=180;
    if(self.view.frame.size.height < 568)
    {
        x= 210;
    }
    
    const int movementDistance = x;
    const float movementDuration = 0.3f;
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    /*SimplePlayerViewController *playerViewController = [segue destinationViewController];
    playerViewController.urlForVideo = _urlToSend;*/
    
}
- (IBAction)goBack:(id)sender {
   // [self.navigationController popViewControllerAnimated:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Downdolad methods
-(void)initializeFileDownloadDataArray{
    self.arrFileDownloadData = [[NSMutableArray alloc] init];
    
    [self.arrFileDownloadData addObject:[[FileDownloadInfo alloc] initWithFileTitle:@"Belinda Video" andDownloadSource:@"http://chelixpreciado.info/media/AppStore.m4v"]];
}

- (IBAction)startOrPauseDownloadingSingleFile:(id)sender {
    // Check if the parent view of the sender button is a table view cell.
  
        
        // Get the row (index) of the cell. We'll keep the index path as well, we'll need it later
        
        // Get the FileDownloadInfo object being at the cellIndex position of the array.
        FileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:0];
        
        // The isDownloading property of the fdi object defines whether a downloading should be started
        // or be stopped.
        if (!fdi.isDownloading) {
            // This is the case where a download task should be started.
            
            // Create a new task, but check whether it should be created using a URL or resume data.
            if (fdi.taskIdentifier == -1) {
                // If the taskIdentifier property of the fdi object has value -1, then create a new task
                // providing the appropriate URL as the download source.
                fdi.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:fdi.downloadSource]];
                
                // Keep the new task identifier.
                fdi.taskIdentifier = fdi.downloadTask.taskIdentifier;
                
                // Start the task.
                [fdi.downloadTask resume];
            }
            else{
                // The resume of a download task will be done here.
            }
        }
        else{
            //  The pause of a download task will be done here.
        }
        
        // Change the isDownloading property value.
        fdi.isDownloading = !fdi.isDownloading;
        
        // Reload the table view.
    
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
    if (totalBytesExpectedToWrite == NSURLSessionTransferSizeUnknown) {
        NSLog(@"Unknown transfer size");
    }
    else{
        // Locate the FileDownloadInfo object among all based on the taskIdentifier property of the task.
        int index = [self getFileDownloadInfoIndexWithTaskIdentifier:downloadTask.taskIdentifier];
        FileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:index];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // Calculate the progress.
            fdi.downloadProgress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
            _labelPercentaje.text = [NSString stringWithFormat:@"%hhd %%",(int8_t)(((double)totalBytesWritten*100)/(double)totalBytesExpectedToWrite)];
           
            _progressView.progress = fdi.downloadProgress;
        }];
    }
}


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *destinationFilename = downloadTask.originalRequest.URL.lastPathComponent;
    NSURL *destinationURL = [self.docDirectoryURL URLByAppendingPathComponent:destinationFilename];
    
    if ([fileManager fileExistsAtPath:[destinationURL path]]) {
        [fileManager removeItemAtURL:destinationURL error:nil];
    }
    
    BOOL success = [fileManager copyItemAtURL:location
                                        toURL:destinationURL
                                        error:&error];
    
    if (success) {
        // Change the flag values of the respective FileDownloadInfo object.
        int index = [self getFileDownloadInfoIndexWithTaskIdentifier:downloadTask.taskIdentifier];
        FileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:index];
        
        fdi.isDownloading = NO;
        fdi.downloadComplete = YES;
        
        // Set the initial value to the taskIdentifier property of the fdi object,
        // so when the start button gets tapped again to start over the file download.
        fdi.taskIdentifier = -1;
        
        // In case there is any resume data stored in the fdi object, just make it nil.
        fdi.taskResumeData = nil;
        
        
    }
    else{
        NSLog(@"Unable to copy temp file. Error: %@", [error localizedDescription]);
    }
}

-(int)getFileDownloadInfoIndexWithTaskIdentifier:(unsigned long)taskIdentifier{
    int index = 0;
    for (int i=0; i<[self.arrFileDownloadData count]; i++) {
        FileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:i];
        if (fdi.taskIdentifier == taskIdentifier) {
            index = i;
            break;
        }
    }
    
    return index;
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if (error != nil) {
        NSLog(@"Download completed with error: %@", [error localizedDescription]);
    }
    else{
        NSLog(@"Download finished successfully.");
    }
}
@end
