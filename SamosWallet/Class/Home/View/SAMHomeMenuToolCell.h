//
//  SAMHomeMenuToolCell.h
//  SamosWallet
//
//  Created by zys on 2018/8/21.
//  Copyright © 2018年 zys. All rights reserved.
//

/**
 首页-菜单-工具cell：扫描二维码、创建钱包、管理钱包
 */

#import <UIKit/UIKit.h>

@interface SAMHomeMenuToolCell : UITableViewCell

+ (void)registerWith:(UITableView *)tableView;
+ (CGFloat)cellHeight;
- (void)setCellWithIconName:(NSString *)iconName
                      title:(NSString *)title;

extern NSString *const SAMHomeMenuToolCellID;

@end
