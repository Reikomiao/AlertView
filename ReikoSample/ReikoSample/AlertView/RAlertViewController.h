//
//  RAlertViewController.h
//  ReikoSample
//
//  Created by 冯振玲 on 2017/2/9.
//  Copyright © 2017年 Reiko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RLabel.h"
#import "RButton.h"
#import "RSubView.h"

@class RAlertViewController;


typedef void(^alertActionHandler)(UIButton *sender);


@interface RAlertViewController : UIViewController
/**
 * 初始化弹框
 *titleString 标题
 *messageString 内容
 *
 **/
+ (instancetype)alertControllerWithTitle:(NSString *)titleString message:(NSString *)messageString;



/**
 *弹框分为三部分，上部，中部，下部。
 *
 **/

// 上部标题
@property (nonatomic, strong)NSString *titleString;

// 上部标题的label
@property (nonatomic, strong)RLabel *titleLable;

// 上部图片
@property (nonatomic, strong)UIImage *titleImage;

// 中部内容 messageString和middleView不能同时设置
@property (nonatomic, strong)NSString *messageString;

// 中部内容的label
@property (nonatomic, strong)RLabel *messageLabel;

// 自定义中部的View 如果设置了middleView，messageString会被覆盖
@property (nonatomic, strong)UIView *middleView;

// 是否点击空白处退出去，默认为NO
@property (nonatomic, assign)BOOL touchBackgroundDismiss;
/**
 * 添加TextField
 **/
- (void)addTextFieldWithHandler:(void (^)(UITextField *textField))handler;

/**
* 添加按钮
* title 按钮的标题
* handler 按钮的点击事件
**/
- (void)addAtionButtonTitle:(NSString *)title Handle:(alertActionHandler)handler;




@end
