//
//  AppDelegate.m
//  IGYoutTubeExtractorMacDemo
//
//  Created by Francis Chong on 18/9/14.
//  Copyright (c) 2014 The App Boutique. All rights reserved.
//

#import "AppDelegate.h"
#import "IGYouTubeExtractor.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    IGYouTubeExtractor *youTubeExtractor = [IGYouTubeExtractor sharedInstance];
    [youTubeExtractor extractVideoForIdentifier:@"MVt32qoyhi0" completion:^(NSArray *videos, NSError *error) {
        if (!error) {
            NSLog(@"succeed: %@", videos);
        } else {
            NSLog(@"failed: %@", error);
        }
    }];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
