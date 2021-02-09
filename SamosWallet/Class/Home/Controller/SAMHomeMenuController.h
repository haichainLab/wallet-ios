//
//  SAMHomeMenuController.h
//  SamosWallet
//
//  Created by zys on 2018/8/21.
//  Copyright © 2018年 zys. All rights reserved.
//

/**
 首页-左侧菜单页
 */

#import "SAMBaseTableViewController.h"

@interface SAMHomeMenuController : SAMBaseTableViewController

/// 选择钱包
@property (nonatomic, copy) SAMVoidBlock selectWalletBlock;
/// 钱包数据
@property (nonatomic, strong) NSArray *wallets;

@end
