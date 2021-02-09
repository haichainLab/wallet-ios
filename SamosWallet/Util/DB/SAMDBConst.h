//
//  SAMDBConst.h
//  SamosWallet
//
//  Created by zys on 2018/11/11.
//  Copyright © 2018 zys. All rights reserved.
//

/**
 数据库常量定义：一共定义了4张表
 1.钱包数据库表（存储本设备包含的钱包）
 2.支持的token数据库表（此表中不包含walletID、walletName）
 3.添加的钱包数据库表（此表包含walletID、walletName、token）
 4.币种的兑换比率
 */

#ifndef SAMDBConst_h
#define SAMDBConst_h

#pragma mark - key
/// 密码key
#define SAM_PWD_KEY @"SAM_PASS_WORD"
/// 默认token key
#define SAM_DEFAULT_TOKEN_KEY @"sam_default_token"
/// 币种单位 key
#define SAM_CUR_COIN_UNIT_KEY @"sam_cur_coin_unit"

#pragma mark - DB name / table name
/// 数据库名字
#define SAM_DB_NAME @"sam_wallet_data"
/// 钱包数据库表名字
#define SAM_DB_WALLET_TABLE @"sam_wallet_table"
/// token数据库表名字
#define SAM_DB_TOKEN_TABLE @"sam_token_table"
/// 添加的币种数据库表
#define SAM_DB_WALLET_TOKEN_TABLE @"sam_wallet_token_table"
/// 货币比率数据库表名
#define SAM_DB_RATE_TABLE @"sam_rate_table"

//xxl 0.0.2 锁币数据库表名
#define SAM_DB_LOCK_TABLE @"hai_lock_table"

#endif /* SAMDBConst_h */
