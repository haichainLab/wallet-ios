//
//  SAMBaseViewController.m
//  SamosWallet
//
//  Created by zys on 2018/8/18.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMBaseViewController.h"
#import "SAMNavigationBar.h"

@interface SAMBaseViewController ()

/// 导航栏
@property (nonatomic, strong) SAMNavigationBar *sam_navigationBar;

@end


@implementation SAMBaseViewController

#pragma mark - life cycle
- (instancetype)init {
    if (self = [super init]) {
        [self preSetupVariables];
        [self setupVariables];
    }
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self preSetupVariables];
        [self setupVariables];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self preSetupSubviews];
    [self setupSubviews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.view bringSubviewToFront:self.sam_navigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - public methods
- (void)setupVariables {
    
}

- (void)setupSubviews {}

- (void)showBackBtn:(BOOL)show {
    [self.sam_navigationBar showBackBtn:show];
}

#pragma mark - event response
- (void)backBtnClicked:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private methods
- (void)preSetupVariables {
    self.isShowNavBar = YES;
    self.navBGColor = SAMNavigationBarBGColorWhite;
}

- (void)preSetupSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavationBar];
}

- (void)setupNavationBar {
    [self.view addSubview:self.sam_navigationBar];
    self.sam_navigationBar.hidden = !self.isShowNavBar;
    self.sam_navigationBar.BGColor = self.navBGColor;
}

#pragma mark - getters / setters
- (SAMNavigationBar *)sam_navigationBar {
    if (!_sam_navigationBar) {
        SAMWeakSelf
        _sam_navigationBar = [SAMNavigationBar new];
        _sam_navigationBar.title = @"";
        _sam_navigationBar.backBlock = ^{
            if (weakSelf.presentingViewController) {
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            } else {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        };
        
        [self.view addSubview:_sam_navigationBar];
        [_sam_navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(weakSelf.view);
            make.height.equalTo(@(SAM_NAV_HEIGHT));
        }];
    }
    
    return _sam_navigationBar;
}

@end
