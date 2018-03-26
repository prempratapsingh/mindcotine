//
//  LogInViewController.m
//  Squire
//
//  Created by Héctor Cuevas Morfín on 2/25/17.
//  Copyright © 2017 AppData. All rights reserved.
//

#import "LogInViewController.h"
#import "SVProgressHUD.h"
#import <MessageUI/MessageUI.h>
#import "Squire-Swift.h"
#import "UIViewController+UIViewController_Alert.h"
#import "TypeFormManager.h"

@interface LogInViewController ()<MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *buttonLogin;
@property (weak, nonatomic) IBOutlet FloatingLabelTextField *username;
@property (weak, nonatomic) IBOutlet FloatingLabelTextField *password;
@property (weak, nonatomic) IBOutlet UIButton *createAccount;
@property (weak, nonatomic) IBOutlet UIButton *contactUs;
@property (weak, nonatomic) IBOutlet UIButton *buttonSkip;

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_buttonLogin setTitle:NSLocalizedString(@"login", @"") forState:UIControlStateNormal];
    [_createAccount setTitle:NSLocalizedString(@"newaccount", @"") forState:UIControlStateNormal];
    [_contactUs setTitle:NSLocalizedString(@"contactus", @"") forState:UIControlStateNormal];

    _username.placeholder = NSLocalizedString(@"userName", @"");
    _password.placeholder = NSLocalizedString(@"userPassword", @"");
    [_buttonSkip setTitle:NSLocalizedString(@"skip", @"") forState:UIControlStateNormal];
    [[self view]addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped)]];
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];

    [self.username textDidChange:^BOOL(NSString * _Nonnull text) {
        return [Validation alphabet:text];
    }];
    // Do any additional setup after loading the view.
}
-(void)viewTapped {
    [[self view]endEditing:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
   // [[UINavigationBar appearance] setBackgroundColor:[UIColor greenColor]];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:(8.0/255.0) green:(223.0/255.0) blue:(161.0/255.0) alpha:(1.0)]];
    
    self.navigationController.navigationBarHidden = YES;
    
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return  UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    //	(iOS 6)
    //	Force to portrait
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)loginUser {
    
    
    
    
    NSDictionary *headers = @{ @"content-type": @"application/json",
                               @"cache-control": @"no-cache",
                               @"postman-token": @"e5902297-2cd6-b459-02f2-b6763957dfb1" };
    NSDictionary *parameters = @{ @"username": _username.text,
                                  @"password": _password.text,
                                  @"grant_type": @"password",
                                  @"client_id": @"f3d259ddd3ed8ff3843839b",
                                  @"client_secret": @"4c7f6f8fa93d59c45502c0ae8c4a95b" };
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://ec2-35-167-200-140.us-west-2.compute.amazonaws.com/index.php/api/v1/user/login"]
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
                                                        NSError *error1;
                                                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error1];
                                                        if ( !error1){
                                                            if ( [httpResponse statusCode] == 200){
                                                                if ([[dict objectForKey:@"response"] isKindOfClass:[NSDictionary class]]){
                                                                    [[NSUserDefaults standardUserDefaults]setObject:[[[dict objectForKey:@"response"] objectForKey:@"user"] objectForKey:@"gender"] forKey:@"gender"];
                                                                    [[NSUserDefaults standardUserDefaults]setObject:[[[dict objectForKey:@"response"] objectForKey:@"user"] objectForKey:@"name"] forKey:@"username"];
                                                                    
                                                                    NSString *userName = [[[dict objectForKey:@"response"] objectForKey:@"user"] objectForKey:@"username"];
                                                                    [[NSUserDefaults standardUserDefaults]setObject:userName forKey:@"userId"];
                                                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        [SVProgressHUD dismiss];
                                                                        if( [TypeFormManager hasUserCompletedSignupSurvey:userName] == NO ) {
                                                                            [self performSegueWithIdentifier:@"showSignupSurvey" sender:nil];
                                                                        } else {
                                                                            [self performSegueWithIdentifier:@"showVideoList" sender:nil];
                                                                        }
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
-(BOOL)isValidaton{
    
    NSString * mgs;
    if (self.username.text.length ==0 ) {
        mgs = @"Enter username";
    }else if (![Validation alphabet:self.username.text]) {
        mgs = @"Username, special characters is not allowed";
    }else if (self.password.text.length ==0 ) {
        mgs = @"Enter Password";
    }else if (self.password.text.length <4 ) {
        mgs = @"Password min length 4";
    }else if (self.password.text.length >8 ) {
        mgs = @"Password max length 8";
    }
    if (mgs.length > 0) {
        
        [self showAlertTitle:@"Error!" message:mgs];
        return false;
    }
    
    return YES;
}
#pragma mark - Button Action
- (IBAction)buttonLoginTapped:(id)sender {
    
    if ([self isValidaton]) {
        [self.view endEditing:true];
        [SVProgressHUD showWithStatus: [self locateString:@"starting"]];
        [self loginUser];
    }
   
}
- (IBAction)signUpButtonTapped:(id)sender {
    [self performSegueWithIdentifier:@"showFirstSignUpView" sender:nil];
}

- (IBAction)sendMail:(id)sender {
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"Support"];
        [mail setMessageBody:@" " isHTML:NO];
        [mail setToRecipients:@[@"nicolas@mindcotine.com"]];
        
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error!" message:@"Your device doesn't support the composer sheet." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:true completion:nil];
    }
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(NSString*)locateString:(NSString *)stringToLocate{
    
    NSString *string = NSLocalizedString(stringToLocate, @"");
    return string;
}
@end
