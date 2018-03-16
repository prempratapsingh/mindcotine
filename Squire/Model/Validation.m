//
//  Validation.m
//  Squire
//
//  Created by INX on 8/29/17.
//  Copyright © 2017 AppData. All rights reserved.
//

#import "Validation.h"
#import <objc/NSObjCRuntime.h>
#import <objc/runtime.h>
//#import <objc/objc-runtime.h>

#define ACCEPTABLE_CHARACTERS @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
#define ACCEPTABLE @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

@implementation Validation

+(BOOL)email:(NSString*)email
{
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    //Valid email address
    
    if ([emailTest evaluateWithObject:email] == YES)
    {
        return true;
    }
    return false;
}
+(BOOL)name:(NSString*)name
{
    NSString *myRegex = @"[A-Z0-9a-z ]*";
    NSPredicate *myTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", myRegex];
     BOOL valid = [myTest evaluateWithObject:name];

    return valid;
    
}
+(BOOL)alphabet:(NSString*)alphabet
{
    NSCharacterSet *unwantedCharacters =
    [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    
    return ([alphabet rangeOfCharacterFromSet:unwantedCharacters].location == NSNotFound);
}
@end


@implementation UITextField (Additaionl)

@dynamic nextTextField;

-(UITextField*)nextTextField{
    UITextField * txt  = objc_getAssociatedObject(self, "next_txt");
    return txt;
}
-(void)setNextTextField:(UITextField *)nextTextField{
    objc_setAssociatedObject(self, "next_txt", nextTextField, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
