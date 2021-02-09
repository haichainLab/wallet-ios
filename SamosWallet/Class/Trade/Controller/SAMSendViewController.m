//
//  SAMSendViewController.m
//  SamosWallet
//
//  Created by zys on 2018/12/1.
//  Copyright © 2018 zys. All rights reserved.
//

#import "SAMSendViewController.h"
#import "SAMSendCell.h"
#import "SAMSendBottomBar.h"
#import "SAMSendDetailSheet.h"
#import "SAMSendInputPwdSheet.h"
#import "QRCodeReaderViewController.h"
#import "NSString+encryptionMD5.h"

@interface SAMSendViewController () <QRCodeReaderDelegate>

/// 二维码按钮
@property (nonatomic, strong) UIButton *qrcodeBtn;
/// 下一步按钮bar
@property (nonatomic, strong) SAMSendBottomBar *bottomBar;
/// token
@property (nonatomic, copy) NSString *token;
/// 转出地址
@property (nonatomic, copy) NSString *address;
/// 转出数目
@property (nonatomic, copy) NSString *num;
/// cell
@property (nonatomic, strong) SAMSendCell *cell;

@end


@implementation SAMSendViewController

#pragma mark - life cycle
+ (void)load {
    [MGJRouter registerURLPattern:@"samos://pay" toHandler:^(NSDictionary *routerParameters) {
        NSString *token = routerParameters[@"token"];
        NSString *address = routerParameters[@"address"];
        NSString *num = routerParameters[@"amount"];
        SAMSendViewController *vc = [SAMSendViewController new];
        vc.token = token;
        vc.address = address;
        vc.num = num;
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
- (void)qrcodeBtnClicked:(UIButton *)btn {
    [self showQRCodeScanVC];
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
    SAMSendCell *cell = [tableView dequeueReusableCellWithIdentifier:SAMSendCellID];
    [cell setCellWithAddress:self.address token:self.token num:self.num];
    self.cell = cell;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowH = [SAMSendCell cellHeight];
    
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
    self.tableView.bounces = NO;
    [self.sam_navigationBar addSubview:self.qrcodeBtn];
}

- (void)registerCell {
    [SAMSendCell registerWith:self.tableView];
}

- (void)updateUI {
    SAMWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        //xxl 0.0.0 hai to haic
        NSString *tokeName = weakSelf.token;
        if([tokeName isEqualToString:@"HAI"]){
            tokeName = @"HAIC";
        }
        
        weakSelf.sam_navigationBar.title = [NSString stringWithFormat:@"%@ %@", SAM_LOCALIZED(@"language_send"),tokeName];
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
        make.height.equalTo(@([SAMSendBottomBar barHeight]));
    }];
}

/// 设置变量
- (void)setupAddressAndNum {
    self.address = self.cell.addressTextField.text;
    self.num = self.cell.numTextField.text;
}

/// 显示付款明细弹窗
- (void)showConfirmSheet {
    if (self.address.length == 0 || self.num.length == 0) {
        [SVProgressHUD showInfoWithStatus:SAM_LOCALIZED(@"language_input_address_and_amount")];
        return;
    }
    SAMSendDetailSheet *sheet = [SAMSendDetailSheet sheet];
    [sheet setSheetWithToken:self.token address:self.address num:self.num];
    [sheet show];
    SAMWeakSelf
    sheet.confirmBlock = ^{
        NSLog(@"调用转帐接口！！");
        [weakSelf sendCoin];
    };
}

/// 检测参数
- (BOOL)checkAddressAndNum {
    BOOL flag = YES;
    if (self.address.length == 0) {
        return NO;
    }
    if (self.num.length == 0) {
        return NO;
    }
    
    return flag;
}

/// 转帐
- (void)sendCoin {
    if ([self checkAddressAndNum]) {
        // 显示填写密码弹窗
        SAMSendInputPwdSheet *sheet = [SAMSendInputPwdSheet sheet];
        [sheet show];
        SAMWeakSelf
        __weak typeof(sheet) weakSheet = sheet;
        sheet.confirmBlock = ^(NSString *pwd) {
            NSString *savedPwd = [SAMWalletDB fetchPwd];
            if ([pwd isEqualToString:savedPwd]) {
                [weakSheet dismiss];
                SAMTokenInfo *token = [SAMWalletDB fetchToken:weakSelf.token];
                SAMWalletInfo *wallet = [SAMWalletDB fetchCurWallet];
                SAMWalletTokenInfo *walletToken = [SAMWalletDB fetchWalletToken:weakSelf.token fromWallet:wallet.walletName];
                NSError *error = nil;
                
                NSLog(@"coinType:%@ ",token.tokenName);
                NSString *ret = MobileSend(token.tokenName, walletToken.walletID, weakSelf.address, weakSelf.num, pwd, &error);
                NSLog(@"%@", ret);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showSuccessWithStatus:SAM_LOCALIZED(@"language_send_success")];
                });
                // 退出当前页，刷新交易记录列表页
                [[NSNotificationCenter defaultCenter] postNotificationName:SAMNotificationRefreshTradeRecordList object:nil];
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
                //xxl 0.0.1 for haichain protocal
                NSString *strCallBackURL = [HaiProtocolTool getCallBackURL];
                NSString *strOutTradeNo = [HaiProtocolTool getOutTradeNo];
                NSString *strTxid = @"";
               
                if(![strCallBackURL isEqualToString:@""]){
                    
                    if(ret != nil){
                        NSDictionary* txDict = [HaiProtocolTool jsonWithString:ret];
                        strTxid = txDict[@"txid"];
                    }
                    
                    NSString *rawSign =  [NSString stringWithFormat: @"out_trade_no=%@&key=XPQJfOgYOQufnXpM",strOutTradeNo];
                    NSMutableString *sign = [NSString stringMD5:rawSign];
                
                    NSString *httpGetURL = [NSString stringWithFormat: @"%@?trade_no=%@&out_trade_no=%@&total_amount=%@&trade_status=SUCCESS&sign=%@",
                                            strCallBackURL,strTxid,strOutTradeNo,weakSelf.num,sign];
                    
                    [HaiProtocolTool httpGetWithUrl:httpGetURL];
                    [HaiProtocolTool clearCallURLInfo];
                 
                   
                }

                
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showInfoWithStatus:SAM_LOCALIZED(@"language_password_is_wrong")];
                });
            }
        };
    }
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
                NSDictionary *param = [weakSelf parseUrlParamWithUrl:resultAsString];
                weakSelf.token = param[@"token"];
                weakSelf.address = param[@"address"];
                weakSelf.num = param[@"amount"];
                [weakSelf updateUI];
            }
        }];
    }];
    [self presentViewController:readerVC animated:YES completion:nil];
}

