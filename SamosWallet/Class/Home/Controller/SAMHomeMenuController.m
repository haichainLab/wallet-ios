//
//  SAMHomeMenuController.m
//  SamosWallet
//
//  Created by zys on 2018/8/21.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMHomeMenuController.h"
#import "SAMHomeMenuHeaderView.h"
#import "SAMHomeMenuToolCell.h"
#import "SAMHomeMenuWalletCell.h"
#import "QRCodeReaderViewController.h"

@interface SAMHomeMenuController () <QRCodeReaderDelegate>

/// header
@property (nonatomic, strong) SAMHomeMenuHeaderView *tableHeader;
/// 工具菜单icon name
@property (nonatomic, strong) NSArray *iconNameArray;
/// 工具菜单title
@property (nonatomic, strong) NSArray *titleArray;

@end


@implementation SAMHomeMenuController


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

- (void)loadMoreDataWithCompletionHandler:(void (^)(BOOL hasMoreData))completion {
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sectionNum = 0;
    /**
     0 - 工具菜单
     1 - 钱包列表
     */
    sectionNum = 2;
    
    return sectionNum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowNum = 0;
    if (section == 0) {
        rowNum = self.iconNameArray.count;
    } else {
        rowNum = self.wallets.count;
    }
    
    return rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [self loadToolMenuCell:indexPath];
    } else {
        cell = [self loadWalletCell:indexPath];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {
                // 扫描二维码
                [self showQRCodeScanVC];
            }
                
                break;
                
            case 1: {
                // 创建钱包
                [SAMControllerTool chooseVCWithScheme:@"samwallet://create_wallet"];
            }
                
                break;
                
            case 2: {
                // 管理钱包
                [SAMControllerTool chooseVCWithScheme:@"samwallet://manage_wallet"];
            }
                
                break;
                
            default:
                break;
        }
    } else {
        // 选择钱包
        if (indexPath.row < self.wallets.count) {
            SAMWalletInfo *wallet = self.wallets[indexPath.row];
            wallet.isSelected = YES;
            [SAMWalletDB saveWalletInfo:wallet];
            [SAMWalletDB selectWallet:wallet.walletName];
            if (self.selectWalletBlock) {
                self.selectWalletBlock();
            }
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = nil;
    if (section == 0) {
        header = self.tableHeader;
    }
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = nil;
    
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowH = 0.f;
    if (indexPath.section == 0) {
        rowH = [SAMHomeMenuToolCell cellHeight];
    } else {
        rowH = [SAMHomeMenuWalletCell cellHeight];
    }
    
    return rowH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat headerH = .001f;
    if (section == 0) {
        headerH = [SAMHomeMenuHeaderView headerHeight];
    }
    
    return headerH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat footerH = .001f;
    
    return footerH;
}

#pragma mark - private methods
- (void)setupVariables {
    [super setupVariables];
    self.isShowNavBar = NO;
    self.navBGColor = SAMNavigationBarBGColorClear;
}

- (void)setupSubviews {
    [super setupSubviews];
    self.sam_navigationBar.hidden = YES;
}

- (void)registerCell {
    [SAMHomeMenuToolCell registerWith:self.tableView];
    [SAMHomeMenuWalletCell registerWith:self.tableView];
}

/// 更新UI
- (void)updateUI {
    SAMWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
    });
}

/// 加载工具菜单cell
- (UITableViewCell *)loadToolMenuCell:(NSIndexPath *)indexPath {
    SAMHomeMenuToolCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SAMHomeMenuToolCellID];
    [cell setCellWithIconName:self.iconNameArray[indexPath.row] title:self.titleArray[indexPath.row]];
    
    return cell;
}

/// 加载钱包cell
- (UITableViewCell *)loadWalletCell:(NSIndexPath *)indexPath {
    SAMHomeMenuWalletCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SAMHomeMenuWalletCellID];
    if (indexPath.row < self.wallets.count) {
        [cell setCellWithModel:self.wallets[indexPath.row]];
    }
    
    return cell;
}

/// 显示二维码扫描vc
- (void)showQRCodeScanVC {
    QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    QRCodeReaderViewController *readerVC = [QRCodeReaderViewController readerWithCancelButtonTitle:SAM_LOCALIZED(@"language_cancel") codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:NO showTorchButton:YES];
    // Set the presentation style
    readerVC.modalPresentationStyle = UIModalPresentationFormSheet;
    // Using delegate methods
    readerVC.delegate = self;
    // Or by using blocks
    SAMWeakSelf
    [readerVC setCompletionWithBlock:^(NSString *resultAsString) {
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            NSLog(@"%@", resultAsString);
            // samos://pay?address=xxx&amount=0&token=SAMO
            // 解析扫描结果
            if ([resultAsString hasPrefix:@"samos://pay"]) {
                [SAMControllerTool chooseVCWithScheme:resultAsString];
            }else{
                //xxl 0.0.1 clear the url when come in
                [HaiProtocolTool strCallBackURL:@""];
                [HaiProtocolTool strOutTradeNo:@""];
                
                NSURL *url = [NSURL URLWithString:resultAsString];
                //xxl 0.0.1 for haichain protocal
                [HaiProtocolTool dealWithUrl:url];
                
            }
            
           
            
        }];
    }];
    [self presentViewController:readerVC animated:YES completion:nil];
}

#pragma mark - QRCodeReaderDelegate
- (void)readerDidCancel:(QRCodeReaderViewController *)reader {
    [reader dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getters
- (SAMHomeMenuHeaderView *)tableHeader {
    if (!_tableHeader) {
        _tableHeader = [SAMHomeMenuHeaderView header];
        _tableHeader.frame = CGRectMake(0.f, 0.f, SAM_SCREEN_WIDTH, [SAMHomeMenuHeaderView headerHeight]);
    }
    
    return _tableHeader;
}

- (NSArray *)iconNameArray {
    if (!_iconNameArray) {
        _iconNameArray = @[@"sam_home_menu_qrcode",
                           @"sam_home_menu_add",
                           @"sam_home_menu_setting"];
    }
    
    return _iconNameArray;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[SAM_LOCALIZED(@"language_scan_qrcode"),
                        SAM_LOCALIZED(@"language_create_wallet"),
                        SAM_LOCALIZED(@"language_manage_wallet")];
    }
    
    return _titleArray;
}

#pragma mark - setters
- (void)setWallets:(NSArray *)wallets {
    if (wallets.count > 0) {
        _wallets = wallets;
        [self updateUI];
    }
}

@end
