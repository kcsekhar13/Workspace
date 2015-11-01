//
//  CLThreeSentenceViewController.h
//  Koolo
//
//  Created by Hamsini on 21/10/15.
//  Copyright (c) 2015 Vinodram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreDataMangager.h"

@interface CLThreeSentenceViewController : UIViewController <UITextViewDelegate> {
    
    StoreDataMangager *dataManager;
    BOOL animationFlag;
    float animateYPosition;
    CGRect viewFrame;
    UIView *inputAccView;
}

@end
