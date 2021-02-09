//
//  SAMReceiveViewController.m
//  SamosWallet
//
//  Created by zys on 2018/12/1.
//  Copyright © 2018 zys. All rights reserved.
//

#import "SAMReceiveViewController.h"
#import "SAMReceiveCell.h"
#import "SAMReceiveBottomBar.h"

@interface SAMReceiveViewController ()

/// 二维码按钮
@property (nonatomic, strong) UIButton *shareBtn;
/// 背景图
@property (nonatomic, strong) UIImageView *bgImageView;
/// bottom bar
@property (nonatomic, strong) SAMReceiveBottomBar *bottomBar;
/// 转入地址
@property (nonatomic, copy) NSString *address;
/// 转入token
@property (nonatomic, copy) NSString *token;
/// cell
@property (nonatomic, strong) SAMReceiveCell *cell;

@end


@implementation SAMReceiveViewController

#pragma mark - life cycle
+ (void)load {
    [MGJRouter registerURLPattern:@"samos://receive_coin" toHandler:^(NSDictionary *routerParameters) {
        NSString *token = routerParameters[@"token"];
        NSString *address = routerParameters[@"address"];
        SAMReceiveViewController *vc = [SAMReceiveViewController new];
        vc.address = address;
        vc.token = token;
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
- (void)shareBtnClicked:(UIButton *)btn {
    UIImage *qrCodeImage = self.cell.qrcodeImageView.image;
    if (qrCodeImage) {
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[qrCodeImage] applicationActivities:nil];
        [self presentViewController:activityViewController animated:YES completion:nil];
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
    SAMReceiveCell *cell = [tableView dequeueReusableCellWithIdentifier:SAMReceiveCellID];
    [cell setCellWithAddress:self.address token:self.token];
    self.cell = cell;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowH = [SAMReceiveCell cellHeight];
    
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
    self.tableView.backgroundView = self.bgImageView;
    [self.sam_navigationBar addSubview:self.shareBtn];
}

- (void)registerCell {
    [SAMReceiveCell registerWith:self.tableView];
}

- (void)updateUI {
    SAMWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //xxl 0.0.0 hai to haic
        NSString *tokeName = weakSelf.token;
        if([tokeName isEqualToString: @"HAI"]){
            tokeName = @"HAIC";
        }
        
        NSString *titel = [NSString stringWithFormat:@"%@ %@", SAM_LOCALIZED(@"language_trade_in_small"), tokeName];
        weakSelf.sam_navigationBar.title = titel;
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
        make.height.equalTo(@([SAMReceiveBottomBar barHeight]));
    }];
}

#pragma mark - getters
- (SAMReceiveBottomBar *)bottomBar {
    if (!_bottomBar) {
        _bottomBar = [SAMReceiveBottomBar bottomBar];
        SAMWeakSelf
        _bottomBar.saveBlock = ^{
            if (weakSelf.cell.qrcodeImageView.image) {
                [[SAMTool new] savePhotoToAlbum:weakSelf.cell.qrcodeImageView.image completion:^{
                    
                }];
            }
        };
        _bottomBar.samCopyBlock = ^{
            if (weakSelf.address.length > 0) {
                [SAMTool copyToPasteboadrd:weakSelf.address];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showSuccessWithStatus:SAM_LOCALIZED(@"language_copy_success")];
                });
            }
        };
    }
    
    return _bottomBar;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sam_blue_bg"]];
    }
    
    return _bgImageView;
}

- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [UIButton new];
        [_shareBtn setTitle:SAM_LOCALIZED(@"language_share") forState:UIControlStateNormal];
        _shareBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [_shareBtn setTitleColor:SAM_BLUE_COLOR forState:UIControlStateNormal];
        CGFloat btnW = 50.f;
        CGFloat btnH = 44.f;
        _shareBtn.frame = CGRectMake(SAM_SCREEN_WIDTH - 15.f - btnW, SAM_STATUSBAR_HEIGHT, btnW, btnH);
        [_shareBtn addTarget:self action:@selector(shareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _shareBtn;
}

@end
