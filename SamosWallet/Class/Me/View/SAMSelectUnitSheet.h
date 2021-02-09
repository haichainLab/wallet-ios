//
//  SAMSelectUnitSheet.h
//  SamosWallet
//
//  Created by zys on 2018/8/24.
//  Copyright © 2018年 zys. All rights reserved.
//

/**
 选择计价单位sheet
 */

#import "SAMActionSheet.h"

@interface SAMSelectUnitSheet : SAMActionSheet

@property (nonatomic, copy) SAMVoidBlock selectBlock;

+ (instancetype)sheet;

@end
