//
//  StoreDataMangager.m
//  Koolo
//
//  Created by Hamsini on 31/10/15.
//  Copyright © 2015 Vinodram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreDataMangager.h"
#import "AppConstants.h"

@implementation StoreDataMangager



static StoreDataMangager *sharedInstance = nil;

+ (id)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        
        NSArray *titlesArray = (NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"colorPickerTitles"];
        self.colorPickerTitleArray = [[NSMutableArray alloc] initWithArray:titlesArray];
        
        self.fetchColorsArray = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithObjects: Skyblue,yellow,blueColor,pink,red,black,lightgray,orange,brown,nil]];
    }
    return self;
}

- (NSMutableArray *)fetchColorPickerTitlesArray {
    
    return self.colorPickerTitleArray;
}

- (NSMutableArray *)fetchColors {
    
    return self.fetchColorsArray;
}

- (void)updateFetchColorPickerTitlesArray:(NSMutableArray *)newTitlesArray {
    
    self.colorPickerTitleArray = newTitlesArray;
    [[NSUserDefaults standardUserDefaults] setObject:newTitlesArray forKey:@"colorPickerTitles"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
