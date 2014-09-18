//
//  IGYouTubeExtractor.m
//  IGYouTubeExtractor
//
//  Created by Francis Chong.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//
//  Included source code from Rune Madsen on 2014-04-26.
//  Copyright (c) 2014 The App Boutique. All rights reserved.
//
//  Extraction code inspired by XCDYouTubeVideoPlayerViewController
//  https://github.com/0xced/XCDYouTubeVideoPlayerViewController
//  by Cédric Luthi

#import "IGYouTubeExtractor.h"

@import AVFoundation;

NSString* const IGYouTubeExtractorErrorDomain = @"IGYouTubeExtractor";

@implementation IGYouTubeVideo

-(NSString*) description
{
    return [NSString stringWithFormat:@"<IGYouTubeVideo title=%@, URL=%@>", self.title, self.videoURL];
}
@end

@interface IGYouTubeExtractor ()

@property (nonatomic, assign) IGYouTubeExtractorAttemptType attemptType;

@end

static NSDictionary *DictionaryWithQueryString(NSString *string, NSStringEncoding encoding) {
	NSMutableDictionary *dictionary = [NSMutableDictionary new];
	NSArray *fields = [string componentsSeparatedByString:@"&"];
	for (NSString *field in fields) {
		NSArray *pair = [field componentsSeparatedByString:@"="];
		if ([pair count] == 2) {
			NSString *key = pair[0];
			NSString *value = [pair[1] stringByReplacingPercentEscapesUsingEncoding:encoding];
			value = [value stringByReplacingOccurrencesOfString:@"+" withString:@" "];
			dictionary[key] = value;
		}
	}
	return dictionary;
}

static NSString *ApplicationLanguageIdentifier(void)
{
	static NSString *applicationLanguageIdentifier;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		applicationLanguageIdentifier = @"en";
		NSArray *preferredLocalizations = [[NSBundle mainBundle] preferredLocalizations];
		if (preferredLocalizations.count > 0)
			applicationLanguageIdentifier = [NSLocale canonicalLanguageIdentifierFromString:preferredLocalizations[0]] ?: applicationLanguageIdentifier;
	});
	return applicationLanguageIdentifier;
}

@implementation IGYouTubeExtractor

+ (IGYouTubeExtractor *)sharedInstance {
    static IGYouTubeExtractor *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [IGYouTubeExtractor new];
    });
    return _sharedInstance;
}

-(NSArray*)preferredVideoQualities {
    return @[ @(IGYouTubeExtractorVideoQualityHD1080), // unfortunately it doesn't look like 1080p is available and will most likely always return null
              @(IGYouTubeExtractorVideoQualityHD720),
              @(IGYouTubeExtractorVideoQualityMedium360),
              @(IGYouTubeExtractorVideoQualitySmall240) ];
}

