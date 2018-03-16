//
//  VideoTableViewCell.m
//  Squire
//
//  Created by Héctor Cuevas Morfín on 2/25/17.
//  Copyright © 2017 AppData. All rights reserved.
//

#import "VideoTableViewCell.h"

@implementation VideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)buttonPlayTapped:(id)sender {
    
    [_delegate didTapPlayView:_indexSelected];
}


@end
