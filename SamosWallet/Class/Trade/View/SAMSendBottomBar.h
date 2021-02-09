//
//  SAMSendBottomBar.h
//  SamosWallet
//
//  Created by zys on 2018/12/1.
//  Copyright © 2018 zys. All rights reserved.
//

/**
 转出页bottombar
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SAMSendBottomBar : UIView

@property (nonatomic, copy) SAMVoidBlock nextBlock;

+ (instancetype)bottomBar;
+ (CGFloat)barHeight;

@end

NS_ASSUME_NONNULL_END
