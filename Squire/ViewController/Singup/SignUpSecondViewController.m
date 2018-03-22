//
//  SignUpSecondViewController.m
//  Squire
//
//  Created by Héctor Cuevas Morfín on 3/7/17.
//  Copyright © 2017 AppData. All rights reserved.
//

#import "SignUpSecondViewController.h"
#import "UIViewController+UIViewController_Alert.h"

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
- (IBAction)showThird:(id)sender {
    if([self isValidation]){
        [self performSegueWithIdentifier:@"showSignupSurvey" sender:nil];
        //[self performSegueWithIdentifier:@"showThird" sender:nil];
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
