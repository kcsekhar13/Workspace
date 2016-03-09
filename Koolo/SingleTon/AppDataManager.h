//
//  AppDataManager.h
//  Koolo
//
//  Created by Hamsini on 22/10/15.
//  Copyright (c) 2015 Vinodram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@class StoreDataMangager;
@interface AppDataManager : NSObject

@property(nonatomic,strong)NSMutableDictionary *selectedDict;
@property(nonatomic,strong)NSMutableArray *datesArray;
@property(nonatomic)int index;
+(AppDataManager *)sharedInstance;
-(BOOL)createEventWithDetails :(NSMutableDictionary*)detailsDict withRemainderType:(NSString *)remainderType;
-(void)createLocalCalendar;
-(void)getEventsForDate:(NSDate*)selectedDate;
-(NSMutableArray*)getEventsForSelectedDate:(NSDate*)date;
-(NSString*)getTimeFromString:(NSString*)dateString;
-(void)updateSelectedDict;
-(void)deleteAndSaveEventForDate:(NSDate*)date eventsArray:(NSArray*)eventsArray eventId:(NSString *)eventID;
-(void)datesArray:(NSArray *)array;
@end
