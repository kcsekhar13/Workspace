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
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIView *circlesView;

@end

@implementation MoodMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Mood Map";
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
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClicked)];
    [doneButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = doneButton;
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    float sizeOfContent = 0;
    UIView *lLast = [_contentScrollView.subviews lastObject];
    NSInteger wd = lLast.frame.origin.y;
    NSInteger ht = lLast.frame.size.height;
    
    sizeOfContent = wd+ht+130;
    
    _contentScrollView.contentSize = CGSizeMake(_contentScrollView.frame.size.width, sizeOfContent);
    
    
    for (UIButton *colorPickerButton in _contentScrollView.subviews) {
        
        NSLog(@"%d >>>", (int)colorPickerButton.tag);
        if (colorPickerButton.tag <= 10 && [colorPickerButton isKindOfClass:[UIButton class]]) {
            
            int tag = (int)colorPickerButton.tag-1;
            if (tag != -1) {
                
                
                [colorPickerButton setBackgroundColor:[UIColor clearColor]];
                [colorPickerButton.layer setBorderColor:[(UIColor *)dataManager.fetchColorsArray[tag] CGColor]];
                
                
            }
            else{
                
                [colorPickerButton setBackgroundColor:[UIColor clearColor]];
                [colorPickerButton.layer setBorderColor:[[UIColor whiteColor] CGColor]];
            }
            
            [colorPickerButton.layer setBorderWidth:2.0f];
            [colorPickerButton.layer setMasksToBounds:YES];
            [colorPickerButton.layer setCornerRadius:colorPickerButton.frame.size.width/2];
            [colorPickerButton setUserInteractionEnabled:YES];
            [colorPickerButton addTarget:self action:@selector(filterMoodPic:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)filterMoodPic:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    if ([self.delegate respondsToSelector:@selector(filterMoodPics:)]) {
        [self.delegate filterMoodPics:(button.tag-1)];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)backButtonClicked {
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
