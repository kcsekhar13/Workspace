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
        //NSLog(@"Create directory error: %@", error);
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
    
    //NSLog(@"date :%@",dateString);
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
        //NSLog(@"Create directory error: %@", error);
    }
    
    return filePathAndDirectory;
}

-(void)saveDictionaryToPlist:(NSDictionary*)dict
{
    
    NSMutableArray *prevMoodsArray = [[NSMutableArray alloc] initWithArray:[self getMoodsFromPlist]];
    
    if (prevMoodsArray == nil) {        
        prevMoodsArray = [[NSMutableArray alloc] init];
    }
    [prevMoodsArray insertObject:dict atIndex:0];
    [prevMoodsArray writeToFile:[self getMoodsFilePath] atomically:YES];
    
}

- (void)checkDummyMoods {
    
    NSDate *oldDate = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"date"];
    NSDate *presentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"d MMM yyyy"];
    
    NSString *oldDateString = @"";
    if (oldDate != nil) {
        oldDateString = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:oldDate]] ;
    }
    
    NSString *presentDateString = [dateFormatter stringFromDate:presentDate];
    
    
    if ( oldDate != nil && !([oldDateString isEqualToString:presentDateString])) {
        [self addDummyMoods];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:presentDate forKey:@"date"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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

-(NSArray*)getSortedData:(NSArray*)moodsList
{
    
    NSMutableArray *sortedMoodList = [[NSMutableArray alloc] init];
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    
    for (int i=0; i<[moodsList count]; i++) {
        
        NSDictionary *internalDict = [moodsList objectAtIndex:i];
        if ([[internalDict objectForKey:@"Hidden"] isEqualToString:@"YES"]) {
            
            NSString *keyString = @"Hidden";
            NSMutableArray *indexArray = [tempDict objectForKey:keyString];
            if (indexArray == nil) {
                indexArray = [[NSMutableArray alloc] init];
            }
            [indexArray addObject:internalDict];
            [tempDict setObject:indexArray forKey:keyString];
            
        }
        else{
            
            NSString *keyString = [internalDict objectForKey:@"GoalStatus"];
            NSMutableArray *indexArray = [tempDict objectForKey:keyString];
            if (indexArray == nil) {
                indexArray = [[NSMutableArray alloc] init];
            }
            [indexArray addObject:internalDict];
            [tempDict setObject:indexArray forKey:keyString];
            
            
        }
       
    }
    //NSLog(@"%@ >>>>",tempDict);
    
    if ([tempDict objectForKey:@"Pending"]) {
        [sortedMoodList addObjectsFromArray:[tempDict objectForKey:@"Pending"]];
    }
    if ([tempDict objectForKey:@"Started"]) {
        [sortedMoodList addObjectsFromArray:[tempDict objectForKey:@"Started"]];
    }
    if ([tempDict objectForKey:@"Completed"]) {
        [sortedMoodList addObjectsFromArray:[tempDict objectForKey:@"Completed"]];
    }
    if ([tempDict objectForKey:@"Hidden"]) {
        
        [sortedMoodList addObjectsFromArray:[tempDict objectForKey:@"Hidden"]];
    }
    

    return sortedMoodList;
    
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


-(NSDate *)getDateFromFileName:(NSString*)fileName
{
        fileName = [fileName stringByReplacingOccurrencesOfString:@".png" withString:@""];
        NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
        [dateformate setDateFormat:@"dd-MM-yyyyhh:mm:SS"];
        NSDate *selectedDate = [dateformate dateFromString:fileName];
    
    return selectedDate;

}
# pragma mark - Checklist New goal data saving methods

-(NSArray*)getMoodShotGoalsFromPlist
{
    
    NSArray *moodShotGoalsArray = [[NSArray alloc] initWithContentsOfFile:[self getMoodShotGoalsFilePath]];
    moodShotGoalsArray = [self getSortedData:moodShotGoalsArray];
    return moodShotGoalsArray;
    
}

-(void)saveDictionaryToMoodShotPlist:(NSDictionary*)dict
{
    
    NSMutableArray *prevMoodsArray = [[NSMutableArray alloc] initWithArray:[self getMoodShotGoalsFromPlist]];
    if (prevMoodsArray == nil) {
        prevMoodsArray = [[NSMutableArray alloc] init];
    }
    [prevMoodsArray insertObject:dict atIndex:0];
    [prevMoodsArray writeToFile:[self getMoodShotGoalsFilePath] atomically:YES];
    
}

-(void)updateMoodsArray:(NSArray*)totalArray
{
    
    [totalArray  writeToFile:[self getMoodShotGoalsFilePath] atomically:YES];
    
}

-(void)updateReadyArray:(NSArray*)totalArray
{
    
    [totalArray  writeToFile:[self getReadyTransferFilePath] atomically:YES];

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
    moodShotGoalsArray = [self getSortedData:moodShotGoalsArray];
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


-(void)addDummyMoods
{
    NSMutableArray *prevMoodsArray = [[NSMutableArray alloc] initWithArray:[self getMoodsFromPlist]];

    NSDate *previousDate = nil;
    if ([prevMoodsArray count] ==0) {
        previousDate = (NSDate *)[[NSUserDefaults standardUserDefaults]  objectForKey:@"AppInstallDate"];
    } else {
       previousDate = (NSDate *)[self getDateFromFileName:[[prevMoodsArray objectAtIndex:0] objectForKey:@"FileName"]];
    }
   
    NSArray *allDates = [self getAllDatesBetweenDates:previousDate toDate:[NSDate date]];

    //NSLog(@"%@ >>>",allDates);

    for (int i= 0; i<[allDates count] - 1; i++) {
        
        NSDate *date = [allDates objectAtIndex:i];
        if (![date compare:previousDate] == NSOrderedSame) {
            NSString *fileName = [NSString stringWithFormat:@"%@.png",[self getStringFromDate:date]];
            NSDictionary *moodDict = [[NSDictionary alloc] initWithObjectsAndKeys:fileName,@"FileName",nil];
            [prevMoodsArray insertObject:moodDict atIndex:0];
        }
        
    }
    [prevMoodsArray writeToFile:[self getMoodsFilePath] atomically:YES];

}

-(NSArray*)getAllDatesBetweenDates:(NSDate*)fromDate toDate:(NSDate*)toDate
{
    
    NSMutableArray *dates = [NSMutableArray array];
//    NSDate *curDate = [self getDateFromString:fromDate];
//    NSDate *todayDate = [self getDateFromString:toDate];
    while([fromDate timeIntervalSince1970] <= [toDate timeIntervalSince1970]) //you can also use the earlier-method
    {
        [dates addObject:fromDate];
        fromDate = [NSDate dateWithTimeInterval:86400 sinceDate:fromDate];

    }
    
    //NSLog(@"%@ >>>",dates);

    return dates;
}

-(NSDate*)getDateFromString:(NSString*)string
{
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"dd-MM-yyyyhh:mm:SS"]; // Date formater
    NSDate *date= [dateformate dateFromString:string];
    return date;
}

@end
