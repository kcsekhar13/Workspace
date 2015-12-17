//
//  CalendarViewController.h
//  Koolo
//
//  Created by Hamsini on 22/10/15.
//  Copyright (c) 2015 Vinodram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreDataMangager.h"
#import "EventsCustomCellTableViewCell.h"

@interface CalendarViewController : UIViewController {
    StoreDataMangager *dataManager;
    NSMutableArray *datesArray;
    int gestureCount;
    int previousDateGestureCount;
    UIButton *rightSwipeButton;
    UIButton *leftSwipeButton;
    
    NSArray *eventsArray;
}
@property(nonatomic,strong)NSArray *eventsArray;
@property (nonatomic, strong) NSDate *selectedDate;
@property (strong, nonatomic) IBOutlet UITableView *eventsTable;
@end
