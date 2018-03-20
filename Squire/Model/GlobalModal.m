//
//  GlobalModal.m
//  Squire
//
//  Created by Prem Pratap Singh on 19/03/18.
//  Copyright © 2018 AppData. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalModal.h"

@implementation GlobalModal

+(NSString*)deviceLanguage {
    
    //Detecing device language
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *languageDic = [NSLocale componentsFromLocaleIdentifier:language];
    NSString *languageCode = [languageDic objectForKey:@"kCFLocaleLanguageCodeKey"];
    if( ![languageCode isEqualToString:@"es"] ) {
        languageCode = @"en";
    }
    
    return languageCode;
}

@end
