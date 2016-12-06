//
//  AppDelegate.m
//  LockUnLockApp
//
//  Created by StarMac on 12/6/16.
//  Copyright © 2016 Minao. All rights reserved.
//

#import "AppDelegate.h"
#import <notify.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    int notify_token;
    notify_register_dispatch("com.apple.springboard.lockstate",
                             &notify_token,
                             dispatch_get_main_queue(),
                             ^(int token)
                             {
                                 uint64_t state = UINT64_MAX;
                                 notify_get_state(token, &state);
                                 if(state == 0) {
                                     [self showAlertUnlock];
                                 } else {
                                     [self sendPushClockScreen];
                                 }
                             }
                             );
    return YES;
}

- (void)showAlertUnlock
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Screen is unlocked" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self.window.rootViewController  presentViewController:alertController animated:YES completion:nil];
}
- (void)sendPushClockScreen
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
     notification.soundName = UILocalNotificationDefaultSoundName;
    notification.fireDate = [[NSDate date] dateByAddingTimeInterval:1];
    notification.alertBody = @"Screen is locked";
   
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
