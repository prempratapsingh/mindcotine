//
//  VideoListViewController.h
//  Squire
//
//  Created by Héctor Cuevas Morfín on 2/25/17.
//  Copyright © 2017 AppData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface VideoListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *signOutButton;
@property (weak, nonatomic) IBOutlet UILabel *contactUsTitle;
@property (weak, nonatomic) IBOutlet UIButton *wantToSmokeButton;

@end
