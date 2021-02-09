//
//  SAMWalletIconItem.h
//  SamosWallet
//
//  Created by zys on 2018/8/31.
//  Copyright © 2018年 zys. All rights reserved.
//

/**
 创建钱包-钱包icon item
 */

#import <UIKit/UIKit.h>

@interface SAMWalletIconItem : UICollectionViewCell

/// icon
@property (nonatomic, copy) NSString *walletIocn;

+ (void)registerWith:(UICollectionView *)collectionView;
+ (CGSize)itemSize;
+ (UIEdgeInsets)sectionInsets;
- (void)setCellWithIconName:(NSString *)iconName;

extern NSString *const SAMWalletIconItemID;

@end
