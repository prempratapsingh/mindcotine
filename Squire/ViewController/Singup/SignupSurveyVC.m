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

@interface SignupSurveyVC ()

@property (weak, nonatomic) IBOutlet UIView *webViewContainer;

@end

@implementation SignupSurveyVC

@synthesize webView;
@synthesize webConfiguration;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD showWithStatus:@""];
    
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
    
    NSString *typeForm;
    if( [GlobalModal.deviceLanguage isEqualToString:@"en"] ) {
        typeForm = @"http://mindcotinecommunity.typeform.com/to/t4rtLg?useri=";
    } else {
        typeForm = @"http://mindcotinecommunity.typeform.com/to/cPy9LN?useri=";
    }
    typeForm = [typeForm stringByAppendingString: signUp.textFieldUserName.text];
    
    NSURL *url = [[NSURL alloc] initWithString:typeForm];
    NSURLRequest *nsrequest = [NSURLRequest requestWithURL:url];
    [webView loadRequest:nsrequest];
    
    [self saveDataOnServer];
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
    if( [webView.URL.absoluteString containsString: @"tf=t4rtLg"] || [webView.URL.absoluteString containsString: @"tf=cPy9LN"]) {
        [self saveDataOnServer];
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

-(void) saveDataOnServer {
    
    [SVProgressHUD showWithStatus:@""];
    
    NSArray * controllersArray = [[self navigationController] viewControllers];
    SignUpViewController *signUp = controllersArray[1];
    SignUpSecondViewController *second = controllersArray[2];
    
    
    NSDictionary *headers = @{ @"content-type": @"application/json",
                               @"cache-control": @"no-cache",
                               @"postman-token": @"e5902297-2cd6-b459-02f2-b6763957dfb1" };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: @"password" forKey: @"grant_type"];
    [params setObject: @"f3d259ddd3ed8ff3843839b" forKey: @"client_id"];
    [params setObject: @"4c7f6f8fa93d59c45502c0ae8c4a95b" forKey: @"client_secret"];
    
    [params setObject: signUp.textFieldName.text forKey: @"name"];
    [params setObject: signUp.textFieldLastName.text forKey: @"lastname"];
    [params setObject: signUp.textFieldUserName.text forKey: @"username"];
    [params setObject: signUp.textFieldMail.text forKey: @"email"];
    [params setObject: signUp.textFieldPassword.text forKey: @"password"];
    NSString * valueGenderMale = NSLocalizedString(@"genderMale", @"");
    NSString * valueGenderFemale = NSLocalizedString(@"genderFemale", @"");
    [params setObject: ([second.textFieldGender.text isEqualToString:valueGenderMale])?@1: ([second.textFieldGender.text isEqualToString:valueGenderFemale])?@2:@3 forKey: @"gender"];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [params setObject: data forKey: @"data"];
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://ec2-35-167-200-140.us-west-2.compute.amazonaws.com/index.php/api/v1/user/create"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
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
                                                        NSError *error1;
                                                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error1];
                                                        if ( !error1){
                                                            if ( [httpResponse statusCode] == 200){
                                                                if ([[dict objectForKey:@"response"] isKindOfClass:[NSDictionary class]]){
                                                                    [[NSUserDefaults standardUserDefaults]setObject:[[[dict objectForKey:@"response"] objectForKey:@"user"] objectForKey:@"gender"] forKey:@"gender"];
                                                                    [[NSUserDefaults standardUserDefaults]setObject:[[[dict objectForKey:@"response"] objectForKey:@"user"] objectForKey:@"name"] forKey:@"username"];
                                                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        [SVProgressHUD dismiss];
                                                                        
                                                                        [self performSegueWithIdentifier:@"showVideoList" sender:nil];
                                                                    });
                                                                    
                                                                }else{
                                                                    [self showAlertTitle:@"Error" message:@"incorrect data!"];
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        [SVProgressHUD dismiss];
                                                                    });
                                                                    
                                                                }
                                                            }else{
                                                                [self showAlertTitle:@"Error" message:@"incorrect data!"];
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    [SVProgressHUD dismiss];
                                                                });
                                                            }
                                                        }else{
                                                            [self showAlertTitle:@"Error" message:@"incorrect data!"];
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [SVProgressHUD dismiss];
                                                            });
                                                            
                                                        }
                                                        
                                                    }
                                                }];
    [dataTask resume];
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

