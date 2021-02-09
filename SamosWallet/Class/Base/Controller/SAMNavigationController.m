//
//  SAMNavigationController.m
//  SamosWallet
//
//  Created by zys on 2018/8/20.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMNavigationController.h"

@interface SAMNavigationController ()

@end


@implementation SAMNavigationController

#pragma mark - life cycle
- (instancetype)init {
    if (self = [super init]) {
        [self setupVariables];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count == 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark - private methods
- (void)setupVariables {
   
}

- (void)setupSubviews {
    [self setupNav];
}

- (void)setupNav {
    self.navigationBar.hidden = YES;
}

@end
