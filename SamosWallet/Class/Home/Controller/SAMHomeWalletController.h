//
//  SAMHomeWalletController.h
//  SamosWallet
//
//  Created by zys on 2018/8/20.
//  Copyright © 2018年 zys. All rights reserved.
//

/**
 首页 - 钱包页
 */

#import "SAMBaseTableViewController.h"

@interface SAMHomeWalletController : SAMBaseTableViewController

/// 左侧菜单点击
@property (nonatomic, copy) SAMVoidBlock menuClickBlock;
/// 当前钱包
@property (nonatomic, strong) SAMWalletInfo *curWallet;

@end
