
//
//  SmokeCravingVC.m
//  Squire
//
//  Created by Prem Pratap Singh on 16/04/18.
//  Copyright © 2018 AppData. All rights reserved.
//
#import "SmokeCravingVC.h"
#import "Squire-Swift.h"
#import "WebKit/WKWebView.h"
#import "GlobalModal.h"
#import "SVProgressHUD.h"
#import "UIViewController+UIViewController_Alert.h"
#import "TypeFormManager.h"
#import "MediaPlayerVC.h"

@interface SmokeCravingVC ()

@property (weak, nonatomic) IBOutlet UIView *webViewContainer;
@property NSString *mediaFileName;
@property BOOL shouldDisplayView;

@end

@implementation SmokeCravingVC

@synthesize webView;
@synthesize webConfiguration;

- (void)viewDidLoad {
    [super viewDidLoad];
    _shouldDisplayView = YES;
    [self showSmokeCravingTypeForm];
}

-(void)viewWillAppear:(BOOL)animated{
    if(_shouldDisplayView == YES) {
        self.navigationController.navigationBarHidden = NO;
        [[UIDevice currentDevice] setValue:
         [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                    forKey:@"orientation"];
        
        [SVProgressHUD showWithStatus:@""];
    } else {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _shouldDisplayView = NO;
}

-(void)showSmokeCravingTypeForm {
    [SVProgressHUD showWithStatus:@""];
    
    NSString *javaScript = @"console.log('hello world')";
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:javaScript
                                                      injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                   forMainFrameOnly:YES];
    
    // webConfiguration
    webConfiguration = [[WKWebViewConfiguration alloc] init];
    
    // webView
    //CGSize webViewFrame = _webViewContainer.frame;
    webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, _webViewContainer.frame.size.width, _webViewContainer.frame.size.height) configuration:webConfiguration];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [webView.configuration.userContentController addUserScript:userScript];
    webView.navigationDelegate = self;
    [_webViewContainer addSubview:webView];
    
    NSString *userName = [[NSUserDefaults standardUserDefaults]valueForKey:@"userId"];
    NSString *typeForm;
    if( [GlobalModal.deviceLanguage isEqualToString:@"en"] ) {
        typeForm = [NSString stringWithFormat:@"http://mindcotinecommunity.typeform.com/to/HICjM8?user=%@", userName];
    } else {
        typeForm = [NSString stringWithFormat:@"http://mindcotinecommunity.typeform.com/to/iQXwlv?user=%@", userName];
    }
    
    typeForm = [typeForm stringByAppendingString: userName];
    
    NSURL *url = [[NSURL alloc] initWithString:typeForm];
    NSURLRequest *nsrequest = [NSURLRequest requestWithURL:url];
    [webView loadRequest:nsrequest];
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler{
    NSLog(@"navigationAction.request.URL: %@", navigationAction.request.URL);
    decisionHandler(WKNavigationActionPolicyAllow);
}

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"didStartProvisionalNavigation");
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"didFinishNavigation: %@", webView.URL.absoluteString);
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    
    _mediaFileName = nil;
    NSString *webUrl = webView.URL.absoluteString;
    BOOL shouldPlayMedia = NO;
    if( [webUrl containsString: @"pY9wJb"] ) {
        _mediaFileName = @"audio_vas_1.mp3";
        shouldPlayMedia = YES;
    } else if( [webUrl containsString: @"IMuC34"] ) {
        _mediaFileName = @"audio_vas_2.mp3";
        shouldPlayMedia = YES;
    } else if( [webUrl containsString: @"XclD1Q"] ) {
        _mediaFileName = @"audio_vas_3.mp3";
        shouldPlayMedia = YES;
    } else if( [webUrl containsString: @"gNCus5"] ) {
        _mediaFileName = @"audio_vas_4.mp3";
        shouldPlayMedia = YES;
    } else if( [webUrl containsString: @"V7k2cd"] ) {
        _mediaFileName = @"audio_vas_5.mp3";
        shouldPlayMedia = YES;
    } else if( [webUrl containsString: @"qtvNDf"] ) {
        _mediaFileName = @"audio_vas_6.mp3";
        shouldPlayMedia = YES;
    } else if( [webUrl containsString: @"saY8Ql"] ) {
        _mediaFileName = @"audio_vas_7.mp3";
        shouldPlayMedia = YES;
    } else if([webUrl containsString: @"EKNY3c"]) {
        _mediaFileName = @"audio_vas_1.mp3";
        shouldPlayMedia = YES;
    }
    
    if( shouldPlayMedia == YES ) {
        [self performSegueWithIdentifier:@"showMediaPlayerVC" sender:nil];
    }
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
    NSLog(@"didFailNavigation");
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Error!"
                                          message:@"Cannot load request."
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [alertController dismissViewControllerAnimated:YES completion:nil];
                               }];
    
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"didCommitNavigation");
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

-(void)viewTapped {
    [[self view]endEditing:true];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return  UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showMediaPlayerVC"]){
        MediaPlayerVC *mediaPlayer = [segue destinationViewController];
        mediaPlayer.mediaFileName = _mediaFileName;
    }
}

@end

