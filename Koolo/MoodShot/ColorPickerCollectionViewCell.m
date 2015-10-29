//
//  ColorPickerCollectionViewCell.m
//  Koolo
//
//  Created by Hamsini on 29/10/15.
//  Copyright © 2015 Vinodram. All rights reserved.
//

#import "ColorPickerCollectionViewCell.h"

@implementation ColorPickerCollectionViewCell

- (IBAction)clickOnColorTitle:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(moveToColorPickerViewController:)]) {
        [self.delegate moveToColorPickerViewController:self];
    }
    
}

@end
