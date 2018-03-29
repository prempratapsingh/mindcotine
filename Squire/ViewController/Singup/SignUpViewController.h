//
//  SignUpViewController.h
//  Squire
//
//  Created by Héctor Cuevas Morfín on 2/22/17.
//  Copyright © 2017 AppData. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FloatingLabelTextField;

@interface SignUpViewController : UIViewController

@property (weak, nonatomic) IBOutlet FloatingLabelTextField *textFieldName;
@property (weak, nonatomic) IBOutlet FloatingLabelTextField *textFieldLastName;
@property (weak, nonatomic) IBOutlet FloatingLabelTextField *textFieldUserName;
@property (weak, nonatomic) IBOutlet FloatingLabelTextField *textFieldMail;
@property (weak, nonatomic) IBOutlet FloatingLabelTextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet FloatingLabelTextField *textFieldReEnttryPassword;
@property (weak, nonatomic) IBOutlet FloatingLabelTextField *textFieldKitCode;
@property (weak, nonatomic) IBOutlet UIView *genderContainerView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;


@end
