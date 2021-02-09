//
//  SAMBackupWordsController.m
//  SamosWallet
//
//  Created by zys on 2018/9/2.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMBackupWordsController.h"
#import "SAMBackupWordsCell.h"
#import "SAMSaveWordsAlert.h"
#import "SAMVerifyWordsController.h"

@interface SAMBackupWordsController ()

/// 下一步按钮
@property (nonatomic, strong) UIButton *nextBtn;
/// cell
@property (nonatomic, strong) SAMBackupWordsCell *cell;
/// 钱包名称
@property (nonatomic, copy) NSString *walletName;
/// 钱包icon
@property (nonatomic, copy) NSString *walletIcon;
/// 助记词
@property (nonatomic, copy) NSString *walletSeed;
/// 是否是编辑钱包数据
@property (nonatomic, assign) BOOL isEditStatus;

@end


@implementation SAMBackupWordsController

#pragma mark - life cycle
+ (void)load {
    [MGJRouter registerURLPattern:@"samwallet://backup_words" toHandler:^(NSDictionary *routerParameters) {
        SAMBackupWordsController *vc = [SAMBackupWordsController new];
        NSString *walletName = routerParameters[@"wallet_name"];
        NSString *walletIcon = routerParameters[@"wallet_icon"];
        NSString *isEdit = routerParameters[@"is_edit"];
        NSString *words = routerParameters[@"words"];
        vc.walletName = walletName;
        vc.walletIcon = walletIcon;
        vc.isEditStatus = isEdit.boolValue;
        vc.walletSeed = words;
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
    if (self.isEditStatus == NO) {
        self.walletSeed = MobileNewSeed();
    }
    if (self.walletSeed.length > 0) {
        [self updateUI];
    }
}

#pragma mark - event response
- (void)nextBtnClicked:(UIButton *)btn {
    if (self.walletSeed.length > 0) {
        NSString *scheme = [NSString stringWithFormat:@"samwallet://verify_words?wallet_name=%@&wallet_icon=%@&wallet_seed=%@", self.walletName, self.walletIcon, self.walletSeed];
        [SAMControllerTool chooseVCWithScheme:scheme];
    } else {
        [SVProgressHUD showInfoWithStatus:SAM_LOCALIZED(@"language_create_mnemonics")];
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
    CGFloat rowH = [SAMBackupWordsCell cellHeightWithWord:self.walletSeed];
    
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
    [self showNotCameraAlert];
}

- (void)registerCell {
    [SAMBackupWordsCell registerWith:self.tableView];
}

/// 设置导航按钮
- (void)setupNav {
    self.sam_navigationBar.title = SAM_LOCALIZED(@"language_backup_seed_small");
    [self.sam_navigationBar addSubview:self.nextBtn];
}

/// 更新UI
- (void)updateUI {
    SAMWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.nextBtn.hidden = weakSelf.isEditStatus;
        weakSelf.cell.recreateBtn.hidden = weakSelf.isEditStatus;
        weakSelf.cell.btnTitleLabel.hidden = weakSelf.isEditStatus;
        [weakSelf.tableView reloadData];
    });
}

/// 加载币种cell
- (UITableViewCell *)loadWordsCell {
    SAMBackupWordsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SAMBackupWordsCellID];
    [cell setCellWithWords:self.walletSeed];
    self.cell = cell;
    SAMWeakSelf
    cell.recreateBlock = ^{
        [weakSelf loadNewDataWithCompletionHandler:nil];
    };
    
    return cell;
}

- (void)showNotCameraAlert {
    SAMSaveWordsAlert *alert = [SAMSaveWordsAlert popView];
    [alert show];
}

#pragma mark - getters
- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [UIButton new];
        [_nextBtn setTitle:SAM_LOCALIZED(@"language_next_small") forState:UIControlStateNormal];
        _nextBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_nextBtn setTitleColor:SAM_BLUE_COLOR forState:UIControlStateNormal];
        CGFloat btnW = 50.f;
        CGFloat btnH = 44.f;
        _nextBtn.frame = CGRectMake(SAM_SCREEN_WIDTH - 15.f - btnW, SAM_STATUSBAR_HEIGHT, btnW, btnH);
        [_nextBtn addTarget:self action:@selector(nextBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _nextBtn;
}

@end
