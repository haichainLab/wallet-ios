//
//  SAMGuideViewController.m
//  SamosWallet
//
//  Created by zys on 2018/8/28.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMGuideViewController.h"
#import "SAMGuideScrollViewItem.h"
#import "SAMAppConfig.h"

@interface SAMGuideViewController ()

/// scroll view
@property (nonatomic, strong) UIScrollView *scrollView;
/// image name array
@property (nonatomic, strong) NSArray *imageNameArray;

@end


@implementation SAMGuideViewController

#define kShowGuideKeyFmt @"ShowGuide_%@"

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - public methods
+ (BOOL)shouldShow {
    BOOL flag = NO;
    NSString *key = [NSString stringWithFormat:kShowGuideKeyFmt, @"en"];
    if ([SAMAppConfig fetchLanguageType] == SAMLanguageTypeEN) {
        key = [NSString stringWithFormat:kShowGuideKeyFmt, @"en"];
    }
    NSString *savedFlag = [SAM_UD objectForKey:key];
    if (!savedFlag) {
        flag = YES;
    }
    
    return flag;
}

#pragma mark - private methods
- (void)setupVariables {
    [super setupVariables];
    self.isShowNavBar = NO;
    self.navBGColor = SAMNavigationBarBGColorClear;
}

- (void)setupSubviews {
    [super setupSubviews];
    [self setupGuideImageArray];
    [self showBackBtn:NO];
    [self setupScrollView];
}

/// 设置scrollview
- (void)setupScrollView {
    self.scrollView.contentSize = CGSizeMake(SAM_SCREEN_WIDTH * self.imageNameArray.count, SAM_SCREEN_HEIGHT);
    self.scrollView.contentOffset = CGPointZero;
    SAMWeakSelf
    [self.imageNameArray enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj && obj.length > 0) {
            SAMGuideScrollViewItem *item = [SAMGuideScrollViewItem item];
            [weakSelf.scrollView addSubview:item];
            [item setItemWithImageName:obj];
            item.frame = CGRectMake(idx * SAM_SCREEN_WIDTH, 0.f, SAM_SCREEN_WIDTH, SAM_SCREEN_HEIGHT);
            [item showStartBtn:(idx == weakSelf.imageNameArray.count - 1)];
            item.dismissBlock = ^{
                [weakSelf.class saveShowFlag];
                if (weakSelf.dismissBlock) {
                    weakSelf.dismissBlock();
                }
            };
        }
    }];
}

/// 保存显示flag
+ (void)saveShowFlag {
    NSString *key = [NSString stringWithFormat:kShowGuideKeyFmt, @"en"];
    if ([SAMAppConfig fetchLanguageType] == SAMLanguageTypeEN) {
        key = [NSString stringWithFormat:kShowGuideKeyFmt, @"en"];
    }
    [SAM_UD setObject:@"1" forKey:key];
    [SAM_UD synchronize];
}

/// 根据语言设置中英文引导图
- (void)setupGuideImageArray {
    self.imageNameArray = @[@"sam_guide_galt_cn_0",
                            @"sam_guide_galt_cn_1"];
//    if ([SAMAppConfig fetchLanguageType] == SAMLanguageTypeCN) {
//        self.imageNameArray = @[@"sam_guide_cn_0",
//                                @"sam_guide_cn_1",
//                                @"sam_guide_cn_2"];
//    } else {
//        self.imageNameArray = @[@"sam_guide_en_0",
//                                @"sam_guide_en_1",
//                                @"sam_guide_en_2"];
//    }
}

#pragma mark - getters
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        [self.view addSubview:_scrollView];
        _scrollView.frame = self.view.bounds;
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = YES;
        _scrollView.userInteractionEnabled = YES;
    }
    
    return _scrollView;
}

- (NSArray *)imageNameArray {
    if (!_imageNameArray) {
        _imageNameArray = @[@"sam_guide_cn_0",
                            @"sam_guide_cn_1",
                            @"sam_guide_cn_2"];
    }
    
    return _imageNameArray;
}

@end
