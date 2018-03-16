 //
//  DetailVideoViewController.m
//  Squire
//
//  Created by Héctor Cuevas Morfín on 3/12/17.
//  Copyright © 2017 AppData. All rights reserved.
//

#import "DetailVideoViewController.h"
#import "ViewController.h"
@interface DetailVideoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageViewVide;
@property (weak, nonatomic) IBOutlet UILabel *textDescription;
@property (weak, nonatomic) IBOutlet UIButton *buttonBack;

@end

@implementation DetailVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageViewVide.image = [UIImage imageNamed:[_dictWithInfo objectForKey:@"image"]];
    _textDescription.text = [_dictWithInfo objectForKey:@"description"];
    [_buttonBack setTitle:NSLocalizedString(@"back", @"") forState:UIControlStateNormal];
    self.title = @"MindCotine";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)showVideo:(id)sender {
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    ViewController *controller = [segue destinationViewController];
    controller.urlToVideo = [_dictWithInfo objectForKey:@"url"];
}
- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
