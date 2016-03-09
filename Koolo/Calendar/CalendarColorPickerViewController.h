//
//  CalendarColorPickerViewController.h
//  Koolo
//
//  Created by Hamsini on 31/10/15.
//  Copyright © 2015 Vinodram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreDataMangager.h"
#import "AppDataManager.h"

@interface CalendarColorPickerViewController : UIViewController {
    
    StoreDataMangager *dataManager;
}

@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, retain) NSDate *selectedDate;
@end
