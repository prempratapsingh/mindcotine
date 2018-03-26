//
//  SettingsVC.h
//  Squire
//
//  Created by Prem Pratap Singh on 19/03/18.
//  Copyright © 2018 AppData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "Squire-Swift.h"

@interface SettingsVC : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *settingsTitle;
@property (weak, nonatomic) IBOutlet UILabel *resetPassword;
@property (weak, nonatomic) IBOutlet FloatingLabelTextField *currentPasswordTF;
@property (weak, nonatomic) IBOutlet FloatingLabelTextField *nwPasswordTF;
@property (weak, nonatomic) IBOutlet FloatingLabelTextField *confirmPasswordTF;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end
