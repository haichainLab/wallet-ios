//
//  SAMBaseTableViewController.m
//  SamosWallet
//
//  Created by zys on 2018/8/18.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMBaseTableViewController.h"

@interface SAMBaseTableViewController ()

/// tableView
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SAMBaseTableViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - table header / footer refresh
- (void)loadNewDataWithCompletionHandler:(SAMVoidBlock)completion {
    // 子类重写
}

- (void)loadMoreDataWithCompletionHandler:(void (^)(BOOL hasMoreData))completion {
    // 子类重写
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UITableViewCell new];
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.f;
}

#pragma mark - private methods
- (void)setupSubviews {
    [self setupTableView];
}

- (void)setupTableView {
    [self registerCell];
    [self placeTableView];
    [self setupTableViewRefresh];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.estimatedRowHeight = 0.f;
        self.tableView.estimatedSectionHeaderHeight = 0.f;
        self.tableView.estimatedSectionFooterHeight = 0.f;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)placeTableView {
    SAMWeakSelf
    [self.view addSubview:self.tableView];
    CGFloat top = 0.f;
    if (self.navBGColor == SAMNavigationBarBGColorWhite) {
        top = SAM_NAV_HEIGHT;
    }
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(top);
        make.left.bottom.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(SAM_TABLE_BOTTOM);
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)registerCell {
    
}

- (void)setupTableViewRefresh {
    SAMWeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewDataWithCompletionHandler:^{
            if ([weakSelf.tableView.mj_header isRefreshing]) {
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
        }];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreDataWithCompletionHandler:^(BOOL hasMoreData) {
            if (hasMoreData) {
                [weakSelf.tableView.mj_footer endRefreshing];
            } else {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
    }];
    
    // 缺省状态下隐藏header和footer
    self.tableView.mj_header.hidden = YES;
    self.tableView.mj_footer.hidden = YES;
}

#pragma mark - Setters / Getters
- (void)setShowRefreshHeader:(BOOL)showRefreshHeader {
    _showRefreshHeader = showRefreshHeader;
    self.tableView.mj_header.hidden = !showRefreshHeader;
}

- (void)setShowRefreshFooter:(BOOL)showRefreshFooter {
    _showRefreshFooter = showRefreshFooter;
    self.tableView.mj_footer.hidden = !showRefreshFooter;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        UIView *tableHeader = [UIView new];
        tableHeader.frame = CGRectMake(0, 0, self.view.frame.size.width, .001f);
        tableHeader.backgroundColor = [UIColor whiteColor];
        _tableView.tableHeaderView = tableHeader;
    }
    
    return _tableView;
}

@end
