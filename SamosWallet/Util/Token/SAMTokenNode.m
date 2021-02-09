//
//  SAMTokenNode.m
//  SamosWallet
//
//  Created by zys on 2018/8/19.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMTokenNode.h"

@implementation SAMTokenNode

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"tokens" : [SAMTokenInfo class]};
}

@end
