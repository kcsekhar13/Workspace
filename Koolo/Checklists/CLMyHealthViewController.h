//
//  CLMyHealthViewController.h
//  Koolo
//
//  Created by Hamsini on 21/10/15.
//  Copyright (c) 2015 Vinodram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreDataMangager.h"

@interface CLMyHealthViewController : UIViewController {
    
    StoreDataMangager *dataManager;
}

@property(nonatomic, retain) NSString *viewTitle;
@property(nonatomic, retain) NSString *rightButtonTitle;
@property(nonatomic, assign) BOOL goalFlag;
- (IBAction)tappedOnStatusButton:(id)sender;

@end
