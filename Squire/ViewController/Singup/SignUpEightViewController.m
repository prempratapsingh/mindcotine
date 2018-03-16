//
//  SignUpEightViewController.m
//  Squire
//
//  Created by Héctor Cuevas Morfín on 3/16/17.
//  Copyright © 2017 AppData. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "SignUpEightViewController.h"
#import "SignUpViewController.h"
#import "SignUpSecondViewController.h"
#import "SignUpThirdViewController.h"
#import "SignUpFourViewController.h"
#import "SignUpFifthViewController.h"
#import "SingUpSixViewController.h"
#import "SingnUpSevenViewController.h"
#import "SVProgressHUD.h"
#import "Squire-Swift.h"
#import "UIViewController+UIViewController_Alert.h"
@interface SignUpEightViewController ()
@property (weak, nonatomic) IBOutlet UILabel *Q23;
@property (weak, nonatomic) IBOutlet UIButton *buttonYes;
@property (weak, nonatomic) IBOutlet UIButton *buttonNo;

@end

@implementation SignUpEightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _Q23.text = NSLocalizedString(@"Q23", @"");
    _buttonAnswer = YES;
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
    _buttonNo.layer.borderWidth = 1;
    _buttonNo.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _buttonYes.layer.borderWidth = 1;
    _buttonYes.layer.borderColor = [UIColor darkGrayColor].CGColor;
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonYesTapped:(id)sender {
    if (!_buttonAnswer){
        UIColor *back = _buttonNo.backgroundColor;
        [_buttonNo setBackgroundColor:_buttonYes.backgroundColor];
        [_buttonYes setBackgroundColor:back];
        _buttonAnswer = !_buttonAnswer;
    }
}
- (IBAction)buttonNoTapped:(id)sender {
    if (_buttonAnswer){
        UIColor *back = _buttonYes.backgroundColor;
        [_buttonYes setBackgroundColor:_buttonNo.backgroundColor];
        [_buttonNo setBackgroundColor:back];
        _buttonAnswer = !_buttonAnswer;
    }
}


-(void) saveDataOnServer {
    
    [SVProgressHUD showWithStatus:@""];
    NSArray * controllersArray = [[self navigationController] viewControllers];
    
    SignUpViewController *signUp = controllersArray[1];
    SignUpSecondViewController *second = controllersArray[2];
    SignUpThirdViewController *third = controllersArray[3];
    SignUpFourViewController *four = controllersArray[4];
    SignUpFifthViewController *fifth = controllersArray[5];
    //SingUpSixViewController *six = controllersArray[6];
    SingnUpSevenViewController *seven = controllersArray[6];
    NSString * valueGenderMale = NSLocalizedString(@"genderMale", @"");
    NSString * valueGenderFemale = NSLocalizedString(@"genderFemale", @"");
    NSDictionary *headers = @{ @"content-type": @"application/json",
                               @"cache-control": @"no-cache"
                              };
    NSDictionary *parameters = @{
                                  @"grant_type": @"password",
                                  @"client_id" : @"f3d259ddd3ed8ff3843839b",
                                  @"client_secret": @"4c7f6f8fa93d59c45502c0ae8c4a95b",
                                  @"email": signUp.textFieldMail.text,
                                  @"password": signUp.textFieldPassword.text,
                                  @"username": signUp.textFieldUserName.text,
                                  @"name": signUp.textFieldName.text,
                                  @"lastname": signUp.textFieldLastName.text,
                                  @"birthday": second.textFieldBirthDay.text,
                                  @"gender":  ([second.textFieldGender.text isEqualToString:valueGenderMale])?@1: ([second.textFieldGender.text isEqualToString:valueGenderFemale])?@2:@3 ,
                                  @"education": second.textFieldEducation.text,
                                  @"tried": second.textFieldWhat.text,
                                  @"data": @{ @"1": third.buttonAnswer ? @1:@0,
                                              @"2": third.FQ3.text,
                                              @"3": third.FQ4.text,
                                              @"4": third.FQ5.text,
                                              @"5": four.FQ6.text,
                                              @"6": four.FQ7.text,
                                              @"7": four.FQ8.text,
                                              @"8": four.FQ9.text,
                                              @"9": fifth.FQ10.text,
                                              @"10":fifth.FQ11.text,
                                              @"11": fifth.FQ12.text,
                                              @"12": fifth.FQ13.text,
                                              @"13": fifth.FQ14.text,
                                              @"14":  fifth.FQ15.text,
                                              @"15": fifth.FQ16.text,
                                              @"16": fifth.FQ17.text,
                                              @"17": seven.LQ18.text,
                                              @"19": seven.LQ20.text,
                                              @"18": seven.buttonAnswer1 ? @1:@0,
                                              @"20": seven.LQ21.text,
                                              @"21": seven.LQ22.text,
                                              @"22": _buttonAnswer ? @1:@0
                                              }

                                  };
   
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://ec2-35-167-200-140.us-west-2.compute.amazonaws.com/index.php/api/v1/user/create/"]
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
//                                                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error1];
                                                        if ( !error1){
                                                            if ( [httpResponse statusCode] == 200){
                                                                
                                                                [[NSUserDefaults standardUserDefaults]setObject:
                                                                                                         ([second.textFieldGender.text isEqualToString:valueGenderMale])? @"1": ([second.textFieldGender.text isEqualToString:valueGenderFemale])?@"2":@"3" forKey:@"gender"];
                                                                
                                                                [[NSUserDefaults standardUserDefaults]setObject: signUp.textFieldName.text forKey:@"username"];
                                                                [[NSUserDefaults standardUserDefaults] synchronize];
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    [SVProgressHUD dismiss];
                                                                    
                                                                    [self performSegueWithIdentifier:@"showListVideosss" sender:nil];
                                                                });
                                                            }
                                                        }else{
                                                            [self showAlertTitle:@"Error" message:@"Incorrect data!"];
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                 [SVProgressHUD dismiss];
                                                            });
                                                            
                                                        }

                                                    }
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        [SVProgressHUD dismiss];
                                                    });
                                                }];
    [dataTask resume];
}
- (IBAction)showList:(id)sender {
    
    [self saveDataOnServer];
}

-(void)viewWillAppear:(BOOL)animated{
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

@end
