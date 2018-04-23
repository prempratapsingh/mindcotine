//
//  VideoListViewController.m
//  Squire
//
//  Created by Héctor Cuevas Morfín on 2/25/17.
//  Copyright © 2017 AppData. All rights reserved.
//

#import "VideoListViewController.h"
#import "VideoTableViewCell.h"
#import "DetailVideoViewController.h"
#import "SmokeCravingVC.h"
#import "URLs.h"
#import "MediaDownloader.h"

@interface VideoListViewController () <TableViewVideCellDelegate, MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *mainMenuView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewTitle;
@property (weak, nonatomic) IBOutlet UILabel *nameUser;
    @property (weak, nonatomic) IBOutlet UILabel *libratyText;
@property (nonatomic) CGFloat previousContentOffset;
@property (weak, nonatomic) IBOutlet UIView *viewWithTableView;
@property (nonatomic, strong) NSArray *arrayWithVideosMale;
@property (nonatomic, strong) NSArray *arrayWithVideosFemaleMale;
@property (nonatomic, strong) NSMutableArray *arrayAllGenders;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;


@end

@implementation VideoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithRed:0.14 green:0.60 blue:0.74 alpha:1.00];
    _tableView.separatorColor = [UIColor clearColor];
    _nameUser.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    
    _arrayAllGenders = [[NSMutableArray alloc]init];
    
    [[UIDevice currentDevice] setValue:
    [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
    
    _libratyText.text = NSLocalizedString(@"library", @"");
    _contactUsTitle.text = NSLocalizedString(@"contactUsTitle", @"");
    [_menuButton setTitle: NSLocalizedString(@"menu", @"") forState:UIControlStateNormal];
    [_signOutButton setTitle: NSLocalizedString(@"signOut", @"") forState:UIControlStateNormal];
    [_wantToSmokeButton setTitle: NSLocalizedString(@"smokeCraving", @"") forState:UIControlStateNormal];
    
    
    _arrayWithVideosFemaleMale =   @[
                        
                          @{
                              @"name":NSLocalizedString(@"morningTitle", @""),
                              @"subtitlte":NSLocalizedString(@"morningSubtitle", @""),
                              @"description":NSLocalizedString(@"morningDescription", @""),
                              @"image":@"morning",
                              @"url":NSLocalizedString(@"morningUrlWoman", @"")
                              },
                          @{
                              @"name":NSLocalizedString(@"dayTitle", @""),
                              @"subtitlte":NSLocalizedString(@"daySubtitle", @""),
                              @"description":NSLocalizedString(@"dayDescription", @""),
                              @"image":@"day",
                              @"url":NSLocalizedString(@"dayUrlWoman", @"")
                              },
                          
                          @{
                              @"name":NSLocalizedString(@"nightTitle", @""),
                              @"subtitlte":NSLocalizedString(@"nightSubtitle", @""),
                              @"description":NSLocalizedString(@"nightDescription", @""),
                              @"image":@"night",
                              @"url":NSLocalizedString(@"nightUrlWoman", @"")
                              }];
    
    _arrayWithVideosMale =   @[
                                    
                                    @{
                                        @"name":NSLocalizedString(@"morningTitle", @""),
                                        @"subtitlte":NSLocalizedString(@"morningSubtitle", @""),
                                        @"description":NSLocalizedString(@"morningDescription", @""),
                                        @"image":@"morning",
                                        @"url":NSLocalizedString(@"morningUrlMan", @"")
                                   },
                                    
                                     @{
                                        @"name":NSLocalizedString(@"dayTitle", @""),
                                        @"subtitlte":NSLocalizedString(@"daySubtitle", @""),
                                        @"description":NSLocalizedString(@"dayDescription", @""),
                                        @"image":@"day",
                                        @"url":NSLocalizedString(@"dayUrlMan", @"")
                                         },
                                     @{
                                        @"name":NSLocalizedString(@"nightTitle", @""),
                                        @"subtitlte":NSLocalizedString(@"nightSubtitle", @""),
                                        @"description":NSLocalizedString(@"nightDescription", @""),
                                        @"image":@"night",
                                        @"url":NSLocalizedString(@"nightUrlMan", @"")
                                         },
                              ];

    

    

    [_arrayAllGenders addObjectsFromArray:_arrayWithVideosMale];
    [_arrayAllGenders addObjectsFromArray:_arrayWithVideosFemaleMale];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    
    NSString *version = NSBundle.mainBundle.infoDictionary [@"CFBundleShortVersionString"];
    _versionLabel.text = [NSLocalizedString(@"version", @"") stringByAppendingString:version];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
        [[UIDevice currentDevice] setValue:
         [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                    forKey:@"orientation"];
    }
    

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSNumber *numberGender = [[NSUserDefaults standardUserDefaults]objectForKey:@"gender"];
    
    if ([numberGender isEqual: @"2"]){
        return _arrayWithVideosFemaleMale.count;

    }else{
        if ([numberGender isEqual: @"1"] || [numberGender isEqual: @"3"]) {
            return _arrayWithVideosMale.count;

        }else{
            return _arrayAllGenders.count;

        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 240.0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoTableViewCell" forIndexPath:indexPath];
    NSDictionary *dict;
    NSNumber *numberGender = [[NSUserDefaults standardUserDefaults]objectForKey:@"gender"];
    
    if ([numberGender isEqual: @"2"]){
        dict =  _arrayWithVideosFemaleMale[indexPath.row];
        
    }else{
        if ([numberGender isEqual: @"1"] || [numberGender isEqual: @"3"]) {
            dict = _arrayWithVideosMale[indexPath.row];
            
        }else{
            dict = _arrayAllGenders[indexPath.row];

        }
        
    }

    cell.imageViewVideo.image = [UIImage imageNamed:[dict objectForKey:@"image"]];
    cell.labelTop.text = [dict objectForKey:@"name"];
    cell.labelBottom.text = [dict objectForKey:@"subtitlte"];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexSelected = indexPath;
    cell.delegate = self;
    return cell;
}

- (IBAction)menuButtonTapped:(id)sender {
    
    [_mainMenuView setTranslatesAutoresizingMaskIntoConstraints:true];
    
    [UIView animateWithDuration:0.7 animations:^{
        
        if (_mainMenuView.frame.origin.x == 0){
            _mainMenuView.frame = CGRectMake(self.view.frame.size.width - 120
                                             , _mainMenuView.frame.origin.y,
                                             _mainMenuView.frame.size.width,
                                             _mainMenuView.frame.size.height);
        }else{
            _mainMenuView.frame = CGRectMake(0, _mainMenuView.frame.origin.y,
                                             _mainMenuView.frame.size.width,
                                             _mainMenuView.frame.size.height);
        }
       
        
    } completion:^(BOOL finished) {
        
    }];
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat currentContentOffset = scrollView.contentOffset.y;
    if (currentContentOffset > 0) {
        if (currentContentOffset > self.previousContentOffset) {
            // scrolling towards the bottom
            //  [self.subButtonView setHidden:YES];
            [UIView animateWithDuration:0.7 animations:^{
                _imageViewTitle.alpha = 0;
                _viewWithTableView.frame = CGRectMake(0, 16, _viewWithTableView.frame.size.width, self.view.frame.size.height );
            } completion:^(BOOL finished) {
                
            }];
            self.previousContentOffset = currentContentOffset;

        } else if (currentContentOffset + 50 < self.previousContentOffset) {
            NSLog(@"%f, %f", currentContentOffset, scrollView.contentSize.height);
            if (currentContentOffset > scrollView.contentSize.height){
                
            }
            // scrolling towards the top
            // [self.subButtonView setHidden:NO];
            [UIView animateWithDuration:0.7 animations:^{
                _imageViewTitle.alpha = 1;
                _viewWithTableView.frame = CGRectMake(0, 75, _viewWithTableView.frame.size.width, self.view.frame.size.height - 59);
            } completion:^(BOOL finished) {
                
            }];
            self.previousContentOffset = currentContentOffset;
            
        }else{
          //  self.previousContentOffset = currentContentOffset;

        }
    }
   
}

- (IBAction)buttonCloseViewTapped:(id)sender {
    [self closeMainMenu];
}

-(void)closeMainMenu {
    [_mainMenuView setTranslatesAutoresizingMaskIntoConstraints:true];
    
    [UIView animateWithDuration:0.7 animations:^{
        
        
        _mainMenuView.frame = CGRectMake(0, _mainMenuView.frame.origin.y,
                                         _mainMenuView.frame.size.width,
                                         _mainMenuView.frame.size.height);
        
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)didTapPlayView:(NSIndexPath *)indexpath{
    NSLog(@"%@",indexpath);
    [self performSegueWithIdentifier:@"showDetail" sender:indexpath];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"%ld",(long)((NSIndexPath *)sender).row);
    if ([segue.identifier isEqualToString:@"showDetail"]){
        DetailVideoViewController *detail = [segue destinationViewController];
        NSNumber *numberGender = [[NSUserDefaults standardUserDefaults]objectForKey:@"gender"];
        if ([numberGender isEqual: @"2"]){
             detail.dictWithInfo =  _arrayWithVideosFemaleMale[((NSIndexPath *)sender).row];
            
        }else{
            if ([numberGender isEqual: @"1"] || [numberGender isEqual: @"3"]) {
                detail.dictWithInfo = _arrayWithVideosMale[((NSIndexPath *)sender).row];
                
            }else{
                detail.dictWithInfo = _arrayAllGenders[((NSIndexPath *)sender).row];
                
            }
            
            
        }

    }
}

- (IBAction)smokeCravingButtonTapped:(UIButton *)sender {
    [self closeMainMenu];
    SmokeCravingVC *smokeCravingVC = [self.storyboard instantiateViewControllerWithIdentifier: @"SmokeCravingVC"];
    [self presentViewController:smokeCravingVC animated:YES completion:nil];
}

- (IBAction)signOutButtonTapped:(id)sender {
    
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        if( [key isEqualToString:@"usersWhoSignedSurvey"] ) {
            continue;
        }
        [defs removeObjectForKey:key];
    }
    
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"navigationLogin"];
    [self presentViewController:controller animated:true completion:nil];
    [defs synchronize];
}

- (IBAction)settingsButtonTapped:(UIButton *)sender {
    [self closeMainMenu];
    [self performSegueWithIdentifier:@"showSettingsView" sender:nil];
}

-(NSString*)locateString:(NSString *)stringToLocate{
    
    NSString *string = NSLocalizedString(stringToLocate, @"");
    return string;
}

//orientation
- (BOOL)shouldAutorotate
{
    //	(iOS 6)
    //	No auto rotating
    return YES;
}
    
- (IBAction)sendMail:(id)sender {
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"Support"];
        [mail setMessageBody:@" " isHTML:NO];
        [mail setToRecipients:@[@"community@mindcotine.com"]];
        
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error!" message:@"Your device doesn't support the composer sheet." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:true completion:nil];
        NSLog(@"This device cannot send email");
    }
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return  UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    //	(iOS 6)
    //	Force to portrait
    return UIInterfaceOrientationPortrait;
}
    
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

@end
