//
//  CalendarColorPickerViewController.m
//  Koolo
//
//  Created by Hamsini on 31/10/15.
//  Copyright © 2015 Vinodram. All rights reserved.
//

#import "CalendarColorPickerViewController.h"

@interface CalendarColorPickerViewController ()
@property (weak, nonatomic) IBOutlet UIView *yellowView;
@property (weak, nonatomic) IBOutlet UIView *blackView;
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet UIView *grayView;
@property (weak, nonatomic) IBOutlet UIView *pinkView;
@property (weak, nonatomic) IBOutlet UIView *orangeView;
@property (weak, nonatomic) IBOutlet UIView *blueView;
@property (weak, nonatomic) IBOutlet UIView *skyBlue;

@property (weak, nonatomic) IBOutlet UILabel *mydayLabel;
@end

@implementation CalendarColorPickerViewController

- (void)viewDidLoad {
    self.navigationController.navigationBar.hidden = YES;
    [super viewDidLoad];
    
    [_mydayLabel setText:@"29"];
    [_mydayLabel setTextAlignment:NSTextAlignmentCenter];
    [_mydayLabel setFont:[UIFont systemFontOfSize:24.0f]];
    [_mydayLabel setBackgroundColor:[UIColor grayColor]];
    [_mydayLabel.layer setBorderColor:[[UIColor redColor] CGColor]];
    [_mydayLabel.layer setBorderWidth:2.0f];
    [_mydayLabel.layer setMasksToBounds:YES];
    [_mydayLabel.layer setCornerRadius:25.0f];
    [_mydayLabel setUserInteractionEnabled:YES];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)colorSelection:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    NSLog(@"Sender = %@ \n withColor Tag %ld", sender, button.tag);
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

