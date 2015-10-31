//
//  colorPickerTableViewCell.h
//  Koolo
//
//  Created by Hamsini on 31/10/15.
//  Copyright © 2015 Vinodram. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol colorPickerTableViewCellDelegate <NSObject>

- (void)adjustTableViewCellFrame:(id)sender;

@end

@interface colorPickerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *colorKeyView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (nonatomic, assign) NSInteger selectedColorIndex;
@property (nonatomic, assign) id <colorPickerTableViewCellDelegate> delegate;

@end
