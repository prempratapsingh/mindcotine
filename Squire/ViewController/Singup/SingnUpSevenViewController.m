//
//  SingnUpSevenViewController.m
//  Squire
//
//  Created by Héctor Cuevas Morfín on 3/12/17.
//  Copyright © 2017 AppData. All rights reserved.
//

#import "SingnUpSevenViewController.h"

@interface SingnUpSevenViewController ()<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *Q18;
@property (weak, nonatomic) IBOutlet UILabel *Q19;
@property (weak, nonatomic) IBOutlet UILabel *Q20;
@property (weak, nonatomic) IBOutlet UILabel *Q21;
@property (weak, nonatomic) IBOutlet UILabel *Q22;
@property (weak, nonatomic) IBOutlet UILabel *Q24;
@property (weak, nonatomic) IBOutlet UIButton *buttonYes;
@property (weak, nonatomic) IBOutlet UIButton *buttonNo;
@property (weak, nonatomic) IBOutlet UIButton *buttonYes1;
@property (weak, nonatomic) IBOutlet UIButton *buttonNo1;

@property (nonatomic,strong) UITextField *activeField;

@property (strong, nonatomic)  NSArray *arrayWithQuitSmoke;
@property (strong, nonatomic)  NSMutableArray *arrayWithNumbersSaved;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic)  NSMutableArray *arrayWithNumbers;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic)  UITextField *activeTextField;
@end

@implementation SingnUpSevenViewController
@synthesize scrollView, activeField;

- (void)viewDidLoad {
    [super viewDidLoad];
    _buttonAnswer1 = YES;
    _arrayWithNumbers = [[NSMutableArray alloc]init];
    [self registerForKeyboardNotifications];
    
    [[self view]addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped)]];
    _arrayWithNumbersSaved = [[NSMutableArray alloc]init];
    for(int i = 1; i < 101; i++){
        [_arrayWithNumbersSaved addObject:[NSString stringWithFormat:@"%i",i]];
    }
//    _pickerView.backgroundColor = [UIColor colorWithRed:0.13 green:0.55 blue:0.68 alpha:1.00];

    _arrayWithQuitSmoke =  [[NSArray alloc] initWithObjects:[self locateString:@"T5"],[self locateString:@"T30"],[self locateString:@"T60"],[self locateString:@"T60s"], nil];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;

    _Q18.text = NSLocalizedString(@"Q18", @"");
    _Q19.text = NSLocalizedString(@"Q19", @"");
    _Q20.text = NSLocalizedString(@"Q20", @"");
    _Q21.text = NSLocalizedString(@"Q21", @"");
    _Q22.text = NSLocalizedString(@"Q22", @"");
    
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
    _buttonNo.layer.borderWidth = 1;
    _buttonNo.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _buttonYes.layer.borderWidth = 1;
    _buttonYes.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _buttonNo1.layer.borderWidth = 1;
    _buttonNo1.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _buttonYes1.layer.borderWidth = 1;
    _buttonYes1.layer.borderColor = [UIColor darkGrayColor].CGColor;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)buttonYesTapped:(id)sender {
    if (!_buttonAnswer1){
        UIColor *back = _buttonNo1.backgroundColor;
        [_buttonNo1 setBackgroundColor:_buttonYes1.backgroundColor];
        [_buttonYes1 setBackgroundColor:back];
        _buttonAnswer1 = !_buttonAnswer1;
    }
}
- (IBAction)buttonNoTapped:(id)sender {
    if (_buttonAnswer1){
        UIColor *back = _buttonYes1.backgroundColor;
        [_buttonYes1 setBackgroundColor:_buttonNo1.backgroundColor];
        [_buttonNo1 setBackgroundColor:back];
        _buttonAnswer1 = !_buttonAnswer1;
    }
}
- (IBAction)cancelButtonTapped:(id)sender {
    _contentView.hidden = YES;
}
- (IBAction)doneButtonTapped:(id)sender {
    
    _activeTextField.text = _arrayWithNumbers[[_pickerView selectedRowInComponent:0]];
    
    
    _contentView.hidden = YES;
    
}



-(void)viewTapped {
    [[self view]endEditing:true];
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    activeField = textField;
    if (textField != _LQ20){
        [textField resignFirstResponder];
        _activeTextField = textField;
        _contentView.hidden = NO;
        
        if (textField == _LQ18){
            _arrayWithNumbers = [[NSMutableArray alloc] initWithArray:[_arrayWithQuitSmoke mutableCopy]];
        }else{
            _arrayWithNumbers =  [[NSMutableArray alloc] initWithArray:_arrayWithNumbersSaved];;
        }
        
        _pickerView.hidden = NO;
        _datePicker.hidden = YES;
        [_pickerView reloadAllComponents];
 
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger idx = [textField.text integerValue];
        NSInteger total = [_pickerView numberOfRowsInComponent:0];
        if (idx < total) {
            [_pickerView selectRow:idx inComponent:0 animated:FALSE];
        } 
    });
   
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self viewTapped];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    activeField = nil;
}

//MARK: pickerview delegates

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (activeField == _LQ21) {
        return 100;
    }else{
        if (activeField == _LQ22) {
            return 7;
        }else{
            return _arrayWithNumbers.count;

        }
    }
    
    
    
}
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    UILabel* tView = (UILabel*)view;
//    if (!tView)
//    {
//        tView = [[UILabel alloc] init];
//        [tView setFont:[UIFont fontWithName:@"Helvetica" size:27]];
//        tView.textColor = [UIColor whiteColor];
//        [tView setTextAlignment: NSTextAlignmentCenter];
//        tView.numberOfLines=3;
//    }
//    // Fill the label text here
//    tView.text=_arrayWithNumbers[row];
//    return tView;
//}

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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
