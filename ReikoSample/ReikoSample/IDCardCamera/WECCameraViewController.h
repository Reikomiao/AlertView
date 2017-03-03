//
//  WECCameraViewController.h
//  Wecash
//
//  Created by 冯振玲 on 2016/10/26.
//  Copyright © 2016年 Wecash. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(int, IDCardType)
{
    IDCardTypeForFront = 0,//正面
    IDCardTypeForBack,// 反面
    IDCardTypeForHand,// 手持
    
};

@protocol WECCustomViewControllerDelegate <NSObject>
@optional
/**
 * viewController 拍照的vc
 * image 拍摄的图片
 *
**/
- (void)photoCapViewController:(UIViewController *)viewController didFinishDismissWithImage:(UIImage *)image;


@end
@interface WECCameraViewController : UIViewController
// 代理
@property(nonatomic, assign)id <WECCustomViewControllerDelegate> delegate;
// 类型
@property(nonatomic,assign)IDCardType cardType;
// init方法
- (instancetype)initWithDelegate:(id<WECCustomViewControllerDelegate>)delegate IDCardType:(IDCardType)cardType;

@end
