//
//  VideoTableViewCell.h
//  Squire
//
//  Created by Héctor Cuevas Morfín on 2/25/17.
//  Copyright © 2017 AppData. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TableViewVideCellDelegate <NSObject>

-(void)didTapPlayView:(NSIndexPath *) indexpath;

@end
@interface VideoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageViewVideo;
@property (weak, nonatomic) IBOutlet UILabel *labelTop;

@property (weak, nonatomic) IBOutlet UILabel *labelBottom;
@property (nonatomic,strong) NSIndexPath *indexSelected;
@property (weak) id<TableViewVideCellDelegate> delegate;

@end
