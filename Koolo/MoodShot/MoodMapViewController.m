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
@property (weak, nonatomic) IBOutlet UIButton *allButton;

@end

@implementation MoodMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataManager = [StoreDataMangager sharedInstance];

    [self filterMoodPics];
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *doneButtonTitle = nil;
    if ([language isEqualToString:@"nb"]) {
        doneButtonTitle = NSLocalizedString(@"Ready", nil);
        self.title = NSLocalizedString(@"Mood Map", nil);
        [self.allButton setTitle:NSLocalizedString(@"All", nil) forState:UIControlStateNormal];
        
    } else {
        doneButtonTitle = @"Done";
        self.title = @"Mood Map";
        [self.allButton setTitle:@"All" forState:UIControlStateNormal];
    }
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
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:doneButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClicked)];
    [doneButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = doneButton;
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    float sizeOfContent = 0;
    UIView *lLast = [_contentScrollView.subviews lastObject];
    NSInteger wd = lLast.frame.origin.y;
    NSInteger ht = lLast.frame.size.height;
    
    sizeOfContent = wd+ht+130;
    
    _contentScrollView.contentSize = CGSizeMake(_contentScrollView.frame.size.width, sizeOfContent);
    
    
    for (CustomMoodMapView *colorPickerButton in _contentScrollView.subviews) {
        
        NSLog(@"%d >>>%@", (int)colorPickerButton.tag,colorPickerButton);
        if (colorPickerButton.tag <= 10 && [colorPickerButton isKindOfClass:[CustomMoodMapView class]]) {
            [colorPickerButton setBackgroundColor:[UIColor clearColor]];

            int tag = (int)colorPickerButton.tag-1;
            
            colorPickerButton.moodsArray = [self.finalFilteredDict objectForKey:[NSString stringWithFormat:@"%d",tag]];
            
            [colorPickerButton drawInputViews];

            
            if (tag == -1) {
                
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, colorPickerButton.frame.size.width, colorPickerButton.frame.size.height)];
                [titleLabel setBackgroundColor:[UIColor clearColor]];
                [titleLabel setTextColor:[UIColor whiteColor]];
                [titleLabel setText:@"ALL"];
                [titleLabel setTextAlignment:NSTextAlignmentCenter];
                [colorPickerButton addSubview:titleLabel];
                
            }
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(filterMoodPic:)];
            [tap setNumberOfTapsRequired:1];
            [colorPickerButton addGestureRecognizer:tap];
            
            
        }
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)filterMoodPic:(UIGestureRecognizer*)sender {
    
    CustomMoodMapView *button = (CustomMoodMapView*)sender.view;
    if ([self.delegate respondsToSelector:@selector(filterMoodPics:)]) {
        [self.delegate filterMoodPics:(button.tag-1)];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)backButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - MoodMapDelegate methods

- (void)filterMoodPics {
    
    if ([self.moodsArray count]) {
        [self.moodsArray removeAllObjects];
    }
    
    NSArray *totalMoodColors = dataManager.fetchColorsArray;
    self.moodsArray = (NSMutableArray *)[dataManager getMoodsFromPlist];
    self.finalFilteredDict = [[NSMutableDictionary alloc] init];
    for (int i=0; i<[totalMoodColors count]; i++) {
        
        NSMutableArray *colorArray = [[NSMutableArray alloc] init];
        
        for (int j=0; j<[self.moodsArray count]; j++) {
            
            NSDictionary *dict = (NSDictionary *)self.moodsArray[j];
            NSString *colorString;
            if (dict[@"ColorIndex"]) {
                colorString = dict[@"ColorIndex"];
            }
            else{
                
                colorString = @"-1";
            }
            NSInteger selectedColorTag = [colorString integerValue];
            
            if (selectedColorTag == i) {
                [colorArray addObject:dict];
            }
        }
        [self.finalFilteredDict setObject:colorArray forKey:[NSString stringWithFormat:@"%d",i]];
    }
    
    
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
