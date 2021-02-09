//
//  UIColor+SAMAddition.h
//  SamosWallet
//
//  Created by zys on 2018/8/20.
//  Copyright © 2018年 zys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (SAMAddition)

/// 16进制颜色值
+ (UIColor *)colorFromHexRGB:(NSString *)colorString;

@end
