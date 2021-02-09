//
//  SAMWalletDetailBottomBar.h
//  SamosWallet
//
//  Created by zys on 2018/12/1.
//  Copyright © 2018 zys. All rights reserved.
//

/**
 钱包详情页bottombar
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SAMWalletDetailBottomBar : UIView

@property (nonatomic, copy) SAMVoidBlock backupBlock;
@property (nonatomic, copy) SAMVoidBlock removeBlock;

+ (instancetype)bottomBar;
+ (CGFloat)barHeight;

@end

NS_ASSUME_NONNULL_END
