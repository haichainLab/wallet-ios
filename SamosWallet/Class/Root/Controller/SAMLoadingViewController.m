//
//  SAMLoadingViewController.m
//  SamosWallet
//
//  Created by zys on 2019/2/11.
//  Copyright © 2019 Samos. All rights reserved.
//

#import "SAMLoadingViewController.h"

@interface SAMLoadingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;

@end


@implementation SAMLoadingViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - private methods
- (void)setupVariables {
    [super setupVariables];
    self.isShowNavBar = NO;
}

- (void)setupSubviews {
    [super setupSubviews];
    self.welcomeLabel.text = SAM_LOCALIZED(@"language_welcome_to_hai");
}

@end
