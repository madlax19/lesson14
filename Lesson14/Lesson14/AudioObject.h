//
//  AudioObject.h
//  Lesson14
//
//  Created by elena on 2/27/16.
//  Copyright (c) 2016 Elena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioObject : NSObject

+ (NSArray*)audioObjectsListFromJson: (NSArray*) jsonArray;

@property (nonatomic, readonly) NSNumber *audioId;
@property (nonatomic, readonly) NSString *artistName;
@property (nonatomic, readonly) NSString *trackName;
@property (nonatomic, readonly) NSString *previewURL;

@end
