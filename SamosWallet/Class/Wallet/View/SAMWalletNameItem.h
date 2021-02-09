//
//  SAMWalletNameItem.h
//  SamosWallet
//
//  Created by zys on 2018/8/31.
//  Copyright © 2018年 zys. All rights reserved.
//

/**
 创建钱包-钱包名称item
 */

#import <UIKit/UIKit.h>

@interface SAMWalletNameItem : UICollectionViewCell

/// 钱包名称
@property (nonatomic, copy) NSString *walletName;

+ (void)registerWith:(UICollectionView *)collectionView;
+ (CGSize)itemSize;
+ (UIEdgeInsets)sectionInsets;

extern NSString *const SAMWalletNameItemID;

@end
