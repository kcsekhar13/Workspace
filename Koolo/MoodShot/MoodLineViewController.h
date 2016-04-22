//
//  MoodLineViewController.h
//  Koolo
//
//  Created by Hamsini on 28/10/15.
//  Copyright © 2015 Vinodram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreDataMangager.h"
#import "MoodPreviewCell.h"

@interface MoodLineViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate> {
    StoreDataMangager *dataManager;
    BOOL pinchFlag;
    UITapGestureRecognizer *pinchGestureRecognizer;
    float backImageXPosition;
}

@property (weak, nonatomic) IBOutlet UITableView *moodLineTableView;
@property (nonatomic, strong)NSMutableArray *moodsArray;
@end
