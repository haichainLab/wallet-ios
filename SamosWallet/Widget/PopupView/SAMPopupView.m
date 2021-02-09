//
//  SAMPopupView.m
//  SAM
//
//  Created by zys on 2017/5/11.
//  Copyright © 2017年 XiaoBu. All rights reserved.
//

#import "SAMPopupView.h"
#import "SAMAppDelegate.h"

@interface SAMPopupView ()

/// 容器视图（所有view的super)
@property (nonatomic, strong) UIView *containerView;
/// 透明黑色蒙层
@property (nonatomic, strong) UIView *overlayView;

@end

@implementation SAMPopupView

NSTimeInterval const SAMPopupDuration = .25f;

#pragma mark - init
- (instancetype)init {
    if (self = [super init]) {
        [self setupVariables];
        [self setupSubviews];
        [self placeSubviews];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupVariables];
    [self setupSubviews];
    [self placeSubviews];
}

#pragma mark - show / dismiss
+ (instancetype)popView {
    return nil;
}

- (void)show {
    /// 已经有弹窗的情况下，不再弹新的
    if ([self.class hasOriginalPopView]) {
        return;
    }
    SAMAppDelegate *appD = (SAMAppDelegate *)[UIApplication sharedApplication].delegate;
    [appD.window addSubview:self.containerView];
    SAMWeakSelf
    self.containerView.alpha = .0f;
    self.overlayView.alpha = .0f;
    if (self.allowAnimation) {
        self.transform = CGAffineTransformMakeScale(.1f, .1f);
    }
    [UIView animateWithDuration:SAMPopupDuration / 2.f animations:^{
        weakSelf.containerView.alpha = 1.f;
        weakSelf.overlayView.alpha = weakSelf.overlayAlpha;
        if (weakSelf.allowAnimation) {
            weakSelf.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
        }
    } completion:^(BOOL finished) {
        if (weakSelf.allowAnimation) {
            [UIView animateWithDuration:SAMPopupDuration / 2.f animations:^{
                weakSelf.transform = CGAffineTransformMakeScale(.9f, .9f);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:SAMPopupDuration animations:^{
                    weakSelf.transform = CGAffineTransformIdentity;
                }];
            }];
        }
    }];
}

- (void)dismiss {
    [self dismissCompletion:nil];
}

- (void)dismissCompletion:(SAMVoidBlock)completion {
    SAMWeakSelf
    [UIView animateWithDuration:SAMPopupDuration animations:^{
        weakSelf.containerView.alpha = 0.f;
        weakSelf.overlayView.alpha = 0.f;
        if (weakSelf.allowAnimation) {
            weakSelf.transform = CGAffineTransformMakeScale(.1f, .1f);
        }
    } completion:^(BOOL finished) {
        [weakSelf.containerView removeFromSuperview];
        if (completion) {
            completion();
        }
        if (weakSelf.dismissBlock) {
            weakSelf.dismissBlock();
        }
    }];
}

#pragma mark - event response
- (void)clickOverlayView:(UITapGestureRecognizer *)tap {
    [self dismiss];
}

#pragma mark - layout
- (void)setupVariables {
    self.allowTapGesture = YES;
    self.allowAnimation = YES;
    self.overlayAlpha = .7f;
}

- (void)setupSubviews {
    
}

- (void)placeSubviews {
    [self.containerView addSubview:self.overlayView];
    [self.containerView addSubview:self];
}
/// 移除已有视图
+ (void)removeOldView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    for (UIView *view in window.subviews) {
        if (view.tag == SAMPopupViewContainerViewTag) {
            [view removeFromSuperview];
        }
    }
}
/// 是否已经有弹窗
+ (BOOL)hasOriginalPopView {
    BOOL flag = NO;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    for (UIView *view in window.subviews) {
        if (view.tag == SAMPopupViewContainerViewTag) {
            flag = YES;
            break;
        }
    }
    
    return flag;
}
#pragma mark - getters / setters
- (void)setAllowTapGesture:(BOOL)allowTapGesture {
    _allowTapGesture = allowTapGesture;
    _overlayView.userInteractionEnabled = allowTapGesture;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:SAM_SCREEN_BOUNDS];
        _containerView.backgroundColor = [UIColor clearColor];
        _containerView.tag = SAMPopupViewContainerViewTag;
    }
    
    return _containerView;
}

- (UIView *)overlayView {
    if (!_overlayView) {
        _overlayView = [[UIView alloc] initWithFrame:SAM_SCREEN_BOUNDS];
        [self.containerView addSubview:_overlayView];
        _overlayView.backgroundColor = [UIColor blackColor];
        _overlayView.alpha = 0.f;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOverlayView:)];
        singleTap.delaysTouchesBegan = YES;
        [_overlayView addGestureRecognizer:singleTap];
    }
    
    return _overlayView;
}

- (void)setHideOverlay:(BOOL)hideOverlay {
    _hideOverlay = hideOverlay;
    self.overlayView.hidden = hideOverlay;
}

@end
