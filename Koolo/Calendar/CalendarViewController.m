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
@property (strong, nonatomic) UIButton *selectedButton;
//@property (nonatomic, strong) CLWeeklyCalendarView* calendarView;
@end

//static CGFloat CALENDER_VIEW_HEIGHT = 150.f;

@implementation CalendarViewController

- (void)viewDidLoad {
    self.navigationController.navigationBar.hidden = NO;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    gestureCount = 0;
    self.eventsArray = [[NSMutableArray alloc] init];
    datesArray = [[NSMutableArray alloc] init];
    NSDate *todayDate = [NSDate date];
    [datesArray addObject:todayDate];
    for (int i = 0; i<219; i++) {
        NSDate *newDate = [datesArray[i] dateByAddingTimeInterval:60*60*24*1];
        [datesArray addObject:newDate];
    }
    
   
    /*
    UISwipeGestureRecognizer * calendarswipeRight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(prepareCalendarView)];
    calendarswipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.calendarView addGestureRecognizer:calendarswipeRight];
    
    UISwipeGestureRecognizer * calendarswipeLeft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(preparePreviousCalendarView)];
    calendarswipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.calendarView addGestureRecognizer:calendarswipeLeft];
     */
    
    rightSwipeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightSwipeButton setFrame:CGRectMake(self.calendarView.frame.size.width - 40.0f,103.0f, 30.0, 30.0)];
    [rightSwipeButton.layer setBorderWidth:2.0f];
    [rightSwipeButton.layer setMasksToBounds:YES];
    [rightSwipeButton.layer setCornerRadius:15.0f];
    [rightSwipeButton setUserInteractionEnabled:YES];
    [rightSwipeButton setBackgroundColor:[UIColor whiteColor]];
    [rightSwipeButton setTitle:@">" forState:UIControlStateNormal];
    [rightSwipeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightSwipeButton.layer setBorderColor:[[UIColor clearColor] CGColor]];
    [rightSwipeButton.titleLabel setTextAlignment: NSTextAlignmentCenter];
    rightSwipeButton.titleEdgeInsets = UIEdgeInsetsMake(-3.0f, 1.0f, 0.0f, 0.0f);
    rightSwipeButton.tag = -150;
    [rightSwipeButton addTarget:self action:@selector(prepareCalendarView) forControlEvents:UIControlEventTouchUpInside];
    [self.calendarView addSubview:rightSwipeButton];
    
    leftSwipeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftSwipeButton setFrame:CGRectMake(10.0f,103.0f, 30.0, 30.0)];
    [leftSwipeButton.layer setBorderWidth:2.0f];
    [leftSwipeButton.layer setMasksToBounds:YES];
    [leftSwipeButton.layer setCornerRadius:15.0f];
    [leftSwipeButton setUserInteractionEnabled:YES];
    [leftSwipeButton setBackgroundColor:[UIColor whiteColor]];
    [leftSwipeButton setTitle:@"<" forState:UIControlStateNormal];
    [leftSwipeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftSwipeButton.layer setBorderColor:[[UIColor clearColor] CGColor]];
    [leftSwipeButton.titleLabel setTextAlignment: NSTextAlignmentCenter];
    leftSwipeButton.titleEdgeInsets = UIEdgeInsetsMake(-3.0f, -1.0f, 0.0f, 0.0f);
    leftSwipeButton.tag = -151;
    [leftSwipeButton addTarget:self action:@selector(preparePreviousCalendarView) forControlEvents:UIControlEventTouchUpInside];
    [self.calendarView addSubview:leftSwipeButton];
    leftSwipeButton.hidden = YES;
    
    
    
    
    UISwipeGestureRecognizer * swipeRight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(moveToHome)];
    swipeRight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *doneButtonTitle = nil;
    if ([language isEqualToString:@"nb"] || [language isEqualToString:@"nb-US"]) {
        
        self.title = NSLocalizedString(@"Calendar", nil);
        doneButtonTitle = NSLocalizedString(@"Done", nil);
        
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
    self.eventsTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //[self.view addSubview:self.calendarView];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
    self.selectedDate = [NSDate date];
    
    if (self.selectedButton != nil) {
        self.selectedButton.layer.borderColor = [UIColor clearColor].CGColor;
    }
    
    [self refreshView];
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

- (void)prepareCalendarView {
    

    if (gestureCount > 20) {
        return;
    } else if (gestureCount == 20) {
        rightSwipeButton.hidden = YES;
    }
    
    if (gestureCount > 0) {
        for (UIView *v in [self.calendarView subviews]){
            if (v.tag != -150 && v.tag != -151) {
                [v removeFromSuperview];
            }
            
        }

    }
    
    if (gestureCount > 0) {
        [leftSwipeButton setHidden:NO];
    }
    
    int dateIndex = 0;
    //NSLog(@"Dates Array = %@", datesArray);
    
    float width = 0;
    float height = 0;
    float fontSize = 0;
    float yPosition = 0.0f;
    if (self.view.frame.size.width == 320 && self.view.frame.size.height == 480) {
        width = 34;
        height = 34;
        fontSize = 11.0;
        yPosition = 2.0f;
        
    } else {
        width = 50;
        height = 50;
        fontSize = 15;
        yPosition = 5.0f;
    }
    
    
    for (int i = 0; i < 3; i++) {
        
        float xPostion = 0.0f;
        if (self.view.frame.size.width > 320.0f) {
            xPostion = 80.0f;
        } else {
            xPostion = 55.0f;
        }
        

        for (int j = 0; j < 3; j++) {
            
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd"];
            
            NSDateFormatter *dayFormatter=[[NSDateFormatter alloc] init];
            [dayFormatter setDateFormat:@"EEE"];
            
            NSLog(@"Date<><> = %@", [dateFormatter stringFromDate:datesArray[(gestureCount * 9) + dateIndex]]);
            NSString *textString = [NSString stringWithFormat:@"%@ \n%@", [dateFormatter stringFromDate:datesArray[(gestureCount * 9) + dateIndex]], [dayFormatter stringFromDate:datesArray[(gestureCount * 9) + dateIndex]]];
            
            dataManager = [StoreDataMangager sharedInstance];
            
            UILabel *mDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPostion,yPosition, width, height)];
            [mDayLabel setText:textString];
            [mDayLabel setNumberOfLines:2];
            [mDayLabel setTextColor:[UIColor whiteColor]];
            [mDayLabel setTextAlignment:NSTextAlignmentCenter];
            [mDayLabel setFont:[UIFont systemFontOfSize:fontSize]];
            [mDayLabel setBackgroundColor:[UIColor grayColor]];
            NSArray *events = [[AppDataManager sharedInstance] getEventsForSelectedDate:[datesArray objectAtIndex:(gestureCount * 9) + dateIndex]];
            NSDictionary *dict = [events lastObject];
            UIColor *boarderColor = [UIColor clearColor];
            if (dict && [[dict objectForKey:@"ColorIndex"] length]) {
                
                int index = [[dict objectForKey:@"ColorIndex"] intValue];
                if (index == -1) {
                    boarderColor = [UIColor clearColor];

                    
                }
                else{
                    
                    boarderColor = (UIColor*)[[StoreDataMangager sharedInstance] fetchColorsArray][index];

                }
            }
            [mDayLabel.layer setBorderColor:[boarderColor CGColor]];
            [mDayLabel.layer setBorderWidth:2.0f];
            [mDayLabel.layer setMasksToBounds:YES];
            [mDayLabel.layer setCornerRadius:width/2];
            [mDayLabel setUserInteractionEnabled:YES];
            [self.calendarView addSubview:mDayLabel];
            
            UIButton *colorPickerButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [colorPickerButton setFrame:CGRectMake(xPostion,yPosition, width, height)];
            [colorPickerButton.layer setBorderWidth:2.0f];
            [colorPickerButton.layer setMasksToBounds:YES];
            [colorPickerButton.layer setCornerRadius:colorPickerButton.frame.size.height/2];
            [colorPickerButton setUserInteractionEnabled:YES];
            [colorPickerButton setBackgroundColor:[UIColor clearColor]];
            colorPickerButton.tag = (gestureCount * 9) + dateIndex;
            if (i==0 && j==0) {
                
                [self updateDateEventsWithTag:colorPickerButton.tag];

            }
            [colorPickerButton addTarget:self action:@selector(displayEventsForSelectedDate:) forControlEvents:UIControlEventTouchUpInside];
            [colorPickerButton.layer setBorderColor:[[UIColor clearColor] CGColor]];
            xPostion = colorPickerButton.frame.origin.x + 80.0f;
            
            //if ([[dateFormatter stringFromDate:datesArray[(gestureCount * 9) + dateIndex]] isEqualToString:@"01"] || ((gestureCount * 9) + dateIndex) == 0) {
                
                
                UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(colorPickerButton.frame.origin.x - 5, colorPickerButton.frame.origin.y + colorPickerButton.frame.size.height + 5.0f, 80.0f, 15.0f)];
                NSDateFormatter *monthFormatter=[[NSDateFormatter alloc] init];
                [monthFormatter setDateFormat:@"MMM, yyyy"];
                monthLabel.text = [monthFormatter stringFromDate:datesArray[(gestureCount * 9) + dateIndex]];
                [monthLabel setTextColor:[UIColor whiteColor]];
                [monthLabel setTextAlignment:NSTextAlignmentCenter];
                [monthLabel setFont:[UIFont systemFontOfSize:fontSize]];
                [monthLabel setBackgroundColor:[UIColor clearColor]];
                [self.calendarView addSubview:monthLabel];
                
           // }
            [self.calendarView addSubview:colorPickerButton];
            //NSLog(@"j = %d ", j);
            ++dateIndex;
        }
        if (self.view.frame.size.width == 320 && self.view.frame.size.height == 480) {
            yPosition += 70.0f;
        } else {
            yPosition += 80.0f;
        }
        
        NSLog(@"\n");
    }
    
    ++gestureCount;
    //NSLog(@"count = %lu ", (unsigned long)self.calendarView.subviews.count);
}

