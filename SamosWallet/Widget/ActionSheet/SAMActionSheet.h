//
//  SAMActionSheet.h
//  SAM
//
//  Created by zys on 2017/7/1.
//  Copyright © 2017年 XiaoBu. All rights reserved.
//

/**
 项目里的自定义sheet的基类
 */

#import <UIKit/UIKit.h>

@interface SAMActionSheet : UIView

/// popview(self)'s size
@property (nonatomic, assign) CGSize orgSize;
/// animation duration
@property (nonatomic, assign) NSTimeInterval animationDuration;
/// show frame
@property (nonatomic, assign, readonly) CGRect showFrame;
/// dismiss回调
@property (nonatomic, copy) SAMVoidBlock dismissBlock;

- (void)setupSubviews;
- (void)show;
- (void)dismiss;

@end
