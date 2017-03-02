//
//  RViewModel.m
//  ReikoObject
//
//  Created by 冯振玲 on 2017/2/28.
//  Copyright © 2017年 Reiko. All rights reserved.
//

#import "RViewModel.h"

@implementation RViewModel
- (IBAction)loginAction:(id)sender{
    if (self.usernameTextField.text.length > 0 && self.passwordTextField.text.length > 0) {
        CFAbsoluteTime time1 = CFAbsoluteTimeGetCurrent();
        printf("time1 = %lf",time1);
        [RViewModel loginWithCompletion:^{
            CFAbsoluteTime time2 = CFAbsoluteTimeGetCurrent();
            printf("time2 - time1 = %lf",time2 - time1);
        }];
        
    }
}
+ (void)loginWithCompletion:(dispatch_block_t)block{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
}

@end
