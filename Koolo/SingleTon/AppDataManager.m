//
//  AppDataManager.m
//  Koolo
//
//  Created by Hamsini on 22/10/15.
//  Copyright (c) 2015 Vinodram. All rights reserved.
//

#import "AppDataManager.h"

@implementation AppDataManager

static AppDataManager *sharedInstance = nil;

+ (id)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
    }
    return self;
}


-(void)createEventWithDetails :(NSDictionary*)detailsDict {
    
    EKEventStore *eventStore = [[EKEventStore alloc ] init];
    EKCalendar *calendar = [eventStore calendarWithIdentifier:[[NSUserDefaults standardUserDefaults] objectForKey:@"Identifier"]];
    
    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
    NSDate *date = [detailsDict objectForKey:@"EventDate"];
    event.title = [detailsDict objectForKey:@"EventTitle"];
    event.startDate = date;
    event.endDate = [date dateByAddingTimeInterval:1800];
    
    if ([[detailsDict objectForKey:@"RemainderFlag"] boolValue]) {
        
        EKAlarm *alaram = [[EKAlarm alloc]init];
        [alaram setRelativeOffset:0];
        [event addAlarm:alaram];
    }
    
    
        [event addRecurrenceRule:[[EKRecurrenceRule alloc] initRecurrenceWithFrequency:[self getRemainderFrequency:[detailsDict objectForKey:@"Remainder"]] interval:1 end:nil]];
        [event setCalendar: calendar];
        NSError *err;
        [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
        if (err == noErr) {
            NSLog(@"Added Successfully");
            //NSString* str = [[NSString alloc] initWithFormat:@"%@", event.eventIdentifier];
            //[arrayofEventId addObject:str];
            [self addEventToFile:detailsDict];
        }
        else{
            
            
            
        }
   
    
    
    //[eventStore defaultCalendarForNewEvents];
    //  NSLog(@"%@ >>>>",[eventStore calendars]);
  
    
    
    
}


-(EKRecurrenceFrequency)getRemainderFrequency:(NSString*)event
{
    
    if ([event isEqualToString:@"Daily"]) {
        
        return EKRecurrenceFrequencyDaily;
    }
    else if ([event isEqualToString:@"Weekly"]){
        
        return EKRecurrenceFrequencyWeekly;
        
    }
    else if ([event isEqualToString:@"Monthly"]){
        
        return EKRecurrenceFrequencyMonthly;
    }
    else if ([event isEqualToString:@"Yearly"]){
        
        return EKRecurrenceFrequencyYearly;
    }
    return nil;
}

-(void)createLocalCalendar
{
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    //  EKCalendar *calendar = [EKCalendar calendarWithEventStore:eventStore];
    
    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        // iOS 6 and later
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (granted) {
                // code here for when the user allows your app to access the calendar
                [self performCalendarActivity:eventStore];
            } else {
                // code here for when the user does NOT allow your app to access the calendar
            }
        }];
    } else {
        // code here for iOS < 6.0
        [self performCalendarActivity:eventStore];
    }
    
    
}


-(void)performCalendarActivity:(EKEventStore*)eventStore
{
    
    EKCalendar *calendar = [eventStore calendarWithIdentifier:[[NSUserDefaults standardUserDefaults] objectForKey:@"Identifier"]];
    
    if (calendar != nil) {
        
        NSLog(@"Calender Already Available");
        return;
    }
    
    calendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:eventStore];
    calendar.title = @"KOOLO CALENDAR";
    // Iterate over all sources in the event store and look for the local source
    EKSource *theSource = nil;
    NSLog(@"%@ >>>>",eventStore.sources);
    for (EKSource *source in eventStore.sources) {
        if (source.sourceType == EKSourceTypeLocal) {
            theSource = source;
            break;
        }
    }
    if (theSource) {
        calendar.source = theSource;
    } else {
        NSLog(@"Error: Local source not available");
        return;
    }
    
    NSError *error = nil;
    BOOL result = [eventStore saveCalendar:calendar commit:YES error:&error];
    if (result) {
        NSLog(@"Saved calendar to event store.");
        [[NSUserDefaults standardUserDefaults] setObject:calendar.calendarIdentifier forKey:@"Identifier"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    } else {
        NSLog(@"Error saving calendar: %@.", error);
    }
}


-(void)getEventsForDate:(NSDate*)selectedDate
{
    
    NSDate* startDate = selectedDate;//start from today
    NSDate* endDate =  [NSDate dateWithTimeIntervalSinceNow:[[NSDate distantFuture] timeIntervalSinceReferenceDate]];//no end
    NSLog(@"S Date %@", startDate);
    NSLog(@"E Date %@", endDate);
    
    NSString *AppointmentTitle=@"Appointment in Hospital at Pediatric Clinic";
    
    EKEventStore *store = [[EKEventStore alloc] init];
    //NSArray *calendarArray = [store calendarsForEntityType:EKEntityTypeEvent];
    EKCalendar *calendar = [store calendarWithIdentifier:[[NSUserDefaults standardUserDefaults] objectForKey:@"Identifier"]];

    NSPredicate *fetchCalendarEvents = [store predicateForEventsWithStartDate:startDate endDate:endDate calendars:[NSArray arrayWithObjects:calendar, nil]];
    NSArray *eventList = [store eventsMatchingPredicate:fetchCalendarEvents];
    BOOL IsFound;
    int EventsCount=(int)eventList.count;
    for(int i=0; i < EventsCount; i++)
    {
        NSLog(@"Event Title:%@", [[eventList objectAtIndex:i] title]);
        if ([[[eventList objectAtIndex:i] title] isEqualToString:AppointmentTitle])//check title
        {
            IsFound=TRUE;
            break;
        }
        else
        {
            IsFound=FALSE;
        }
    }
    
}

-(NSString *)getEventsFilePath
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePathAndDirectory = [documentsDirectory stringByAppendingPathComponent:@"EventsList.plist"];
    
    return filePathAndDirectory;
}


-(NSDictionary*)getAllEvents
{
    
    NSString *eventsFilePath =[self getEventsFilePath];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:eventsFilePath];
    return dict;
}

-(void)addEventToFile:(NSDictionary*)event
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[self getAllEvents]];
    
    if (dict == nil) {
        dict = [[NSMutableDictionary alloc] init];
    }

    NSDate *date = [event objectForKey:@"EventDate"];
    NSString *dateKeyString = [self getStringFromDate:date];

    
    NSMutableArray *array = [dict objectForKey:dateKeyString];
    
    if (array == nil) {
        
        array = [[NSMutableArray alloc] init];
    
    }
    [array addObject:event];
    [dict setObject:array forKey:dateKeyString];
    [dict writeToFile:[self getEventsFilePath] atomically:YES];
    
    
    
}

-(NSString*)getStringFromDate:(NSDate*)date
{
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"dd-MM-yyyy"]; // Date formater
    NSString *dateString = [dateformate stringFromDate:date]; // Convert date to string
    //NSLog(@"date :%@",dateString);
    return dateString;
}

-(NSArray*)getEventsForSelectedDate:(NSDate*)date
{
    
    NSString *keyString = [self getStringFromDate:date];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[self getAllEvents]];
    
    if (dict == nil) {
        dict = [[NSMutableDictionary alloc] init];
    }
    
    NSArray *array = [dict objectForKey:keyString];
    
    return array;
    
    
}


@end
