//
//  SAMWalletIconItem.m
//  SamosWallet
//
//  Created by zys on 2018/8/31.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMWalletIconItem.h"

@interface SAMWalletIconItem ()

@property (weak, nonatomic) IBOutlet UILabel *iconKeyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *iconListLabel;

@end


@implementation SAMWalletIconItem

NSString *const SAMWalletIconItemID = @"SAMWalletIconItem";

#pragma mark - life cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubviews];
}

#pragma mark - public methods
+ (void)registerWith:(UICollectionView *)collectionView {
    [collectionView registerNib:[UINib nibWithNibName:@"SAMWalletIconItem" bundle:nil] forCellWithReuseIdentifier:SAMWalletIconItemID];
}

+ (CGSize)itemSize {
    CGFloat w = SAM_SCREEN_WIDTH;
    CGFloat h = 0.f;
    // label top
    h += 20.f;
    // label h
    h += 17.f;
    // icon top
    h += 15.f;
    // icon h
    h += 100.f;
    // icon list label top
    h += 20.f;
    // icon list label h
    h += 17.f;
    // icon list label bottom
    h += 10.f;
    
    return CGSizeMake(w, h);
}

+ (UIEdgeInsets)sectionInsets {
    return UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);
}

- (void)setCellWithIconName:(NSString *)iconName {
    if (iconName && iconName.length > 0) {
        self.walletIocn = iconName;
        self.iconImageView.image = [UIImage imageNamed:self.walletIocn];
    }
}

#pragma mark - private methods
- (void)setupSubviews {
    self.iconKeyLabel.text = SAM_LOCALIZED(@"language_wallet_avatar");
    self.iconListLabel.text = SAM_LOCALIZED(@"language_select_wallet_avatar");
    self.walletIocn = @"sam_wallet_icon_0";
    self.iconImageView.image = [UIImage imageNamed:self.walletIocn];
}

@end
