//
//  SAMWalletIconListItem.m
//  SamosWallet
//
//  Created by zys on 2018/8/31.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMWalletIconListItem.h"

@interface SAMWalletIconListItem ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end


@implementation SAMWalletIconListItem

NSString *const SAMWalletIconListItemID = @"SAMWalletIconListItem";

#define kLeft 20.f
#define kSpacing 15.f

#pragma mark - life cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubviews];
}

#pragma mark - public methods
+ (void)registerWith:(UICollectionView *)collectionView {
    [collectionView registerNib:[UINib nibWithNibName:@"SAMWalletIconListItem" bundle:nil] forCellWithReuseIdentifier:SAMWalletIconListItemID];
}

+ (CGSize)itemSize {
    CGFloat w = (SAM_SCREEN_WIDTH - kLeft * 2 - kSpacing * 3) / 4.f;
    CGFloat h = w;
    
    return CGSizeMake(w, h);
}

+ (UIEdgeInsets)sectionInsets {
    return UIEdgeInsetsMake(0.f, kLeft, 0.f, kLeft);
}

+ (CGFloat)hSpacing {
    CGFloat s = kSpacing;
    
    return s;
}

+ (CGFloat)vSpacing {
    CGFloat s = kSpacing;
    
    return s;
}

- (void)setCellWithIconName:(NSString *)iconName {
    if (iconName && iconName.length > 0) {
        self.iconImageView.image = [UIImage imageNamed:iconName];
    }
}

#pragma mark - private methods
- (void)setupSubviews {
    self.iconImageView.image = nil;
    self.iconImageView.layer.cornerRadius = [self.class itemSize].width / 2.f;
}

@end
