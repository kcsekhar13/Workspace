//
//  CheckListViewController.m
//  Koolo
//
//  Created by Hamsini on 21/10/15.
//  Copyright (c) 2015 Vinodram. All rights reserved.
//

#import "CheckListViewController.h"
#import "CLMyHealthViewController.h"

@interface CheckListViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *myHealthButton;
@property (weak, nonatomic) IBOutlet UIButton *threeSentence;
@property (weak, nonatomic) IBOutlet UIButton *readyButton;

@end

@implementation CheckListViewController

- (void)viewDidLoad {
    
    self.navigationController.navigationBar.hidden = NO;
    [super viewDidLoad];
    
    self.title = @"Checklists";
    dataManager = [StoreDataMangager sharedInstance];
    UIImage *backgroundImage = dataManager.returnBackgroundImage;
    if (backgroundImage) {
        _backgroundImageView.image = backgroundImage;
    }
    
    // create blur effect
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    // create vibrancy effect
    UIVibrancyEffect *vibrancy = [UIVibrancyEffect effectForBlurEffect:blur];
    
    // add blur to an effect view
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = self.view.frame;
    
    // add vibrancy to yet another effect view
    UIVisualEffectView *vibrantView = [[UIVisualEffectView alloc]initWithEffect:vibrancy];
    vibrantView.frame = self.view.frame;
    effectView.alpha = 0.9;
    vibrantView.alpha = 0.9;
    // add both effect views to the image view
    [self.backgroundImageView addSubview:effectView];
    [self.backgroundImageView addSubview:vibrantView];
    
    
    
    [_myHealthButton.layer setBorderColor:[UIColor clearColor].CGColor];
    [_myHealthButton.layer setCornerRadius:_myHealthButton.frame.size.width/2];
    _myHealthButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _myHealthButton.titleLabel.numberOfLines = 2;
    [_myHealthButton.layer setMasksToBounds:YES];
    [_myHealthButton setFrame:CGRectMake(_myHealthButton.frame.origin.x, _myHealthButton.frame.origin.y, _myHealthButton.frame.size.width, _myHealthButton.frame.size.width)];
    
    [_threeSentence.layer setBorderColor:[UIColor clearColor].CGColor];
    _threeSentence.titleLabel.textAlignment = NSTextAlignmentCenter;
    _threeSentence.titleLabel.numberOfLines = 2;
    [_threeSentence.layer setCornerRadius:_myHealthButton.frame.size.width/2];
    [_threeSentence.layer setMasksToBounds:YES];
    [_threeSentence setFrame:CGRectMake(_threeSentence.frame.origin.x, _threeSentence.frame.origin.y, _threeSentence.frame.size.width, _threeSentence.frame.size.width)];
    
    [_readyButton.layer setBorderColor:[UIColor clearColor].CGColor];
    [_readyButton.layer setCornerRadius:_myHealthButton.frame.size.width/2];
    _readyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _readyButton.titleLabel.numberOfLines = 2;
    [_readyButton.layer setMasksToBounds:YES];
    [_readyButton setFrame:CGRectMake(_readyButton.frame.origin.x, _readyButton.frame.origin.y, _readyButton.frame.size.width, _readyButton.frame.size.width)];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    int totalGoalCount = 0;
    int completedGoals = 0;
    
    NSArray *goalsArray = dataManager.getMoodShotGoalsFromPlist;
    
    for (NSDictionary *goalDict in goalsArray) {
        
        if (![[goalDict objectForKey:@"GoalStatus"] isEqualToString:@"NA"]) {
            ++totalGoalCount;
        }
        
        if ([[goalDict objectForKey:@"GoalStatus"] isEqualToString:@"Completed"]) {
            ++completedGoals;
        }
    }
    [_myHealthButton setTitle:[NSString stringWithFormat:@"My Health %d/%d",completedGoals,totalGoalCount] forState:UIControlStateNormal];
    
    int readyCount = 0;
    int completedReadyStatus = 0;
    
    NSArray *readyArray = dataManager.getReadyTransferDataFromPlist;
    
    for (NSDictionary *goalDict in readyArray) {
        
        if (![[goalDict objectForKey:@"GoalStatus"] isEqualToString:@"NA"]) {
            ++readyCount;
        }
        
        if ([[goalDict objectForKey:@"GoalStatus"] isEqualToString:@"Completed"]) {
            ++completedReadyStatus;
        }
    }
    
    [_readyButton setTitle:[NSString stringWithFormat:@"Ready for transfer %d/%d",completedReadyStatus,readyCount] forState:UIControlStateNormal];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UIButton *button = (UIButton *)sender;
    
    if (button.tag == 0) {
        
        CLMyHealthViewController *healthViewController = (CLMyHealthViewController *)segue.destinationViewController;
        
        healthViewController.viewTitle = @"My Health";
        healthViewController.rightButtonTitle = @"New Goal";
        healthViewController.goalFlag = YES;
        
    } else if (button.tag == 2) {
        CLMyHealthViewController *healthViewController = (CLMyHealthViewController *)segue.destinationViewController;
        
        healthViewController.viewTitle = @"My Transfer";
        healthViewController.rightButtonTitle = @"New Transfer";
        healthViewController.goalFlag = NO;
    }
}


@end
