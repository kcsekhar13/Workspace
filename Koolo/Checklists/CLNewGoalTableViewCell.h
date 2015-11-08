//
//  CLNewGoalTableViewCell.h
//  Koolo
//
//  Created by Hamsini on 03/11/15.
//  Copyright © 2015 Vinodram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckListCustomView.h"

@interface CLNewGoalTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goalCellImage;
@property (weak, nonatomic) IBOutlet UILabel *goalTextLabel;
@property (weak, nonatomic) IBOutlet CheckListCustomView *labelBackView;
@property (nonatomic)NSString *status;

@end
