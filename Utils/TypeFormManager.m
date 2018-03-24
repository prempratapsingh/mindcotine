//
//  TypeFormManager.m
//  Squire
//
//  Created by Prem Pratap Singh on 24/03/18.
//  Copyright © 2018 AppData. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "TypeFormManager.h"

@implementation TypeFormManager

+ (void) init {
    NSMutableArray *usersWhoSignedSurvey = [[NSMutableArray alloc]init];
    
    [[NSUserDefaults standardUserDefaults] setObject:usersWhoSignedSurvey forKey:@"usersWhoSignedSurvey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) addToSignedSurveyUsersList:(NSString *)userId {
    
    NSMutableArray *signedSurveyUsers = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"usersWhoSignedSurvey"] mutableCopy];
    if( signedSurveyUsers == nil ) {
        [self init];
    }
    
    NSMutableArray *usersWhoSignedSurvey = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"usersWhoSignedSurvey"] mutableCopy];
    [usersWhoSignedSurvey addObject: userId];
    [[NSUserDefaults standardUserDefaults] setObject:usersWhoSignedSurvey forKey:@"usersWhoSignedSurvey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL) hasUserCompletedSignupSurvey:(NSString *)userId {
    
    NSMutableArray *usersWhoSignedSurvey = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"usersWhoSignedSurvey"] mutableCopy];
    if( usersWhoSignedSurvey == nil) {
        return false;
    } else {
        return [usersWhoSignedSurvey containsObject:userId];
    }
}

@end
