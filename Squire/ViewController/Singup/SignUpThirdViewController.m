//
//  SignUpThirdViewController.m
//  Squire
//
//  Created by Héctor Cuevas Morfín on 3/8/17.
//  Copyright © 2017 AppData. All rights reserved.
//

#import "SignUpThirdViewController.h"
#import "UIViewController+UIViewController_Alert.h"
@interface SignUpThirdViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>



@end

@implementation SignUpThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _buttonAnswer = YES;
    _datePicker.maximumDate  = [NSDate date];

    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _buttonNo.layer.borderWidth = 1;
    _buttonNo.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _buttonYes.layer.borderWidth = 1;
    _buttonYes.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _arrayWithNumbers = [[NSMutableArray alloc]init];
    for(int i = 0; i < 100; i++){
        [_arrayWithNumbers addObject:[NSString stringWithFormat:@"%i",i]];
    }
    
    _Q2.text = NSLocalizedString(@"Q2", @"");
    _Q3.text = NSLocalizedString(@"Q3", @"");
    _Q4.text = NSLocalizedString(@"Q4", @"");
    _Q5.text = NSLocalizedString(@"Q5", @"");
    _text1.text = NSLocalizedString(@"text1", @"");
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (IBAction)cancelButtonTapped:(id)sender {
    _contentView.hidden = YES;
}
- (IBAction)doneButtonTapped:(id)sender {
    if ( _activeTextField == _textFieldDate) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"dd MMMM YYYY";
        _activeTextField.text = [formatter stringFromDate:_datePicker.date];
    }else{
        _activeTextField.text = _arrayWithNumbers[[_pickerView selectedRowInComponent:0]];
    }
    
    _contentView.hidden = YES;
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    _activeTextField = textField;
    _contentView.hidden = NO;
    
    if (textField == _textFieldDate)
    {_pickerView.hidden = YES;
        _datePicker.hidden = NO;
    }
    else
    {_pickerView.hidden = NO;
        _datePicker.hidden = YES;
        [_pickerView reloadAllComponents];}
    
    NSInteger idx = [textField.text integerValue];
    if (idx < _arrayWithNumbers.count) {
        [_pickerView selectRow:idx inComponent:0 animated:FALSE];
    }
    
}

- (IBAction)showThird:(id)sender {
    if(![_textFieldDate.text isEqualToString:@""] && ![_textFieldMany.text isEqualToString:@""] && ![_textFieldManyDaily.text isEqualToString:@""]  ){
        [self performSegueWithIdentifier:@"showFour" sender:nil];
        
    }else{
        
        [self showAlertTitle:@"" message:NSLocalizedString(@"completeData", @"")];

    }
}

//MARK: pickerview delegates

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (_activeTextField == _textFieldDate)
    {return 0;}
    else{
        return _arrayWithNumbers.count;
    }

}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    
    return _arrayWithNumbers[row];
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
