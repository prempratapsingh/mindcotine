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

#import "Squire-Swift.h"

@interface SignUpViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *usernameInvalid;
@property (weak, nonatomic) IBOutlet UIImageView *emailInvalid;
@property (weak, nonatomic) IBOutlet UILabel *signupTitle;



@property BOOL isValidMail;

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
    }
    
    [self setupTextFeild];
  
//    self.textFieldReEnttryPassword.nextTextField = self.textFieldLastName;
    
    [[self view]addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped)]];
    _isValidMail = YES;
    
    _signupTitle.text = NSLocalizedString(@"signupTitle", @"");
    _textFieldName.placeholder = NSLocalizedString(@"firstname", @"");
    _textFieldLastName.placeholder = NSLocalizedString(@"lastname", @"");
    _textFieldMail.placeholder = NSLocalizedString(@"email", @"");
    _textFieldPassword.placeholder = NSLocalizedString(@"password", @"");
    _textFieldReEnttryPassword.placeholder = NSLocalizedString(@"re-enterpassword", @"");
    _textFieldUserName.placeholder = NSLocalizedString(@"username", @"");
    [_nextButton setTitle:NSLocalizedString(@"next", @"") forState:UIControlStateNormal];
    
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
    // Do any additional setup after loading the view.
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
    if (textField == _textFieldReEnttryPassword){
        [self.view endEditing:true];
        [self showSecondViewTapped:nil];
    }
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    SignUpSecondViewController *controller = segue.destinationViewController;
    controller.dictWithInfo = @{@"key": @"value"};
}

#pragma mark - Validation

- (IBAction)showSecondViewTapped:(id)sender {
    
    if ([self isValidaton]) {
        [self performSegueWithIdentifier:@"showSecond" sender:nil];
    }
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
    
    [self.textFieldName textDidChange:^BOOL(NSString * _Nonnull text) {
        return [Validation name:text];
    }];
    
    [self.textFieldLastName textDidChange:^BOOL(NSString * _Nonnull text) {
        return [Validation name:text];
    }];
    
    [self.textFieldUserName textDidChange:^BOOL(NSString * _Nonnull text) {
        return [Validation alphabet:text];
    }];
//    
//    [self.textFieldMail textDidChange:^BOOL(NSString * _Nonnull text) {
//        return [Validation email:text];
//    }];
   
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
    }
    if (mgs.length > 0) {
        
        [self showAlertTitle:NSLocalizedString(@"validationError", @"") message:mgs];
        return false;
    }
    
    return YES;
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
    //	(iOS 6)
    //	Force to portrait
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}
@end
