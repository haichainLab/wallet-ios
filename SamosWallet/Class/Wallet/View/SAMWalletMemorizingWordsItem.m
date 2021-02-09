//
//  SAMWalletMemorizingWordsItem.m
//  SamosWallet
//
//  Created by zys on 2018/8/31.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMWalletMemorizingWordsItem.h"

@interface SAMWalletMemorizingWordsItem () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameKeyLabel;
@property (weak, nonatomic) IBOutlet UITextView *wordsTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@end


@implementation SAMWalletMemorizingWordsItem

NSString *const SAMWalletMemorizingWordsItemID = @"SAMWalletMemorizingWordsItem";

#pragma mark - life cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubviews];
}

#pragma mark - public methods
+ (void)registerWith:(UICollectionView *)collectionView {
    [collectionView registerNib:[UINib nibWithNibName:@"SAMWalletMemorizingWordsItem" bundle:nil] forCellWithReuseIdentifier:SAMWalletMemorizingWordsItemID];
}

+ (CGSize)itemSize {
    CGFloat w = SAM_SCREEN_WIDTH;
    CGFloat h = 0.f;
    // label top
    h += 20.f;
    // label h
    h += 17.f;
    // text view top
    h += 0.f;
    // text field h
    h += 50.f;
    
    return CGSizeMake(w, h);
}

+ (UIEdgeInsets)sectionInsets {
    return UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        self.placeholderLabel.hidden = YES;
    } else {
        self.placeholderLabel.hidden = NO;
    }
}

#pragma mark - private methods
- (void)setupSubviews {
    self.nameKeyLabel.text =SAM_LOCALIZED(@"language_input_mnemonics");
    self.placeholderLabel.text = SAM_LOCALIZED(@"language_input_mnemonics");
    
    //xxl 0.0.3 首字母非大写设置
    self.wordsTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.wordsTextView.text = @"";
}

#pragma mark getters
- (NSString *)walletSeed {
    _walletSeed = [self.wordsTextView.text trime];
    
    return _walletSeed;
}

@end
