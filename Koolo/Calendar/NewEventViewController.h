//
//  NewEventViewController.h
//  Koolo
//
//  Created by Hamsini on 22/10/15.
//  Copyright (c) 2015 Vinodram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreDataMangager.h"
#import "AppDataManager.h"

@interface NewEventViewController : UIViewController <UITextFieldDelegate> {
    
    StoreDataMangager *dataManager;
    UIToolbar *toolBar;
    BOOL displayDatePicker;
    NSArray *titlesArray;
    BOOL remaindFlag;
    BOOL selectedTagFlag;
    NSMutableArray *selectedTagsArray;
    
}

@property (nonatomic, strong) NSDate *selectedDate;

@end
