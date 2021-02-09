//
//  SAMHomeWalletCoinCell.h
//  SamosWallet
//
//  Created by zys on 2018/8/21.
//  Copyright © 2018年 zys. All rights reserved.
//

/**
 首页-钱包-币种列表cell
 */

#import <UIKit/UIKit.h>
@class SAMWalletTokenInfo;

@interface SAMHomeWalletCoinCell : UITableViewCell

+ (void)registerWith:(UITableView *)tableView;
+ (CGFloat)cellHeight;
- (void)setCellWithModel:(SAMWalletTokenInfo *)model;

extern NSString *const SAMHomeWalletCoinCellID;

@end
