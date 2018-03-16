//
//  ViewController.m
//  Squire
//
//  Created by Héctor Cuevas Morfín on 3/24/16.
//  Copyright © 2016 AppData. All rights reserved.
//

#import "ViewController.h"
#import <Google/Analytics.h>
#import "SimplePlayerViewController.h"

@interface ViewController ()
    @property (weak, nonatomic) IBOutlet UILabel *topTextS1;
    @property (weak, nonatomic) IBOutlet UILabel *text2s1;
    @property (weak, nonatomic) IBOutlet UILabel *text3s1;
    @property (weak, nonatomic) IBOutlet UILabel *text4s1;
    @property (weak, nonatomic) IBOutlet UILabel *text5s1;
    @property (weak, nonatomic) IBOutlet UILabel *text1s2;
    @property (weak, nonatomic) IBOutlet UILabel *text1s3;
    @property (weak, nonatomic) IBOutlet UIButton *playButon;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    
    _topTextS1.text = [self locateString:@"s11"];
    _text2s1.text = [self locateString:@"s12"];
    _text3s1.text = [self locateString:@"s13"];
    _text4s1.text = [self locateString:@"s14"];
    _text5s1.text = [self locateString:@"s15"];
    _text1s2.text = [self locateString:@"s21"];
    _text1s3.text = [self locateString:@"s31"];
    [_playButon setTitle:[self locateString:@"playVideo"] forState:UIControlStateNormal];

    // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"tourViewController"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)shouldAutorotate
{
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    SimplePlayerViewController *controller = [segue destinationViewController];
    controller.urlForVideo = _urlToVideo;
}

- (IBAction)doOkPressed:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"tourViewed"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

    
-(NSString*)locateString:(NSString *)stringToLocate{
        
        NSString *string = NSLocalizedString(stringToLocate, @"");
        return string;
}
@end
