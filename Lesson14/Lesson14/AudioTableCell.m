//
//  AudioTableCell.m
//  Lesson14
//
//  Created by elena on 2/27/16.
//  Copyright (c) 2016 Elena. All rights reserved.
//

#import "AudioTableCell.h"

@implementation AudioTableCell

- (IBAction)buttonTouch:(id)sender {
    if (self.buttonAction) {
        self.buttonAction();
    }
}

@end
