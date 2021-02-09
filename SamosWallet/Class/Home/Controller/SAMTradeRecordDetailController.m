//
//  SAMTradeRecordDetailController.m
//  SamosWallet
//
//  Created by zys on 2018/12/1.
//  Copyright © 2018 zys. All rights reserved.
//

#import "SAMTradeRecordDetailController.h"
#import "SAMTradeRecordListModel.h"
#import "SAMTradeRecordDetailCell.h"
#import "SAMTradeRecordDetailBottomBar.h"

@interface SAMTradeRecordDetailController ()

/// bottom bar
@property (nonatomic, strong) SAMTradeRecordDetailBottomBar *bottomBar;
/// data
@property (nonatomic, strong) SAMTradeRecordListModel *tradeInfo;
/// 交易地址查询
@property (nonatomic, copy) NSString *explorerUrl;

@end


@implementation SAMTradeRecordDetailController

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

#pragma mark - public methods
+ (instancetype)pushFrom:(UIViewController *)fromVC
               tradeInfo:(SAMTradeRecordListModel *)tradeInfo
             explorerUrl:(NSString *)explorerUrl {
    if (tradeInfo && tradeInfo.txid.length > 0) {
        SAMTradeRecordDetailController *vc = [SAMTradeRecordDetailController new];
        vc.tradeInfo = tradeInfo;
        vc.explorerUrl = explorerUrl;
        if (fromVC) {
            [fromVC.navigationController pushViewController:vc animated:YES];
        }
        
        return vc;
    }
    
    return nil;
}

#pragma mark - load data
- (void)loadNewDataWithCompletionHandler:(SAMVoidBlock)completion {
    if (self.tradeInfo) {
        [self updateUI];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sectionNum = 1;
    
    return sectionNum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowNum = 0;
    if (self.tradeInfo) {
        rowNum = 1;
    }
    
    return rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SAMTradeRecordDetailCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SAMTradeRecordDetailCellID];
    [cell setCellWithModel:self.tradeInfo explorerUrl:self.explorerUrl];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowH = [SAMTradeRecordDetailCell cellHeight];
    
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
    self.sam_navigationBar.title = SAM_LOCALIZED(@"language_trade_record");
    [self setupBottomBar];
}

- (void)registerCell {
    [SAMTradeRecordDetailCell registerWith:self.tableView];
}

- (void)updateUI {
    SAMWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
    });
}

/// 设置bottombar
- (void)setupBottomBar {
    [self.view addSubview:self.bottomBar];
    SAMWeakSelf
    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.tableView);
        make.bottom.equalTo(weakSelf.view).offset(SAM_TABLE_BOTTOM);
        make.height.equalTo(@([SAMTradeRecordDetailBottomBar barHeight]));
    }];
}

#pragma mark - getters
- (SAMTradeRecordDetailBottomBar *)bottomBar {
    if (!_bottomBar) {
        _bottomBar = [SAMTradeRecordDetailBottomBar bottomBar];
        SAMWeakSelf
        _bottomBar.samCopyBlock = ^{
            NSString *qrcodeStr = [weakSelf.explorerUrl stringByAppendingPathComponent:weakSelf.tradeInfo.txid];
            [SAMTool copyToPasteboadrd:qrcodeStr];
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showSuccessWithStatus:SAM_LOCALIZED(@"language_copy_success")];
            });
        };
    }
    
    return _bottomBar;
}

@end
