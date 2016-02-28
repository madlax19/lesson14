//
//  DownloadObject.h
//  Lesson14
//
//  Created by elena on 2/27/16.
//  Copyright (c) 2016 Elena. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AudioObject;

@interface DownloadObject : NSObject

@property (nonatomic, strong) AudioObject *audioObject;
@property (nonatomic, strong) NSString *fileUrl;
@property (nonatomic) float progress;
@property (nonatomic) BOOL isDownloading;
@property (nonatomic) BOOL isDownloaded;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

@end
