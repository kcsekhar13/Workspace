//
//  EventsCustomCellTableViewCell.h
//  Koolo
//
//  Created by Venkatesh Yedidha on 12/17/15.
//  Copyright © 2015 Vinodram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventsCustomCellTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *eventTitle;
@property (weak, nonatomic) IBOutlet UILabel *recurenceLabel;
@property (weak, nonatomic) IBOutlet UILabel *modeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;
@end
