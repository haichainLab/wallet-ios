//
//  SAMHomeMenuWalletCell.h
//  SamosWallet
//
//  Created by zys on 2018/8/21.
//  Copyright © 2018年 zys. All rights reserved.
//

/**
 首页-菜单-钱包cell
 */

#import <UIKit/UIKit.h>

@interface SAMHomeMenuWalletCell : UITableViewCell

+ (void)registerWith:(UITableView *)tableView;
+ (CGFloat)cellHeight;
- (void)setCellWithModel:(SAMWalletInfo *)model;

extern NSString *const SAMHomeMenuWalletCellID;

@end
