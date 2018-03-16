//
//  SingUpSixViewController.m
//  Squire
//
//  Created by Héctor Cuevas Morfín on 3/12/17.
//  Copyright © 2017 AppData. All rights reserved.
//

#import "SingUpSixViewController.h"

@interface SingUpSixViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *buttonYes;
@property (weak, nonatomic) IBOutlet UIButton *buttonNo;

@property (weak, nonatomic) IBOutlet UILabel *Q16;
@property (weak, nonatomic) IBOutlet UILabel *Q17;
@property (weak, nonatomic) IBOutlet UILabel *Q18;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic)  NSMutableArray *arrayWithNumbers;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic)  UITextField *activeTextField;
@end

@implementation SingUpSixViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arrayWithNumbers = [[NSMutableArray alloc]init];
    for(int i = 1; i < 8; i++){
        [_arrayWithNumbers addObject:[NSString stringWithFormat:@"%i",i]];
    }
//    _pickerView.backgroundColor = [UIColor colorWithRed:0.13 green:0.55 blue:0.68 alpha:1.00];

    _Q16.text = NSLocalizedString(@"Q16", @"");
    _Q17.text = NSLocalizedString(@"Q17", @"");
    _Q18.text = NSLocalizedString(@"Q18", @"");
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    _activeTextField.text = _arrayWithNumbers[[_pickerView selectedRowInComponent:0]];
    
    
    _contentView.hidden = YES;
    
}
- (IBAction)showSeven:(id)sender {
    [self performSegueWithIdentifier:@"showSeven" sender:nil];
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

@end
