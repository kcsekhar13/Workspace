//
//  CheckListCustomView.m
//  Koolo
//
//  Created by CNU on 08/11/15.
//  Copyright © 2015 Vinodram. All rights reserved.
//

#import "CheckListCustomView.h"

@implementation CheckListCustomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    // Set the border width
    // Set the border color to RED
    CGContextSetStrokeColorWithColor(contextRef, [[UIColor lightGrayColor] colorWithAlphaComponent:0.5].CGColor);
    CGContextSetFillColorWithColor(contextRef, [[UIColor lightGrayColor] colorWithAlphaComponent:0.5].CGColor);
    
    CGContextFillRect(contextRef, CGRectMake(20, 0, rect.size.width, rect.size.height));
    CGContextBeginPath(contextRef);
    CGContextSetLineWidth(contextRef, 5.0);
    CGContextMoveToPoint(contextRef, 20, (rect.size.height/2)-10);
    CGContextAddLineToPoint(contextRef, 0, (rect.size.height/2));
    CGContextAddLineToPoint(contextRef, 20, (rect.size.height/2)+10);
    CGContextClosePath(contextRef);
    CGContextFillPath(contextRef);
}


@end
