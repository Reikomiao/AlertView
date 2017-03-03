//
//  RActionSheetTransition.h
//  ReikoSample
//
//  Created by 冯振玲 on 2017/2/14.
//  Copyright © 2017年 Reiko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RActionSheetTransitionPresentAnimation.h"
#import "RActionSheetTransitionDismissAnimation.h"

@interface RActionSheetTransition : NSObject<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong)RActionSheetTransitionPresentAnimation *presentAnimation;
@property (nonatomic, strong)RActionSheetTransitionDismissAnimation *dismissAnimation;

@end
