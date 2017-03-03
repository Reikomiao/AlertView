//
//  RActionSheetTransitionPresentAnimation.m
//  ReikoSample
//
//  Created by 冯振玲 on 2017/2/13.
//  Copyright © 2017年 Reiko. All rights reserved.
//

#import "RActionSheetTransitionPresentAnimation.h"
#import "RActionSheetViewController.h"
#import "AppDelegate.h"

@interface RActionSheetTransitionPresentAnimation ()

@property (weak, nonatomic) UIViewController *fromVC;
@property (weak, nonatomic) UIViewController *toVC;

@end

@implementation RActionSheetTransitionPresentAnimation



- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.6f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    // 1. Get controllers from transition context
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    // 2. Set init frame for toVC
    CGRect finalFrame = CGRectMake((kScreenWidth - RActionSheetViewWidthDefault)/2, kScreenHeight - RActionSheetViewHeightDefault, RActionSheetViewWidthDefault, RActionSheetViewHeightDefault);

    toVC.view.frame = CGRectOffset(finalFrame, 0, kScreenHeight);
    
    // 3. Add toVC's view to containerView
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    // set backgroundImage
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGRect rect = [UIScreen mainScreen].bounds;
    [fromVC.view drawViewHierarchyInRect:rect afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:image];
    backgroundImageView.frame =containerView.frame;
    backgroundImageView.alpha = 0.4;
    [containerView addSubview:backgroundImageView];
    
    
    // 4. Do animate now
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration
                          delay:0.0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         toVC.view.frame = finalFrame;

                     } completion:^(BOOL finished) {
                         // 5. Tell context that we completed.
                         [transitionContext completeTransition:YES];
                         [[UIApplication sharedApplication].keyWindow addSubview:backgroundImageView];
                         [[UIApplication sharedApplication].keyWindow sendSubviewToBack:backgroundImageView];

                     }];
}




@end
