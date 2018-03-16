//
//  SignUpSecondViewController.h
//  Squire
//
//  Created by Héctor Cuevas Morfín on 3/7/17.
//  Copyright © 2017 AppData. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpSecondViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *textFieldBirthDay;
@property (weak, nonatomic) IBOutlet UITextField *textFieldGender;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEducation;
@property (weak, nonatomic) IBOutlet UITextField *textFieldWhat;
@property (nonatomic, strong) NSDictionary *dictWithInfo;
@end
