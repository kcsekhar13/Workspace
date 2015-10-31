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

- (UIImage *)returnBackgroundImage {
    
    UIImage *image = nil;
    NSError *error = nil;
    NSString *stringPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    
    NSArray *filePathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath: stringPath  error:&error];
    
    if (filePathsArray.count != 0) {
        NSString *strFilePath = [filePathsArray objectAtIndex:0];
        if ([[strFilePath pathExtension] isEqualToString:@"jpg"] || [[strFilePath pathExtension] isEqualToString:@"png"] || [[strFilePath pathExtension] isEqualToString:@"PNG"])
        {
            NSString *imagePath = [[stringPath stringByAppendingString:@"/"] stringByAppendingString:strFilePath];
            NSData *data = [NSData dataWithContentsOfFile:imagePath];
            if(data)
            {
                image = [UIImage imageWithData:data];
            }
        }
    }
    return image;
}
@end
