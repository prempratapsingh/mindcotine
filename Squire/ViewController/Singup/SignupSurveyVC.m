//
//  SignupSurveyVC.m
//  Squire
//
//  Created by Prem Pratap Singh on 18/03/18.
//  Copyright © 2018 AppData. All rights reserved.
//
#import "SignupSurveyVC.h"
#import "SignUpViewController.h"
#import "SignUpSecondViewController.h"
#import "Squire-Swift.h"
#import "WebKit/WKWebView.h"
#import "GlobalModal.h"
#import "SVProgressHUD.h"
#import "UIViewController+UIViewController_Alert.h"
#import "TypeFormManager.h"

@interface SignupSurveyVC ()

@property (weak, nonatomic) IBOutlet UIView *webViewContainer;

@end

@implementation SignupSurveyVC

@synthesize webView;
@synthesize webConfiguration;

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    NSString *typeForm;
    if( [GlobalModal.deviceLanguage isEqualToString:@"en"] ) {
        typeForm = @"http://mindcotinecommunity.typeform.com/to/t4rtLg?useri=";
    } else {
        typeForm = @"http://mindcotinecommunity.typeform.com/to/cPy9LN?useri=";
    }
    NSString *userName = [[NSUserDefaults standardUserDefaults]valueForKey:@"userId"];
    typeForm = [typeForm stringByAppendingString: userName];
    
    NSURL *url = [[NSURL alloc] initWithString:typeForm];
    NSURLRequest *nsrequest = [NSURLRequest requestWithURL:url];
    [webView loadRequest:nsrequest];
}

#pragma mark - WKWebview Delegate Methods

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler{
    NSLog(@"navigationAction.request.URL: %@", navigationAction.request.URL);
    decisionHandler(WKNavigationActionPolicyAllow);
}

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"didStartProvisionalNavigation");
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"didFinishNavigation: %@", webView.URL.absoluteString);
    if( [webView.URL.absoluteString containsString: @"tf=t4rtLg"] || [webView.URL.absoluteString containsString: @"tf=cPy9LN"] ) {
        
        NSString *userName = [[NSUserDefaults standardUserDefaults]valueForKey:@"userId"];
        [TypeFormManager addToSignedSurveyUsersList:userName];
        [self performSegueWithIdentifier:@"showVideoList" sender:nil];
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

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [[UIDevice currentDevice] setValue:
    [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
    
    [SVProgressHUD showWithStatus:@""];
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

