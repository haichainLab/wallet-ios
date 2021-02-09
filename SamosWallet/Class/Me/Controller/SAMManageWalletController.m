//
//  SAMManageWalletController.m
//  SamosWallet
//
//  Created by zys on 2018/8/28.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMManageWalletController.h"
#import "SAMManageWalletBottomView.h"
#import "SAMManageWalletCell.h"

@interface SAMManageWalletController ()

/// 底部菜单
@property (nonatomic, strong) SAMManageWalletBottomView *bottomView;
/// wallet
@property (nonatomic, strong) NSArray <SAMWalletInfo *> *wallets;

@end


@implementation SAMManageWalletController

#pragma mark - life cycle
+ (void)load {
    [MGJRouter registerURLPattern:@"samwallet://manage_wallet" toHandler:^(NSDictionary *routerParameters) {
        SAMManageWalletController *vc = [SAMManageWalletController new];
        [SAMControllerTool showVC:vc];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadNewDataWithCompletionHandler:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self removeObservers];
}

#pragma mark - table header / footer refresh
- (void)loadNewDataWithCompletionHandler:(SAMVoidBlock)completion {
    self.wallets = [SAMWalletDB fetchAllWallets];
    [self updateUI];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowNum = 0;
    if (self.wallets.count > 0) {
        rowNum = self.wallets.count;
    }
    
    return rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self loadWalletCell:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.wallets.count) {
        SAMWalletInfo *wallet = self.wallets[indexPath.row];
        NSString *scheme = [NSString stringWithFormat:@"xiaobu://wallet_detail?wallet_name=%@", wallet.walletName];
        [SAMControllerTool chooseVCWithScheme:scheme];
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
    CGFloat rowH = [SAMManageWalletCell cellHeight];
    
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
    self.navBGColor = SAMNavigationBarBGColorWhite;
}

- (void)setupSubviews {
    [super setupSubviews];
    [self setupNav];
    [self setupBottomView];
    [self addObservers];
}

- (void)registerCell {
    [SAMManageWalletCell registerWith:self.tableView];
}

/// 设置导航按钮
- (void)setupNav {
    self.sam_navigationBar.title = SAM_LOCALIZED(@"language_manage_wallet");
}

/// 更新UI
- (void)updateUI {
    SAMWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
    });
}

/// 加载币种cell
- (UITableViewCell *)loadWalletCell:(NSIndexPath *)indexPath {
    SAMManageWalletCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SAMManageWalletCellID];
    if (indexPath.row < self.wallets.count) {
        [cell setCellWithModel:self.wallets[indexPath.row]];
    }
    
    return cell;
}

/// 设置底部菜单
- (void)setupBottomView {
    [self.view insertSubview:self.bottomView aboveSubview:self.tableView];
    SAMWeakSelf
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(weakSelf.view);
        make.height.equalTo(@([SAMManageWalletBottomView viewHeight]));
    }];
}

#pragma mark - kvo
- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:SAMNotificationRefreshManageWalletPage object:nil];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SAMNotificationRefreshManageWalletPage object:nil];
}

- (void)loadNewData {
    [self loadNewDataWithCompletionHandler:nil];
}

#pragma mark - getters
- (SAMManageWalletBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [SAMManageWalletBottomView bottomView];
    }
    
    return _bottomView;
}

@end
