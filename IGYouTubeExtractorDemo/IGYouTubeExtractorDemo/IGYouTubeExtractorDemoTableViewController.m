//
//  RMYouTubeExtractorDemoTableViewController.m
//  RMYouTubeExtractorDemo
//
//  Created by Rune Madsen on 2014-04-26.
//  Copyright (c) 2014 The App Boutique. All rights reserved.
//

#import "IGYouTubeExtractorDemoTableViewController.h"
#import "IGYouTubeExtractor.h"
#import "IGYouTubeVideo.h"

@import MediaPlayer;

@interface IGYouTubeExtractorDemoTableViewController ()

@property (nonatomic, strong) NSArray *videoArray;
@property (nonatomic, strong) MPMoviePlayerController *moviePlayerController;

@end

@implementation IGYouTubeExtractorDemoTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

static NSString *CellIdentifier = @"CellIdentifier";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"RMYouTubeExtractor Demo"];
    
    self.moviePlayerController = [[MPMoviePlayerController alloc] init];
    [self.moviePlayerController.view setFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), ((CGRectGetWidth(self.tableView.frame) / 16) * 9))];
    self.moviePlayerController.movieSourceType = MPMovieSourceTypeFile;
    [self.moviePlayerController setAllowsAirPlay:YES];
    [self.tableView setTableHeaderView:self.moviePlayerController.view];
    
    self.videoArray = [[NSArray alloc] init];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    [[IGYouTubeExtractor sharedInstance] extractVideoForIdentifier:@"MVt32qoyhi0"
                                                        completion:^(NSArray *videos, NSError *error) {
                                                            if (!error) {
                                                                self.videoArray = [videos copy];
                                                                [self.tableView reloadData];
                                                            } else {
                                                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An Error Occurred"
                                                                                                                    message:[error localizedFailureReason]
                                                                                                                   delegate:nil
                                                                                                          cancelButtonTitle:nil
                                                                                                          otherButtonTitles:@"OK", nil];
                                                                [alertView show];
                                                            }
                                                        }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.videoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    IGYouTubeVideo* video = self.videoArray[indexPath.row];
    [cell.textLabel setText:[self qualityStringForQuality:video.quality]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    IGYouTubeVideo* video = self.videoArray[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.moviePlayerController setContentURL:video.videoURL];
    [self.moviePlayerController play];
}

-(NSString*)qualityStringForQuality:(IGYouTubeExtractorVideoQuality)quality {
    switch (quality) {
        case IGYouTubeExtractorVideoQualitySmall240:
            return @"Small 240p";
            break;
        case IGYouTubeExtractorVideoQualityMedium360:
            return @"Medium 360p";
            break;
        case IGYouTubeExtractorVideoQualityHD720:
            return @"HD 720p";
            break;
        case IGYouTubeExtractorVideoQualityHD1080:
            return @"HD 1080p";
            break;
        default:
            return @"Unknown";
            break;
    }
}

@end
