//
//  MSSurveysTableViewCellIPhone.m
//  MFormsSurveys
//
//  Created by Srikar Chowdary on 22/02/15.
//  Copyright (c) 2015 Srikar Chowdary. All rights reserved.
//

#import "QuotesTableviewCell.h"

@implementation QuotesTableviewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];

    }
    return self;
}

//- (void)drawRect:(CGRect)rect{
//    [self initUI];
//
//}

-(void)initUI {
    _mQuoteText = [[UILabel alloc] init];
    [_mQuoteText setFrame:CGRectMake(5, 5, self.frame.size.width-50, self.frame.size.height + 20.0)];
    [_mQuoteText setTextColor:[UIColor blackColor]];
    [_mQuoteText setTextAlignment:NSTextAlignmentLeft];
    [_mQuoteText setFont:[UIFont systemFontOfSize:14.0f]];
    [_mQuoteText setNumberOfLines:2];

    [self.contentView addSubview:_mQuoteText];
    
    _mCheckImageView = [[UIImageView alloc] init];
    [_mCheckImageView setFrame:CGRectMake(self.frame.size.width-30, 17, 20, 20)];
    [_mCheckImageView setImage:[UIImage imageNamed:@"unchecked"]];
    [self.contentView addSubview:_mCheckImageView];
}

@end
