//
//  IGYouTubeVideo.h
//  IGYouTubeExtractorDemo
//
//  Created by Francis Chong on 5/9/14.
//  Copyright (c) 2014 The App Boutique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IGYouTubeExtractor.h"

@interface IGYouTubeVideo : NSObject

@property (nonatomic, copy) NSString* title;
@property (nonatomic, strong) NSURL* videoURL;
@property (nonatomic, strong) NSURL* thumbnailURL;
@property (nonatomic, assign) IGYouTubeExtractorVideoQuality quality;

@end
