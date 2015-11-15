//
//  CheckListViewController.h
//  Koolo
//
//  Created by Hamsini on 21/10/15.
//  Copyright (c) 2015 Vinodram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreDataMangager.h"

@interface CheckListViewController : UIViewController {
    
    StoreDataMangager *dataManager;
    NSString *myhealthString;
    NSString *transferString;
    NSString *goalString;
    
    NSString *mytransferString;
    NSString *newTransferString;
    NSString *doneButtonTitle;
}

@end
