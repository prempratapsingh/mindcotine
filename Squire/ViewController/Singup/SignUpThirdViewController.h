//
//  SignUpThirdViewController.h
//  Squire
//
//  Created by Héctor Cuevas Morfín on 3/8/17.
//  Copyright © 2017 AppData. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpThirdViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *buttonNo;
@property (weak, nonatomic) IBOutlet UIButton *buttonYes;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITextField *textFieldDate;
@property (weak, nonatomic) IBOutlet UITextField *textFieldMany;
@property (weak, nonatomic) IBOutlet UITextField *textFieldManyDaily;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic)  UITextField *activeTextField;
@property (strong, nonatomic)  NSMutableArray *arrayWithNumbers;
@property (weak, nonatomic) IBOutlet UILabel *text1;

@property (weak, nonatomic) IBOutlet UILabel *Q2;
@property (weak, nonatomic) IBOutlet UILabel *Q3;
@property (weak, nonatomic) IBOutlet UILabel *Q4;
@property (weak, nonatomic) IBOutlet UILabel *Q5;

@property BOOL buttonAnswer;
@property (weak, nonatomic) IBOutlet UITextField *FQ3;
@property (weak, nonatomic) IBOutlet UITextField *FQ4;
@property (weak, nonatomic) IBOutlet UITextField *FQ5;

@end
