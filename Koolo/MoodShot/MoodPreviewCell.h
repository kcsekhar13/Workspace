//
//  MoodPreviewCell.h
//  Koolo
//
//  Created by CNU on 01/11/15.
//  Copyright © 2015 Vinodram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomMoodsImageView.h"

@protocol moodsImageTableViewCellDelegate <NSObject>

- (void)adjustTableViewCellFrame:(id)sender;
- (void)updateColorPickertitles:(id)sender;

@end

@interface MoodPreviewCell : UITableViewCell

@property (nonatomic, assign) id <moodsImageTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *moodColorImage;

@property (weak, nonatomic) IBOutlet UIImageView *moodCellImage;
@property (weak, nonatomic) IBOutlet CustomMoodsImageView *backView;
@property (weak, nonatomic) UIColor *boarderColor;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

-(void)drawBoarderForCell;
@end
