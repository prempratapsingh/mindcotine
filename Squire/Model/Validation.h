//
//  Validation.h
//  Squire
//
//  Created by INX on 8/29/17.
//  Copyright © 2017 AppData. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Validation : NSObject

+(BOOL)email:(NSString*)email;

+(BOOL)alphabet:(NSString*)alphabet;

+(BOOL)name:(NSString*)name;

@end



@interface UITextField (Additaionl)

@property(nonatomic,strong) UITextField * nextTextField;

@end
