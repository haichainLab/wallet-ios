//
//  SAMNavigationBar.m
//  SAM
//
//  Created by zys on 2017/7/17.
//  Copyright © 2017年 XiaoBu. All rights reserved.
//

#import "SAMNavigationBar.h"

@interface SAMNavigationBar ()

/// 返回图片
@property (nonatomic, strong) UIImageView *backImageView;
/// 返回按钮
@property (nonatomic, strong) UIButton *backBtn;
/// 标题Label
@property (nonatomic, strong) UILabel *titleLabel;
/// 底部横线
@property (nonatomic, strong) UIView *bottomLine;
/// 背景view
@property (nonatomic, strong) UIView *barBGView;

@end

@implementation SAMNavigationBar

#pragma mark - life cycle
- (instancetype)init {
    if (self = [super init]) {
        [self setupVariables];
        [self placeSubviews];
    }
    
    return self;
}

#pragma mark - public methods
- (void)showBackBtn:(BOOL)show; {
    self.backBtn.hidden = !show;
    self.backImageView.hidden = !show;
}

- (void)showBottomLine:(BOOL)show {
    if (show) {
        self.bottomLine.hidden = NO;
        [self addSubview:self.bottomLine];
    } else {
        self.bottomLine.hidden = YES;
        [self.bottomLine removeFromSuperview];
    }
    
}

#pragma mark - event response
- (void)backBtnClicked:(UIButton *)btn {
    if (self.backBlock) {
        self.backBlock();
    }
}

#pragma mark - private methods
- (void)setupVariables {
    self.BGColor = SAMNavigationBarBGColorWhite;
}

- (void)placeSubviews {
    self.backgroundColor = [UIColor clearColor];
    [self setupBGColor];
    
    [self addSubview:self.barBGView];
    [self addSubview:self.backImageView];
    [self addSubview:self.backBtn];
    [self addSubview:self.titleLabel];
    [self addSubview:self.bottomLine];
    CGFloat backIconW = 10.5f;
    CGFloat backIconH = 19.5f;
    self.barBGView.frame = CGRectMake(0.f, 0.f, SAM_SCREEN_WIDTH, SAM_NAV_HEIGHT - .7f);
    self.backImageView.frame = CGRectMake(20.f, (SAM_NAV_HEIGHT - SAM_STATUSBAR_HEIGHT - backIconH) / 2.f + SAM_STATUSBAR_HEIGHT, backIconW, backIconH);
    self.backBtn.frame = CGRectMake(0.f, 0.f, 80.f, SAM_NAV_HEIGHT);
    self.titleLabel.frame = CGRectMake(30.f, SAM_STATUSBAR_HEIGHT, SAM_SCREEN_WIDTH - 60.f, SAM_NAV_HEIGHT - SAM_STATUSBAR_HEIGHT);
    self.bottomLine.frame = CGRectMake(0.f, SAM_NAV_HEIGHT - 0.7f, SAM_SCREEN_WIDTH, .7f);
}

- (void)setupBGColor {
    switch (self.BGColor) {
        case SAMNavigationBarBGColorWhite: {
            // 白色
            self.barBGView.backgroundColor = [UIColor whiteColor];
            self.bottomLine.hidden = NO;
            self.backImageView.image = [UIImage imageNamed:@"sam_back_black"];
            self.titleLabel.textColor = SAM_DEFAULT_FONT_COLOR;
        }
            break;
          
        case SAMNavigationBarBGColorClear: {
            // 透明
            self.barBGView.backgroundColor = [UIColor clearColor];
            self.bottomLine.hidden = YES;
            self.backImageView.image = [UIImage imageNamed:@"sam_back_black"];
            self.titleLabel.textColor = SAM_DEFAULT_FONT_COLOR;
        }
            break;
            
        case SAMNavigationBarBGColorBlue: {
            // 蓝色
            self.barBGView.backgroundColor = SAM_BLUE_COLOR;
            self.bottomLine.hidden = YES;
            self.backImageView.image = [UIImage imageNamed:@"sam_back_white"];
            self.titleLabel.textColor = [UIColor whiteColor];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - getters / setters
- (UIView *)barBGView {
    if (!_barBGView) {
        _barBGView = [UIView new];
        _barBGView.backgroundColor = [UIColor whiteColor];
    }
    
    return _barBGView;
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [UIImageView new];
        _backImageView.image = [UIImage imageNamed:@"sam_back_black"];
    }
    
    return _backImageView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton new];
        _backBtn.backgroundColor = [UIColor clearColor];
        [_backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _backBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:17.f];
        _titleLabel.textColor = SAM_DEFAULT_FONT_COLOR;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _titleLabel;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = [UIColor colorFromHexRGB:@"D2D2D2"];
    }
    
    return _bottomLine;
}

- (void)setTitle:(NSString *)title {
    if (title) {
        _title = [title copy];
        self.titleLabel.text = title;
    }
}

- (void)setBGColor:(SAMNavigationBarBGColor)BGColor {
    _BGColor = BGColor;
    [self setupBGColor];
}

- (void)setBGAlpha:(CGFloat)BGAlpha {
    if (BGAlpha > 1.f) {
        BGAlpha = 1.f;
    }
    _BGAlpha = BGAlpha;
    self.barBGView.alpha = BGAlpha;
    if (BGAlpha > .1f) {
        self.barBGView.backgroundColor = self.BGFillColor;
    } else {
        self.barBGView.backgroundColor = [UIColor clearColor];
    }
}

@end
