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

@property (weak, nonatomic) IBOutlet UILabel *mydayLabel;
@end

@implementation CalendarColorPickerViewController

- (void)viewDidLoad {
    self.navigationController.navigationBar.hidden = YES;
    [super viewDidLoad];
    dataManager = [StoreDataMangager sharedInstance];
    [_mydayLabel setText:@"29"];
    [_mydayLabel setTextAlignment:NSTextAlignmentCenter];
    [_mydayLabel setFont:[UIFont systemFontOfSize:24.0f]];
    [_mydayLabel setBackgroundColor:[UIColor grayColor]];
    [_mydayLabel.layer setBorderColor:[[UIColor redColor] CGColor]];
    [_mydayLabel.layer setBorderWidth:2.0f];
    [_mydayLabel.layer setMasksToBounds:YES];
    [_mydayLabel.layer setCornerRadius:25.0f];
    [_mydayLabel setUserInteractionEnabled:YES];
    
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 #pragma mark - UIButton action methods

- (IBAction)colorSelection:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    NSLog(@"Sender = %@ \n withColor Tag %ld", sender, button.tag);
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)button.tag] forKey:@"calendarColorIndex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
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