-(void)refreshView
{
    if (gestureCount >0) {
        
        gestureCount--;

    }
    [self prepareCalendarView];

    
}
- (void)preparePreviousCalendarView {
    
    rightSwipeButton.hidden = NO;
    if (gestureCount == 1) {
        [leftSwipeButton setHidden:YES];
        return;
    }
    
    if (gestureCount > 0) {
        for (UIView *v in [self.calendarView subviews]){
            if (v.tag != -150 && v.tag != -151) {
                [v removeFromSuperview];
            }
        }
        
    }
    gestureCount-=2;
    if (gestureCount == 0) {
        [leftSwipeButton setHidden:YES];
    }
    int dateIndex = 0;
    float width = 0;
    float height = 0;
    float fontSize = 0;

    float yPosition = 0;
    //NSLog(@"Dates Array = %@", datesArray);
    if (self.view.frame.size.width == 320 && self.view.frame.size.height == 480) {
        width = 34;
        height = 34;
        fontSize = 11.0;
        yPosition = 2.0f;
        
    } else {
        width = 50;
        height = 50;
        fontSize = 15;
        yPosition = 5.0f;
    }
    for (int i = 0; i < 3; i++) {
        
        float xPostion = 0.0f;
        if (self.view.frame.size.width > 320.0f) {
            xPostion = 80.0f;
        } else {
            xPostion = 55.0f;
        }
        
        
        for (int j = 0; j < 3; j++) {
            
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd"];
            
            NSDateFormatter *dayFormatter=[[NSDateFormatter alloc] init];
            [dayFormatter setDateFormat:@"EEE"];
            
            NSString *textString = [NSString stringWithFormat:@"%@ \n%@", [dateFormatter stringFromDate:datesArray[(gestureCount * 9) + dateIndex]], [dayFormatter stringFromDate:datesArray[(gestureCount * 9) + dateIndex]]];
            
            dataManager = [StoreDataMangager sharedInstance];
            
            
            UILabel *mDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPostion,yPosition, width, height)];
            [mDayLabel setText:textString];
            [mDayLabel setNumberOfLines:2];
            [mDayLabel setTextColor:[UIColor whiteColor]];
            [mDayLabel setTextAlignment:NSTextAlignmentCenter];
            [mDayLabel setFont:[UIFont systemFontOfSize:fontSize]];
            [mDayLabel setBackgroundColor:[UIColor grayColor]];
            NSArray *events = [[AppDataManager sharedInstance] getEventsForSelectedDate:[datesArray objectAtIndex:(gestureCount * 9) + dateIndex]];
            NSDictionary *dict = [events lastObject];
            UIColor *boarderColor = [UIColor clearColor];
            if (dict && [[dict objectForKey:@"ColorIndex"] length]) {
                
                int index = [[dict objectForKey:@"ColorIndex"] intValue];
                if (index == -1) {
                    boarderColor = [UIColor clearColor];
                    
                }
                else{
                    
                boarderColor = (UIColor*)[[StoreDataMangager sharedInstance] fetchColorsArray][index];
                    
                }
            }
            
            
            [mDayLabel.layer setBorderColor:[boarderColor CGColor]];
            [mDayLabel.layer setBorderWidth:2.0f];
            [mDayLabel.layer setMasksToBounds:YES];
            [mDayLabel.layer setCornerRadius:width/2];
            [mDayLabel setUserInteractionEnabled:YES];
            [self.calendarView addSubview:mDayLabel];
            
            UIButton *colorPickerButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [colorPickerButton setFrame:CGRectMake(xPostion,yPosition, width, height)];
            [colorPickerButton.layer setBorderWidth:2.0f];
            [colorPickerButton.layer setMasksToBounds:YES];
            [colorPickerButton.layer setCornerRadius:width/2];
            [colorPickerButton setUserInteractionEnabled:YES];
            [colorPickerButton setBackgroundColor:[UIColor clearColor]];
            colorPickerButton.tag = (gestureCount * 9) + dateIndex;
            if (i==0 && j==0) {
                
                [self updateDateEventsWithTag:colorPickerButton.tag];
                
            }
            [colorPickerButton addTarget:self action:@selector(displayEventsForSelectedDate:) forControlEvents:UIControlEventTouchUpInside];
            [colorPickerButton.layer setBorderColor:[[UIColor clearColor] CGColor]];
            xPostion = colorPickerButton.frame.origin.x + 80.0f;
            
            //if ([[dateFormatter stringFromDate:datesArray[(gestureCount * 9) + dateIndex]] isEqualToString:@"01"] || ((gestureCount * 9) + dateIndex) == 0) {
                UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(colorPickerButton.frame.origin.x - 5, colorPickerButton.frame.origin.y + colorPickerButton.frame.size.height + 5.0f, 80.0f, 15.0f)];
                NSDateFormatter *monthFormatter=[[NSDateFormatter alloc] init];
                [monthFormatter setDateFormat:@"MMM, yyyy"];
                monthLabel.text = [monthFormatter stringFromDate:datesArray[(gestureCount * 9) + dateIndex]];
                [monthLabel setTextColor:[UIColor whiteColor]];
                [monthLabel setTextAlignment:NSTextAlignmentCenter];
                [monthLabel setFont:[UIFont systemFontOfSize:fontSize]];
                [monthLabel setBackgroundColor:[UIColor clearColor]];
                [self.calendarView addSubview:monthLabel];
                
           // }
            
            [self.calendarView addSubview:colorPickerButton];
            //NSLog(@"j = %d ", j);
            ++dateIndex;
        }
        if (self.view.frame.size.width == 320 && self.view.frame.size.height == 480) {
            yPosition += 70.0f;
        } else {
            yPosition += 80.0f;
        }
        NSLog(@"\n");
    }
    ++gestureCount;
    
    //NSLog(@"count = %lu ", (unsigned long)self.calendarView.subviews.count);
}

