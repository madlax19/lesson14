//
//  ViewController.m
//  Lesson14
//
//  Created by elena on 2/27/16.
//  Copyright (c) 2016 Elena. All rights reserved.
//

#import "ViewController.h"
#import "AudioObject.h"
#import "DownloadObject.h"
#import "AudioTableCell.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <IDMPhotoBrowser/IDMPhotoBrowser.h>

@interface ViewController () <NSURLSessionDelegate, NSURLSessionDownloadDelegate, NSURLSessionTaskDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSArray *audioList;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.HTTPMaximumConnectionsPerHost = 3;
    self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSString *applicationSupportPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"Application Support"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:applicationSupportPath] ) {
        [fileManager createDirectoryAtPath:applicationSupportPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadAudioList];
}

- (void)loadAudioList {
    NSURLSessionDataTask *task = [self.session dataTaskWithURL:[NSURL URLWithString:@"https://itunes.apple.com/search?term=rock&country=US&entity=song"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *jsonError = nil;
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        if (jsonError) {
            NSLog(@"%@", jsonError.localizedDescription);
        } else {
            NSArray *audioObjects = [AudioObject audioObjectsListFromJson:jsonData[@"results"]];
            NSMutableArray *list = [NSMutableArray array];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            for (AudioObject *object in audioObjects) {
                DownloadObject *downloadObject = [[DownloadObject alloc] init];
                downloadObject.audioObject = object;
                
                NSString *destinationUrl = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"Application Support"];
                destinationUrl = [destinationUrl stringByAppendingPathComponent:object.previewURL.lastPathComponent];

                if ([fileManager fileExistsAtPath:destinationUrl]) {
                    downloadObject.progress = 1.0;
                    downloadObject.isDownloaded = YES;
                } else {
                    downloadObject.progress = 0.0;
                    downloadObject.isDownloaded = NO;
                }
                downloadObject.isDownloading = NO;
                
                [list addObject:downloadObject];
            }
            self.audioList = list;
            [self.tableView reloadData];
        }
    }];
    [task resume];
}

#pragma mark - UITableView delegated methods

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.audioList.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AudioTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"audioCell" forIndexPath:indexPath];
    DownloadObject *object = self.audioList[indexPath.row];
    cell.nameLabel.text = object.audioObject.artistName;
    cell.titleLabel.text = object.audioObject.trackName;
    [cell setButtonAction:^{
        [self cellButtonTouched:object];
    }];
    if (object.isDownloaded) {
        [cell.cellButton setTitle:@"Play" forState:UIControlStateNormal];
    } else {
        [cell.cellButton setTitle:@"Download" forState:UIControlStateNormal];
    }
    if (object.isDownloading) {
        cell.progressView.hidden = NO;
        cell.progressLabel.text = [NSString stringWithFormat:@"%d%%", (int)(object.progress * 100.0)];
        [cell.progressIndicator startAnimating];
    } else {
        cell.progressView.hidden = YES;
        cell.progressLabel.text = @"";
        [cell.progressIndicator stopAnimating];
    }
    return cell;
}

- (void)cellButtonTouched: (DownloadObject*) object {
    if (object.isDownloaded) {
        AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] initWithNibName:nil bundle:nil];
        AVPlayer *player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:object.fileUrl]];
        playerViewController.player = player;
        [self presentViewController:playerViewController animated:YES completion:nil];
    } else {
        NSURLSessionDownloadTask *task = [self.session downloadTaskWithURL:[NSURL URLWithString:object.audioObject.previewURL]];
        object.downloadTask = task;
        object.isDownloading = YES;
        object.isDownloaded = NO;
        [task resume];
    }
}

- (DownloadObject*) downloadObjectByTask: (NSURLSessionDownloadTask*) task {
    for (DownloadObject *object in self.audioList) {
        if (object.downloadTask == task) {
            return object;
        }
    }
    return nil;
}

#pragma mark - NSURLSession delegated methods
- (void) URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    DownloadObject *object = [self downloadObjectByTask:downloadTask];
    if (object) {
        object.progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        int row = [self.audioList indexOfObject:object];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    DownloadObject *object = [self downloadObjectByTask:downloadTask];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSString *destinationUrl = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"Application Support"];
    destinationUrl = [destinationUrl stringByAppendingPathComponent:object.audioObject.previewURL.lastPathComponent];
    
    if (![fileManager fileExistsAtPath:destinationUrl]) {
        [fileManager moveItemAtURL:location toURL:[NSURL fileURLWithPath:destinationUrl] error:&error];
    } else {
        [fileManager replaceItemAtURL:[NSURL fileURLWithPath: destinationUrl] withItemAtURL:location
                       backupItemName:object.audioObject.previewURL.lastPathComponent
                              options:NSFileManagerItemReplacementUsingNewMetadataOnly
                     resultingItemURL:NULL
                                error:&error];
    }
    
    if (!error) {
        object.fileUrl = destinationUrl;
        object.isDownloaded = YES;
        object.isDownloading = NO;
        int row = [self.audioList indexOfObject:object];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
    
}


@end
