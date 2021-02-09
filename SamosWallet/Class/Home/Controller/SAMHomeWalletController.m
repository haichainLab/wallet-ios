//
//  SAMHomeWalletController.m
//  SamosWallet
//
//  Created by zys on 2018/8/20.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMHomeWalletController.h"
#import "SAMHomeWalletHeaderView.h"
#import "LGSideMenuController.h"
#import "UIViewController+LGSideMenuController.h"
#import "SAMHomeWalletCoinCell.h"
#import "SAMTokenUtil.h"
#import "SAMCoinBalanceInfo.h"

@interface SAMHomeWalletController ()

/// 菜单vc
@property (nonatomic, strong) UIViewController *menuVC;
/// 首页-钱包-header
@property (nonatomic, strong) SAMHomeWalletHeaderView *tableHeader;
/// 菜单btn
@property (nonatomic, strong) UIButton *menuBtn;
/// 当前钱包的下的币种数据
@property (nonatomic, strong) NSMutableArray <SAMWalletTokenInfo *> *walletTokens;

@end


@implementation SAMHomeWalletController


#pragma mark - life cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadNewDataWithCompletionHandler:nil];
    
    NSString* strCallURL = [HaiProtocolTool getCallURL];
    if(strCallURL != nil && ![strCallURL isEqualToString:@""] ){
        NSURL * nsURL =  [NSURL URLWithString:strCallURL];
        [HaiProtocolTool strCallURL:@""];
        [HaiProtocolTool dealWithUrl:nsURL];
    }
        
}

- (void)writeUsernameToFile {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
   
    NSString *myFile = [documentsDirectory stringByAppendingPathComponent:@"data"];
    NSString *uname = @"myName";
    // NSData和NSString之间的转换
   NSData *data = [uname dataUsingEncoding:NSASCIIStringEncoding];
   if ([data writeToFile:myFile atomically:YES]) {
       return;
   } else {
       // 如何抛出异常
       [NSException raise:@"Write Error" format:@"Cannot write to %@", myFile];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self removeObservers];
}

#pragma mark - event response
- (void)menBtnClicked:(UIBarButtonItem *)btn {
    if (self.menuClickBlock) {
        self.menuClickBlock();
    }
}

- (void)loadNewDataWithCompletionHandler:(SAMVoidBlock)completion {
    SAMWeakSelf
    [self fetchTokensCompletion:^{
        [weakSelf updateUI];
        if (completion) {
            completion();
        }
    }];
}

/// 获取当前钱包的token
- (void)fetchTokensCompletion:(SAMVoidBlock)completion {
    if (self.curWallet) {
        NSArray <SAMWalletTokenInfo *> *savedTokens = [SAMWalletDB fetchAllWalletTokensWithWalletName:self.curWallet.walletName];
        [self.walletTokens removeAllObjects];
        if (savedTokens.count > 0) {
            self.walletTokens = [savedTokens mutableCopy];
            self.curWallet.balance = 0.f;
            SAMWeakSelf
            [savedTokens enumerateObjectsUsingBlock:^(SAMWalletTokenInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                // 开启子线程获取币种余额，获取成功一次，刷一次页面，避免个别币种服务器宕机导致整个余额列表显示不出来
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    NSError *error = nil;
                    SAMTokenInfo *token = [SAMWalletDB fetchToken:obj.token];
                    NSString *balance = MobileGetWalletBalance(token.tokenName, obj.walletID, &error);
                    // 解析余额和币时
                    SAMCoinBalanceInfo *ba = [SAMCoinBalanceInfo yy_modelWithJSON:balance];
                    if (!error) {
                        obj.balance = ba.balance;
                        obj.hours = ba.hours;
                    } else {
                        obj.balance = 0.f;
                        obj.hours = 0;
                    }
                    // 保存余额和币时
                    [SAMWalletDB saveWalletToken:obj];
                    SAMCoinRateInfo *rate = [SAMWalletDB rateForCoin:obj.token];
                    CGFloat rateUnit = rate.cny;
                    NSString *curUnit = [SAMWalletDB fetchCurCoinUnit];
                    if ([curUnit isEqualToString:@"USD"]) {
                        rateUnit = rate.usd;
                    }
                    weakSelf.curWallet.balance += (ba.balance * rateUnit);
                    if (completion) {
                        completion();
                    }
                });
            }];
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowNum = 0;
    if (self.walletTokens.count > 0) {
        rowNum = self.walletTokens.count;
    }
    
    return rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self loadCoinCell:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.walletTokens.count) {
        SAMWalletTokenInfo *walletToken = self.walletTokens[indexPath.row];
        NSString *scheme = [NSString stringWithFormat:@"xiaobu://coin_detail?wallet_id=%@", walletToken.walletID];
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
    CGFloat rowH = [SAMHomeWalletCoinCell cellHeight];
    
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
    self.isShowNavBar = YES;
    self.navBGColor = SAMNavigationBarBGColorClear;
}

