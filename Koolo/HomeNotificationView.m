//
//  HomeNotificationView.m
//  Koolo
//
//  Created by Srikar Chowdary on 11/10/15.
//  Copyright (c) 2015 Vinodram. All rights reserved.
//

#import "HomeNotificationView.h"
#import "StoreDataMangager.h"
#import "AppDataManager.h"
@implementation HomeNotificationView

- (void)awakeFromNib {
    // Initialization code
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)initUI {
    
    StoreDataMangager *dataManager = [StoreDataMangager sharedInstance];
    NSMutableDictionary *mutableDictionary  =  [[NSUserDefaults standardUserDefaults] objectForKey:@"Notifications"];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd"];
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    
    if(_mDayLabel == nil) {
        _mDayLabel = [[UILabel alloc] init];
        [_mDayLabel setFrame:CGRectMake(20, 40, 50, 50)];
        [_mDayLabel setText:[dateFormatter stringFromDate:[NSDate date]]];
        [_mDayLabel setTextAlignment:NSTextAlignmentCenter];
        [_mDayLabel setFont:[UIFont fontWithName:@"Klavika-Regular" size:24.0f]];
        [_mDayLabel setBackgroundColor:[UIColor grayColor]];
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"calendarColorIndex"] intValue] != -1 && [[NSUserDefaults standardUserDefaults] objectForKey:@"calendarColorIndex"]) {
            int index = [[[NSUserDefaults standardUserDefaults] objectForKey:@"calendarColorIndex"] intValue];
            _mDayLabel.layer.borderColor = [(UIColor *)dataManager.fetchColorsArray[index] CGColor];
        } else {
            [_mDayLabel.layer setBorderColor:[[UIColor clearColor] CGColor]];
        }
        
        
        
        [_mDayLabel.layer setBorderWidth:2.0f];
        [_mDayLabel.layer setMasksToBounds:YES];
        [_mDayLabel.layer setCornerRadius:25.0f];
        [_mDayLabel setUserInteractionEnabled:YES];
        [self addSubview:_mDayLabel];
        
        _calnderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_calnderButton setFrame:CGRectMake(0, 0, 50, 50)];
        [_calnderButton setTitle:nil forState:UIControlStateNormal];
        [_calnderButton addTarget:self action:@selector(calendarButtonAction) forControlEvents:UIControlEventTouchUpInside];
         [self.mDayLabel addSubview:_calnderButton];
    } else {
        [_mDayLabel setText:[dateFormatter stringFromDate:[NSDate date]]];
    }
  
    if(_mQuoteText == nil) {
        _mQuoteText = [[UILabel alloc] init];
        [_mQuoteText setFrame:CGRectMake(80, 30, self.frame.size.width-100, 60)];
        [_mQuoteText setTextColor:[UIColor whiteColor]];
        [_mQuoteText setNumberOfLines:3];
        [_mQuoteText setTextAlignment:NSTextAlignmentLeft];
        [_mQuoteText setFont:[UIFont fontWithName:@"Klavika-Regular" size:14.0f]];
        [_mQuoteText setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedQuote"]];
        [self addSubview:_mQuoteText];
    } else {
        [_mQuoteText setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedQuote"]];
    }
   
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"showQuotes" ]) {
        
            [_mQuoteText setHidden:NO];
    } else {
            [_mQuoteText setHidden:YES];
    }
    
    NSMutableArray *unsortedArray = [[NSMutableArray alloc] initWithArray:[[AppDataManager sharedInstance] getEventsForSelectedDate:[NSDate date]]];
    
    self.eventsArray = (NSMutableArray *)[unsortedArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        int valueOne = [[obj1 valueForKey:@"Sort"] integerValue];
        int valueTwo = [[obj2 valueForKey:@"Sort"] integerValue];
        return [[NSNumber numberWithInteger:valueOne] compare:[NSNumber numberWithInteger:valueTwo]];
    }];
    
    NSLog(@"self.eventsArray = %@", self.eventsArray);
      
    if (self.eventsTable == nil) {
        
        self.eventsTable = [[UITableView alloc] initWithFrame:CGRectMake(80, 90, self.frame.size.width-20, self.frame.size.height-90) style:UITableViewStylePlain];
        
        [self.eventsTable setDelegate:self];
        [self.eventsTable setBackgroundView:nil];
        [self.eventsTable setBackgroundColor:[UIColor clearColor]];
        [self.eventsTable setDataSource:self];
        [self addSubview:self.eventsTable];
    }
    
    if (_noAppointmentsLabel == nil) {
        _noAppointmentsLabel = [[UILabel alloc] init];
        [_noAppointmentsLabel setFrame:CGRectMake(80, 90, self.frame.size.width-100, 40)];
        [_noAppointmentsLabel setTextColor:[UIColor whiteColor]];
        [_noAppointmentsLabel setTextAlignment:NSTextAlignmentLeft];
        _noAppointmentsLabel.font = [UIFont fontWithName:@"Klavika-Bold" size:15.0f];
        [_noAppointmentsLabel setHidden:YES];
    }
    if (self.eventsArray.count == 0) {
        [self.eventsTable setHidden:YES];
        [self changeColor:[[[NSUserDefaults standardUserDefaults] objectForKey:@"ColorIndex"] intValue]];
        
        
        [self addSubview:_noAppointmentsLabel];
        
        NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
        if ([language isEqualToString:@"nb"] || [language isEqualToString:@"nb-US"]|| [language isEqualToString:@"nb-NO"]) {
            
            NSString *appointMentsLabelText = NSLocalizedString(@"No Appointments", nil);
            [_noAppointmentsLabel setText:appointMentsLabelText];
            
        } else {
            [_noAppointmentsLabel setText:@"No Appointments"];
        }
        
        [_noAppointmentsLabel setHidden:NO];

    } else {
        [self.eventsTable setHidden:NO];
        [self.eventsTable reloadData];
        [_noAppointmentsLabel setHidden:YES];
        
        self.selectedDict = [self.eventsArray objectAtIndex:[AppDataManager sharedInstance].index];
        [self changeColor:[[self.selectedDict objectForKey:@"ColorIndex"] intValue]];
    }
    [self.eventsTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.eventsTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];


