//
//  CalendarColorPickerViewController.m
//  Koolo
//
//  Created by Hamsini on 31/10/15.
//  Copyright © 2015 Vinodram. All rights reserved.
//

#import "CalendarColorPickerViewController.h"

@interface CalendarColorPickerViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UILabel *mydayLabel;
@end

@implementation CalendarColorPickerViewController

- (void)viewDidLoad {
    self.navigationController.navigationBar.hidden = YES;
    [super viewDidLoad];
    dataManager = [StoreDataMangager sharedInstance];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd"];
    [_mydayLabel setText:[dateFormatter stringFromDate:[NSDate date]]];
    [_mydayLabel setTextAlignment:NSTextAlignmentCenter];
    [_mydayLabel setFont:[UIFont systemFontOfSize:24.0f]];
    [_mydayLabel setBackgroundColor:[UIColor grayColor]];
    [_mydayLabel.layer setBorderWidth:2.0f];
    [_mydayLabel.layer setMasksToBounds:YES];
    [_mydayLabel.layer setCornerRadius:25.0f];
    [_mydayLabel setUserInteractionEnabled:YES];
    [_mydayLabel.layer setBorderColor:[[UIColor clearColor] CGColor]];
    
    [_backButton.layer setBorderWidth:2.0f];
    [_backButton.layer setMasksToBounds:YES];
    [_backButton.layer setCornerRadius:25.0f];
    [_backButton setUserInteractionEnabled:YES];
    [_backButton.layer setBorderColor:[[UIColor clearColor] CGColor]];
    
    float originX = _mydayLabel.frame.origin.x + _mydayLabel.frame.size.width + 10;
    float originY = _mydayLabel.frame.origin.y + _mydayLabel.frame.size.height + 10;
    for (int i = 0; i < dataManager.fetchColorsArray.count; i++) {
        
        UIButton *colorPickerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i < 4) {
            [colorPickerButton setFrame:CGRectMake(originX, _mydayLabel.frame.origin.y, 50.0, 50.0)];
            originX = colorPickerButton.frame.origin.x + _mydayLabel.frame.size.width + 10;
            [colorPickerButton setBackgroundColor:(UIColor *)dataManager.fetchColorsArray[i]];
            
        } else {
            [colorPickerButton setFrame:CGRectMake(_mydayLabel.frame.origin.x, originY, 50.0, 50.0)];
            originY = colorPickerButton.frame.origin.y + _mydayLabel.frame.size.height + 10;
            [colorPickerButton setBackgroundColor:(UIColor *)dataManager.fetchColorsArray[i]];
            
        }
        
        colorPickerButton.tag = i;
        [colorPickerButton addTarget:self action:@selector(colorSelection:) forControlEvents:UIControlEventTouchUpInside];
        [colorPickerButton.layer setBorderColor:[(UIColor *)dataManager.fetchColorsArray[i] CGColor]];
        [colorPickerButton.layer setBorderWidth:2.0f];
        [colorPickerButton.layer setMasksToBounds:YES];
        [colorPickerButton.layer setCornerRadius:25.0f];
        [colorPickerButton setUserInteractionEnabled:YES];

        [self.view addSubview:colorPickerButton];
        
    }
    
    for (UIView *view in [self.view subviews]) {
        
        NSLog(@"View = %@", view);
    }
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 #pragma mark - UIButton action methods
- (IBAction)backToHomeScreen:(id)sender {
    
      if (self.selectedIndex == 1) {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",-1] forKey:@"calendarColorIndex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
      }
      else{
          
          NSArray *eventArray  = [[AppDataManager sharedInstance] getEventsForSelectedDate:[NSDate date]];
          if (eventArray.count) {
              [[AppDataManager sharedInstance].selectedDict setObject:[NSString stringWithFormat:@"%ld",(long)-1] forKey:@"ColorIndex"];
              [[AppDataManager sharedInstance] updateSelectedDict];
          } else {
              
              [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)-1] forKey:@"ColorIndex"];
              [[NSUserDefaults standardUserDefaults] synchronize];
          }
          
          
          
      }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)colorSelection:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    NSLog(@"Sender = %@ \n withColor Tag %ld", sender, button.tag);
    if (self.selectedIndex == 1) {
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)button.tag] forKey:@"calendarColorIndex"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else{
        NSArray *eventArray  = [[AppDataManager sharedInstance] getEventsForSelectedDate:[NSDate date]];
        if (eventArray.count) {
            [[AppDataManager sharedInstance].selectedDict setObject:[NSString stringWithFormat:@"%ld",(long)button.tag] forKey:@"ColorIndex"];
            [[AppDataManager sharedInstance] updateSelectedDict];
        } else {
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)button.tag] forKey:@"ColorIndex"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        


    }
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

