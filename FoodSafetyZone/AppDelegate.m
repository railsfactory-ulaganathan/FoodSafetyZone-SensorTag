//
//  AppDelegate.m
//  FoodSafetyZone
//
//  Created by railsfactory on 15/07/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "DBManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString *path=[DBManager createEditableCopyOfDatabaseIfNeeded];
    
    dbManager = [DBManager sharedInstance];
    
    dbManager.fmDatabase = [FMDatabase databaseWithPath:path];
    NSLog(@"%@",path);
    // NSLog(path);;
    if (![dbManager.fmDatabase open]) {
        NSLog(@"Could not open db.");
    }

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    application.applicationIconBadgeNumber = 0;
    
    // Detect the Notification after a user taps it
    UILocalNotification *localNotif =
    [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif)
    {
        NSLog(@"Recieved Notification %@",localNotif);
    }
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {    // The iOS device = iPhone or iPod Touch
        
        
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        
        if (iOSDeviceScreenSize.height == 480)
        {
            LoginViewController *login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:login];
        }
        if (iOSDeviceScreenSize.height == 568)
        {
            LoginViewController *login = [[LoginViewController alloc]initWithNibName:@"LoginViewController5" bundle:nil];
            self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:login];
        }
    }
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"header-bg-1.png"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                UITextAttributeTextColor: [UIColor whiteColor],
                          UITextAttributeTextShadowColor: [UIColor darkGrayColor],
                         UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)],
                                     UITextAttributeFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f]
     }];
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    if(getenv("NSZombieEnabled") || getenv("NSAutoreleaseFreedObjectCheckEnabled"))
        NSLog(@"NSZombieEnabled/NSAutoreleaseFreedObjectCheckEnabled enabled!");
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    UIApplication* app = [UIApplication sharedApplication];
    NSArray *notifications = [app scheduledLocalNotifications];
    if ([notifications count] > 0)
        [app presentLocalNotificationNow:notifications[0]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;

}
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidFinishLaunching:(UIApplication *)application
{

}

- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif
{
	// Handle the notification when the app is running
	NSLog(@"Recieved Notification %@",notif);
}


@end
