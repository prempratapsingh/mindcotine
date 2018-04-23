#//
//  SignUpViewController.m
//  Squire
//
//  Created by Héctor Cuevas Morfín on 2/22/17.
//  Copyright © 2017 AppData. All rights reserved.
//

#import "SignUpViewController.h"
#import "SignUpSecondViewController.h"
#import "UIViewController+UIViewController_Alert.h"
#import "RadioButtonGroup.h"
#import "Squire-Swift.h"
#import "SVProgressHUD.h"

@interface SignUpViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *usernameInvalid;
@property (weak, nonatomic) IBOutlet UIImageView *emailInvalid;
@property (weak, nonatomic) IBOutlet UILabel *titleText1;
@property (weak, nonatomic) IBOutlet UILabel *titleText2;
@property (weak, nonatomic) IBOutlet UILabel *titleText3;

@property BOOL isValidMail;
@property RadioButtonGroup *radioButtonGroup;

@end

@implementation SignUpViewController
@synthesize scrollView;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (TARGET_IPHONE_SIMULATOR) {
        self.textFieldMail.text = @"ff@gmail.com";
        self.textFieldName.text = @"Test";
        self.textFieldLastName.text = @"Demo";
        self.textFieldUserName.text = @"username";
        self.textFieldPassword.text = @"Test";
        self.textFieldReEnttryPassword.text = @"Test";
        self.textFieldKitCode.text = @"123xyz";
    }
    
    [self setupTextFeild];
    [[self view]addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped)]];
    
    _isValidMail = YES;
    
    _titleText1.text = NSLocalizedString(@"signupTitle1", @"");
    _titleText2.text = NSLocalizedString(@"signupTitle2", @"");
    _titleText3.text = NSLocalizedString(@"signupTitle3", @"");
    _textFieldName.placeholder = NSLocalizedString(@"firstname", @"");
    _textFieldLastName.placeholder = NSLocalizedString(@"lastname", @"");
    _textFieldMail.placeholder = NSLocalizedString(@"email", @"");
    _textFieldPassword.placeholder = NSLocalizedString(@"password", @"");
    _textFieldReEnttryPassword.placeholder = NSLocalizedString(@"re-enterpassword", @"");
    _textFieldUserName.placeholder = NSLocalizedString(@"username", @"");
    _textFieldKitCode.placeholder = NSLocalizedString(@"kitCode", @"");
    [_nextButton setTitle:NSLocalizedString(@"next", @"") forState:UIControlStateNormal];
    
    NSArray *options = [[NSArray alloc] initWithObjects:NSLocalizedString(@"contentForMale", @""), NSLocalizedString(@"contentForFemale", @""), nil];
    _radioButtonGroup = [[RadioButtonGroup alloc]
                                initWithFrame: _genderContainerView.bounds
                                andOptions:options andColumns:1];
    [_genderContainerView addSubview: _radioButtonGroup];
    [_radioButtonGroup setSelected: 0];
    
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
}


-(void)viewTapped {
    [[self view]endEditing:true];
}

-(BOOL)textField:(FloatingLabelTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
     return [textField textField:textField shouldChangeCharactersInRange:range replacementString:string];
}

-(BOOL)textFieldShouldEndEditing:(FloatingLabelTextField *)textField{
    return [textField textFieldShouldEndEditing:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _textFieldMail){
        if ([Validation email:_textFieldMail.text]) {
            _emailInvalid.hidden = true;
            [self checkMail];
        }else{  _emailInvalid.hidden = false; }
    }else if (textField == _textFieldUserName){
        [self checkUsername];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField.nextTextField becomeFirstResponder];
    if (textField == _textFieldKitCode){
        [self.view endEditing:true];
        [self showSecondViewTapped:nil];
    }
    return YES;
}

#pragma mark - Validation

- (IBAction)showSecondViewTapped:(id)sender {
    if ([self isValidaton]) {
        [self checkKitCode];
    }
}