- (void)setupSubviews {
    [super setupSubviews];
    [self setupNav];
    self.curWallet.balance = 0.f;
    [self addObservers];
    self.showRefreshHeader = YES;
    [self layoutUI];
}

- (void)registerCell {
    [SAMHomeWalletCoinCell registerWith:self.tableView];
}

/// 设置导航按钮
- (void)setupNav {
    self.sam_navigationBar.titleLabel.textColor = [UIColor whiteColor];
    [self.sam_navigationBar addSubview:self.menuBtn];
    [self.sam_navigationBar showBackBtn:NO];
}

/// 更新UI
- (void)updateUI {
    SAMWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.sam_navigationBar.title = weakSelf.curWallet.walletName;
        [weakSelf setupTableHeader];
        [weakSelf.tableView reloadData];
    });
}

/// 布局
- (void)layoutUI {
    SAMWeakSelf
    [self.view addSubview:self.tableHeader];
    [self.tableHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.view);
        make.height.equalTo(@([SAMHomeWalletHeaderView headerHeight]));
    }];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset([SAMHomeWalletHeaderView headerHeight]);
        make.bottom.equalTo(weakSelf.view);
    }];
}

- (void)setupTableHeader {
    [self.tableHeader setHeaderWithModel:self.curWallet];
}

/// 加载币种cell
- (UITableViewCell *)loadCoinCell:(NSIndexPath *)indexPath {
    SAMHomeWalletCoinCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SAMHomeWalletCoinCellID];
    if (self.walletTokens && indexPath.row < self.walletTokens.count) {
        [cell setCellWithModel:self.walletTokens[indexPath.row]];
    }
    
    return cell;
}

#pragma mark - KVO
- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:SAMNotificationInitSuccess object:nil];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SAMNotificationInitSuccess object:nil];
}

- (void)loadNewData {
    [self loadNewDataWithCompletionHandler:nil];
}

#pragma mark - getters
- (SAMHomeWalletHeaderView *)tableHeader {
    if (!_tableHeader) {
        _tableHeader = [SAMHomeWalletHeaderView header];
    }
    
    return _tableHeader;
}

- (UIButton *)menuBtn {
    if (!_menuBtn) {
        _menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(20.f, SAM_STATUSBAR_HEIGHT + (44.f - 22.f) / 2.f, 22.f, 22.f)];
        [_menuBtn setImage:[UIImage imageNamed:@"sam_home_menu"] forState:UIControlStateNormal];
        [_menuBtn addTarget:self action:@selector(menBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _menuBtn;
}

- (NSMutableArray <SAMWalletTokenInfo *> *)walletTokens {
    if (!_walletTokens) {
        _walletTokens = [NSMutableArray new];
    }
    
    return _walletTokens;
}

#pragma mark - setters
- (void)setCurWallet:(SAMWalletInfo *)curWallet {
    if (curWallet) {
        _curWallet = curWallet;
        SAMWeakSelf
        [self fetchTokensCompletion:^{
            [weakSelf updateUI];
        }];
    }
}

@end
