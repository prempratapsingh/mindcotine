//
//  SmokeCravingVC.h
//  Squire
//
//  Created by Prem Pratap Singh on 16/04/18.
//  Copyright © 2018 AppData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface SmokeCravingVC : UIViewController <WKNavigationDelegate>

@property (nonatomic, retain) WKWebView *webView;
@property (nonatomic, retain) WKWebViewConfiguration *webConfiguration;

@end
