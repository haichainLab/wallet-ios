//
//  SAMActionSheet.m
//  XB
//
//  Created by zys on 2017/7/1.
//  Copyright © 2017年 Xiaobu. All rights reserved.
//

#import "SAMActionSheet.h"
#import "SAMAppDelegate.h"

@interface SAMActionSheet ()

/// 容器视图（所有view的super)
@property (nonatomic, strong) UIView *containerView;
/// 透明黑色蒙层
@property (nonatomic, strong) UIView *overlayView;
/// hide frame
@property (nonatomic, assign) CGRect hideFrame;
/// show frame
@property (nonatomic, assign) CGRect showFrame;

@end

@implementation SAMActionSheet

#pragma mark - init
- (instancetype)init {
    if (self = [super init]) {
        [self setupSubviews];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupSubviews];
}

#pragma mark - show / dismiss
- (void)show {
    SAMWeakSelf
    [self prepareToShow];
    [UIView animateWithDuration:self.animationDuration animations:^{
        weakSelf.overlayView.alpha = .5f;
        weakSelf.frame = weakSelf.showFrame;
    }];
}

- (void)dismiss {
    SAMWeakSelf
    [UIView animateWithDuration:self.animationDuration animations:^{
        weakSelf.frame = weakSelf.hideFrame;
        weakSelf.overlayView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [weakSelf.containerView removeFromSuperview];
        if (weakSelf.dismissBlock) {
            weakSelf.dismissBlock();
        }
    }];
}

#pragma mark - event response
- (void)clickOverlayView:(UITapGestureRecognizer *)tap {
    [self dismiss];
}

#pragma mark - private methods
- (void)setupSubviews {
    self.backgroundColor = [UIColor whiteColor];
    self.animationDuration = .25f;
}

- (void)prepareToShow {
    if (self.containerView.subviews.count > 0) {
        [self.containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    [self.containerView addSubview:self.overlayView];
    [self.containerView addSubview:self];
    SAMAppDelegate *appD = (SAMAppDelegate *)[UIApplication sharedApplication].delegate;
    [appD.window addSubview:self.containerView];
    self.frame = self.hideFrame;
    self.overlayView.alpha = .0f;
}

#pragma mark - getters / setters
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:SAM_SCREEN_BOUNDS];
        _containerView.backgroundColor = [UIColor clearColor];
    }
    
    return _containerView;
}

- (UIView *)overlayView {
    if (!_overlayView) {
        _overlayView = [[UIView alloc] initWithFrame:SAM_SCREEN_BOUNDS];
        _overlayView.backgroundColor = [UIColor colorFromHexRGB:@"333333"];
        _overlayView.alpha = .5f;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOverlayView:)];
        singleTap.delaysTouchesBegan = YES;
        [_overlayView addGestureRecognizer:singleTap];
    }
    
    return _overlayView;
}

- (void)setOrgSize:(CGSize)orgSize {
    _orgSize = orgSize;
    self.hideFrame = CGRectMake((SAM_SCREEN_WIDTH - orgSize.width) / 2.f, SAM_SCREEN_HEIGHT, orgSize.width, orgSize.height);
    self.showFrame = CGRectMake((SAM_SCREEN_WIDTH - orgSize.width) / 2.f, SAM_SCREEN_HEIGHT - orgSize.height, orgSize.width, orgSize.height);
}


@end
