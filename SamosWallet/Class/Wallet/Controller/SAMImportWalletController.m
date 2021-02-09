//
//  SAMImportWalletController.m
//  SamosWallet
//
//  Created by zys on 2018/8/30.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMImportWalletController.h"
#import "SAMWalletNameItem.h"
#import "SAMWalletIconItem.h"
#import "SAMWalletIconListItem.h"
#import "SAMWalletMemorizingWordsItem.h"

@interface SAMImportWalletController ()

/// 导入按钮
@property (nonatomic, strong) UIButton *importBtn;
/// icon name array
@property (nonatomic, strong) NSArray *iconNameArray;
/// 默认icon
@property (nonatomic, copy) NSString *walletIcon;
/// 助记词cell
@property (nonatomic, strong) SAMWalletMemorizingWordsItem *wordsCell;
/// 钱包名称cell
@property (nonatomic, strong) SAMWalletNameItem *nameCell;
/// 钱包icon cell
@property (nonatomic, strong) SAMWalletIconItem *iconCell;

@end


@implementation SAMImportWalletController

#pragma mark - life cycle
+ (void)load {
    [MGJRouter registerURLPattern:@"samwallet://import_wallet" toHandler:^(NSDictionary *routerParameters) {
        SAMImportWalletController *vc = [SAMImportWalletController new];
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
    // 子类重写
}

- (void)loadMoreDataWithCompletionHandler:(void (^)(BOOL hasMoreData))completion {
    // 子类重写
}

#pragma mark - event response
- (void)importBtnClicked:(UIButton *)btn {
    if ([self importWallet]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SAMControllerTool chooseRootVC];
        });
    }
}

#pragma mark - UICollectionViewdataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSInteger sectionNum = 0;
    /**
     0 - memorizing words
     1 - name
     2 - icon
     3 - icon list
     */
    sectionNum = 4;
    
    return sectionNum;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger itemNum = 0;
    switch (section) {
        case 0: {
            // memorizing words
            itemNum = 1;
        }
            break;
            
        case 1: {
            // name
            itemNum = 1;
        }
            break;
            
        case 2: {
            // icon
            itemNum = 1;
        }
            break;
            
        case 3: {
            // icon list
            itemNum = self.iconNameArray.count;
        }
            break;
            
        default:
            break;
    }
    
    return itemNum;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = nil;
    switch (indexPath.section) {
        case 0: {
            // memorizing words
            cell = [self loadWordsCell:indexPath];
        }
            break;
            
        case 1: {
            // name
            cell = [self loadNameCell:indexPath];
        }
            break;
            
        case 2: {
            // icon
            cell = [self loadIconCell:indexPath];
        }
            break;
            
        case 3: {
            // icon list
            cell = [self loadIconListCell:indexPath];
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            // memorizing words
            
        }
            break;
            
        case 1: {
            // name
            
        }
            break;
            
        case 2: {
            // icon
        }
            break;
            
        case 3: {
            // icon list
            if (indexPath.row < self.iconNameArray.count) {
                self.walletIcon = self.iconNameArray[indexPath.row];
                [self updateUI];
            }
        }
            break;
            
        default:
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeZero;
    switch (indexPath.section) {
        case 0: {
            // memorizing words
            size = [SAMWalletMemorizingWordsItem itemSize];
        }
            break;
            
        case 1: {
            // name
            size = [SAMWalletNameItem itemSize];
        }
            break;
            
        case 2: {
            // icon
            size = [SAMWalletIconItem itemSize];
        }
            break;
            
        case 3: {
            // icon list
            size = [SAMWalletIconListItem itemSize];
        }
            break;
            
        default:
            break;
    }
    
    return size;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    switch (section) {
        case 0: {
            // memorizing words
            insets = [SAMWalletMemorizingWordsItem sectionInsets];
        }
            break;
            
        case 1: {
            // name
            insets = [SAMWalletNameItem sectionInsets];
        }
            break;
            
        case 2: {
            // icon
            insets = [SAMWalletIconItem sectionInsets];
        }
            break;
            
        case 3: {
            // icon list
            insets = [SAMWalletIconListItem sectionInsets];
        }
            break;
            
        default:
            break;
    }
    
    return insets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    CGFloat spacing = 0.f;
    switch (section) {
        case 0: {
            // memorizing words
            
        }
            break;
            
        case 1: {
            // name
        }
            break;
            
        case 2: {
            // icon
        }
            break;
            
        case 3: {
            // icon list
            spacing = [SAMWalletIconListItem hSpacing];
        }
            break;
            
        default:
            break;
    }
    
    return spacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    CGFloat spacing = 0.f;
    switch (section) {
        case 0: {
            // memorizing words
        }
            break;
            
        case 1: {
            // name
        }
            break;
            
        case 2: {
            // icon
        }
            break;
            
        case 3: {
            // icon list
            spacing = [SAMWalletIconListItem vSpacing];
        }
            break;
            
        default:
            break;
    }
    
    return spacing;
}

