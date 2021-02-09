//
//  SAMAboutUsController.m
//  SamosWallet
//
//  Created by zys on 2018/8/24.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMAboutUsController.h"
#import "SAMAboutUsHeaderView.h"
#import "SAMVersionCell.h"

@interface SAMAboutUsController ()

/// header
@property (nonatomic, strong) SAMAboutUsHeaderView *tableHeader;

@end


@implementation SAMAboutUsController

#pragma mark - life cycle
+ (void)load {
    [MGJRouter registerURLPattern:@"samwallet://about_us" toHandler:^(NSDictionary *routerParameters) {
        SAMAboutUsController *vc = [SAMAboutUsController new];
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

#pragma mark - table header / footer refresh
- (void)loadNewDataWithCompletionHandler:(SAMVoidBlock)completion {
    [self updateUI];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowNum = 1;
    
    return rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self loadVersionCell];
    
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
    CGFloat rowH = [SAMVersionCell cellHeight];
    
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
}

- (void)registerCell {
    [SAMVersionCell registerWith:self.tableView];
}

/// 设置导航按钮
- (void)setupNav {
    self.sam_navigationBar.titleLabel.textColor = [UIColor whiteColor];
    self.sam_navigationBar.title = SAM_LOCALIZED(@"language_about_us");
}

/// 更新UI
- (void)updateUI {
    SAMWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf setupTableHeader];
        [weakSelf.tableView reloadData];
    });
}

- (void)setupTableHeader {
    self.tableView.tableHeaderView = self.tableHeader;
}

/// 加载币种cell
- (UITableViewCell *)loadVersionCell {
    SAMVersionCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SAMVersionCellID];
    
    return cell;
}

#pragma mark - getters
- (SAMAboutUsHeaderView *)tableHeader {
    if (!_tableHeader) {
        _tableHeader = [SAMAboutUsHeaderView header];
        _tableHeader.frame = CGRectMake(0.f, 0.f, SAM_SCREEN_WIDTH, [SAMAboutUsHeaderView headerHeight]);
    }
    
    return _tableHeader;
}

@end
