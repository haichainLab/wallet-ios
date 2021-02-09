//
//  SAMCoinDetailHeader.m
//  SamosWallet
//
//  Created by zys on 2018/12/1.
//  Copyright © 2018 zys. All rights reserved.
//

#import "SAMCoinDetailHeader.h"

@interface SAMCoinDetailHeader ()

@property (weak, nonatomic) IBOutlet UIImageView *coinIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *coinBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinHourLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordTitleLabel;

@end


@implementation SAMCoinDetailHeader

#pragma mark - life cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupSubviews];
}

#pragma mark - public methods
+ (instancetype)header {
    SAMCoinDetailHeader *header = [[NSBundle mainBundle] loadNibNamed:@"SAMCoinDetailHeader" owner:nil options:nil].firstObject;
    
    return header;
}

+ (CGFloat)headerHeight {
    CGFloat resultH = 0.f;
    // icon top
    resultH += 30.f;
    // icon h
    resultH += 70.f;
    // icon bottom
    resultH += 30.f;
    // title h
    resultH += 40.f;
    
    return resultH;
}

- (void)setHeaderWithModel:(SAMWalletTokenInfo *)model {
    if (model) {
        if (model.token.length > 0) {
            SAMTokenInfo *token = [SAMWalletDB fetchToken:model.token];
            if (token.tokenIcon.length > 0) {
                [self.coinIconImageView sd_setImageWithURL:[NSURL URLWithString:token.tokenIcon]];
            }
            self.coinNameLabel.text = model.token;
            //xxl 0.0.0 hai to haic
            if ([model.token isEqualToString:@"HAI"]) {
                self.coinNameLabel.text = @"HAIC";
            }
            
            if (token.coinHour) {
                self.coinHourLabel.text = [NSString stringWithFormat:@"%ld%s", (long)model.hours," CoinHour"];
            }
        }
        if (model.balance >= 0.f) {
            self.coinBalanceLabel.text = [NSString stringWithFormat:@"%.3lf", model.balance];
        }
    }
}

#pragma mark - private methods
- (void)setupSubviews {
    self.coinIconImageView.image = nil;
    self.coinBalanceLabel.text = @"";
    self.coinNameLabel.text = @"";
    self.coinHourLabel.text = @"";
    self.recordTitleLabel.text = SAM_LOCALIZED(@"language_recent_trade_record");
}

@end
