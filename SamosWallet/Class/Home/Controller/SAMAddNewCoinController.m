//
//  SAMAddNewCoinController.m
//  SamosWallet
//
//  Created by jtt on 2018/11/14.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMAddNewCoinController.h"
#import "SAMAddNewCoinCell.h"
#import "SAMTokenUtil.h"
#import "SAMTokenNode.h"

@interface SAMAddNewCoinController ()

/// 数据
@property (nonatomic, strong) SAMTokenNode *model;

@end


@implementation SAMAddNewCoinController

#pragma mark - life cycle
+ (void)load {
    [MGJRouter registerURLPattern:@"samwallet://add_coin" toHandler:^(NSDictionary *routerParameters) {
        SAMAddNewCoinController *vc = [SAMAddNewCoinController new];
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
    // 获取所有币种数据
    SAMWeakSelf
    [SAMTokenUtil loadTokenDataCompletion:^(SAMTokenNode * _Nonnull token) {
        weakSelf.model = token;
        [weakSelf updateUI];
    }];
}

- (void)loadMoreDataWithCompletionHandler:(void (^)(BOOL hasMoreData))completion {
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowNum = 0;
    if (self.model && self.model.tokens.count > 0) {
        rowNum = self.model.tokens.count;
    }
    
    return rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self loadCoinCell:indexPath];
    
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
    CGFloat rowH = [SAMAddNewCoinCell cellHeight];
    
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
    self.navBGColor = SAMNavigationBarBGColorWhite;
}

- (void)setupSubviews {
    [super setupSubviews];
    [self setupNav];
}

- (void)registerCell {
    [SAMAddNewCoinCell registerWith:self.tableView];
}

/// 设置导航按钮
- (void)setupNav {
    self.sam_navigationBar.title = SAM_LOCALIZED(@"language_new_asset");
}

/// 更新UI
- (void)updateUI {
    SAMWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
    });
}

/// 加载币种cell
- (UITableViewCell *)loadCoinCell:(NSIndexPath *)indexPath {
    SAMAddNewCoinCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SAMAddNewCoinCellID];
    if (self.model && indexPath.row < self.model.tokens.count) {
        SAMTokenInfo *token = self.model.tokens[indexPath.row];
        BOOL isSelected = [SAMTokenUtil isTokenSelected:token];
        
        //xxl 0.0.0 hai to haic
        if([token.token  isEqual: @"HAI"]){
            self.model.defaultToken = @"HAIC";
            token.token = @"HAIC";
        }
        
        [cell setCellWithModel:token
                  defaultToken:self.model.defaultToken
                    isSelected:isSelected];
        SAMWeakSelf
        cell.selectStatusBlock = ^(BOOL isSelected) {
            if (isSelected) {
                [SAMTokenUtil addNewCoin:token];
            } else {
                [SAMTokenUtil removeCoin:token];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:SAMNotificationRefreshTabBarHome object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    
    return cell;
}

@end
