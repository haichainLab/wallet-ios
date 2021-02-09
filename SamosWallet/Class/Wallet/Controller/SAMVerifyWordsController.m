//
//  SAMVerifyWordsController.m
//  SamosWallet
//
//  Created by zys on 2018/9/2.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMVerifyWordsController.h"
#import "SAMVerifyWordsCell.h"

@interface SAMVerifyWordsController ()

/// cell
@property (nonatomic, strong) SAMVerifyWordsCell *cell;
/// 下一步按钮
@property (nonatomic, strong) UIButton *confirmBtn;
/// 钱包名称
@property (nonatomic, copy) NSString *walletName;
/// 钱包icon
@property (nonatomic, copy) NSString *walletIcon;
/// 助记词
@property (nonatomic, copy) NSString *walletSeed;

@end


@implementation SAMVerifyWordsController

#pragma mark - life cycle
+ (void)load {
    [MGJRouter registerURLPattern:@"samwallet://verify_words" toHandler:^(NSDictionary *routerParameters) {
        NSString *walletName = routerParameters[@"wallet_name"];
        NSString *walletIcon = routerParameters[@"wallet_icon"];
        NSString *walletSeed = routerParameters[@"wallet_seed"];
        SAMVerifyWordsController *vc = [SAMVerifyWordsController new];
        vc.walletName = walletName;
        vc.walletIcon = walletIcon;
        vc.walletSeed = walletSeed;
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
    [self updateUI];
}

#pragma mark - event response
- (void)confirmBtnClicked:(UIButton *)btn {
    NSString *inputWords = [self.cell.words trime];
    if (inputWords.length > 0) {
        if ([inputWords isEqualToString:self.walletSeed]) {
            if ([self createNewWallet]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SAMControllerTool chooseRootVC];
                });
            }
        }
    } else {
        [SVProgressHUD showInfoWithStatus:SAM_LOCALIZED(@"language_input_mnemonics")];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowNum = 1;
    
    return rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self loadWordsCell];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    CGFloat rowH = [SAMVerifyWordsCell cellHeight];
    
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
}

- (void)registerCell {
    [SAMVerifyWordsCell registerWith:self.tableView];
}

/// 设置导航按钮
- (void)setupNav {
    self.sam_navigationBar.title = SAM_LOCALIZED(@"language_backup_seed_small");
    [self.sam_navigationBar addSubview:self.confirmBtn];
}

/// 更新UI
- (void)updateUI {
    SAMWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
    });
}

/// 加载币种cell
- (UITableViewCell *)loadWordsCell {
    SAMVerifyWordsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SAMVerifyWordsCellID];
    self.cell = cell;
    
    return cell;
}

/// 创建钱包
- (BOOL)createNewWallet {
    BOOL flag = NO;
    SAMTokenInfo *defaultTokenInfo = [SAMWalletDB fetchDefaultToken];
    flag = [SAMWalletUtil createWalletWithWalletName:self.walletName walletIcon:self.walletIcon walletSeed:self.walletSeed token:defaultTokenInfo];
    
    return flag;
}

#pragma mark - getters
- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [UIButton new];
        [_confirmBtn setTitle:SAM_LOCALIZED(@"language_confirm_small") forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_confirmBtn setTitleColor:SAM_BLUE_COLOR forState:UIControlStateNormal];
        CGFloat btnW = 70.f;
        CGFloat btnH = 44.f;
        _confirmBtn.frame = CGRectMake(SAM_SCREEN_WIDTH - 15.f - btnW, SAM_STATUSBAR_HEIGHT, btnW, btnH);
        [_confirmBtn addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _confirmBtn;
}

@end
