//
//  MSColorPickerViewController.h
//  Koolo
//
//  Created by Hamsini on 28/10/15.
//  Copyright © 2015 Vinodram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreDataMangager.h"
#import "colorPickerTableViewCell.h"

@interface MSColorPickerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
    
    NSMutableArray *colorTitlesArray;
    StoreDataMangager *dataManager;
    colorPickerTableViewCell *colorCell;
    CGSize keyboardSize;
    CGRect oldRect;
}

@end
