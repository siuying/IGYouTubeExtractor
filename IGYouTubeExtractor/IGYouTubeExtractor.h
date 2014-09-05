//
//  RMYouTubeExtractor.h
//  RMYouTubeExtractor
//
//  Created by Rune Madsen on 2014-04-26.
//  Copyright (c) 2014 The App Boutique. All rights reserved.
//

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

@interface IGYouTubeExtractor : NSObject

+(IGYouTubeExtractor*)sharedInstance;

-(void)extractVideoForIdentifier:(NSString*)videoIdentifier completion:(void (^)(NSArray *videos, NSError *error))completion;

-(NSArray*)preferredVideoQualities;

@end
