//
//  AudioObject.m
//  Lesson14
//
//  Created by elena on 2/27/16.
//  Copyright (c) 2016 Elena. All rights reserved.
//

#import "AudioObject.h"

@interface AudioObject()

@property (nonatomic, readwrite) NSNumber *audioId;
@property (nonatomic, readwrite) NSString *artistName;
@property (nonatomic, readwrite) NSString *trackName;
@property (nonatomic, readwrite) NSString *previewURL;

@end

@implementation AudioObject

+ (NSArray*)audioObjectsListFromJson: (NSArray*) jsonArray {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in jsonArray) {
        AudioObject *object = [[AudioObject alloc] init];
        object.audioId = dict[@"trackId"];
        object.artistName = dict[@"artistName"];
        object.trackName = dict[@"trackName"];
        object.previewURL = dict[@"previewUrl"];
        [result addObject:object];
    }
    
    return result;
}

@end
