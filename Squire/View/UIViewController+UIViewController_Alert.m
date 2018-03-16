//
//  UIViewController+UIViewController_Alert.m
//  Squire
//
//  Created by INX on 8/29/17.
//  Copyright © 2017 AppData. All rights reserved.
//

#import "UIViewController+UIViewController_Alert.h"

@implementation UIViewController (UIViewController_Alert)
-(void)showAlertTitle:(NSString*)title message:(NSString*)message
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:true completion:nil];

}
@end
