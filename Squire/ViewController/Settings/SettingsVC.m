//
//  SettingsVC.m
//  Squire
//
//  Created by Prem Pratap Singh on 19/03/18.
//  Copyright © 2018 AppData. All rights reserved.
//

#import "SettingsVC.h"
#import "Squire-Swift.h"

@interface SettingsVC ()
@property (weak, nonatomic) IBOutlet FloatingLabelTextField *currentPasswordTextField;
@property (weak, nonatomic) IBOutlet FloatingLabelTextField *nwPasswordTextField;
@property (weak, nonatomic) IBOutlet FloatingLabelTextField *confirmPasswordTextField;
@end

@implementation SettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_backButton setTitle:NSLocalizedString(@"back", @"") forState:UIControlStateNormal];
    [_submitButton setTitle:NSLocalizedString(@"submit", @"") forState:UIControlStateNormal];
    _settingsTitle.text = NSLocalizedString(@"settingsTitle", @"");
    _resetPassword.text = NSLocalizedString(@"resetPasswordTitle", @"");
    _currentPasswordTF.placeholder = NSLocalizedString(@"currentPasswordTitle", @"");
    _nwPasswordTF.placeholder = NSLocalizedString(@"newPasswordTitle", @"");
    _confirmPasswordTF.placeholder = NSLocalizedString(@"confirmPasswordTitle", @"");
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return  UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)didClickOnBackButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didClickOnSubmitButton:(UIButton *)sender {
}

@end


