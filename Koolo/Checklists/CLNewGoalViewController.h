//
//  CLNewGoalViewController.h
//  Koolo
//
//  Created by Hamsini on 21/10/15.
//  Copyright (c) 2015 Vinodram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreDataMangager.h"

@protocol NewGoalDelegate <NSObject>

- (void)addNewgoalWithText:(NSString *)goalText;
- (void)updateGoalWithText:(NSMutableDictionary *)goalDict withIndexValue:(int)index;

@end

@interface CLNewGoalViewController : UIViewController {
    
    StoreDataMangager *dataManager;
    BOOL newGoalFlag;
}

@property (nonatomic, assign) id <NewGoalDelegate> delegate;
@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, assign) BOOL editFlag;
@property (nonatomic, assign) int indexValue;
@property (nonatomic, strong) NSMutableDictionary *editDict;

@end
