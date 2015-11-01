//
//  CustomMoodsImageView.m
//  Koolo
//
//  Created by CNU on 01/11/15.
//  Copyright © 2015 Vinodram. All rights reserved.
//

#import "CustomMoodsImageView.h"

@implementation CustomMoodsImageView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    // Set the border width
    // Set the border color to RED
    CGContextSetStrokeColorWithColor(contextRef, self.boarderColor.CGColor);
    CGContextSetFillColorWithColor(contextRef, self.boarderColor.CGColor);

    CGContextBeginPath(contextRef);
    CGContextSetLineWidth(contextRef, 5.0);

    CGContextMoveToPoint(contextRef, 60, (rect.size.height/2)-30);
    CGContextAddLineToPoint(contextRef, 0, (rect.size.height/2));
    CGContextAddLineToPoint(contextRef, 60, (rect.size.height/2)+30);
    
    CGContextClosePath(contextRef);
    CGContextFillPath(contextRef);
}


@end
