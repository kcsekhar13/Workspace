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
@property (nonatomic, strong) NSMutableArray *fetchColorsArray;

- (NSMutableArray *)fetchColorPickerTitlesArray;

- (void)updateFetchColorPickerTitlesArray:(NSMutableArray *)newTitlesArray;
- (UIImage *)returnBackgroundImage;
- (NSMutableArray *)fetchColors;
-(NSString*)getStringFromDate:(NSDate*)date;
-(NSString*)getDocumentryPath;
-(void)saveDictionaryToPlist:(NSDictionary*)dict;
-(NSArray*)getMoodsFromPlist;
-(NSString*)getDateStringFromDate:(NSString*)string;
@end
