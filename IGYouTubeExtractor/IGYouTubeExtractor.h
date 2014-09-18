//
//  IGYouTubeExtractor.h
//  IGYouTubeExtractor
//
//  Created by Francis Chong.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const IGYouTubeExtractorErrorDomain;

typedef NS_ENUM (NSUInteger, IGYouTubeExtractorAttemptType) {
    IGYouTubeExtractorAttemptTypeEmbedded = 0,
    IGYouTubeExtractorAttemptTypeDetailPage,
    IGYouTubeExtractorAttemptTypeVevo,
    IGYouTubeExtractorAttemptTypeBlank,
    IGYouTubeExtractorAttemptTypeError
};

typedef NS_ENUM (NSUInteger, IGYouTubeExtractorVideoQuality) {
    IGYouTubeExtractorVideoQualityUnknown   = 0,
    IGYouTubeExtractorVideoQualitySmall240  = 36,
	IGYouTubeExtractorVideoQualityMedium360 = 18,
	IGYouTubeExtractorVideoQualityHD720     = 22,
	IGYouTubeExtractorVideoQualityHD1080    = 37,
};

@interface IGYouTubeVideo : NSObject
@property (nonatomic, copy) NSString* title;
@property (nonatomic, strong) NSURL* videoURL;
@property (nonatomic, strong) NSURL* thumbnailURL;
@property (nonatomic, assign) IGYouTubeExtractorVideoQuality quality;
@end

@interface IGYouTubeExtractor : NSObject

+(IGYouTubeExtractor*)sharedInstance;

/**
 * @param videoIdentifier a YouTube video identifier
 * @param completion a block called on completed extraction, with following parameters: 
 *   - [NSArray<IGYouTubeVideo>] videos set of videos object
 *   - [NSError] error the error object, if any error occurred
 */
-(void)extractVideoForIdentifier:(NSString*)videoIdentifier completion:(void (^)(NSArray *videos, NSError *error))completion;

-(NSArray*)preferredVideoQualities;

@end
