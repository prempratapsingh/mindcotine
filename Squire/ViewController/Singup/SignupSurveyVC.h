//
//  SignupSurveyVC.h
//  Squire
//
//  Created by Prem Pratap Singh on 18/03/18.
//  Copyright © 2018 AppData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface SignupSurveyVC : UIViewController <WKNavigationDelegate>

@property (nonatomic, retain) WKWebView *webView;
@property (nonatomic, retain) WKWebViewConfiguration *webConfiguration;

@end
