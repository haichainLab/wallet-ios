//
//  SAMWalletIconListItem.h
//  SamosWallet
//
//  Created by zys on 2018/8/31.
//  Copyright © 2018年 zys. All rights reserved.
//

/**
 创建钱包-钱包icon item
 */

#import <UIKit/UIKit.h>

@interface SAMWalletIconListItem : UICollectionViewCell

+ (void)registerWith:(UICollectionView *)collectionView;
+ (CGSize)itemSize;
+ (UIEdgeInsets)sectionInsets;
+ (CGFloat)hSpacing;
+ (CGFloat)vSpacing;
- (void)setCellWithIconName:(NSString *)iconName;

extern NSString *const SAMWalletIconListItemID;

@end