-(void)displayEventsForSelectedDate:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    int tag = (int)button.tag;
   
    if (self.selectedButton != nil) {
         self.selectedButton.layer.borderColor = [UIColor clearColor].CGColor;
    }
    self.selectedButton = button;
    self.selectedButton.layer.borderColor = [UIColor greenColor].CGColor;
    self.selectedDate = datesArray[button.tag];
    [self updateDateEventsWithTag:tag];

}


-(void)updateDateEventsWithTag:(int)tag
{
    
    //NSLog(@"Selected button Tag = %@", [datesArray objectAtIndex:tag]);
    
    // [[AppDataManager sharedInstance] getEventsForDate:[datesArray objectAtIndex:tag]];
    self.eventsArray = [[AppDataManager sharedInstance] getEventsForSelectedDate:[datesArray objectAtIndex:tag]];
    
    if (self.eventsArray.count == 0) {
        [self.eventsTable setHidden:YES];
    } else {
        [self.eventsTable setHidden:NO];
        [self.eventsTable reloadData];
    }
    

}

#pragma mark -  UITableView dataSource methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.eventsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EventsCustomCellTableViewCell *cell = (EventsCustomCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"EventsCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dict = self.eventsArray[indexPath.row];
    cell.eventTitle.text = [dict objectForKey:@"EventTitle"];
    
   
    //NSArray *colorsArray = [StoreDataMangager sharedInstance].fetchColorsArray;
    cell.recurenceLabel.text = [dict objectForKey:@"Remainder"];
    cell.modeLabel.text = [dict objectForKey:@"TagTitle"];
    
    NSArray *selectArray = nil;
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    if ([language isEqualToString:@"nb"] || [language isEqualToString:@"nb-US"]) {
        selectArray = [[NSArray alloc] initWithObjects:NSLocalizedString(@"Tough", nil), NSLocalizedString(@"Long", nil), NSLocalizedString(@"Faith", nil), nil];
    } else {
        selectArray = [[NSArray alloc] initWithObjects:@"Tough", @"Long", @"Faith", nil];
    }
    
    
    NSArray *statusArray  = [dict objectForKey:@"SelectedTags"];
    NSMutableString *tagLabelString = [[NSMutableString alloc] init];

    for (int i=0; i<selectArray.count; i++) {
        
        if ([[statusArray objectAtIndex:i] isEqualToString:@"YES"]) {
            
            NSString *tagLabel = [selectArray objectAtIndex:i];
            [tagLabelString appendString:tagLabel];
            [tagLabelString appendString:@"   "];
        }
        
        
    }
    
    cell.tagsLabel.text = tagLabelString;
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}

# pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Fetch yourText for this row from your data source..
    
    return 85.0;
    
}



@end
