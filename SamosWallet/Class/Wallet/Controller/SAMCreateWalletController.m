//
//  SAMCreateWalletController.m
//  SamosWallet
//
//  Created by zys on 2018/8/30.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMCreateWalletController.h"
#import "SAMWalletNameItem.h"
#import "SAMWalletIconItem.h"
#import "SAMWalletIconListItem.h"

@interface SAMCreateWalletController ()

/// 下一步按钮
@property (nonatomic, strong) UIButton *nextBtn;
/// icon name array
@property (nonatomic, strong) NSArray *iconNameArray;
/// 选中的图片名称，缺省为第一个
@property (nonatomic, copy) NSString *selectImageName;
/// name item
@property (nonatomic, strong) SAMWalletNameItem *nameItem;
/// icon item
@property (nonatomic, strong) SAMWalletIconItem *iconItem;

@end


@implementation SAMCreateWalletController

#pragma mark - life cycle
+ (void)load {
    [MGJRouter registerURLPattern:@"samwallet://create_wallet" toHandler:^(NSDictionary *routerParameters) {
        SAMCreateWalletController *vc = [SAMCreateWalletController new];
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

}

#pragma mark - event response
- (void)nextBtnClicked:(UIButton *)btn {
    if (self.nameItem.walletName == nil || self.nameItem.walletName.length == 0) {
        [SVProgressHUD showInfoWithStatus:SAM_LOCALIZED(@"language_input_wallet_name")];
        
        return;
    }
    if ([SAMWalletUtil isWalletExist:self.nameItem.walletName]) {
        [SVProgressHUD showInfoWithStatus:SAM_LOCALIZED(@"language_wallet_name_exist")];
        return;
    }
    
    NSString *scheme = [NSString stringWithFormat:@"samwallet://backup_words?wallet_name=%@&wallet_icon=%@&is_edit=0", self.nameItem.walletName, self.iconItem.walletIocn];
    [SAMControllerTool chooseVCWithScheme:scheme];
}

#pragma mark - UICollectionViewdataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSInteger sectionNum = 0;
    /**
     0 - name
     1 - icon
     2 - icon list
     */
    sectionNum = 3;
    
    return sectionNum;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger itemNum = 0;
    switch (section) {
        case 0: {
            // name
            itemNum = 1;
        }
            break;
            
        case 1: {
            // icon
            itemNum = 1;
        }
            break;
            
        case 2: {
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
            // name
            cell = [self loadNameCell:indexPath];
        }
            break;
            
        case 1: {
            // icon
            cell = [self loadIconCell:indexPath];
        }
            break;
            
        case 2: {
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
            // name
            
        }
            break;
            
        case 1: {
            // icon
        }
            break;
            
        case 2: {
            // icon list
            if (indexPath.row < self.iconNameArray.count) {
                self.selectImageName = self.iconNameArray[indexPath.row];
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
            // name
            size = [SAMWalletNameItem itemSize];
        }
            break;
            
        case 1: {
            // icon
            size = [SAMWalletIconItem itemSize];
        }
            break;
            
        case 2: {
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
            // name
            insets = [SAMWalletNameItem sectionInsets];
        }
            break;
            
        case 1: {
            // icon
            insets = [SAMWalletIconItem sectionInsets];
        }
            break;
            
        case 2: {
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
            // name
        }
            break;
            
        case 1: {
            // icon
        }
            break;
            
        case 2: {
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
            // name
        }
            break;
            
        case 1: {
            // icon
        }
            break;
            
        case 2: {
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
    self.selectImageName = self.iconNameArray.firstObject;
}

- (void)setupSubviews {
    [super setupSubviews];
    [self setupNav];
}

- (void)registerCell {
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
    self.sam_navigationBar.title = SAM_LOCALIZED(@"language_new_wallet");
    [self.sam_navigationBar addSubview:self.nextBtn];
}

/// 加载name cell
- (UICollectionViewCell *)loadNameCell:(NSIndexPath *)indexPath {
    SAMWalletNameItem *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:SAMWalletNameItemID forIndexPath:indexPath];
    self.nameItem = cell;
    
    return cell;
}

/// 加载icon cell
- (UICollectionViewCell *)loadIconCell:(NSIndexPath *)indexPath {
    SAMWalletIconItem *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:SAMWalletIconItemID forIndexPath:indexPath];
    self.iconItem = cell;
    if (self.selectImageName && self.selectImageName.length > 0) {
        [cell setCellWithIconName:self.selectImageName];
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

#pragma mark - getters
- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [UIButton new];
        [_nextBtn setTitle:SAM_LOCALIZED(@"language_next_small") forState:UIControlStateNormal];
        _nextBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_nextBtn setTitleColor:SAM_BLUE_COLOR forState:UIControlStateNormal];
        CGFloat btnW = 50.f;
        CGFloat btnH = 44.f;
        _nextBtn.frame = CGRectMake(SAM_SCREEN_WIDTH - 15.f - btnW, SAM_STATUSBAR_HEIGHT, btnW, btnH);
        [_nextBtn addTarget:self action:@selector(nextBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _nextBtn;
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
