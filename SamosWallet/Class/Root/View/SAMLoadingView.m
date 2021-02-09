//
//  SAMLoadingView.m
//  SamosWallet
//
//  Created by jtt on 2018/12/3.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMLoadingView.h"
#import "SAMAppConfig.h"
#import "SAMTokenUtil.h"

@interface SAMLoadingView ()

/// 倒计时秒数label
@property (weak, nonatomic) IBOutlet UILabel *secondsLabel;
/// 定时器
@property (nonatomic, strong) NSTimer *timer;
/// 倒计时秒数
@property (nonatomic, assign) NSInteger seconds;
/// 是否已经初始化成功
@property (nonatomic, assign) BOOL isInitSuccess;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;

@end


@implementation SAMLoadingView

/// 开屏时间默认时常
#define kDefaultLoadingDuration 1.f

#pragma mark - public methods
+ (instancetype)popView {
    SAMLoadingView *view = [[NSBundle mainBundle] loadNibNamed:@"SAMLoadingView" owner:nil options:nil].firstObject;
    view.allowAnimation = NO;
    view.allowTapGesture = NO;
    
    return view;
}

#pragma mark - private methods
- (void)setupSubviews {
    [super setupSubviews];
    self.welcomeLabel.text = SAM_LOCALIZED(@"language_welcome_to_hai");
    self.isInitSuccess = NO;
    self.seconds = 10;
    [self setupSecondsLabel];
    [self setupTimer];
    // 初始化钱包
    SAMWeakSelf
    [SAMAppConfig walletInitCompletion:^(BOOL success){
        weakSelf.isInitSuccess = success;
        [weakSelf handleDismiss];
    }];
}

- (void)placeSubviews {
    [super placeSubviews];
    SAMWeakSelf
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.containerView).insets(UIEdgeInsetsZero);
    }];
}

/// 释放定时器
- (void)releaseTimer {
    if (self.timer) {
        if ([self.timer isValid]) {
            [self.timer invalidate];
        }
        self.timer = nil;
    }
}

/// 设置label
- (void)setupSecondsLabel {
    self.secondsLabel.text = [NSString stringWithFormat:@"%ld", (long)self.seconds];
}

/// 设置定时器
- (void)setupTimer {
    [self releaseTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(handleTimerAction:) userInfo:nil repeats:YES];
}

/// 处理定时器事件
- (void)handleTimerAction:(NSTimer *)timer {
    if (self.seconds > 0) {
        self.seconds--;
        [self setupSecondsLabel];
        [self handleDismiss];
    } else {
        // 结束倒计时
        [self releaseTimer];
        [self handleTimeout];
    }
}

/// 处理dismiss
- (void)handleDismiss {
    if (self.isInitSuccess && 10 - self.seconds >= kDefaultLoadingDuration) {
        [self dismiss];
        [self releaseTimer];
    }
}

/// 处理超时情况
- (void)handleTimeout {
    if (self.seconds <= 0 && self.isInitSuccess == NO) {
        SAMWeakSelf
        [UIView animateWithDuration:.25f animations:^{
            weakSelf.containerView.alpha = 0.f;
            weakSelf.overlayView.alpha = 0.f;
            if (weakSelf.allowAnimation) {
                weakSelf.transform = CGAffineTransformMakeScale(.1f, .1f);
            }
        } completion:^(BOOL finished) {
            [weakSelf.containerView removeFromSuperview];
        }];
        [SAMTokenUtil showTimeoutAlert];
    }
}

@end
