//
//  CalendarViewController.m
//  Koolo
//
//  Created by Hamsini on 22/10/15.
//  Copyright (c) 2015 Vinodram. All rights reserved.
//

#import "CalendarViewController.h"
#import "CLWeeklyCalendarView.h"
#import "NewEventViewController.h"

@interface CalendarViewController () //<CLWeeklyCalendarViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *calendarView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
//@property (nonatomic, strong) CLWeeklyCalendarView* calendarView;
@end

static CGFloat CALENDER_VIEW_HEIGHT = 150.f;

@implementation CalendarViewController

- (void)viewDidLoad {
    self.navigationController.navigationBar.hidden = NO;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    datesArray = [[NSMutableArray alloc] init];
    NSDate *todayDate = [NSDate date];
    int daysToAdd = 1;
    [datesArray addObject:todayDate];
    for (int i = 0; i<8; i++) {
        NSDate *newDate = [datesArray[i] dateByAddingTimeInterval:60*60*24*daysToAdd];
         [datesArray addObject:newDate];
    }
    int dateIndex = 0;
    NSLog(@"Dates Array = %@", datesArray);
    float yPosition = 10.0f;
    for (int i = 0; i < 3; i++) {
        
        float xPostion = 80.0f;
        
        for (int j = 0; j < 3; j++) {
            
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd"];
            
            NSDateFormatter *dayFormatter=[[NSDateFormatter alloc] init];
            [dayFormatter setDateFormat:@"EEE"];
            
            NSString *textString = [NSString stringWithFormat:@"%@ \n%@", [dateFormatter stringFromDate:datesArray[dateIndex]], [dayFormatter stringFromDate:datesArray[dateIndex]]];
            
            dataManager = [StoreDataMangager sharedInstance];
            
            UILabel *mDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPostion,yPosition, 50.0, 50.0)];
            [mDayLabel setText:textString];
            [mDayLabel setNumberOfLines:2];
            [mDayLabel setTextColor:[UIColor whiteColor]];
            [mDayLabel setTextAlignment:NSTextAlignmentCenter];
            [mDayLabel setFont:[UIFont systemFontOfSize:14.0f]];
            [mDayLabel setBackgroundColor:[UIColor grayColor]];
            [mDayLabel.layer setBorderColor:[[UIColor clearColor] CGColor]];
            [mDayLabel.layer setBorderWidth:2.0f];
            [mDayLabel.layer setMasksToBounds:YES];
            [mDayLabel.layer setCornerRadius:25.0f];
            [mDayLabel setUserInteractionEnabled:YES];
            [self.calendarView addSubview:mDayLabel];
            
            UIButton *colorPickerButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [colorPickerButton setFrame:CGRectMake(xPostion,yPosition, 50.0, 50.0)];
            [colorPickerButton.layer setBorderWidth:2.0f];
            [colorPickerButton.layer setMasksToBounds:YES];
            [colorPickerButton.layer setCornerRadius:25.0f];
            [colorPickerButton setUserInteractionEnabled:YES];
            [colorPickerButton setBackgroundColor:[UIColor clearColor]];
            colorPickerButton.tag = dateIndex;
            [colorPickerButton addTarget:self action:@selector(newEventScreen:) forControlEvents:UIControlEventTouchUpInside];
            [colorPickerButton.layer setBorderColor:[[UIColor clearColor] CGColor]];
            xPostion = colorPickerButton.frame.origin.x + colorPickerButton.frame.size.width + 30.0f;
            
            [self.calendarView addSubview:colorPickerButton];
            NSLog(@"j = %d ", j);
            ++dateIndex;
        }
        yPosition += 80.0f;
        NSLog(@"\n");
    }
    self.selectedDate = todayDate;
    UISwipeGestureRecognizer * swipeLeft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(moveToHome)];
    swipeLeft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *doneButtonTitle = nil;
    if ([language isEqualToString:@"nb"]) {
        
        self.title = NSLocalizedString(@"Calendar", nil);
        doneButtonTitle = NSLocalizedString(@"Ready", nil);
        
    } else {
        self.title = @"Calendar";
        doneButtonTitle = @"Done";
    }
    
    
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
    [vibrantView setBackgroundColor:[UIColor blackColor]];
    vibrantView.alpha = 0.6;
    // add both effect views to the image view
    [self.backgroundImageView addSubview:effectView];
    [self.backgroundImageView addSubview:vibrantView];
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:doneButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(moveToHome)];
    [doneButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    //[self.view addSubview:self.calendarView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - CLWeeklyCalendarView Initialize and Delegate methods

//Initialize
-(CLWeeklyCalendarView *)calendarView
{
    if(!_calendarView){
        _calendarView = [[CLWeeklyCalendarView alloc] initWithFrame:CGRectMake(0, 66, self.view.bounds.size.width, CALENDER_VIEW_HEIGHT)];
        _calendarView.delegate = self;
    }
    return _calendarView;
}

-(NSDictionary *)CLCalendarBehaviorAttributes
{
    return @{
             CLCalendarWeekStartDay : @2,                 //Start Day of the week, from 1-7 Mon-Sun -- default 1
             //             CLCalendarDayTitleTextColor : [UIColor yellowColor],
             //             CLCalendarSelectedDatePrintColor : [UIColor greenColor],
             };
}



-(void)dailyCalendarViewDidSelect:(NSDate *)date
{
    //You can do any logic after the view select the date
    self.selectedDate = date;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.destinationViewController isKindOfClass:[NewEventViewController class]]) {
        NewEventViewController *newEvent = (NewEventViewController *)segue.destinationViewController;
        newEvent.selectedDate = self.selectedDate;
    }
}

- (void)newEventScreen:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    NewEventViewController *newEvent = [storyboard instantiateViewControllerWithIdentifier:@"NewEventScreen"];
    newEvent.selectedDate = datesArray[button.tag];
    [self.navigationController pushViewController:newEvent animated:YES];
}

#pragma mark - User defined methods

- (void)moveToHome {
    
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromLeft];
    
    [animation setDuration:0.45];
    [animation setTimingFunction:
     [CAMediaTimingFunction functionWithName:
      kCAMediaTimingFunctionEaseInEaseOut]];
    
    [self.navigationController.view.layer addAnimation:animation forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:NO];
    
}
@end
