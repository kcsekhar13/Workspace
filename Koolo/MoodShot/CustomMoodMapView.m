//
//  CustomMoodMapView.m
//  Koolo
//
//  Created by CNU on 08/12/15.
//  Copyright © 2015 Vinodram. All rights reserved.
//

#import "CustomMoodMapView.h"
#import "StoreDataMangager.h"

@implementation CustomMoodMapView




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
 
}
*/


-(void)drawInputViews
{
    
    int tag = (int)self.tag-1;

    
    StoreDataMangager *datahandler = [StoreDataMangager sharedInstance];
    if (tag == -1) {
        [self.layer setBorderWidth:2.0f];
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:self.frame.size.width/2];
        [self setUserInteractionEnabled:YES];
        [self.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        return;
    }
    
    int count = (int)self.moodsArray.count;
    switch (count) {
        case 0:
        {
            [self.layer setBorderWidth:2.0f];
            [self.layer setMasksToBounds:YES];
            [self.layer setCornerRadius:self.frame.size.width/2];
            [self.layer setBorderColor:[(UIColor *)datahandler.fetchColorsArray[tag] CGColor]];
        }
        break;
        
        case 1:
        {
            [self.layer setBorderWidth:2.0f];
            [self.layer setMasksToBounds:YES];
            [self.layer setCornerRadius:self.frame.size.width/2];
            [self.layer setBorderColor:[(UIColor *)datahandler.fetchColorsArray[tag] CGColor]];
            [self.layer setBackgroundColor:[(UIColor *)datahandler.fetchColorsArray[tag] CGColor]];
        }
            break;
            
        default:
        {
            [self.layer setBorderWidth:2.0f];
            [self.layer setMasksToBounds:YES];
            [self.layer setCornerRadius:2.0];
            //[self.layer setBorderColor:[(UIColor *)datahandler.fetchColorsArray[tag] CGColor]];
            [self.layer setBorderColor:[[UIColor clearColor] CGColor]];
            [self addCircles];
            
        }
            break;
    }
    
    
}

-(void)addCircles{
    
    int tag = (int)self.tag-1;
    StoreDataMangager *datahandler = [StoreDataMangager sharedInstance];
    int count = (int)self.moodsArray.count;
    if (count > 9) {
        
        count = 9;
    }
    float xAxis = 5.0;
    float yAxis = 5.0;
    float width = ((self.frame.size.width-15)/3);
    float height = ((self.frame.size.height-15)/3);
    for (int i=0; i<count; i++) {
        
        UIColor *boarderColor = (UIColor *)datahandler.fetchColorsArray[tag];
        int size = (float)(rand()%(int)width + 10);
        if (size > width) {
            size = width;
        }
        UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(xAxis, yAxis, size, size)];
        [circleView setBackgroundColor:boarderColor];
        [circleView setCenter:CGPointMake(xAxis+width/2, yAxis+height/2)];
        [circleView.layer setBorderWidth:2.0f];
        [circleView.layer setMasksToBounds:YES];
        [circleView.layer setCornerRadius:circleView.frame.size.width/2];
        [circleView setUserInteractionEnabled:YES];
        [circleView.layer setBorderColor:[[UIColor clearColor] CGColor]];
        
        xAxis = xAxis + width + 2.5;
        
        if (xAxis + width > self.frame.size.width) {
            
            xAxis = 5.0;
            yAxis = yAxis + height + 2.5;
        }
        
        [self addSubview:circleView];
    }
    
}
@end
