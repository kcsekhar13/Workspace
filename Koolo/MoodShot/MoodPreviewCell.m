//
//  MoodPreviewCell.m
//  Koolo
//
//  Created by CNU on 01/11/15.
//  Copyright © 2015 Vinodram. All rights reserved.
//

#import "MoodPreviewCell.h"

@implementation MoodPreviewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)drawBoarderForCell
{
    
    self.backView.boarderColor = self.boarderColor;
    [self.backView setNeedsDisplay];
    
}
- (IBAction )zoomButtonAction :(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(moveToZoomScreen:)]) {
        [self.delegate moveToZoomScreen:sender];
    }
}
@end
