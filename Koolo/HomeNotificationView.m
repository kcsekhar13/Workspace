//
//  HomeNotificationView.m
//  Koolo
//
//  Created by Srikar Chowdary on 11/10/15.
//  Copyright (c) 2015 Vinodram. All rights reserved.
//

#import "HomeNotificationView.h"
#import "StoreDataMangager.h"

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
        [_mDayLabel setFont:[UIFont systemFontOfSize:24.0f]];
        [_mDayLabel setBackgroundColor:[UIColor grayColor]];
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"calendarColorIndex"]) {
            int index = [[[NSUserDefaults standardUserDefaults] objectForKey:@"calendarColorIndex"] intValue];
            _mDayLabel.layer.borderColor = [(UIColor *)dataManager.fetchColorsArray[index] CGColor];
        } else {
            [_mDayLabel.layer setBorderColor:[[UIColor redColor] CGColor]];
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
        [_mQuoteText setFont:[UIFont italicSystemFontOfSize:14.0f]];
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
    
    if(_mDateLabel == nil) {
        _mDateLabel = [[UILabel alloc] init];
        [_mDateLabel setFrame:CGRectMake(80, 90, self.frame.size.width-100, 30)];
        [_mDateLabel setTextColor:[UIColor whiteColor]];
        [_mDateLabel setTextAlignment:NSTextAlignmentLeft];
        [_mDateLabel setFont:[UIFont systemFontOfSize:24.0f]];
        [_mDateLabel setText:[mutableDictionary objectForKey:@"BloodTest"]];
        [self addSubview:_mDateLabel];
    } else {
        [_mDateLabel setText:[mutableDictionary objectForKey:@"BloodTest"]];
    }
   
    if (_mDateText == nil) {
        _mDateText = [[UILabel alloc] init];
        [_mDateText setFrame:CGRectMake(80, 115, self.frame.size.width-100, 30)];
        [_mDateText setTextColor:[UIColor whiteColor]];
        [_mDateText setTextAlignment:NSTextAlignmentLeft];
        [_mDateText setFont:[UIFont systemFontOfSize:14.0f]];
        [_mDateText setText:[mutableDictionary objectForKey:@"BloodTest"]];
        [self addSubview:_mDateText];
    } else {
        [_mDateText setText:[mutableDictionary objectForKey:@"BloodTest"]];
    }
    
    if(_mTimeLabel == nil) {
        _mTimeLabel = [[UILabel alloc] init];
        [_mTimeLabel setFrame:CGRectMake(80, 150, self.frame.size.width-100, 30)];
        [_mTimeLabel setTextColor:[UIColor whiteColor]];
        [_mTimeLabel setTextAlignment:NSTextAlignmentLeft];
        [_mTimeLabel setFont:[UIFont systemFontOfSize:24.0f]];
        [_mTimeLabel setText:[mutableDictionary objectForKey:@"Time"]];
        [self addSubview:_mTimeLabel];
    } else {
        [_mTimeLabel setText:[mutableDictionary objectForKey:@"Time"]];
    }
    
    if(_mTimeText== nil) {
        _mTimeText = [[UILabel alloc] init];
        [_mTimeText setFrame:CGRectMake(80, 185, self.frame.size.width-100, 30)];
        [_mTimeText setTextColor:[UIColor whiteColor]];
        [_mTimeText setTextAlignment:NSTextAlignmentLeft];
        [_mTimeText setFont:[UIFont systemFontOfSize:14.0f]];
        [_mTimeText setText:[mutableDictionary objectForKey:@"Time"]];
        [self addSubview:_mTimeText];
    } else {
        [_mTimeText setText:[mutableDictionary objectForKey:@"Time"]];
    }
   
    if(_mLastDayLabel == nil) {
        _mLastDayLabel = [[UILabel alloc] init];
        [_mLastDayLabel setFrame:CGRectMake(80, 220, self.frame.size.width-100, 30)];
        [_mLastDayLabel setTextColor:[UIColor whiteColor]];
        [_mLastDayLabel setTextAlignment:NSTextAlignmentLeft];
        [_mLastDayLabel setFont:[UIFont systemFontOfSize:24.0f]];
        [_mLastDayLabel setText:[mutableDictionary objectForKey:@"Last"]];
        [self addSubview:_mLastDayLabel];
    } else {
        [_mLastDayLabel setText:[mutableDictionary objectForKey:@"Last"]];

    }
  
    if(_mLastDayText == nil) {
        _mLastDayText = [[UILabel alloc] init];
        [_mLastDayText setFrame:CGRectMake(80, 250, self.frame.size.width-100, 30)];
        [_mLastDayText setTextColor:[UIColor whiteColor]];
        [_mLastDayText setTextAlignment:NSTextAlignmentLeft];
        [_mLastDayText setFont:[UIFont systemFontOfSize:14.0f]];
        [_mLastDayText setText:[mutableDictionary objectForKey:@"Last"]];
        [self addSubview:_mLastDayText];
    } else {
        [_mLastDayText setText:[mutableDictionary objectForKey:@"Last"]];

    }
   
}

- (void)calendarButtonAction {
    
    if ([self.delegate respondsToSelector:@selector(moveToCalendarColorPicker:)]) {
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
