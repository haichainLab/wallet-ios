//
//  SAMDeviceInfo.m
//  XB
//
//  Created by zys on 2017/8/23.
//  Copyright © 2017年 zys. All rights reserved.
//

#import "SAMDeviceInfo.h"

@implementation SAMDeviceInfo

#pragma mark - public methods

+ (BOOL)isiPhoneXSeries {
    BOOL flag = NO;
    if ([UIScreen instanceMethodForSelector:@selector(currentMode)]) {
        if (CGSizeEqualToSize(CGSizeMake(1125.f, 2436.f), [UIScreen mainScreen].currentMode.size)
            || CGSizeEqualToSize(CGSizeMake(750.f, 1624.f), [UIScreen mainScreen].currentMode.size)
            || CGSizeEqualToSize(CGSizeMake(828.f, 1792.f), [UIScreen mainScreen].currentMode.size)) {
            flag = YES;
        }
    }
    
    return flag;
}

@end
