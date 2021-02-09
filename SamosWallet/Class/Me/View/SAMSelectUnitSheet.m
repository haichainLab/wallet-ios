//
//  SAMSelectUnitSheet.m
//  SamosWallet
//
//  Created by zys on 2018/8/24.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMSelectUnitSheet.h"
#import "SAMSelectLanuageCell.h"

@interface SAMSelectUnitSheet () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;
/// 工具菜单title
@property (nonatomic, strong) NSArray *titleArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation SAMSelectUnitSheet

#pragma mark - public methods
+ (instancetype)sheet {
    SAMSelectUnitSheet *view = [[NSBundle mainBundle] loadNibNamed:@"SAMSelectUnitSheet" owner:nil options:nil].firstObject;
    view.orgSize = CGSizeMake(SAM_SCREEN_WIDTH, [self sheetHeight]);
    
    return view;
}

#pragma mark - load data
- (void)loadNewDataWithCompletionHandler:(SAMVoidBlock)completion {
    [self updateUI];
}

- (IBAction)closeBtnClicked:(id)sender {
    [self dismiss];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowNum = self.titleArray.count;
    
    return rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self loadLanguageCell:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.titleArray.count) {
        NSString *unit = self.titleArray[indexPath.row];
        [SAMWalletDB saveCurCoinUnit:unit];
        [self updateUI];
        if (self.selectBlock) {
            self.selectBlock();
        }
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
    CGFloat rowH = [SAMSelectLanuageCell cellHeight];
    
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
- (void)setupSubviews {
    [super setupSubviews];
    [self registerCell];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.headerTitleLabel.text = SAM_LOCALIZED(@"language_pricing_unit");
}

- (void)registerCell {
    [SAMSelectLanuageCell registerWith:self.tableView];
}

+ (CGFloat)sheetHeight {
    CGFloat resultH = 0.f;
    // header h
    resultH += 49.f;
    // table h
    resultH += [SAMSelectLanuageCell cellHeight] * 2;
    // bottom
    resultH += 50.f;
    
    return resultH;
}

/// 更新UI
- (void)updateUI {
    SAMWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
    });
}

/// 加载计价单位cell
- (UITableViewCell *)loadLanguageCell:(NSIndexPath *)indexPath {
    SAMSelectLanuageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SAMSelectLanuageCellID];
    if (indexPath.row < self.titleArray.count) {
        NSString *unit = self.titleArray[indexPath.row];
        NSString *curUnit = [SAMWalletDB fetchCurCoinUnit];
        BOOL isSelected = [unit isEqualToString:curUnit];
        [cell setCellWithLanguageName:self.titleArray[indexPath.row] selected:isSelected];
    }
    
    return cell;
}

#pragma mark - getters
- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"CNY",
                        @"USD"];
    }
    
    return _titleArray;
}

@end