-(void) saveDataOnServer {
    
    [SVProgressHUD showWithStatus:@""];
    
    NSDictionary *headers = @{ @"content-type": @"application/json",
                               @"cache-control": @"no-cache",
                               @"postman-token": @"e5902297-2cd6-b459-02f2-b6763957dfb1" };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: @"password" forKey: @"grant_type"];
    [params setObject: @"f3d259ddd3ed8ff3843839b" forKey: @"client_id"];
    [params setObject: @"4c7f6f8fa93d59c45502c0ae8c4a95b" forKey: @"client_secret"];
    
    [params setObject: _textFieldName.text forKey: @"name"];
    [params setObject: _textFieldLastName.text forKey: @"lastname"];
    [params setObject: _textFieldUserName.text forKey: @"username"];
    [params setObject: _textFieldMail.text forKey: @"email"];
    [params setObject: _textFieldPassword.text forKey: @"password"];
    [params setObject: (_radioButtonGroup.selectedItemIndex == 0) ? @1 : @2 forKey: @"gender"];
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
                                                                    [[NSUserDefaults standardUserDefaults]setObject:[[[dict objectForKey:@"response"] objectForKey:@"user"] objectForKey:@"username"] forKey:@"userId"];
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        [SVProgressHUD dismiss];
                                                                        [self performSegueWithIdentifier:@"showSignupSurvey" sender:nil];
                                                                    });
                                                                    
                                                                }else{
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        [self showAlertTitle:@"Error" message:@"incorrect data!"];
                                                                        [SVProgressHUD dismiss];
                                                                    });
                                                                    
                                                                }
                                                            }else{
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    [self showAlertTitle:@"Error" message:@"incorrect data!"];
                                                                    [SVProgressHUD dismiss];
                                                                });
                                                            }
                                                        }else{
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [self showAlertTitle:@"Error" message:@"incorrect data!"];
                                                                [SVProgressHUD dismiss];
                                                            });
                                                        }
                                                    }
                                                }];
    [dataTask resume];
}

-(void)checkMail{
    NSDictionary *headers = @{ @"cache-control": @"no-cache",
                               @"postman-token": @"8cceb4c7-da0e-f2a2-b935-94bcbbdd34c1" };
    
    NSString *string = [NSString stringWithFormat:@"http://ec2-35-167-200-140.us-west-2.compute.amazonaws.com/index.php/api/v1/user/check-email/%@",_textFieldMail.text];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:string]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            _emailInvalid.hidden = false;
                                                        });
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);
                                                        
                                                        NSError *error1;
                                                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error1];
                                                        if ( !error1){
                                                            if ( [httpResponse statusCode] == 200){
                                                                if ([[dict objectForKey:@"response"] isKindOfClass:[NSDictionary class]]){
                                                                    
                                                                    if([[[dict objectForKey:@"response"]objectForKey:@"exists"] boolValue]){
                                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                                            _emailInvalid.hidden = NO;
                                                                        });
                                                                    }else{
                                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                                            _emailInvalid.hidden = YES;
                                                                        });
                                                                    }
                                                                }
                                                            }
                                                        }else{
                                                        }
                                                    }
                                                }];
    [dataTask resume];
}

-(void)checkUsername{
    NSDictionary *headers = @{ @"cache-control": @"no-cache",
                               @"postman-token": @"8cceb4c7-da0e-f2a2-b935-94bcbbdd34c1" };
    
    NSString *string = [NSString stringWithFormat:@"http://ec2-35-167-200-140.us-west-2.compute.amazonaws.com/index.php/api/v1/user/check-username/%@",_textFieldUserName.text];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:string]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            _emailInvalid.hidden = false;
                                                        });
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);
                                                        
                                                        NSError *error1;
                                                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error1];
                                                        if ( !error1){
                                                            if ( [httpResponse statusCode] == 200){
                                                                if ([[dict objectForKey:@"response"] isKindOfClass:[NSDictionary class]]){
                                                                    
                                                                    BOOL exist = [[[dict objectForKey:@"response"]objectForKey:@"exists"]boolValue ];
                                                                    
                                                                    if(exist){
                                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                                            _usernameInvalid.hidden = NO;
                                                                        });
                                                                    }else{
                                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                                            _usernameInvalid.hidden = YES;
                                                                        });
                                                                    }
                                                                }
                                                            }
                                                        }else{
                                                        }
                                                        
                                                    }
                                                }];
    [dataTask resume];
}

-(void)setupTextFeild{
    
    self.textFieldName.nextTextField = self.textFieldLastName;
    self.textFieldLastName.nextTextField = self.textFieldUserName;
    self.textFieldUserName.nextTextField = self.textFieldMail;
    self.textFieldMail.nextTextField = self.textFieldPassword;
    self.textFieldPassword.nextTextField = self.textFieldReEnttryPassword;
    self.textFieldReEnttryPassword.nextTextField = self.textFieldKitCode;
    
    [self.textFieldName textDidChange:^BOOL(NSString * _Nonnull text) {
        return [Validation name:text];
    }];
    
    [self.textFieldLastName textDidChange:^BOOL(NSString * _Nonnull text) {
        return [Validation name:text];
    }];
    
    [self.textFieldUserName textDidChange:^BOOL(NSString * _Nonnull text) {
        return [Validation alphabet:text];
    }];
}

