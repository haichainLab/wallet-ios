//
//  SAMBaseTableViewController.h
//  SamosWallet
//
//  Created by zys on 2018/8/18.
//  Copyright © 2018年 zys. All rights reserved.
//

/**
 项目里所有列表页基类
 */

#import "SAMBaseViewController.h"

@interface SAMBaseTableViewController : SAMBaseViewController <UITableViewDataSource, UITableViewDelegate>

/// tableView
@property (nonatomic, strong, readonly) UITableView *tableView;
/// 是否显示下拉刷新
@property (nonatomic, assign) BOOL showRefreshHeader;
/// 是否显示上拉刷新
@property (nonatomic, assign) BOOL showRefreshFooter;

/// 注册cell
- (void)registerCell;

@end
