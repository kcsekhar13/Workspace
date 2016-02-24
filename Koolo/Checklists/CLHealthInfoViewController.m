//
//  CLHealthInfoViewController.m
//  Koolo
//
//  Created by Hamsini on 21/10/15.
//  Copyright (c) 2015 Vinodram. All rights reserved.
//

#import "CLHealthInfoViewController.h"

@interface CLHealthInfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (weak, nonatomic) IBOutlet UILabel *finishedTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *pendingLabelText;
@property (weak, nonatomic) IBOutlet UILabel *progressLabelText;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation CLHealthInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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
    effectView.alpha = 0.65;
    vibrantView.alpha = 0.45;
    [vibrantView setBackgroundColor:[UIColor blackColor]];
    // add both effect views to the image view
    [self.backgroundImageView addSubview:effectView];
    [self.backgroundImageView addSubview:vibrantView];
    
    
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *doneButtonTitle = nil;
    
    if ([language isEqualToString:@"nb"] || [language isEqualToString:@"nb-US"]|| [language isEqualToString:@"nb-NO"]) {
        self.title = NSLocalizedString(@"Information", nil);
        doneButtonTitle = NSLocalizedString(@"Done", nil);
        
        _finishedTextLabel.text = NSLocalizedString(@"Done", nil);
        _pendingLabelText.text = NSLocalizedString(@"Not done", nil);
        _progressLabelText.text = NSLocalizedString(@"Progress", nil);
        _descriptionLabel.text = NSLocalizedString(@"InfoDescription", nil);
    } else {
        doneButtonTitle = @"Done";
        self.title = @"Information";
        _finishedTextLabel.text = @"Finished";
        _pendingLabelText.text = @"Not done";
        _progressLabelText.text = @"Ongoing";
        _descriptionLabel.text = @"Swiping to the right will mark the goal as not relevant  ";
    }
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:doneButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(doneWithInfo)];
    [doneButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = doneButton;
    [self.navigationItem setHidesBackButton:YES animated:NO];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  User defined methods

- (void)doneWithInfo {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
