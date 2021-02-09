//
//  SAMWalletDetailController.m
//  SamosWallet
//
//  Created by zys on 2018/12/2.
//  Copyright © 2018 zys. All rights reserved.
//

#import "SAMWalletDetailController.h"
#import "SAMWalletDetailCell.h"
#import "SAMWalletDetailBottomBar.h"
#import "SAMSendInputPwdSheet.h"

@interface SAMWalletDetailController ()

/// cell
@property (nonatomic, strong) SAMWalletDetailCell *cell;
/// 下一步按钮
@property (nonatomic, strong) UIButton *saveBtn;
/// bottom bar
@property (nonatomic, strong) SAMWalletDetailBottomBar *bottomBar;
/// 钱包名
@property (nonatomic, copy) NSString *walletName;
/// 当前钱包
@property (nonatomic, strong) SAMWalletInfo *wallet;

@end


@implementation SAMWalletDetailController

#pragma mark - life cycle
+ (void)load {
    [MGJRouter registerURLPattern:@"xiaobu://wallet_detail" toHandler:^(NSDictionary *routerParameters) {
        NSString *walletName = routerParameters[@"wallet_name"];
        SAMWalletDetailController *vc = [SAMWalletDetailController new];
        vc.walletName = walletName;
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

#pragma mark - load data
- (void)loadNewDataWithCompletionHandler:(SAMVoidBlock)completion {
    self.wallet = [SAMWalletDB fetchWallet:self.walletName];
    [self updateUI];
}

#pragma mark - event response
- (void)saveBtnClicked:(UIButton *)btn {
    NSString *newName = self.cell.walletNameTextField.text;
    if (newName.length > 0) {
        // 检查钱包名是否存在，不存在才能替换
        if (![SAMWalletUtil isWalletExist:newName]) {
            if ([SAMWalletUtil changeWalletName:self.walletName withNewName:newName]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showSuccessWithStatus:SAM_LOCALIZED(@"language_save_success")];
                });
                // 刷新管理钱包页、首页
                [[NSNotificationCenter defaultCenter] postNotificationName:SAMNotificationRefreshManageWalletPage object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:SAMNotificationRefreshTabBarHome object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } else {
            if (![newName isEqualToString:self.walletName]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@%@%@", SAM_LOCALIZED(@"language_wallet"),newName,SAM_LOCALIZED(@"language_exists")]];
                });
            }
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sectionNum = 1;
    
    return sectionNum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowNum = 1;
    
    return rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SAMWalletDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:SAMWalletDetailCellID];
    [cell setCellWithModel:self.wallet];
    self.cell = cell;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowH = [SAMWalletDetailCell cellHeight];
    
    return rowH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [UIView new];
    header.backgroundColor = [UIColor whiteColor];
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [UIView new];
    footer.backgroundColor = [UIColor whiteColor];
    
    return footer;
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
    self.isShowNavBar = YES;
    self.navBGColor = SAMNavigationBarBGColorWhite;
}

- (void)setupSubviews {
    [super setupSubviews];
    [self setupBottomBar];
    [self.sam_navigationBar addSubview:self.saveBtn];
}

- (void)registerCell {
    [SAMWalletDetailCell registerWith:self.tableView];
}

/// 更新UI
- (void)updateUI {
    SAMWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.sam_navigationBar.title = weakSelf.walletName;
        [weakSelf.tableView reloadData];
    });
}

/// 设置bottom bar
- (void)setupBottomBar {
    [self.view addSubview:self.bottomBar];
    SAMWeakSelf
    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(SAM_TABLE_BOTTOM);
        make.height.equalTo(@([SAMWalletDetailBottomBar barHeight]));
    }];
}

/// 备份助记词
- (void)backupWords {
    SAMSendInputPwdSheet *sheet = [SAMSendInputPwdSheet sheet];
    [sheet show];
    __weak typeof (sheet) weakSheet = sheet;
    SAMWeakSelf
    sheet.confirmBlock = ^(NSString *pwd) {
        NSString *savedPwd = [SAMWalletDB fetchPwd];
        if ([pwd isEqualToString:savedPwd]) {
            [weakSheet dismiss];
            // 获取助记词
            NSString *words = [SAMWalletUtil fetchWalletSeed:weakSelf.walletName];
            NSString *scheme = [NSString stringWithFormat:@"samwallet://backup_words?is_edit=1&words=%@", words];
            [SAMControllerTool chooseVCWithScheme:scheme];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showInfoWithStatus:SAM_LOCALIZED(@"language_password_is_wrong")];
            });
        }
    };
}

/// 删除钱包
- (void)removeWallet {
    SAMWeakSelf
    // 提示
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:SAM_LOCALIZED(@"language_warning") message:SAM_LOCALIZED(@"language_remove_wallet_alert") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:SAM_LOCALIZED(@"language_confirm_small") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SAMSendInputPwdSheet *sheet = [SAMSendInputPwdSheet sheet];
        [sheet show];
        __weak typeof (sheet) weakSheet = sheet;
        sheet.confirmBlock = ^(NSString *pwd) {
            NSString *savedPwd = [SAMWalletDB fetchPwd];
            if ([pwd isEqualToString:savedPwd]) {
                [weakSheet dismiss];
                if ([SAMWalletUtil removeWallet:weakSelf.walletName]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD showInfoWithStatus:SAM_LOCALIZED(@"language_remove_wallet_success")];
                    });
                    // 刷新管理钱包页、首页
                    [[NSNotificationCenter defaultCenter] postNotificationName:SAMNotificationRefreshManageWalletPage object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:SAMNotificationRefreshTabBarHome object:nil];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showInfoWithStatus:SAM_LOCALIZED(@"language_password_is_wrong")];
                });
            }
        };
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:SAM_LOCALIZED(@"language_cancel") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    if (@available(iOS 9.0, *)) {
        [confirmAction setValue:SAM_GRAY_COLOR forKey:@"titleTextColor"];
        [cancelAction setValue:SAM_BLUE_COLOR forKey:@"titleTextColor"];
    }
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - getters
- (SAMWalletDetailBottomBar *)bottomBar {
    if (!_bottomBar) {
        _bottomBar = [SAMWalletDetailBottomBar bottomBar];
        SAMWeakSelf
        _bottomBar.backupBlock = ^{
            [weakSelf backupWords];
        };
        _bottomBar.removeBlock = ^{
            [weakSelf removeWallet];
        };
    }
    
    return _bottomBar;
}

- (UIButton *)saveBtn {
    if (!_saveBtn) {
        _saveBtn = [UIButton new];
        [_saveBtn setTitle:SAM_LOCALIZED(@"language_save") forState:UIControlStateNormal];
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_saveBtn setTitleColor:SAM_BLUE_COLOR forState:UIControlStateNormal];
        CGFloat btnW = 50.f;
        CGFloat btnH = 44.f;
        _saveBtn.frame = CGRectMake(SAM_SCREEN_WIDTH - 15.f - btnW, SAM_STATUSBAR_HEIGHT, btnW, btnH);
        [_saveBtn addTarget:self action:@selector(saveBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _saveBtn;
}

@end
