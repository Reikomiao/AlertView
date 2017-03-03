//
//  RActionSheetItem.m
//  ReikoSample
//
//  Created by 冯振玲 on 2017/2/14.
//  Copyright © 2017年 Reiko. All rights reserved.
//

#import "RActionSheetItem.h"

@implementation RActionSheetItem

+ (instancetype)actionSheetItemWithTitle:(NSString *)title image:(UIImage *)image handler:(actionSheetItemAction)handler{

    RActionSheetItem *actionSheet = [[RActionSheetItem alloc] init];
    actionSheet.title = title;
    actionSheet.image = image;
    actionSheet.handler = handler;
    return actionSheet;
    
}

- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}
@end
