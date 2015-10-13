//
//  InformationViewController.m
//  Koolo
//
//  Created by Vinodram on 09/10/15.
//  Copyright © 2015 Vinodram. All rights reserved.
//

#import "InformationViewController.h"

@interface InformationViewController (){
    
    CGRect cameraButtonFrame;
}

@property (weak, nonatomic) IBOutlet UIButton *unlockButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *allKeysArray;
@property (weak, nonatomic) IBOutlet UIView *keyBoardView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageController;

- (IBAction)pushToNextView:(id)sender;

@end

@implementation InformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view.
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];
    
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];
}

-(void)viewWillAppear:(BOOL)animated
{
    cameraButtonFrame = self.cameraButton.frame;
    [self.cameraButton.layer setBorderWidth:5.0];
    [self.cameraButton.layer setBorderColor:[UIColor clearColor].CGColor];
    [self.cameraButton.layer setMasksToBounds:YES];
    [self.cameraButton.layer setCornerRadius:10];
    
    for (int i=0; i<[self.allKeysArray count]; i++) {
        UIButton *btn = (UIButton*)[self.allKeysArray objectAtIndex:i];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn.layer setMasksToBounds:YES];
        [btn.layer setBorderColor:[UIColor clearColor].CGColor];
        [btn.layer setCornerRadius:btn.frame.size.width/2];

    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISwipeGestureRecognizer methods

-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    //Do what you want here
    //[self.unlockButton setHidden:NO];
    float width = [UIScreen mainScreen].bounds.size.width;
    float height = [UIScreen mainScreen].bounds.size.height;
    [UIView animateWithDuration:0.5 animations:^{
        [self.keyBoardView setAlpha:0.0];
        [self.cameraButton setBackgroundImage:[UIImage imageNamed:@"lock.png"] forState:UIControlStateNormal];
        [self.cameraButton setCenter:CGPointMake((width/2), (height/2))];
        
    } completion:^(BOOL finished) {
        
        [self.pageController setCurrentPage:1];

        
    }];
    
    
}
-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.keyBoardView setAlpha:1.0];
        [self.cameraButton setBackgroundImage:[UIImage imageNamed:@"Camera.png"] forState:UIControlStateNormal];
        [self.cameraButton setFrame:cameraButtonFrame];
        
    } completion:^(BOOL finished) {
        
        
        [self.pageController setCurrentPage:0];
        
    }];
   
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HideInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}



- (IBAction)pushToNextView:(id)sender {
    
    if (self.pageController.currentPage == 1) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"InfoCompleted"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [self.navigationController pushViewController:[storyboard instantiateViewControllerWithIdentifier:@"HomeScreen"] animated:YES];
        
    }
}
@end