-(BOOL)isValidaton{
    
    NSString * mgs;
    
    //First Name
    if (self.textFieldName.text.length ==0 ) {
        mgs = NSLocalizedString(@"firstname", @"");
    }else if (![Validation alphabet:self.textFieldName.text]) {
        mgs = NSLocalizedString(@"validationEnterNameError", @"");
    }
    
    //Last Name
    else if (self.textFieldLastName.text.length ==0 ) {
        mgs = NSLocalizedString(@"validationEnterLastName", @"");
    }else if (![Validation alphabet:self.textFieldLastName.text]) {
        mgs = NSLocalizedString(@"validationEnterLastNameError", @"");
    }
    //UsreName
    else if (self.textFieldUserName.text.length ==0 ) {
        mgs = NSLocalizedString(@"validationEnterUserName", @"");
    }else if (![Validation alphabet:self.textFieldUserName.text]) {
        mgs = NSLocalizedString(@"validationEnterUserNameError", @"");
    }
    
    //Email
    else if (self.textFieldMail.text.length ==0 ) {
        mgs = NSLocalizedString(@"validationEnterEmail", @"");
    }else if (![Validation email:self.textFieldMail.text]) {
        mgs = NSLocalizedString(@"validationEnterEmailError1", @"");
    } else if (self.emailInvalid.isHidden == false ) {
        mgs = NSLocalizedString(@"validationEnterEmailError2", @"");
    }
    
    //Passoword
    else if (self.textFieldPassword.text.length ==0 ) {
        mgs = NSLocalizedString(@"validationEnterPassword", @"");
    }else if (self.textFieldReEnttryPassword.text.length ==0 ) {
        mgs = NSLocalizedString(@"validationEnterPassword", @"");
    }else if (self.textFieldPassword.text.length <4 ) {
        mgs = NSLocalizedString(@"validationEnterPasswordError1", @"");
    }else if (self.textFieldPassword.text.length >8 ) {
        mgs = NSLocalizedString(@"validationEnterPasswordError2", @"");
    }else if (![self.textFieldReEnttryPassword.text isEqualToString:self.textFieldPassword.text] ) {
        mgs = NSLocalizedString(@"validationEnterPasswordError3", @"");
    }else if (self.textFieldKitCode.text.length == 0 ) {
        mgs = NSLocalizedString(@"validationEnterKitCode", @"");
    }
    if (mgs.length > 0) {
        
        [self showAlertTitle:NSLocalizedString(@"validationError", @"") message:mgs];
        return NO;
    }
    
    return YES;
}

-(void)checkKitCode {
    NSURL *url = [NSURL URLWithString:@"http://ec2-35-167-200-140.us-west-2.compute.amazonaws.com/WebMindCotine/registerMindCotine.php?"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url
                                                       cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                   timeoutInterval:60];
    
    [req setHTTPMethod:@"POST"];
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSString *postData = [NSString stringWithFormat:@"&code_cardboard=%@&usuario=%@", _textFieldKitCode.text, _textFieldUserName.text];
    NSString *length = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    [req setValue:length forHTTPHeaderField:@"Content-Length"];
    [req setHTTPBody:[postData dataUsingEncoding:NSASCIIStringEncoding]];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:req
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                [self showAlertTitle:NSLocalizedString(@"validationError", @"") message:NSLocalizedString(@"validationEnterKitCode", @"")];
            } else {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                NSLog(@"%@", httpResponse);
                
                // Kit Id Check Responses
                //For Used Kit id - {"error":false,"error_msg":"Codigo inexistente "}
                //For Valid/New Kit id - {"error":true}
                
                NSError *error1;
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error1];
                if ( !error1){
                    if ( [httpResponse statusCode] == 200){
                        BOOL isError = [[dict objectForKey:@"error"] boolValue];
                        NSString *errorMessage = [dict objectForKey:@"error_msg"];
                        if( isError == YES ) {
                            [self saveDataOnServer];
                        } else {
                            [self saveDataOnServer];
//                            dispatch_async(dispatch_get_main_queue(), ^{
//                                [self showAlertTitle:NSLocalizedString(@"validationError", @"") message:NSLocalizedString(@"validationEnterKitCode", @"")];
//                            });
                        }
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self showAlertTitle:NSLocalizedString(@"validationError", @"") message:NSLocalizedString(@"validationEnterKitCode", @"")];
                        });
                    }
                } else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showAlertTitle:NSLocalizedString(@"validationError", @"") message:NSLocalizedString(@"validationEnterKitCode", @"")];
                    });
                }
            }
            
    }] resume];
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