//    if(_mDateLabel == nil) {
//        _mDateLabel = [[UILabel alloc] init];
//        [_mDateLabel setFrame:CGRectMake(80, 90, self.frame.size.width-100, 30)];
//        [_mDateLabel setTextColor:[UIColor whiteColor]];
//        [_mDateLabel setTextAlignment:NSTextAlignmentLeft];
//        [_mDateLabel setFont:[UIFont systemFontOfSize:24.0f]];
//        [_mDateLabel setText:[mutableDictionary objectForKey:@"BloodTest"]];
//        [self addSubview:_mDateLabel];
//    } else {
//        [_mDateLabel setText:[mutableDictionary objectForKey:@"BloodTest"]];
//    }
//   
//    if (_mDateText == nil) {
//        _mDateText = [[UILabel alloc] init];
//        [_mDateText setFrame:CGRectMake(80, 115, self.frame.size.width-100, 30)];
//        [_mDateText setTextColor:[UIColor whiteColor]];
//        [_mDateText setTextAlignment:NSTextAlignmentLeft];
//        [_mDateText setFont:[UIFont systemFontOfSize:14.0f]];
//        [_mDateText setText:[mutableDictionary objectForKey:@"BloodTest"]];
//        [self addSubview:_mDateText];
//    } else {
//        [_mDateText setText:[mutableDictionary objectForKey:@"BloodTest"]];
//    }
//    
//    if(_mTimeLabel == nil) {
//        _mTimeLabel = [[UILabel alloc] init];
//        [_mTimeLabel setFrame:CGRectMake(80, 150, self.frame.size.width-100, 30)];
//        [_mTimeLabel setTextColor:[UIColor whiteColor]];
//        [_mTimeLabel setTextAlignment:NSTextAlignmentLeft];
//        [_mTimeLabel setFont:[UIFont systemFontOfSize:24.0f]];
//        [_mTimeLabel setText:[mutableDictionary objectForKey:@"Time"]];
//        [self addSubview:_mTimeLabel];
//    } else {
//        [_mTimeLabel setText:[mutableDictionary objectForKey:@"Time"]];
//    }
//    
//    if(_mTimeText== nil) {
//        _mTimeText = [[UILabel alloc] init];
//        [_mTimeText setFrame:CGRectMake(80, 185, self.frame.size.width-100, 30)];
//        [_mTimeText setTextColor:[UIColor whiteColor]];
//        [_mTimeText setTextAlignment:NSTextAlignmentLeft];
//        [_mTimeText setFont:[UIFont systemFontOfSize:14.0f]];
//        [_mTimeText setText:[mutableDictionary objectForKey:@"Time"]];
//        [self addSubview:_mTimeText];
//    } else {
//        [_mTimeText setText:[mutableDictionary objectForKey:@"Time"]];
//    }
//   
//    if(_mLastDayLabel == nil) {
//        _mLastDayLabel = [[UILabel alloc] init];
//        [_mLastDayLabel setFrame:CGRectMake(80, 220, self.frame.size.width-100, 30)];
//        [_mLastDayLabel setTextColor:[UIColor whiteColor]];
//        [_mLastDayLabel setTextAlignment:NSTextAlignmentLeft];
//        [_mLastDayLabel setFont:[UIFont systemFontOfSize:24.0f]];
//        [_mLastDayLabel setText:[mutableDictionary objectForKey:@"Last"]];
//        [self addSubview:_mLastDayLabel];
//    } else {
//        [_mLastDayLabel setText:[mutableDictionary objectForKey:@"Last"]];
//
//    }
//  
//    if(_mLastDayText == nil) {
//        _mLastDayText = [[UILabel alloc] init];
//        [_mLastDayText setFrame:CGRectMake(80, 250, self.frame.size.width-100, 30)];
//        [_mLastDayText setTextColor:[UIColor whiteColor]];
//        [_mLastDayText setTextAlignment:NSTextAlignmentLeft];
//        [_mLastDayText setFont:[UIFont systemFontOfSize:14.0f]];
//        [_mLastDayText setText:[mutableDictionary objectForKey:@"Last"]];
//        [self addSubview:_mLastDayText];
//    } else {
//        [_mLastDayText setText:[mutableDictionary objectForKey:@"Last"]];
//
//    }
    
}