#pragma mark - private methods
- (void)setupVariables {
    [super setupVariables];
    self.navBGColor = SAMNavigationBarBGColorWhite;
    self.walletIcon = self.iconNameArray.firstObject;
}

- (void)setupSubviews {
    [super setupSubviews];
    [self setupNav];
}

- (void)registerCell {
    [SAMWalletMemorizingWordsItem registerWith:self.collectionView];
    [SAMWalletNameItem registerWith:self.collectionView];
    [SAMWalletIconItem registerWith:self.collectionView];
    [SAMWalletIconListItem registerWith:self.collectionView];
}

- (void)updateUI {
    SAMWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.collectionView reloadData];
    });
}

- (void)setupNav {
    self.sam_navigationBar.title = SAM_LOCALIZED(@"language_load_wallet");
    [self.sam_navigationBar addSubview:self.importBtn];
}

/// 加载助记词cell
- (UICollectionViewCell *)loadWordsCell:(NSIndexPath *)indexPath {
    SAMWalletMemorizingWordsItem *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:SAMWalletMemorizingWordsItemID forIndexPath:indexPath];
    self.wordsCell = cell;
    
    return cell;
}

/// 加载name cell
- (UICollectionViewCell *)loadNameCell:(NSIndexPath *)indexPath {
    SAMWalletNameItem *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:SAMWalletNameItemID forIndexPath:indexPath];
    self.nameCell = cell;
    
    return cell;
}

/// 加载icon cell
- (UICollectionViewCell *)loadIconCell:(NSIndexPath *)indexPath {
    SAMWalletIconItem *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:SAMWalletIconItemID forIndexPath:indexPath];
    self.iconCell = cell;
    if (self.walletIcon && self.walletIcon.length > 0) {
        [cell setCellWithIconName:self.walletIcon];
    }
    
    return cell;
}

/// 加载icon list cell
- (UICollectionViewCell *)loadIconListCell:(NSIndexPath *)indexPath {
    SAMWalletIconListItem *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:SAMWalletIconListItemID forIndexPath:indexPath];
    if (indexPath.row < self.iconNameArray.count) {
        [cell setCellWithIconName:self.iconNameArray[indexPath.row]];
    }
    
    return cell;
}

/// 检测参数
- (BOOL)checkInput {
    if (self.wordsCell.walletSeed.length == 0) {
        [SVProgressHUD showInfoWithStatus:SAM_LOCALIZED(@"language_input_mnemonics")];
        return NO;
    }
    if (self.nameCell.walletName.length == 0) {
        [SVProgressHUD showInfoWithStatus:SAM_LOCALIZED(@"language_input_wallet_name")];
        return NO;
    }
    if ([SAMWalletUtil isWalletExist:self.nameCell.walletName]) {
        [SVProgressHUD showInfoWithStatus:SAM_LOCALIZED(@"language_wallet_name_exist")];
        return NO;
    }
    
    return YES;
}

/// 创建钱包
- (BOOL)importWallet {
    BOOL flag = NO;
    if ([self checkInput]) {
        SAMTokenInfo *defaultTokenInfo = [SAMWalletDB fetchDefaultToken];
        flag = [SAMWalletUtil createWalletWithWalletName:self.nameCell.walletName walletIcon:self.iconCell.walletIocn walletSeed:self.wordsCell.walletSeed token:defaultTokenInfo];
        if (flag) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showSuccessWithStatus:SAM_LOCALIZED(@"language_import_success")];
            });
        }
    }
    
    return flag;
}

#pragma mark - getters
- (UIButton *)importBtn {
    if (!_importBtn) {
        _importBtn = [UIButton new];
        [_importBtn setTitle:SAM_LOCALIZED(@"language_import") forState:UIControlStateNormal];
        _importBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_importBtn setTitleColor:SAM_BLUE_COLOR forState:UIControlStateNormal];
        CGFloat btnW = 50.f;
        CGFloat btnH = 44.f;
        _importBtn.frame = CGRectMake(SAM_SCREEN_WIDTH - 15.f - btnW, SAM_STATUSBAR_HEIGHT, btnW, btnH);
        [_importBtn addTarget:self action:@selector(importBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _importBtn;
}

- (NSArray *)iconNameArray {
    if (!_iconNameArray) {
        NSMutableArray *tempArray = [NSMutableArray new];
        for (int i=0; i<16; i++) {
            [tempArray addObject:[NSString stringWithFormat:@"sam_wallet_icon_%ld", (long)i]];
        }
        _iconNameArray = tempArray.copy;
    }
    
    return _iconNameArray;
}

@end
