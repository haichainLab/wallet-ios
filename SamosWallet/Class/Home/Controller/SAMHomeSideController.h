//
//  SAMHomeSideController.h
//  SamosWallet
//
//  Created by zys on 2018/8/20.
//  Copyright © 2018年 zys. All rights reserved.
//

/**
 首页-钱包-抽屉vc
 */

#import "LGSideMenuController.h"

@interface SAMHomeSideController : LGSideMenuController

/// 选择钱包
@property (nonatomic, copy) SAMVoidBlock selectWalletBlock;
/// 钱包数据
@property (nonatomic, strong) NSArray *wallets;
/// 当前钱包
@property (nonatomic, strong) SAMWalletInfo *curWallet;

@end
