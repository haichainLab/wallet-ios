//
//  SAMWalletInfo.m
//  SamosWallet
//
//  Created by zys on 2018/11/10.
//  Copyright © 2018 zys. All rights reserved.
//

#import "SAMWalletInfo.h"

@implementation SAMWalletInfo

- (instancetype)init {
    if (self = [super init]) {
        self.isSelected = NO;
    }
    
    return self;
}

+ (NSArray *)bg_unionPrimaryKeys {
    return @[@"walletName"];
}

/**
 设置不需要存储的属性, 在模型.m文件中实现该函数.
 */
+(NSArray *)bg_ignoreKeys{
    return @[@"balance"];
}

@end
