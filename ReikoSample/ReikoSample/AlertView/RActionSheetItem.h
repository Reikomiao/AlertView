//
//  RActionSheetItem.h
//  ReikoSample
//
//  Created by 冯振玲 on 2017/2/14.
//  Copyright © 2017年 Reiko. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^actionSheetItemAction)();

@interface RActionSheetItem : NSObject
/**
* 每个按钮的设置
*title 标题
*image 图片
*handler 点击事件
**/
+ (instancetype)actionSheetItemWithTitle:(NSString *)title image:(UIImage *)image handler:(actionSheetItemAction)handler;

@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)UIImage *image;
@property (nonatomic, copy)actionSheetItemAction handler;

@end
