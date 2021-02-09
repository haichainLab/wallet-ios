//
//  SAMPopupView.h
//  SAM
//
//  Created by zys on 2017/5/11.
//  Copyright © 2017年 XiaoBu. All rights reserved.
//

/**
 项目里所有弹出视图的基类
 */

#import <UIKit/UIKit.h>

#define SAMPopupViewContainerViewTag 1313


@interface SAMPopupView : UIView

/// self的父视图（直接添加在window上的view）
@property (nonatomic, strong, readonly) UIView *containerView;
/// 透明黑色蒙层
@property (nonatomic, strong, readonly) UIView *overlayView;
/// 是否允许弹出动画（缺省为YES）
@property (nonatomic, assign) BOOL allowAnimation;
/// 是否允许点击消失（缺省为YES）
@property (nonatomic, assign) BOOL allowTapGesture;
/// 是否隐藏overlayView，缺省不隐藏
@property (nonatomic, assign) BOOL hideOverlay;
/// 蒙层显示时的透明度，默认0.7
@property (nonatomic, assign) CGFloat overlayAlpha;
/// 监听dismiss事件
@property (nonatomic, copy) SAMVoidBlock dismissBlock;


/**
 创建实例，子类实现

 @return 子类实例
 */
+ (instancetype)popView;

/**
 子类重写，记得调用[super setupVariables];
 */
- (void)setupVariables;

/**
 子类重写，记得调用[super setupSubviews];
 */
- (void)setupSubviews;

/**
 布局方法，由子类重写来布局视图（主要是self）
 注意：调用前，请先调用父类的方法（父类里实现了addSubview），这样子类调用masonry才不会出问题
 */
- (void)placeSubviews;

- (void)show;
- (void)dismiss;
- (void)dismissCompletion:(SAMVoidBlock)completion;

@end
