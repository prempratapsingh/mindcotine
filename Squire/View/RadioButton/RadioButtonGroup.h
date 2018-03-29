//
//  RadioButtonGroup.h
//  Squire
//
//  Created by Prem Pratap Singh on 30/03/18.
//  Copyright © 2018 AppData. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadioButtonGroup : UIView {
    NSMutableArray *radioButtons;
}

@property (nonatomic,retain) NSMutableArray *radioButtons;

- (id)initWithFrame:(CGRect)frame andOptions:(NSArray *)options
         andColumns:(int)columns;
-(IBAction) radioButtonClicked:(UIButton *) sender;
-(void) removeButtonAtIndex:(int)index;
-(void) setSelected:(int) index;
-(void)clearAll;
@end
