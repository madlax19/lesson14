//
//  AudioTableCell.h
//  Lesson14
//
//  Created by elena on 2/27/16.
//  Copyright (c) 2016 Elena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AudioTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressIndicator;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *cellButton;
@property (nonatomic, copy) void (^buttonAction)();

@end
