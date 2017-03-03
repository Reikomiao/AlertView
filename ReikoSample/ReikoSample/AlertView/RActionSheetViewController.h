//
//  RActionSheetViewController.h
//  ReikoSample
//
//  Created by 冯振玲 on 2017/2/13.
//  Copyright © 2017年 Reiko. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RActionSheetItem;

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define RActionSheetViewWidthDefault kScreenWidth * 0.9
static const CGFloat RActionSheetViewHeightDefault = 300;

@interface RActionSheetViewController : UIViewController
- (instancetype)initWithTitle:(NSString *)title Message:(NSString *)message Items:(NSArray <RActionSheetItem *>*)items;


@end
