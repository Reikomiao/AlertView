//
//  RViewModel.h
//  ReikoObject
//
//  Created by 冯振玲 on 2017/2/28.
//  Copyright © 2017年 Reiko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RViewModel : NSObject
@property (nonatomic, weak) IBOutlet UIViewController *ownerViewController;
@property (nonatomic, weak) IBOutlet UITextField *usernameTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
- (IBAction)loginAction:(id)sender;
@end
