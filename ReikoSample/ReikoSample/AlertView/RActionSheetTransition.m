//
//  RActionSheetTransition.m
//  ReikoSample
//
//  Created by 冯振玲 on 2017/2/14.
//  Copyright © 2017年 Reiko. All rights reserved.
//

#import "RActionSheetTransition.h"

@implementation RActionSheetTransition


- (instancetype)init{
    if (self = [super init]) {
        _presentAnimation = [[RActionSheetTransitionPresentAnimation alloc] init];
        _dismissAnimation = [[RActionSheetTransitionDismissAnimation alloc] init];
        
    }
    return self;
}

-(id< UIViewControllerAnimatedTransitioning >)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return _presentAnimation;
}

-(id< UIViewControllerAnimatedTransitioning >)animationControllerForDismissedController:(UIViewController *)dismissed{
    return _dismissAnimation;
    
}

//-(id< UIViewControllerInteractiveTransitioning >)interactionControllerForPresentation:(id < UIViewControllerAnimatedTransitioning >)animator{
//    return nil;
//}
//
//-(id< UIViewControllerInteractiveTransitioning >)interactionControllerForDismissal:(id < UIViewControllerAnimatedTransitioning >)animator{
//    return nil;
//}
@end
