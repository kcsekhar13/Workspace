//
//  StoreDataMangager.m
//  Koolo
//
//  Created by Hamsini on 31/10/15.
//  Copyright © 2015 Vinodram. All rights reserved.
//

#import "StoreDataMangager.h"

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
    }
    return self;
}

- (NSMutableArray *)fetchColorPickerTitlesArray {
    
    return self.colorPickerTitleArray;
}

- (void)updateFetchColorPickerTitlesArray:(NSMutableArray *)newTitlesArray {
    
    self.colorPickerTitleArray = newTitlesArray;
    [[NSUserDefaults standardUserDefaults] setObject:newTitlesArray forKey:@"colorPickerTitles"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
