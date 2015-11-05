//
//  MoodMapViewController.m
//  Koolo
//
//  Created by Hamsini on 28/10/15.
//  Copyright © 2015 Vinodram. All rights reserved.
//

#import "MoodMapViewController.h"

@interface MoodMapViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end

@implementation MoodMapViewController

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
    effectView.alpha = 0.9;
    vibrantView.alpha = 0.9;
    // add both effect views to the image view
    [self.backgroundImageView addSubview:effectView];
    [self.backgroundImageView addSubview:vibrantView];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
