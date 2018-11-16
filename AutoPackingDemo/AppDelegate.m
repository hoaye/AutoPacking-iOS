//
//  AppDelegate.m
//  AutoPackingDemo
//
//  Created by stackhou on 2016/4/21.
//  Copyright © 2016年 com.hm. All rights reserved.
//

#import "AppDelegate.h"
#import <Bugly/Bugly.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self _initBugly];

    return YES;
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

#pragma mark - 初始化Bugly
- (void)_initBugly {
    @try{
        // 初始化SDK并设置属性
        BuglyConfig *bugluConfig = [[BuglyConfig alloc] init];
        bugluConfig.channel = @"YJGithub";
        bugluConfig.version = [NSString stringWithFormat:@"%@(%@)", [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"], [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleVersion"]];
        bugluConfig.deviceIdentifier = @"11020101";
        [Bugly startWithAppId:@"bef5c76b98" config:bugluConfig];
        [Bugly setUserValue:@"20110101001" forKey:@"imeiAndIdfa"];
    }@catch(NSException* e) {
    }
}



@end
