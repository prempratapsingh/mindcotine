//
//  TypeFormManager.h
//  Squire
//
//  Created by Prem Pratap Singh on 24/03/18.
//  Copyright © 2018 AppData. All rights reserved.
//

@interface TypeFormManager: NSObject

+ (void) init;
+ (BOOL) hasUserCompletedSignupSurvey:(NSString *)userId;
+ (void) addToSignedSurveyUsersList:(NSString *)userId;

@end
