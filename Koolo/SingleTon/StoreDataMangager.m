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

# pragma mark - Fetching colors and Background Image

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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePathAndDirectory = [documentsDirectory stringByAppendingPathComponent:@"BackgroundImages"];

    NSError *error;
    if (![[NSFileManager defaultManager] createDirectoryAtPath:filePathAndDirectory
                                   withIntermediateDirectories:NO
                                                    attributes:nil
                                                         error:&error])
    {
        NSLog(@"Create directory error: %@", error);
    }
    
    NSString *savedImagePath = [filePathAndDirectory stringByAppendingPathComponent:@"savedImage.png"];
    image = [UIImage imageWithContentsOfFile:savedImagePath];
    
    return image;
}


# pragma mark - Moodshot data saving methods

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



-(NSString*)getDateStringFromDate:(NSString*)string
{
    
    string = [string stringByReplacingOccurrencesOfString:@".png" withString:@""];
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"dd-MM-yyyyhh:mm:SS"];
    NSDate *selectedDate = [dateformate dateFromString:string];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:selectedDate];
    NSInteger day = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
    
    NSString *monthName = [[dateformate monthSymbols] objectAtIndex:(month-1)];
    
    NSString *dateString = [NSString stringWithFormat:@"%ld %@ %ld", (long)day, monthName, (long)year];
    
    return dateString;
}

# pragma mark - Checklist New goal data saving methods

-(NSArray*)getMoodShotGoalsFromPlist
{
    
    NSArray *moodShotGoalsArray = [[NSArray alloc] initWithContentsOfFile:[self getMoodShotGoalsFilePath]];
    
    return moodShotGoalsArray;
    
}

-(void)saveDictionaryToMoodShotPlist:(NSDictionary*)dict
{
    
    NSMutableArray *prevMoodsArray = [[NSMutableArray alloc] initWithArray:[self getMoodShotGoalsFromPlist]];
    
    if (prevMoodsArray == nil) {
        prevMoodsArray = [[NSMutableArray alloc] init];
    }
    [prevMoodsArray addObject:dict];
    [prevMoodsArray writeToFile:[self getMoodShotGoalsFilePath] atomically:YES];
    
}

-(NSString *)getMoodShotGoalsFilePath
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePathAndDirectory = [documentsDirectory stringByAppendingPathComponent:@"MoodShot.plist"];
    
    return filePathAndDirectory;
}

# pragma mark - Checklist Ready transfer data saving methods

-(NSArray*)getReadyTransferDataFromPlist
{
    
    NSArray *moodShotGoalsArray = [[NSArray alloc] initWithContentsOfFile:[self getReadyTransferFilePath]];
    
    return moodShotGoalsArray;
    
}

-(void)saveDictionaryToReadyTransferPlist:(NSDictionary*)dict
{
    
    NSMutableArray *prevMoodsArray = [[NSMutableArray alloc] initWithArray:[self getReadyTransferDataFromPlist]];
    
    if (prevMoodsArray == nil) {
        prevMoodsArray = [[NSMutableArray alloc] init];
    }
    [prevMoodsArray addObject:dict];
    [prevMoodsArray writeToFile:[self getReadyTransferFilePath] atomically:YES];
    
}

-(NSString *)getReadyTransferFilePath
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePathAndDirectory = [documentsDirectory stringByAppendingPathComponent:@"ReadyTransfer.plist"];
    
    return filePathAndDirectory;
}

@end
