//
//  ColorPickerCollectionViewCell.h
//  Koolo
//
//  Created by Hamsini on 29/10/15.
//  Copyright © 2015 Vinodram. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ColorPickerCollectionViewDelegate <NSObject>

- (void)moveToColorPickerViewController:(id)sender;

@end

@interface ColorPickerCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *colorKeyView;
@property (weak, nonatomic) IBOutlet UIView *selectedColorKeyView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *pickerButton;

@property (nonatomic, assign) id <ColorPickerCollectionViewDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedColorIndex;

@end
