//
//  AppDataManager.h
//  Koolo
//
//  Created by Hamsini on 22/10/15.
//  Copyright (c) 2015 Vinodram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface AppDataManager : NSObject

+(AppDataManager *)sharedInstance;
-(void)createEventWithDetails :(NSDictionary*)detailsDict;
-(void)createLocalCalendar;
@end
