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
            [self addCircles:count];
            
        }
            break;
    }
    
    
}

-(void)addCircles:(int)withColorCount{
    
    
    StoreDataMangager *datahandler = [StoreDataMangager sharedInstance];
    NSArray *moodArray = (NSArray *)[datahandler getMoodsFromPlist];
    int count = (int)moodArray.count;
    
    int withOutColorCount = 0;
    
    for (int i=0; i<count; i++) {
        NSDictionary *dict = [moodArray objectAtIndex:i];
        NSString *str = [dict objectForKey:@"ColorIndex"];
        if (str.intValue == 0) {
            ++withOutColorCount;;
        } 
    }
    
    if (withColorCount >= 5 && withOutColorCount >= 5) {
        
        withColorCount = 5;
        withOutColorCount = 4;
        
        [self drawCirclesWithTotalCount:count withMoodsArray:moodArray withColorCount:withColorCount withOutColorCount:withOutColorCount];
        
    } else if (withColorCount >= 5 && withOutColorCount <= 5) {
        
         withColorCount = 9 - withOutColorCount;
        
        [self drawCirclesWithTotalCount:count withMoodsArray:moodArray withColorCount:withColorCount withOutColorCount:withOutColorCount];
        
    } else if (withColorCount <= 5 && withOutColorCount >= 5) {
        
        withOutColorCount = 9 - withColorCount;
        
        [self drawCirclesWithTotalCount:count withMoodsArray:moodArray withColorCount:withColorCount withOutColorCount:withOutColorCount];
        
    } else if (withColorCount < 5 && withOutColorCount < 5) {
        
        [self drawCirclesWithTotalCount:count withMoodsArray:moodArray withColorCount:withColorCount withOutColorCount:withOutColorCount];
    }
    
    
    
}

- (void)drawCirclesWithTotalCount:(int)count withMoodsArray:(NSArray *)moodArray withColorCount:(int)withColorCount withOutColorCount:(int)withOutColorCount{
    
    StoreDataMangager *datahandler = [StoreDataMangager sharedInstance];
    int tag = (int)self.tag-1;
    
    int withColor = 0;
    int withOutColor = 0;
    float xAxis = 5.0;
    float yAxis = 5.0;
    float width = ((self.frame.size.width-15)/3);
    float height = ((self.frame.size.height-15)/3);
    for (int i=0; i<count; i++) {
        
        
        UIColor *backgroundColor = nil;
        NSDictionary *dict = [moodArray objectAtIndex:i];
        
        
        backgroundColor = (UIColor *)datahandler.fetchColorsArray[tag];
        /*
        int size = (float)(rand()%(int)width + 10);
        if (size > width) {
            size = width;
        }
        UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(xAxis, yAxis, size, size)];*/
        
        UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(xAxis, yAxis, width, width)];
        
        
        
        [circleView setCenter:CGPointMake(xAxis+width/2, yAxis+height/2)];
        [circleView.layer setBorderWidth:2.0f];
        [circleView.layer setMasksToBounds:YES];
        [circleView.layer setCornerRadius:circleView.frame.size.width/2];
        [circleView setUserInteractionEnabled:YES];
        
        
        xAxis = xAxis + width + 2.5;
        
        if (xAxis + width > self.frame.size.width) {
            
            xAxis = 5.0;
            yAxis = yAxis + height + 2.5;
        }
        
        //NSString *indexValue = [dict objectForKey:@"ColorIndex"];
        
        if ((withColorCount > 0) && (withColor < withColorCount)) {
            
            backgroundColor = (UIColor *)datahandler.fetchColorsArray[tag];
            [circleView.layer setBorderColor:[(UIColor *)datahandler.fetchColorsArray[tag] CGColor]];
            [circleView setBackgroundColor:(UIColor *)datahandler.fetchColorsArray[tag]];
            [self addSubview:circleView];
            ++withColor;
            
        } else if ((withOutColorCount > 0) && (withOutColor < withOutColorCount)){
            
            backgroundColor = [UIColor clearColor];
            [circleView.layer setBorderColor:[(UIColor *)datahandler.fetchColorsArray[tag] CGColor]];
            [circleView setBackgroundColor:backgroundColor];
            [self addSubview:circleView];
            ++withOutColor;
        }
        
        
        
        
    }
}

@end