-(void)extractVideoForIdentifier:(NSString*)videoIdentifier completion:(void (^)(NSArray *videos, NSError *error))completion {
    if (videoIdentifier && [videoIdentifier length] > 0) {
        if (self.attemptType == IGYouTubeExtractorAttemptTypeError) {
            NSError *error = [NSError errorWithDomain:IGYouTubeExtractorErrorDomain code:404 userInfo:@{ NSLocalizedFailureReasonErrorKey : @"Unable to find playable content" }];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
            });
            self.attemptType = IGYouTubeExtractorAttemptTypeEmbedded;
            return;
        }
        NSMutableDictionary *parameters = [@{} mutableCopy];
        switch (self.attemptType) {
            case IGYouTubeExtractorAttemptTypeEmbedded:
                parameters[@"el"] = @"embedded";
                break;
            case IGYouTubeExtractorAttemptTypeDetailPage:
                parameters[@"el"] = @"detailpage";
                break;
            case IGYouTubeExtractorAttemptTypeVevo:
                parameters[@"el"] = @"vevo";
                break;
            case IGYouTubeExtractorAttemptTypeBlank:
                parameters[@"el"] = @"";
                break;
            default:
                break;
        }
        parameters[@"video_id"] = videoIdentifier;
        parameters[@"ps"] = @"default";
        parameters[@"eurl"] = @"";
        parameters[@"gl"] = @"US";
        parameters[@"hl"] = ApplicationLanguageIdentifier();
        
        NSString *urlString = [self addQueryStringToUrlString:@"https://www.youtube.com/get_video_info" withParamters:parameters];
        
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithURL:[NSURL URLWithString:urlString]
               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                   if (!error) {
                       NSString *videoQuery = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                       NSStringEncoding queryEncoding = NSUTF8StringEncoding;
                       NSDictionary *video = DictionaryWithQueryString(videoQuery, queryEncoding);
                       NSString* title = video[@"title"];
                       NSString* thumbnailURLString =  video[@"irul"] ?: video[@"irulhq"] ?: video[@"iurlmq"] ?: video[@"iurlsq"];
                       NSURL* thumbnailURL = [NSURL URLWithString:thumbnailURLString];

                       NSMutableArray *streamQueries = [[video[@"url_encoded_fmt_stream_map"] componentsSeparatedByString:@","] mutableCopy];
                       [streamQueries addObjectsFromArray:[video[@"adaptive_fmts"] componentsSeparatedByString:@","]];
                       
                       NSMutableDictionary *streamVideos = [NSMutableDictionary new];
                       for (NSString *streamQuery in streamQueries) {
                           NSDictionary *stream = DictionaryWithQueryString(streamQuery, queryEncoding);
                           NSString *type = stream[@"type"];
                           NSString *urlString = stream[@"url"];
                           if (urlString && [AVURLAsset isPlayableExtendedMIMEType:type]) {
                               NSURL *streamURL = [NSURL URLWithString:urlString];
                               NSString *signature = stream[@"sig"];
                               if (signature) {
                                   streamURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@&signature=%@", urlString, signature]];
                               }
                               if ([[DictionaryWithQueryString(streamURL.query, queryEncoding) allKeys] containsObject:@"signature"]) {
                                   IGYouTubeVideo* video = [IGYouTubeVideo new];
                                   video.videoURL = streamURL;
                                   video.thumbnailURL = thumbnailURL;
                                   video.quality = stream[@"itag"] ? [stream[@"itag"] integerValue] : IGYouTubeExtractorVideoQualityUnknown;
                                   video.title = title;
                                   streamVideos[@([stream[@"itag"] integerValue])] = video;
                               }
                           }
                       }
                       
                       BOOL contentIsAvailable = NO;
                       
                       NSMutableArray* videos = [NSMutableArray array];
                       for (NSNumber *videoQuality in [self preferredVideoQualities]) {
                           IGYouTubeVideo *video = streamVideos[videoQuality];
                           NSURL *streamURL = video.videoURL;
                           if (streamURL) {
                               [videos addObject:video];
                               contentIsAvailable = YES;
                           }
                       }
                       
                       self.attemptType++;
                       
                       if (!contentIsAvailable) {
                           [self extractVideoForIdentifier:videoIdentifier completion:completion];
                       } else {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               completion(videos, nil);
                           });
                       }
                       
                   } else {
                       dispatch_async(dispatch_get_main_queue(), ^{
                           completion(nil, error);
                       });
                   }
               }
         ] resume];
    } else {
        NSError *error = [NSError errorWithDomain:IGYouTubeExtractorErrorDomain code:400 userInfo:@{ NSLocalizedFailureReasonErrorKey : @"Invalid or missing YouTube video identifier" }];
        completion(nil, error);
    }
}

- (NSString*)urlEscapeString:(NSString *)unencodedString {
    CFStringRef originalStringRef = (__bridge_retained CFStringRef)unencodedString;
    NSString *string = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,originalStringRef, NULL, NULL,kCFStringEncodingUTF8);
    CFRelease(originalStringRef);
    return string;
}


- (NSString*)addQueryStringToUrlString:(NSString *)urlString withParamters:(NSDictionary *)dictionary {
    NSMutableString *urlWithQuerystring = [[NSMutableString alloc] initWithString:urlString];
    for (id key in dictionary) {
        NSString *keyString = [key description];
        NSString *valueString = [[dictionary objectForKey:key] description];
        
        if ([urlWithQuerystring rangeOfString:@"?"].location == NSNotFound) {
            [urlWithQuerystring appendFormat:@"?%@=%@", [self urlEscapeString:keyString], [self urlEscapeString:valueString]];
        } else {
            [urlWithQuerystring appendFormat:@"&%@=%@", [self urlEscapeString:keyString], [self urlEscapeString:valueString]];
        }
    }
    return urlWithQuerystring;
}

@end
