//
//  colorPickerTableViewCell.m
//  Koolo
//
//  Created by Hamsini on 31/10/15.
//  Copyright © 2015 Vinodram. All rights reserved.
//

#import "colorPickerTableViewCell.h"

@implementation colorPickerTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    
    if ([self.delegate respondsToSelector:@selector(adjustTableViewCellFrame:)]) {
        [self.delegate adjustTableViewCellFrame:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
