//
//  SAMGuideScrollViewItem.h
//  SamosWallet
//
//  Created by zys on 2018/8/28.
//  Copyright © 2018年 zys. All rights reserved.
//

/**
 引导页-图片item
 */

#import <UIKit/UIKit.h>

@interface SAMGuideScrollViewItem : UIView

/// dismiss回调
@property (nonatomic, copy) SAMVoidBlock dismissBlock;

+ (instancetype)item;
- (void)setItemWithImageName:(NSString *)imageName;
- (void)showStartBtn:(BOOL)show;

@end
