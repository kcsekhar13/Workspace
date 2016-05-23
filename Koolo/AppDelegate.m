//
//  AppDelegate.m
//  Koolo
//
//  Created by Vinodram on 08/10/15.
//  Copyright (c) 2015 Vinodram. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "PassCodeViewController.h"
#import "AppDataManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    if ([[NSUserDefaults standardUserDefaults]  objectForKey:@"AppInstallDate"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"AppInstallDate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
   
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd"];
    NSString *presentDateString = [dateFormatter stringFromDate:[NSDate date]];
    NSString *previousDateString = @"";
    
    NSDate * previousDate = (NSDate *)[[NSUserDefaults standardUserDefaults]  objectForKey:@"PreviousCalendarDate"];
    
    if (previousDate != nil) {
        previousDateString = [dateFormatter stringFromDate:previousDate];
    }
    
    if( !([presentDateString isEqualToString:previousDateString]) || previousDate == nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"PreviousCalendarDate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)-1] forKey:@"ColorIndex"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)-1] forKey:@"calendarColorIndex"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        

    }
    [self handlePasscodeScreen];
  
    if ([[[NSUserDefaults standardUserDefaults]  objectForKey:@"Quotes"] count] == 0) {
        
        NSMutableArray *quotesArray = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DefaultQuotes.plist" ofType:nil]];
        
//        [quotesArray addObject:@"In the midst of winter, I found there was within me, an invincible summer"];
//        [quotesArray addObject:@"If you’re going through hell, keep going"];
//        [quotesArray addObject:@"If your dreams don’t scare you, they’re not big enough"];
//        [quotesArray addObject:@"The only time you should ever look back is to see how far you’ve come"];
//        [quotesArray addObject:@"Nothing can dim the light which shines from within"];
//        [quotesArray addObject:@"When something bad happens you have three choices. You can let it define you, let it destroy you, or you can let it strengthen you."];
//        [quotesArray addObject:@"People cry, not because they’re weak. It’s because they’ve been strong for too long.” - Johnny Depp."];
//        [quotesArray addObject:@"Those who fly solo have the strongest wings"];
//        [quotesArray addObject:@"The struggle is part of the story"];
//        [quotesArray addObject:@"H.O.P.E. Hold On Pain Ends"];
//        [quotesArray addObject:@"I’m sick and tired of being sick and tired"];
        
        
        
        
        [[NSUserDefaults standardUserDefaults] setObject:quotesArray forKey:@"Quotes"];
        [[NSUserDefaults standardUserDefaults]   setObject:[NSNumber numberWithInt:0] forKey:@"SelectedIndex"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSMutableDictionary *notificationDictionary = [[NSMutableDictionary alloc] init];
    [notificationDictionary setObject:@"Blodprøver i dag" forKey:@"BloodTest"];
    [notificationDictionary setObject:@"Time ced klinikken i dag" forKey:@"Time"];
    [notificationDictionary setObject:@"Siste kur i dag" forKey:@"Last"];
    [[NSUserDefaults standardUserDefaults] setObject:notificationDictionary forKey:@"Notifications"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *quotesString = [[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedQuote"];
    if (!quotesString.length) {
        [[NSUserDefaults standardUserDefaults] setObject:@"In the midst of winter, I found there was within me, an invincible summer" forKey:@"SelectedQuote"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
   

    [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"QuoteSelected"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"colorPickerTitles"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",nil] forKey:@"colorPickerTitles"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    [[AppDataManager sharedInstance] createLocalCalendar];
    return YES;
}

- (void)handlePasscodeScreen {
    UINavigationController *navigationController = nil;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:@"InfoCompleted"]) {
        
        if ([defaults boolForKey:@"isPassCodeOn"] && [[defaults objectForKey:@"Password"] length]) {
            
            self.window.rootViewController = nil;
            PassCodeViewController *passCodeViewController = (PassCodeViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"PasscodeController"];
            [passCodeViewController setMode:2];
            navigationController = [[UINavigationController alloc] initWithRootViewController:passCodeViewController];
            self.window.rootViewController = navigationController;
            
        } else {
            // navigationController = [[UINavigationController alloc] initWithRootViewController:mainStoryboard.instantiateInitialViewController];
            
            self.window.rootViewController = nil;
            ViewController *rootViewController = (ViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"HomeScreen"];
            navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
            self.window.rootViewController = navigationController;
        }
        
        
        
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showQuotes"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self handlePasscodeScreen];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
