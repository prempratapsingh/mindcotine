//
//  MediaPlayerVC.h
//  Squire
//
//  Created by Prem Pratap Singh on 21/04/18.
//  Copyright © 2018 AppData. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MediaPlayerVC : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *playButton;
- (IBAction)didClickOnPlayButton:(id)sender;
@end
