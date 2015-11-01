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

-(NSString*)getStringFromDate:(NSDate*)date
{
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"dd-MM-yyyyhh:mm:SS"]; // Date formater
    NSString *dateString = [dateformate stringFromDate:date]; // Convert date to string
    NSLog(@"date :%@",dateString);
    return dateString;
}



-(NSString*)getDocumentryPath
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePathAndDirectory = [documentsDirectory stringByAppendingPathComponent:@"MoodImages"];
    NSError *error;
    if (![[NSFileManager defaultManager] createDirectoryAtPath:filePathAndDirectory
                                   withIntermediateDirectories:NO
                                                    attributes:nil
                                                         error:&error])
    {
        NSLog(@"Create directory error: %@", error);
    }
    
    return filePathAndDirectory;
}

-(void)saveDictionaryToPlist:(NSDictionary*)dict
{
    
    NSMutableArray *prevMoodsArray = [[NSMutableArray alloc] initWithArray:[self getMoodsFromPlist]];
    
    if (prevMoodsArray == nil) {        
        prevMoodsArray = [[NSMutableArray alloc] init];
    }
    [prevMoodsArray addObject:dict];
    [prevMoodsArray writeToFile:[self getMoodsFilePath] atomically:YES];
    
}


-(NSArray*)getMoodsFromPlist
{
    
    
    NSArray *moodsArray = [[NSArray alloc] initWithContentsOfFile:[self getMoodsFilePath]];
    
    return moodsArray;

    
    
}

-(NSString *)getMoodsFilePath
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePathAndDirectory = [documentsDirectory stringByAppendingPathComponent:@"Moods.plist"];
    
    return filePathAndDirectory;
}
@end
