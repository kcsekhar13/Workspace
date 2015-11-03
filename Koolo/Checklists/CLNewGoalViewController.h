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

@end

@interface CLNewGoalViewController : UIViewController {
    
    StoreDataMangager *dataManager;
    BOOL newGoalFlag;
}

@property (nonatomic, assign) id <NewGoalDelegate> delegate;

@end
