//
//  HomeNotificationView.h
//  Koolo
//
//  Created by Srikar Chowdary on 11/10/15.
//  Copyright (c) 2015 Vinodram. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeNotificationViewDelegate <NSObject>

- (void)moveToCalendarColorPicker:(id)sender;

@end

@interface HomeNotificationView : UIView
@property(nonatomic, strong) UILabel *mQuoteText;
@property(nonatomic, strong) UILabel *mDayLabel;

@property(nonatomic, strong) UILabel *mDateLabel;
@property(nonatomic, strong) UILabel *mDateText;

@property(nonatomic, strong) UILabel *mTimeLabel;
@property(nonatomic, strong) UILabel *mTimeText;

@property(nonatomic, strong) UILabel *mLastDayLabel;
@property(nonatomic, strong) UILabel *mLastDayText;

@property(nonatomic, strong) UIButton *calnderButton;

@property (nonatomic, assign) id <HomeNotificationViewDelegate> delegate;


@end
