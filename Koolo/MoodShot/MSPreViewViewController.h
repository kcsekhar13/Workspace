//
//  MSPreViewViewController.h
//  Koolo
//
//  Created by Hamsini on 28/10/15.
//  Copyright © 2015 Vinodram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreDataMangager.h"

@interface MSPreViewViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate> {
    
    StoreDataMangager *dataManager;
    NSIndexPath *selectedIndexPath;
}
@property (nonatomic,strong)NSData *selectedImageData;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
