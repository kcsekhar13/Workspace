//
//  CLNewGoalTableViewCell.m
//  Koolo
//
//  Created by Hamsini on 03/11/15.
//  Copyright © 2015 Vinodram. All rights reserved.
//

#import "CLNewGoalTableViewCell.h"

@implementation CLNewGoalTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setStatus:(NSString*)status
{
    
    _status = status;
    
    if ([status isEqualToString:@"Pending"]) {
        
        [self.goalCellImage setBackgroundColor:[UIColor redColor]];
    }
    else if ([status isEqualToString:@"Started"]) {
        
        [self.goalCellImage setBackgroundColor:[UIColor yellowColor]];
    }
    else if ([status isEqualToString:@"Completed"]) {
        
        [self.goalCellImage setBackgroundColor:[UIColor greenColor]];
    }
    
    
}

@end
