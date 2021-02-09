//
//  SAMSystemSettingController.m
//  SamosWallet
//
//  Created by zys on 2018/8/24.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMSystemSettingController.h"
#import "SAMSystemSettingCell.h"
#import "SAMSelectLanuageSheet.h"
#import "SAMSelectUnitSheet.h"
#import "SAMAppConfig.h"

@interface SAMSystemSettingController ()

/// 工具菜单title
@property (nonatomic, strong) NSArray *titleArray;

@end


@implementation SAMSystemSettingController

#pragma mark - life cycle
+ (void)load {
    [MGJRouter registerURLPattern:@"samwallet://system_setting" toHandler:^(NSDictionary *routerParameters) {
        SAMSystemSettingController *vc = [SAMSystemSettingController new];
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
    NSInteger rowNum = self.titleArray.count;
    
    return rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];
    if (indexPath.row == 0) {
        cell = [self loadUnitCell];
    } else {
        cell = [self loadLanguageCell];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        SAMSelectUnitSheet *sheet = [SAMSelectUnitSheet sheet];
        [sheet show];
        SAMWeakSelf
        sheet.selectBlock = ^{
            [weakSelf updateUI];
            // 更新首页
            [[NSNotificationCenter defaultCenter] postNotificationName:SAMNotificationRefreshTabBarHome object:nil];
        };
    } else {
        SAMSelectLanuageSheet *sheet = [SAMSelectLanuageSheet sheet];
        [sheet show];
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
    CGFloat rowH = [SAMSystemSettingCell cellHeight];
    
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
    
}

- (void)setupSubviews {
    [super setupSubviews];
    [self setupNav];
}

- (void)registerCell {
    [SAMSystemSettingCell registerWith:self.tableView];
}

/// 设置导航按钮
- (void)setupNav {
    self.sam_navigationBar.title = SAM_LOCALIZED(@"language_system_settings");
}

/// 更新UI
- (void)updateUI {
    SAMWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
    });
}

/// 加载币种单位cell
- (UITableViewCell *)loadUnitCell {
    SAMSystemSettingCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SAMSystemSettingCellID];
    NSString *curUnit = [SAMWalletDB fetchCurCoinUnit];
    [cell setCellWithTitle:self.titleArray.firstObject value:curUnit];
    
    return cell;
}

/// 加载语言设置cell
- (UITableViewCell *)loadLanguageCell {
    SAMSystemSettingCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SAMSystemSettingCellID];
    SAMLanguageType type = [SAMAppConfig fetchLanguageType];
    NSString *lang = (type == SAMLanguageTypeCN) ? @"中文" : @"English";
    if (self.titleArray.count > 1) {
        [cell setCellWithTitle:self.titleArray[1] value:lang];
    }
    
    return cell;
}
#pragma mark - getters
- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[SAM_LOCALIZED(@"language_pricing_unit"),
                        SAM_LOCALIZED(@"language_select_language")];
    }
    
    return _titleArray;
}

@end
