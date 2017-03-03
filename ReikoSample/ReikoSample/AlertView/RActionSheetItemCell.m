//
//  RActionSheetItemCell.m
//  ReikoSample
//
//  Created by 冯振玲 on 2017/3/1.
//  Copyright © 2017年 Reiko. All rights reserved.
//

#import "RActionSheetItemCell.h"

@implementation RActionSheetItemCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetWidth(frame))];
        [self.contentView addSubview:self.itemImageView];
        
        self.itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.itemImageView.frame), CGRectGetWidth(self.itemImageView.frame), CGRectGetHeight(frame) - CGRectGetHeight(self.itemImageView.frame))];
        self.itemLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.itemLabel];
    }
    return self;
}

@end
