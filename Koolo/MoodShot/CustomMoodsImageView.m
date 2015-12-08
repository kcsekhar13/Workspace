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

    if ([self.cellDict objectForKey:@"ColorIndex"]) {
  
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
    else{
        
        CGContextSetLineWidth(contextRef, 2.0);
        CGContextSetStrokeColorWithColor(contextRef, self.boarderColor.CGColor);
        CGContextSetFillColorWithColor(contextRef, [[UIColor blackColor] colorWithAlphaComponent:0.3].CGColor);
        CGContextBeginPath(contextRef);
        CGContextMoveToPoint(contextRef, 18, (rect.size.height/2)-9);
        CGContextAddLineToPoint(contextRef, 0, (rect.size.height/2));
        CGContextAddLineToPoint(contextRef, 18, (rect.size.height/2)+9);
        CGContextClosePath(contextRef);
        CGContextFillPath(contextRef);
        CGContextStrokePath(contextRef);
    }
}


@end
