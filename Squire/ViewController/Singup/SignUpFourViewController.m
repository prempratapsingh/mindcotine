//
//  SignUpFourViewController.m
//  Squire
//
//  Created by Héctor Cuevas Morfín on 3/8/17.
//  Copyright © 2017 AppData. All rights reserved.
//

#import "SignUpFourViewController.h"
#import "UIViewController+UIViewController_Alert.h"

@interface SignUpFourViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>



@property (weak, nonatomic) IBOutlet UILabel *Q6;
@property (weak, nonatomic) IBOutlet UILabel *Q7;
@property (weak, nonatomic) IBOutlet UILabel *Q8;
@property (weak, nonatomic) IBOutlet UILabel *Q9;


@end

@implementation SignUpFourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _arrayWithNumbers = [[NSMutableArray alloc]init];
//    _pickerView.backgroundColor = [UIColor colorWithRed:0.13 green:0.55 blue:0.68 alpha:1.00];
    for(int i = 0; i < 8; i++){
        [_arrayWithNumbers addObject:[NSString stringWithFormat:@"%i",i]];
    }
    
    _Q6.text = NSLocalizedString(@"Q6", @"");
    _Q7.text = NSLocalizedString(@"Q7", @"");
    _Q8.text = NSLocalizedString(@"Q8", @"");
    _Q9.text = NSLocalizedString(@"Q9", @"");
    _text2.text = NSLocalizedString(@"text2", @"");

    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
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

        _activeTextField.text = _arrayWithNumbers[[_pickerView selectedRowInComponent:0]];
    
    
    _contentView.hidden = YES;
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    
    _activeTextField = textField;
    _contentView.hidden = NO;
    _pickerView.hidden = NO;
    _datePicker.hidden = YES;
    [_pickerView reloadAllComponents];
    
    NSInteger idx = [textField.text integerValue];
    if (idx < _arrayWithNumbers.count) {
        [_pickerView selectRow:idx inComponent:0 animated:FALSE];
    }
    
}

- (IBAction)showNext:(id)sender {
    if(![_FQ6.text isEqualToString:@""] && ![_FQ7.text isEqualToString:@""] && ![_FQ8.text isEqualToString:@""] && ![_FQ9.text isEqualToString:@""]  ){
        [self performSegueWithIdentifier:@"showFifth" sender:nil];
        
    }else{
        
        [self showAlertTitle:@"" message:NSLocalizedString(@"completeData", @"")];
 
    }
}

//MARK: pickerview delegates

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
        return _arrayWithNumbers.count;
    
    
}
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    UILabel* tView = (UILabel*)view;
//    if (!tView)
//    {
//        tView = [[UILabel alloc] init];
//        [tView setFont:[UIFont fontWithName:@"Helvetica" size:34]];
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
