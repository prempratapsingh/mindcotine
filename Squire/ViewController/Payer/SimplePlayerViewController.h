//
//  SimplePlayerViewController.h
//  SimplePlayer
//
//  Created by Ron Bakker on 18-06-13.
//  Copyright (c) 2013 Mindlight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimplePlayerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic, assign) BOOL isHiddenBottomView;
@property (nonatomic,strong) NSString *urlForVideo;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end
