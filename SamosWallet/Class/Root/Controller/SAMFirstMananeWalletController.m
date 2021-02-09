//
//  SAMFirstMananeWalletController.m
//  SamosWallet
//
//  Created by zys on 2018/9/8.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMFirstMananeWalletController.h"
#import "SAMFirstManageWalletCell.h"
#import "SAMWalletPasswordPopView.h"
#import "SAMTokenUtil.h"

@interface SAMFirstMananeWalletController ()

@end


@implementation SAMFirstMananeWalletController


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
    [SAMTokenUtil loadTokenDataCompletion:^(SAMTokenNode * _Nonnull token) {
        
    }];
    [self updateUI];
}

- (void)loadMoreDataWithCompletionHandler:(void (^)(BOOL hasMoreData))completion {
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowNum = 0;
    rowNum = 1;
    
    return rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self loadCell:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = nil;
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = nil;
    
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowH = [SAMFirstManageWalletCell cellHeight];
    
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
    [self showSetPwdAlert];
}

- (void)registerCell {
    [SAMFirstManageWalletCell registerWith:self.tableView];
}

/// 设置导航按钮
- (void)setupNav {
    [self.sam_navigationBar showBackBtn:NO];
}

/// 更新UI
- (void)updateUI {
    SAMWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
    });
}

/// 加载cell
- (UITableViewCell *)loadCell:(NSIndexPath *)indexPath {
    SAMFirstManageWalletCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SAMFirstManageWalletCellID];
    
    return cell;
}

/// 显示密码弹窗
- (void)showSetPwdAlert {
    if ([SAMWalletPasswordPopView shouldShow]) {
        SAMWalletPasswordPopView *alert = [SAMWalletPasswordPopView popView];
        [alert show];
        __weak typeof(alert) weakAlert = alert;
        SAMWeakSelf
        alert.confirmBlock = ^(NSString *pwd, NSString *pwdTip) {
            [weakSelf mobileInitWithPwd:pwd completion:^(BOOL success) {
                if (success) {
                    // 存储密码
                    [SAMWalletDB savePwd:pwd];
                    [weakAlert dismiss];
                }
            }];
        };
    }
}

/// 初始化客户端
- (void)mobileInitWithPwd:(NSString *)pwd
               completion:(void (^)(BOOL success))completion {
    if (pwd.length > 0) {
        NSError *error = nil;
        BOOL ret = MobileInit([SAMPathManager walletDirectory], pwd, &error);
        if (error) {
            NSLog(@"MobileInit error: %@", error);
        }
        if (completion) {
            completion(ret);
        }
    }
}

@end
