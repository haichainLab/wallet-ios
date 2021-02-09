//
//  SAMWalletMemorizingWordsItem.h
//  SamosWallet
//
//  Created by zys on 2018/8/31.
//  Copyright © 2018年 zys. All rights reserved.
//

/**
 创建钱包-钱包助记词item
 */

#import <UIKit/UIKit.h>

@interface SAMWalletMemorizingWordsItem : UICollectionViewCell

/// 助记词
@property (nonatomic, copy) NSString *walletSeed;

+ (void)registerWith:(UICollectionView *)collectionView;
+ (CGSize)itemSize;
+ (UIEdgeInsets)sectionInsets;

extern NSString *const SAMWalletMemorizingWordsItemID;

@end
