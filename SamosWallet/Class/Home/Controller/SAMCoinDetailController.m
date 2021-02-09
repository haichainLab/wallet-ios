//
//  SAMCoinDetailController.m
//  SamosWallet
//
//  Created by zys on 2018/12/1.
//  Copyright © 2018 zys. All rights reserved.
//

#import "SAMCoinDetailController.h"
#import "SAMCoinDetailHeader.h"
#import "SAMCoinBalanceinfo.h"
#import "SAMCoinTradeRecordListCell.h"
#import "SAMTradeBottomBar.h"
#import "SAMCoinTradeRecordListCell.h"
#import "SAMTradeRecordListModel.h"
#import "SAMNetwork.h"
#import "SAMApi.h"
#import "SAMTradeRecordDetailController.h"

@interface SAMCoinDetailController ()

/// header
@property (nonatomic, strong) SAMCoinDetailHeader *header;
/// bottom bar
@property (nonatomic, strong) SAMTradeBottomBar *bottomBar;

/// data
@property (nonatomic, copy) NSString *walletID;
/// wallet token info
@property (nonatomic, strong) SAMWalletTokenInfo *walletToken;
/// trade record data
@property (nonatomic, strong) NSArray <SAMTradeRecordListModel *> *recordArray;
/// 交易地址查询
@property (nonatomic, copy) NSString *explorerUrl;

@end


@implementation SAMCoinDetailController

#pragma mark - life cycle
+ (void)load {
    [MGJRouter registerURLPattern:@"xiaobu://coin_detail" toHandler:^(NSDictionary *routerParameters) {
        NSString *walletID = routerParameters[@"wallet_id"];
        SAMCoinDetailController *vc = [SAMCoinDetailController new];
        vc.walletID = walletID;
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

#pragma mark - load data
- (void)loadNewDataWithCompletionHandler:(SAMVoidBlock)completion {
    if (self.walletID.length > 0) {
        // 获取余额
        [SAMWalletUtil fetchWalletTokenBalanceInfoWithWalletID:self.walletID];
        // 获取币种数据
        self.walletToken = [SAMWalletDB fetchWalletTokenWithWalletID:self.walletID];
        SAMWeakSelf
        [self loadRecordListCompletion:^{
            [weakSelf updateUI];
            if (completion) {
                completion();
            }
        }];
    }
}

/// 获取交易记录
- (void)loadRecordListCompletion:(SAMVoidBlock)completion {
    if (self.walletID.length > 0) {
        SAMWalletInfo *wallet = [SAMWalletDB fetchCurWallet];
        NSString *timestamp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
        NSDictionary *param = @{@"token"   : self.walletToken.token,
                                @"address" : wallet.address,
                                @"ts"      : timestamp};
        SAMWeakSelf
        [SAMNetwork GETWithURLStr:SAMApiGetCoinTradeRecordList parameters:param success:^(id responseObject) {
            weakSelf.explorerUrl = responseObject[@"explorerUrl"];
            weakSelf.recordArray = [NSArray yy_modelArrayWithClass:[SAMTradeRecordListModel class] json:responseObject[@"transList"]];
            if (completion) {
                completion();
            }
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
            if (completion) {
                completion();
            }
        }];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sectionNum = 1;
    
    return sectionNum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowNum = 0;
    if (self.recordArray.count > 0) {
        rowNum = self.recordArray.count;
    }
    
    return rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SAMCoinTradeRecordListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SAMCoinTradeRecordListCellID];
    if (indexPath.row < self.recordArray.count) {
        [cell setCellWithModel:self.recordArray[indexPath.row]];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.recordArray.count) {
        SAMTradeRecordListModel *model = self.recordArray[indexPath.row];
        if (model.txid.length > 0) {
            [SAMTradeRecordDetailController pushFrom:self tradeInfo:model explorerUrl:self.explorerUrl];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowH = [SAMCoinTradeRecordListCell cellHeight];
    
    return rowH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = self.header;
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [UIView new];
    footer.backgroundColor = [UIColor whiteColor];
    
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat headerH = [SAMCoinDetailHeader headerHeight];
    
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
    self.showRefreshHeader = YES;
    [self setupBottomBar];
    [self addObservers];
}

- (void)registerCell {
    [SAMCoinTradeRecordListCell registerWith:self.tableView];
}

- (void)updateUI {
    SAMWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        
        weakSelf.sam_navigationBar.title = weakSelf.walletToken.token;
        //xxl 0.0.0 hai to haic
        if([weakSelf.walletToken.token isEqualToString:@"HAI"]){
            weakSelf.sam_navigationBar.title = @"HAIC";
        }
        
        [weakSelf setupHeader];
        [weakSelf.tableView reloadData];
    });
}

/// 设置header
- (void)setupHeader {
    [self.header setHeaderWithModel:self.walletToken];
}

/// 设置bottom bar
- (void)setupBottomBar {
    [self.view addSubview:self.bottomBar];
    SAMWeakSelf
    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(SAM_TABLE_BOTTOM);
        make.height.equalTo(@([SAMTradeBottomBar barHeight]));
    }];
}

#pragma mark - kvo
- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:SAMNotificationRefreshTradeRecordList object:nil];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SAMNotificationRefreshTradeRecordList object:nil];
}

- (void)loadNewData {
    [self loadNewDataWithCompletionHandler:nil];
}

#pragma mark - getters
- (SAMCoinDetailHeader *)header {
    if (!_header) {
        _header = [SAMCoinDetailHeader header];
    }
    
    return _header;
}

- (SAMTradeBottomBar *)bottomBar {
    if (!_bottomBar) {
        _bottomBar = [SAMTradeBottomBar bottomBar];
        SAMWeakSelf
        _bottomBar.outBtnClickBlock = ^{
            NSLog(@"转出！！");
            NSString *scheme = [NSString stringWithFormat:@"samos://pay?address=%@&amount=%@&token=%@", @"", @"", weakSelf.walletToken.token];
            [SAMControllerTool chooseVCWithScheme:scheme];
        };
        _bottomBar.inBtnClickBlock = ^{
            NSLog(@"转入！！");
            SAMWalletInfo *wallet = [SAMWalletDB fetchCurWallet];
            NSString *scheme = [NSString stringWithFormat:@"samos://receive_coin?address=%@&token=%@", wallet.address, weakSelf.walletToken.token];
            [SAMControllerTool chooseVCWithScheme:scheme];
        };
    }
    
    return _bottomBar;
}

@end
