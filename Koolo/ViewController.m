
//
//  ViewController.m
//  Koolo
//
//  Created by Vinodram on 08/10/15.
//  Copyright (c) 2015 Vinodram. All rights reserved.
//

#import "ViewController.h"
#import "HomeNotificationView.h"
#import "CheckListViewController.h"
#import "StoreDataMangager.h"

@interface ViewController () <HomeNotificationViewDelegate>{
    
    UIView *contentView;
    StoreDataMangager *dataManager;
}
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet HomeNotificationView *mNoteView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    dataManager = [StoreDataMangager sharedInstance];
    
    [self createDefaultMenuView];
}

-(void)createDefaultMenuView;
{
    if (contentView) {
        [contentView removeFromSuperview];
        contentView = nil;
    }
    float width = [UIScreen mainScreen].bounds.size.width;
    float height = [UIScreen mainScreen].bounds.size.height;
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    [contentView setBackgroundColor:[UIColor clearColor]];
    [contentView.layer setCornerRadius:6.];
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"plus.png"]];
    [icon setContentMode:UIViewContentModeScaleAspectFill];
    [icon setBackgroundColor:[UIColor clearColor]];
    
    //[UIColor colorWithRed:98.0/255.0 green:192.0/255.0 blue:202.0/255.0 alpha:1.0]
    [icon setFrame:CGRectMake(0, 0, 45, 45)];
    [contentView addSubview:icon];
    
    if(stack)
        [stack removeFromSuperview];
    
    stack = [[UPStackMenu alloc] initWithContentView:contentView];
    [stack setCenter:CGPointMake(width-30, height-30)];
    [stack setDelegate:self];
    
    UPStackMenuItem *audioItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"CheckListpng.png"] highlightedImage:nil title:nil];
    UPStackMenuItem *pictureItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"Calander.png"] highlightedImage:nil title:nil];
    UPStackMenuItem *textIcon = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"Camera.png"] highlightedImage:nil title:nil];\
    
    
    NSMutableArray *items = [[NSMutableArray alloc] initWithObjects:textIcon,audioItem, pictureItem,nil];
    [items enumerateObjectsUsingBlock:^(UPStackMenuItem *item, NSUInteger idx, BOOL *stop) {
        [item setTitleColor:[UIColor whiteColor]];
    }];
    [stack setAnimationType:UPStackMenuAnimationType_progressive];
    [stack setStackPosition:UPStackMenuStackPosition_up];
    [stack setOpenAnimationDuration:.4];
    [stack setCloseAnimationDuration:.4];
    
    [items enumerateObjectsUsingBlock:^(UPStackMenuItem *item, NSUInteger idx, BOOL *stop) {
        [item setLabelPosition:UPStackMenuItemLabelPosition_right];
        [item setLabelPosition:UPStackMenuItemLabelPosition_left];
    }];
    [stack addItems:items];
    [self.view addSubview:stack];
    [self setStackIconClosed:YES];
}

- (void)setStackIconClosed:(BOOL)closed
{
    UIImageView *icon = [[contentView subviews] objectAtIndex:0];
    float angle = closed ? 0 : (M_PI * (135) / 180.0);
    [UIView animateWithDuration:0.3 animations:^{
        [icon.layer setAffineTransform:CGAffineTransformRotate(CGAffineTransformIdentity, angle)];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.hidden = YES;
    UIImage *backgroundImage = dataManager.returnBackgroundImage;
    if (backgroundImage) {
        _backgroundImageView.image = backgroundImage;
    }
       
    if(_mNoteView == nil) {
        _mNoteView = [[HomeNotificationView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2)];
        _mNoteView.delegate = self;
        int index = [[[NSUserDefaults standardUserDefaults] objectForKey:@"calendarColorIndex"] intValue];
        _mNoteView.mDayLabel.layer.borderColor = [(UIColor *)dataManager.fetchColorsArray[index] CGColor];
        [self.view addSubview:_mNoteView];
        
    } else {
        _mNoteView.delegate = self;
        int index = [[[NSUserDefaults standardUserDefaults] objectForKey:@"calendarColorIndex"] intValue];
        _mNoteView.mDayLabel.layer.borderColor = [(UIColor *)dataManager.fetchColorsArray[index] CGColor];
        [_mNoteView clearsContextBeforeDrawing];
        [_mNoteView setNeedsDisplay];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UPStackMenuDelegate

- (void)stackMenuWillOpen:(UPStackMenu *)menu
{
    if([[contentView subviews] count] == 0)
        return;
    
    [self setStackIconClosed:NO];
}

- (void)stackMenuWillClose:(UPStackMenu *)menu
{
    if([[contentView subviews] count] == 0)
        return;
    
    [self setStackIconClosed:YES];
}

- (void)stackMenu:(UPStackMenu *)menu didTouchItem:(UPStackMenuItem *)item atIndex:(NSUInteger)index
{
    
    [stack closeStack];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    //id controller = nil;
    switch (index) {
        case 0:
            
            [self.navigationController pushViewController:[storyboard instantiateViewControllerWithIdentifier:@"MoodLineScreen"] animated:YES];
            
            break;
        case 1:
            
            [self.navigationController pushViewController:[storyboard instantiateViewControllerWithIdentifier:@"CLHomeScreen"] animated:YES];
            
            break;
        case 2:
            [self.navigationController pushViewController:[storyboard instantiateViewControllerWithIdentifier:@"CalendarScreen"] animated:YES];
            break;
            
        default:
            break;
    }
    
    
    
}

- (void)moveToCalendarColorPicker:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    [self.navigationController pushViewController:[storyboard instantiateViewControllerWithIdentifier:@"CalendarColorPicker"] animated:YES];
}

@end
