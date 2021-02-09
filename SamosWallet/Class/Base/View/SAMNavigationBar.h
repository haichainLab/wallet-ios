//
//  SAMNavigationBar.h
//  SAM
//
//  Created by zys on 2017/7/17.
//  Copyright © 2017年 XiaoBu. All rights reserved.
//

/**
 导航控制栏
 */

#import <UIKit/UIKit.h>

/// 导航栏背景色类型
typedef NS_ENUM(NSInteger, SAMNavigationBarBGColor) {
    SAMNavigationBarBGColorWhite = 0,
    SAMNavigationBarBGColorClear,
    SAMNavigationBarBGColorBlue,
};

@interface SAMNavigationBar : UIView

/// 标题Label
@property (nonatomic, strong, readonly) UILabel *titleLabel;
/// 返回图片
@property (nonatomic, strong, readonly) UIImageView *backImageView;
/// title
@property (nonatomic, copy) NSString *title;
/// bar背景颜色
@property (nonatomic, assign) SAMNavigationBarBGColor BGColor;
/// 返回按钮响应
@property (nonatomic, copy) SAMVoidBlock backBlock;
/// 背景填充色（BGColor为clear时会用到）
@property (nonatomic, strong) UIColor *BGFillColor;
/// 背景色的透明度
@property (nonatomic, assign) CGFloat BGAlpha;

/// 隐藏返回按钮
- (void)showBackBtn:(BOOL)show;
/// 显示 / 隐藏底部黑线
- (void)showBottomLine:(BOOL)show;

@end
