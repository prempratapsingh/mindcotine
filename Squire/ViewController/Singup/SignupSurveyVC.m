//
//  SignupSurveyVC.m
//  Squire
//
//  Created by Prem Pratap Singh on 18/03/18.
//  Copyright © 2018 AppData. All rights reserved.
//
#import "SignupSurveyVC.h"
#import "SignUpViewController.h"
#import "Squire-Swift.h"
#import "WebKit/WKWebView.h"

@interface SignupSurveyVC ()

@property (weak, nonatomic) IBOutlet UIView *webViewContainer;

@end

@implementation SignupSurveyVC

@synthesize webView;
@synthesize webConfiguration;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray * controllersArray = [[self navigationController] viewControllers];
    SignUpViewController *signUp = controllersArray[1];
    
    // userScript
    
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
    
    // request
    NSString *google = @"http://mindcotinecommunity.typeform.com/to/t4rtLg?useri=xparrow";
    NSURL *url = [[NSURL alloc] initWithString:google];
    NSURLRequest *nsrequest = [NSURLRequest requestWithURL:url];
    [webView loadRequest:nsrequest];
}

#pragma mark - WKWebview Delegate Methods

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSLog(@"decidePolicyForNavigationAction");
    
    NSLog(@"navigationAction.request.URL: %@", navigationAction.request.URL);
    
    // cancel or allow requests
    
    if (([[NSString stringWithFormat:@"%@", navigationAction.request.URL] isEqualToString: @"https://www.bing.com"])){
        
        decisionHandler(WKNavigationActionPolicyCancel);
        
    } else {
        
        decisionHandler(WKNavigationActionPolicyAllow);
        
    }
}

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    NSLog(@"didStartProvisionalNavigation");
    
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    NSLog(@"didFinishNavigation");
    
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
                                   // call a method when the OK button is pressed
                               }];
    
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
    NSLog(@"didCommitNavigation");
    
}

-(void)viewTapped {
    [[self view]endEditing:true];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    
    
    
    [[UIDevice currentDevice] setValue:
    [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
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

@end

