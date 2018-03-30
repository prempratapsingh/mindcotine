//
//  RadioButtonGroup.m
//  Squire
//
//  Created by Prem Pratap Singh on 30/03/18.
//  Copyright © 2018 AppData. All rights reserved.
//

#import "RadioButtonGroup.h"

@implementation RadioButtonGroup
@synthesize radioButtons;

- (id)initWithFrame:(CGRect)frame andOptions:(NSArray *)options
         andColumns:(int)columns{
    
    NSMutableArray *arrTemp =[[NSMutableArray alloc]init];
    self.radioButtons =arrTemp;
    //[arrTemp release];
    if (self = [super initWithFrame:frame]) {
        // Initialization code
        int framex =0;
        framex= frame.size.width/columns;
        int framey = 0;
        framey =frame.size.height/([options count]/(columns));
        int rem =[options count]%columns;
        if(rem !=0){
            framey =frame.size.height/(([options  count]
                                        /columns)+1);
        }
        int k = 0;
        for(int i = 0; i < ([options count]/columns); i++) {
            for(int j=0; j < columns; j++){
                
                int x = 0;
                int y = 0;
                UIButton *btTemp = [[UIButton alloc]
                                    initWithFrame:CGRectMake(framex*j+x, framey*i+y,
                                                             framex+x, framey+y)];
                [btTemp addTarget: self action: @selector(radioButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                btTemp.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [btTemp setImage:[UIImage imageNamed: @"radio-off.png"] forState:UIControlStateNormal];
                [btTemp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btTemp.titleLabel.font = [UIFont italicSystemFontOfSize:15];
                [btTemp setTitle:[options objectAtIndex:k] forState:UIControlStateNormal];
                [self.radioButtons addObject:btTemp];
                [self addSubview:btTemp];
                //[btTemp release];
                k++;
                
            }
        }
        
        for(int j=0; j < rem; j++){
            
            int x = 0;
            int y = 0;
            UIButton *btTemp = [[UIButton   alloc]
                                initWithFrame:CGRectMake(framex*j+x,
                                                         framey* ([options count]/columns),
                                                         framex+x,framey+y)];
            [btTemp addTarget:self action:@selector(radioButtonClicked:)
             forControlEvents:UIControlEventTouchUpInside];
            btTemp.contentHorizontalAlignment =
            UIControlContentHorizontalAlignmentLeft;
            [btTemp setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
            [btTemp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btTemp.titleLabel.font =[UIFont italicSystemFontOfSize:15];
            [btTemp setTitle:[options objectAtIndex:k] forState:UIControlStateNormal];
            [self.radioButtons addObject:btTemp];
            [self addSubview:btTemp];
            //[btTemp release];
            k++;
            
        }
        
    }
    return self;
}

- (void)dealloc {
    //[radioButtons release];
    //[super dealloc];
}

-(IBAction) radioButtonClicked:(UIButton *) sender{
    
    for(int i=0; i <[self.radioButtons count]; i++){
        [[self.radioButtons objectAtIndex:i] setImage:[UIImage imageNamed:@"radio-off.png"]
                                             forState:UIControlStateNormal];
    }
    [sender setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
    _selectedItemIndex = (int)[self.radioButtons indexOfObject:sender];
}

-(void) removeButtonAtIndex:(int)index{
    [[self.radioButtons objectAtIndex:index] removeFromSuperview];
}

-(void) setSelected:(int) index{
    for(int i=0; i < [self.radioButtons count];i++){
        [[self.radioButtons objectAtIndex:i] setImage:[UIImage
                                                       imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
        
    }
    [[self.radioButtons objectAtIndex:index] setImage:[UIImage
                                                       imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
    _selectedItemIndex = index;
}

-(void)clearAll{
    for(int i=0; i < [self.radioButtons count]; i++){
        [[self.radioButtons objectAtIndex:i] setImage:[UIImage imageNamed:@"radio-off.png"]
                                             forState:UIControlStateNormal];
    }
}

@end
