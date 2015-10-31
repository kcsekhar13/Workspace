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
        
        self.colorPickerTitleArray = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithObjects:@"Lykkelig",@"Glad",@"Rolig",@"Fremgang",@"sing",@"Legg til humer",@"Legg til humer",@"Rolig",@"sing",@"Fremgang",nil]];
    }
    return self;
}

- (NSMutableArray *)fetchColorPickerTitlesArray {
    
    return self.colorPickerTitleArray;
}

@end
