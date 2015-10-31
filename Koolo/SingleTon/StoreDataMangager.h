//
//  StoreDataMangager.h
//  Koolo
//
//  Created by Hamsini on 31/10/15.
//  Copyright © 2015 Vinodram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreDataMangager : NSData

+(StoreDataMangager *)sharedInstance;

@property (nonatomic, strong) NSMutableArray *colorPickerTitleArray;

- (NSMutableArray *)fetchColorPickerTitlesArray;

- (void)updateFetchColorPickerTitlesArray:(NSMutableArray *)newTitlesArray;

@end
