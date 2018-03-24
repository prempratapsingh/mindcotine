//
//  SignUpSecondViewController.m
//  Squire
//
//  Created by Héctor Cuevas Morfín on 3/7/17.
//  Copyright © 2017 AppData. All rights reserved.
//

#import "SignUpSecondViewController.h"
#import "SignUpViewController.h"
#import "UIViewController+UIViewController_Alert.h"
#import "SVProgressHUD.h"
#import "Squire-Swift.h"

@interface SignUpSecondViewController () <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic)  UITextField *activeTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet NSArray *arrayWithGender;
@property (strong, nonatomic) IBOutlet NSArray *arrayWithEducation;
@property (strong, nonatomic) IBOutlet NSArray *arrayWithQuitSmoke;


@end

@implementation SignUpSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [NSDateComponents new];
     comps.year   = -10;
    
    
    _datePicker.maximumDate = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
    comps.year   = -90;
    _datePicker.minimumDate = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    _arrayWithGender = [[NSArray alloc] initWithObjects:[self locateString:@"genderMale"],[self locateString:@"genderFemale"],[self locateString:@"genderX"], nil];
    _arrayWithEducation = [[NSArray alloc] initWithObjects:[self locateString:@"elementary"],[self locateString:@"high"],[self locateString:@"graduated"],[self locateString:@"master"],[self locateString:@"doctor"], nil];
    _arrayWithQuitSmoke =  [[NSArray alloc] initWithObjects:[self locateString:@"none"],[self locateString:@"pills"],[self locateString:@"patches"],[self locateString:@"gums"],[self locateString:@"e-cigarettes"],[self locateString:@"therapies"], nil];
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
    _textFieldBirthDay.placeholder = [self locateString:@"birthdaydate"];
    _textFieldGender.placeholder = [self locateString:@"gender"];
    _textFieldWhat.placeholder = [self locateString:@"quit"];
    _textFieldEducation.placeholder = [self locateString:@"education"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cancelButtonTapped:(id)sender {
    _contentView.hidden = YES;
}

- (IBAction)doneButtonTapped:(id)sender {
    if ( _activeTextField == _textFieldBirthDay) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"YYYY-MM-dd";
        _activeTextField.text = [formatter stringFromDate:_datePicker.date];
    }
    if (_activeTextField == _textFieldGender){
        _activeTextField.text = _arrayWithGender[[_pickerView selectedRowInComponent:0]];
    }
    if (_activeTextField == _textFieldEducation){
        _activeTextField.text = _arrayWithEducation[[_pickerView selectedRowInComponent:0]];
    }
    if (_activeTextField == _textFieldWhat){
        _activeTextField.text = _arrayWithQuitSmoke[[_pickerView selectedRowInComponent:0]];
    }
    
    _contentView.hidden = YES;

}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    _activeTextField = textField;
    _contentView.hidden = NO;

    if (textField == _textFieldBirthDay)
    {_pickerView.hidden = YES;
        _datePicker.hidden = NO;
    }
    else
    {_pickerView.hidden = NO;
        _datePicker.hidden = YES;
        [_pickerView reloadAllComponents];
    }
    [self selectedindex];
    
}

-(void)selectedindex{
    NSArray * tmp;
    if (_activeTextField == _textFieldGender)
        tmp =  _arrayWithGender;
    if (_activeTextField == _textFieldEducation)
        tmp = _arrayWithEducation;
    if (_activeTextField == _textFieldWhat)
        tmp = _arrayWithQuitSmoke;
    NSInteger index = [tmp indexOfObject:_activeTextField.text];
    if (index<0 || index>tmp.count) {
        index  = 0;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [_pickerView selectRow: index inComponent:0 animated:false];
    });

}

//MARK: pickerview delegates

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (_activeTextField == _textFieldGender)
        return _arrayWithGender.count;
    if (_activeTextField == _textFieldEducation)
        return _arrayWithEducation.count;
    if (_activeTextField == _textFieldWhat)
        return _arrayWithQuitSmoke.count;
    return  10;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (_activeTextField == _textFieldGender)
        return _arrayWithGender[row];
    if (_activeTextField == _textFieldWhat)
        return _arrayWithQuitSmoke[row];
    if (_activeTextField == _textFieldEducation)
        return _arrayWithEducation[row];

    return @"";
}

- (IBAction)didClickOnSubmitButton:(UIButton *)sender {
    if([self isValidation]){
        [self saveDataOnServer];
    }
}


-(BOOL)isValidation{
    
    NSString * mgs;
    if (_textFieldBirthDay.text.length == 0) {
        mgs = @"Select your DOB";
    }else if (_textFieldGender.text.length == 0) {
        mgs = @"Select your Gender";
    }else if (_textFieldEducation.text.length == 0) {
        mgs = @"Select your Education";
    }else if (_textFieldWhat.text.length == 0) {
        mgs = @"completeData";
    }
   
    if (mgs.length >0) {
        [self showAlertTitle:@"Error" message:mgs];
        return FALSE;
    }

    return YES;
}

-(void) saveDataOnServer {
    
    [SVProgressHUD showWithStatus:@""];
    
    NSArray * controllersArray = [[self navigationController] viewControllers];
    SignUpViewController *signUp = controllersArray[1];
    
    
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
    [params setObject: ([_textFieldGender.text isEqualToString:valueGenderMale])?@1: ([_textFieldGender.text isEqualToString:valueGenderFemale])?@2:@3 forKey: @"gender"];
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

-(NSString*)locateString:(NSString *)stringToLocate{
    
    NSString *string = NSLocalizedString(stringToLocate, @"");
    return string;
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
@end
