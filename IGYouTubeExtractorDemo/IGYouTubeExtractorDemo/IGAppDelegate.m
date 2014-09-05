//
//  RMAppDelegate.m
//  RMYouTubeExtractorDemo
//
//  Created by Rune Madsen on 2014-04-26.
//  Copyright (c) 2014 The App Boutique. All rights reserved.
//

#import "IGAppDelegate.h"
#import "IGYouTubeExtractorDemoTableViewController.h"

@implementation IGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    IGYouTubeExtractorDemoTableViewController *youTubeExtractorDemoTableViewController = [[IGYouTubeExtractorDemoTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:youTubeExtractorDemoTableViewController];
    self.window.rootViewController = navigationController;
    
    return YES;
}

@end
