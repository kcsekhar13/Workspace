//
//  MoodPreviewCell.h
//  Koolo
//
//  Created by CNU on 01/11/15.
//  Copyright © 2015 Vinodram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomMoodsImageView.h"

@protocol MoodsImageTableViewCellDelegate <NSObject>

- (void)adjustTableViewCellFrame:(id)sender;
- (void)updateColorPickertitles:(id)sender;
- (void)moveToZoomScreen:(UIButton *)sender;

@end

@interface MoodPreviewCell : UITableViewCell

@property (nonatomic, assign) id <MoodsImageTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *moodColorImage;

@property (weak, nonatomic) IBOutlet UIImageView *moodCellImage;
@property (weak, nonatomic) IBOutlet CustomMoodsImageView *backView;
@property (weak, nonatomic) UIColor *boarderColor;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *emptyDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *zoomButton;

-(void)drawBoarderForCell;
@end
