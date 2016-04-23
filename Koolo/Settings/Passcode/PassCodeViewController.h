//
//  PassCodeViewController.h
//  Koolo
//
//  Created by Vinodram on 09/10/15.
//  Copyright (c) 2015 Vinodram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreDataMangager.h"

@interface PassCodeViewController : UIViewController{
    
    StoreDataMangager *dataManager;
    int wrongCount;
    NSString *wrongCodeMessage;
    NSString *secretQuestion;
    NSString *secretAnswer;
    NSString *passCodeString;

}

@property (nonatomic)int mode;
@end
