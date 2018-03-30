//
//  AppDelegate.m
//  Squire
//
//  Created by Héctor Cuevas Morfín on 3/24/16.
//  Copyright © 2016 AppData. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "ViewController.h"
#import <Google/Analytics.h>
#import "GlobalModal.h"
#import "TypeFormManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    // Optional: configure GAI options.
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
    gai.logger.logLevel = kGAILogLevelVerbose;  // remove before app release
    
    // Setting the app language based on the user device language
    [self setAppLanguage];
    
    [Fabric with:@[[Crashlytics class]]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    UIViewController *initViewController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"gender"]intValue]) {
        initViewController = [storyboard instantiateViewControllerWithIdentifier:@"videoListViewController"];
    }else {
       initViewController = [storyboard instantiateViewControllerWithIdentifier:@"navigationLogin"];
    }
    
    [self.window setRootViewController:initViewController];
    return YES;
}

/*
 Detects the device language and sets either of the English and Spanish language.
 If the language is neither Spanish nor English, the app language is defaulted to English.
 */
- (void)setAppLanguage {
    //Switching the app resource bundle
    [NSBundle setLanguage: GlobalModal.deviceLanguage];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