-(void)changeColor:(int)indexValue
{
    
    if(indexValue == -1)
    {
        
        _mDayLabel.layer.borderColor = [UIColor clearColor].CGColor;

    }
    else{
        
        _mDayLabel.layer.borderColor = [(UIColor *)[StoreDataMangager sharedInstance].fetchColorsArray[indexValue] CGColor];

    }
    
}

#pragma mark -  UITableView dataSource methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.eventsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"EventsCell"];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"EventsCell"];
        
    }
    else{
        
        for (UIView *view in [cell.contentView subviews]) {
            
            [view removeFromSuperview];
        }
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSDictionary *dict = self.eventsArray[indexPath.row];

    [cell.textLabel setTextColor:[UIColor whiteColor]];
    cell.textLabel.text = @"";
    cell.textLabel.font = [UIFont fontWithName:@"Klavika-Bold" size:20.0f];
    //cell.textLabel.frame = CGRectMake(cell.textLabel.frame.origin.x + 15, cell.textLabel.frame.origin.y, cell.textLabel.frame.size.width, cell.textLabel.frame.size.height);
    [cell setBackgroundColor:[UIColor clearColor]];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 25, 15, 15)];
    [view.layer setCornerRadius:view.frame.size.width/2];
    if([[dict objectForKey:@"ColorIndex"]intValue] == -1)
    {
        
        [view setBackgroundColor:[UIColor clearColor]];
        //[view.layer setBorderColor:[UIColor clearColor].CGColor];
        
    }
    else{
        
    [view setBackgroundColor:(UIColor *)[StoreDataMangager sharedInstance].fetchColorsArray[[[dict objectForKey:@"ColorIndex"]intValue]]];
        //[view.layer setBorderColor:((UIColor *)[StoreDataMangager sharedInstance].fetchColorsArray[[[dict objectForKey:@"ColorIndex"]intValue]]).CGColor];
        
    }
    
    UILabel *eventTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 11.0f, 290.0f, 42)];
    [eventTitleLabel setText:[dict objectForKey:@"EventTitle"]];
    [eventTitleLabel setTextColor:[UIColor whiteColor]];
    [eventTitleLabel setTextAlignment:NSTextAlignmentLeft];
    [eventTitleLabel setFont:[UIFont fontWithName:@"Klavika-Bold" size:20.0f]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(85.0f, 56.0f, 25, 25)];
    [imageView setImage:[UIImage imageNamed:@"time.png"]];
    
    UILabel *remainderLabel = [[UILabel alloc] initWithFrame:CGRectMake(113.0f, 59.0f, 90.0f, 21)];
    [remainderLabel setText:[dict objectForKey:@"Remainder"]];
    [remainderLabel setTextColor:[UIColor whiteColor]];
    [remainderLabel setTextAlignment:NSTextAlignmentLeft];
    [remainderLabel setFont:[UIFont fontWithName:@"Klavika-Bold" size:15.0f]];
    
    UILabel *clinicLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 56.0f, 90.0f, 21)];
    [clinicLabel setText:[dict objectForKey:@"TagTitle"]];
    [clinicLabel setTextColor:[UIColor whiteColor]];
    [clinicLabel setTextAlignment:NSTextAlignmentLeft];
    [cell.contentView addSubview:eventTitleLabel];
    [cell.contentView addSubview:clinicLabel];
    [cell.contentView addSubview:remainderLabel];
    
    if ([(NSString *)[dict objectForKey:@"RemainderFlag"] intValue] == 1) {
        [cell.contentView addSubview:imageView];
    }
    
    
    [cell.contentView addSubview:view];
    
    
    return cell;
}

# pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Fetch yourText for this row from your data source..
    
    return 85.0;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[AppDataManager sharedInstance] setIndex:(int)indexPath.row];
    self.selectedDict = self.eventsArray[indexPath.row];
   // int index = []
    [self changeColor:[[self.selectedDict objectForKey:@"ColorIndex"] intValue]];
}


- (void)calendarButtonAction {
    
    if (self.eventsArray.count == 0) {

     
        if ([self.delegate respondsToSelector:@selector(moveToCalendarColorPicker:)]) {
            
            [self.delegate moveToCalendarColorPicker:self];
        }
        
        
        
        return;
    }
    if ([self.delegate respondsToSelector:@selector(moveToCalendarColorPicker:)]) {
        [[AppDataManager sharedInstance] setSelectedDict:(NSMutableDictionary*)self.selectedDict];
        [self.delegate moveToCalendarColorPicker:self];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self initUI];
    [self setBackgroundColor:[UIColor darkGrayColor]];
    [self setAlpha:0.7];
}


@end
