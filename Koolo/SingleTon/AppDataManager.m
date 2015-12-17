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


-(void)createEventWithTitle :(NSString*)title atDate:(NSDate*)date  {
    
   
    EKEventStore *eventStore = [[EKEventStore alloc ] init];
    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
    event.title = title;
    event.startDate = date;
    event.endDate = date;
    event.allDay = YES;
    
    EKCalendar *calendar = [eventStore calendarWithIdentifier:[[NSUserDefaults standardUserDefaults] objectForKey:@"Identifier"]];
    //[eventStore defaultCalendarForNewEvents];
    //  NSLog(@"%@ >>>>",[eventStore calendars]);
    [event setCalendar: calendar];
    NSError *err;
    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
    
    if (err == noErr) {
        NSLog(@"Added Successfully");
        NSString* str = [[NSString alloc] initWithFormat:@"%@", event.eventIdentifier];
        //[arrayofEventId addObject:str];
    }
    else{
        
        
    }
    
}


-(void)createLocalCalendar
{
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    //  EKCalendar *calendar = [EKCalendar calendarWithEventStore:eventStore];
    
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


@end
