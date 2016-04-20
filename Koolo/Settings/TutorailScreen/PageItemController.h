//
//  PageItemController.h
//  HandOff_ObjC
//
//  Created by Olga Dalton on 23/10/14.
//  Copyright (c) 2014 Olga Dalton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageItemController : UIViewController

// Item controller information
@property (nonatomic) NSUInteger itemIndex;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *screenTitle;
@property (nonatomic, strong) NSString *description;

// IBOutlets
@property (nonatomic, weak) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenDescription;

@end
