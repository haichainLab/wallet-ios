//
//  SAMTradeRecordDetailBottomBar.h
//  SamosWallet
//
//  Created by zys on 2018/12/1.
//  Copyright © 2018 zys. All rights reserved.
//

/**
 交易记录页bottombar
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SAMTradeRecordDetailBottomBar : UIView

@property (nonatomic, copy) SAMVoidBlock samCopyBlock;

+ (instancetype)bottomBar;
+ (CGFloat)barHeight;

@end

NS_ASSUME_NONNULL_END