/// 解析url中的参数
- (NSDictionary *)parseUrlParamWithUrl:(NSString *)urlStr {
    NSMutableDictionary *param = [NSMutableDictionary new];
    // 传入url创建url组件类
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:urlStr];
    // 回调遍历所有参数，添加入字典
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [param setObject:obj.value forKey:obj.name];
    }];
    
    return param;
}

#pragma mark - QRCodeReaderDelegate
- (void)readerDidCancel:(QRCodeReaderViewController *)reader {
    [reader dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getters
- (SAMSendBottomBar *)bottomBar {
    if (!_bottomBar) {
        _bottomBar = [SAMSendBottomBar bottomBar];
        SAMWeakSelf
        _bottomBar.nextBlock = ^{
            NSLog(@"付款明细！！");
            [weakSelf setupAddressAndNum];
            [weakSelf showConfirmSheet];
        };
    }
    
    return _bottomBar;
}

- (UIButton *)qrcodeBtn {
    if (!_qrcodeBtn) {
        _qrcodeBtn = [UIButton new];
        [_qrcodeBtn setImage:[UIImage imageNamed:@"sam_home_menu_qrcode"] forState:UIControlStateNormal];
        _qrcodeBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_qrcodeBtn setTitleColor:SAM_BLUE_COLOR forState:UIControlStateNormal];
        CGFloat btnW = 50.f;
        CGFloat btnH = 44.f;
        _qrcodeBtn.frame = CGRectMake(SAM_SCREEN_WIDTH - 15.f - btnW, SAM_STATUSBAR_HEIGHT, btnW, btnH);
        [_qrcodeBtn addTarget:self action:@selector(qrcodeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _qrcodeBtn;
}

@end
