//
//  SAMWalletNameItem.m
//  SamosWallet
//
//  Created by zys on 2018/8/31.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMWalletNameItem.h"

@interface SAMWalletNameItem ()

@property (weak, nonatomic) IBOutlet UILabel *nameKeyLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end


@implementation SAMWalletNameItem

NSString *const SAMWalletNameItemID = @"SAMWalletNameItem";

#pragma mark - life cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubviews];
}

#pragma mark - public methods
+ (void)registerWith:(UICollectionView *)collectionView {
    [collectionView registerNib:[UINib nibWithNibName:@"SAMWalletNameItem" bundle:nil] forCellWithReuseIdentifier:SAMWalletNameItemID];
}

+ (CGSize)itemSize {
    CGFloat w = SAM_SCREEN_WIDTH;
    CGFloat h = 0.f;
    // label top
    h += 20.f;
    // label h
    h += 17.f;
    // text field top
    h += 0.f;
    // text field h
    h += (15.f + 17.f + 15.f);
    
    return CGSizeMake(w, h);
}

+ (UIEdgeInsets)sectionInsets {
    return UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);
}

#pragma mark - private methods
- (void)setupSubviews {
    self.nameKeyLabel.text = SAM_LOCALIZED(@"language_wallet_name");
    self.nameTextField.placeholder = SAM_LOCALIZED(@"language_input_wallet_name");
}

#pragma mark - getters
- (NSString *)walletName {
    _walletName = self.nameTextField.text;
    
    return _walletName;
}

@end
