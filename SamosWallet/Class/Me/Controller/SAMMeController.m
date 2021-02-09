//
//  SAMMeController.m
//  SamosWallet
//
//  Created by zys on 2018/8/21.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMMeController.h"
#import "SAMMeHeaderView.h"
#import "SAMMeCell.h"

@interface SAMMeController ()

/// 首页-钱包-header
@property (nonatomic, strong) SAMMeHeaderView *tableHeader;
/// 工具菜单title
@property (nonatomic, strong) NSArray *titleArray;

@end


@implementation SAMMeController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadNewDataWithCompletionHandler:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table header / footer refresh
- (void)loadNewDataWithCompletionHandler:(SAMVoidBlock)completion {
    [self updateUI];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowNum = self.titleArray.count;
    
    return rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self loadMeCell:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            // 系统设置
            [SAMControllerTool chooseVCWithScheme:@"samwallet://system_setting"];
        }
            break;
            
        case 1: {
            // 关于我们
            [SAMControllerTool chooseVCWithScheme:@"samwallet://about_us"];
        }
            break;
            
        default:
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = nil;
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = nil;
    
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowH = [SAMMeCell cellHeight];
    
    return rowH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat headerH = .001f;
    
    return headerH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat footerH = .001f;
    
    return footerH;
}

#pragma mark - private methods
- (void)setupVariables {
    [super setupVariables];
    self.navBGColor = SAMNavigationBarBGColorClear;
}

- (void)setupSubviews {
    [super setupSubviews];
    [self setupNav];
}

- (void)registerCell {
    [SAMMeCell registerWith:self.tableView];
}

/// 设置导航按钮
- (void)setupNav {
    self.sam_navigationBar.titleLabel.textColor = [UIColor whiteColor];
    self.sam_navigationBar.title = SAM_LOCALIZED(@"language_my_wallet");
    [self showBackBtn:NO];
}

/// 更新UI
- (void)updateUI {
    SAMWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf setupTableHeader];
        [weakSelf.tableView reloadData];
    });
}

- (void)setupTableHeader {
    self.tableView.tableHeaderView = self.tableHeader;
}

/// 加载币种cell
- (UITableViewCell *)loadMeCell:(NSIndexPath *)indexPath {
    SAMMeCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SAMMeCellID];
    [cell setCellWithTitle:self.titleArray[indexPath.row]];
    
    return cell;
}

#pragma mark - getters
- (SAMMeHeaderView *)tableHeader {
    if (!_tableHeader) {
        _tableHeader = [SAMMeHeaderView header];
        _tableHeader.frame = CGRectMake(0.f, 0.f, SAM_SCREEN_WIDTH, [SAMMeHeaderView headerHeight]);
    }
    
    return _tableHeader;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[SAM_LOCALIZED(@"language_system_setting"),
                        SAM_LOCALIZED(@"language_about_us")];
    }
    
    return _titleArray;
}

@end
