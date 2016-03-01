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
        sharedInstance.index = 0;
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
    }
    return self;
}


-(void)createEventWithDetails :(NSMutableDictionary*)detailsDict withRemainderType:(NSString *)remainderType {
    
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
            NSString* str = [[NSString alloc] initWithFormat:@"%@", event.eventIdentifier];
            //[arrayofEventId addObject:str];
            [detailsDict setObject:str forKey:@"EventId"];
            
            if ([[detailsDict objectForKey:@"Remainder"] isEqualToString:@"Daily"] || [[detailsDict objectForKey:@"Remainder"] isEqualToString:@"Daglig"]) {
                
                NSDate *presentDate = [detailsDict objectForKey:@"EventDate"];
                
                [self addEventToFile:detailsDict];
                
                for (int i = 0; i < 219; i++) {
                    
                    NSDate *nextDay = [presentDate dateByAddingTimeInterval:60*60*24*1];
                    presentDate = nextDay;
                    [detailsDict setObject:presentDate forKey:@"EventDate"];
                    [self addEventToFile:detailsDict];
                    
                }
                
                
            } else if ([[detailsDict objectForKey:@"Remainder"] isEqualToString:@"Weekly"] || [[detailsDict objectForKey:@"Remainder"] isEqualToString:@"Ukentlig"]) {
                
                NSCalendar *calendar = [NSCalendar currentCalendar];
                //declare your unitFlags
                int unitFlags = NSCalendarUnitWeekOfMonth;
                
                NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:self.datesArray[0]  toDate:[self.datesArray lastObject] options:0];
                
                long weeksInBetween = [dateComponents weekOfMonth];
                
                NSDate *presentDate = [detailsDict objectForKey:@"EventDate"];
                
                [self addEventToFile:detailsDict];
                
                for (int i = 0; i < weeksInBetween; i++) {
                    
                    NSDate *nextWeek = [presentDate dateByAddingTimeInterval:60*60*24*7];
                    presentDate = nextWeek;
                    [detailsDict setObject:presentDate forKey:@"EventDate"];
                    [self addEventToFile:detailsDict];
                    
                }
                
                
                
            } else if ([[detailsDict objectForKey:@"Remainder"] isEqualToString:@"Monthly"] || [[detailsDict objectForKey:@"Remainder"] isEqualToString:@"Månedlig"]) {
                
                NSDate *presentDate = [detailsDict objectForKey:@"EventDate"];
                [self addEventToFile:detailsDict];
                NSCalendar *cal = [NSCalendar currentCalendar];
                for (int i = 0; i < 6; i++) {
                    NSDate *someDate = [cal dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:presentDate options:0];
                    presentDate = someDate;
                    [detailsDict setObject:presentDate forKey:@"EventDate"];
                    [self addEventToFile:detailsDict];
                }
                
            } else {
                
                NSDate *presentDate = [detailsDict objectForKey:@"EventDate"];
                [self addEventToFile:detailsDict];
                NSCalendar *cal = [NSCalendar currentCalendar];
                for (int i = 0; i < 6; i++) {
                    NSDate *someDate = [cal dateByAddingUnit:NSCalendarUnitYear value:1 toDate:presentDate options:0];
                    presentDate = someDate;
                    [detailsDict setObject:presentDate forKey:@"EventDate"];
                    [self addEventToFile:detailsDict];
                }
                
            }
            
           
            
            
            //[self addEventToFile:detailsDict];
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
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[dict objectForKey:dateKeyString]];
    
    if (array == nil) {
        
        array = [[NSMutableArray alloc] init];
    
    }
    [array addObject:event];
    [dict setObject:array forKey:dateKeyString];
    [dict writeToFile:[self getEventsFilePath] atomically:YES];

}

- (void)datesArray:(NSArray *)array {
    
    if (self.datesArray.count) {
        [self.datesArray removeAllObjects];
        self.datesArray = nil;
    }
    self.datesArray = [NSMutableArray arrayWithArray:array];
    //[self addEventsWeeklyWise];
}

-(void)addEventsWeeklyWise {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //declare your unitFlags
    int unitFlags = NSCalendarUnitWeekOfMonth;
    
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:self.datesArray[0]  toDate:[self.datesArray lastObject] options:0];
    
    long weeksInBetween = [dateComponents weekOfMonth];
    
    NSDate *presentDate = [NSDate date];
    
    for (int i = 0; i < weeksInBetween; i++) {
        
        NSDate *nextWeek = [presentDate dateByAddingTimeInterval:60*60*24*7];
        presentDate = nextWeek;
        
    }
}

-(void)deleteAndSaveEventForDate:(NSDate*)date eventsArray:(NSArray*)eventsArray eventId:(NSString *)eventID
{
    
    EKEventStore* store = [[EKEventStore alloc] init];
    EKEvent* eventToRemove = [store eventWithIdentifier:eventID];
    if (eventToRemove != nil) {
        NSError* error = nil;
        [store removeEvent:eventToRemove span:EKSpanThisEvent error:&error];
    }
     NSString *dateKeyString = [self getStringFromDate:date];
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[self getAllEvents]];
    [dict setObject:eventsArray forKey:dateKeyString];
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

-(NSMutableArray*)getEventsForSelectedDate:(NSDate*)date
{
    
    NSString *keyString = [self getStringFromDate:date];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[self getAllEvents]];
    
    if (dict == nil) {
        dict = [[NSMutableDictionary alloc] init];
    }
    
    NSMutableArray *array = [dict objectForKey:keyString];
    
    return array;
    
    
}

-(NSString*)getTimeFromString:(NSDate*)dateString
{
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"hh:mm:SS a"]; // Date formater
    
    NSString *string = [dateformate stringFromDate:dateString]; // Convert date to string
    NSLog(@"date :%@",string);
    return string;
}

-(void)updateSelectedDict
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[self getAllEvents]];
    
    if (dict == nil) {
        dict = [[NSMutableDictionary alloc] init];
    }
    
    NSDate *date = [self.selectedDict objectForKey:@"EventDate"];
    NSString *dateKeyString = [self getStringFromDate:date];
    
    NSMutableArray *array = [dict objectForKey:dateKeyString];
    
    if (array == nil) {
        
        array = [[NSMutableArray alloc] init];
        
    }
    [array replaceObjectAtIndex:self.index withObject:self.selectedDict];
    [dict setObject:array forKey:dateKeyString];
    [dict writeToFile:[self getEventsFilePath] atomically:YES];
    
}
@end
