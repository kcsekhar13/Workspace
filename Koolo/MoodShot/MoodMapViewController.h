//
//  MoodMapViewController.h
//  Koolo
//
//  Created by Hamsini on 28/10/15.
//  Copyright © 2015 Vinodram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreDataMangager.h"

@protocol MoodMapDelegate <NSObject>

- (void)filterMoodPics:(NSInteger)tag;

@end

@interface MoodMapViewController : UIViewController {
    StoreDataMangager *dataManager;
}

@property (nonatomic, assign) id <MoodMapDelegate> delegate;
@end
