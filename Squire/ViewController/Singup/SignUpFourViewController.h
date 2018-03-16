//
//  SignUpFourViewController.h
//  Squire
//
//  Created by Héctor Cuevas Morfín on 3/8/17.
//  Copyright © 2017 AppData. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpFourViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic)  NSMutableArray *arrayWithNumbers;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic)  UITextField *activeTextField;
@property (weak, nonatomic) IBOutlet UILabel *text2;
@property (weak, nonatomic) IBOutlet UITextField *FQ6;
@property (weak, nonatomic) IBOutlet UITextField *FQ7;
@property (weak, nonatomic) IBOutlet UITextField *FQ8;
@property (weak, nonatomic) IBOutlet UITextField *FQ9;


@end
