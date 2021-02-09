//
//  SAMHomeWalletCoinCell.m
//  SamosWallet
//
//  Created by zys on 2018/8/21.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMHomeWalletCoinCell.h"

@interface SAMHomeWalletCoinCell ()

@property (weak, nonatomic) IBOutlet UIImageView *coinIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *coinNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *realValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *coinLockButton;

@end

@implementation SAMHomeWalletCoinCell

NSString *const SAMHomeWalletCoinCellID = @"SAMHomeWalletCoinCell";

- (IBAction)onLockCoin:(id)sender {
    
    //xxl 0.0.2 add for lock wallet
    //xxl for webview ip
    NSString *baseURL = @"http://192.168.2.102:1030/vip.html";
    
    NSArray<SAMWalletInfo *>* walletsInfos = [SAMWalletDB fetchAllWallets];
    NSMutableArray *tempArray = [NSMutableArray new];
    for(SAMWalletInfo * walletsInfo in walletsInfos){
         [tempArray addObject:walletsInfo.walletName];
    }
    NSString *strWalletNames = [tempArray componentsJoinedByString:@","];
    NSString* balance = [self fetchBalanceWithToken:@"HAI"];
    NSString *toURL = [[NSString alloc] initWithFormat:@"%@?coinName=HAIC&amount=%@&wallets=%@", baseURL,balance,strWalletNames];

    toURL = [toURL URLEncodedString];
    NSString *scheme = [NSString stringWithFormat:@"samwallet://hai_explorer?url=%@",toURL];
    [SAMControllerTool chooseVCWithScheme:scheme];
    
}

/// 获取余额
- (NSString *)fetchBalanceWithToken:(NSString *)token {
    NSString *balance = @"";
    SAMWalletInfo *curWallet = [SAMWalletDB fetchCurWallet];
    SAMWalletTokenInfo *walletToken = [SAMWalletDB fetchWalletToken:token fromWallet:curWallet.walletName];
    balance = [NSString stringWithFormat:@"%.3lf", walletToken.balance];
    
    return balance;
}

#pragma mark - life cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubviews];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self setupSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - public methods
+ (void)registerWith:(UITableView *)tableView {
    [tableView registerNib:[UINib nibWithNibName:@"SAMHomeWalletCoinCell" bundle:nil] forCellReuseIdentifier:SAMHomeWalletCoinCellID];
}

+ (CGFloat)cellHeight {
    CGFloat resultH = 0.f;
    // icon top
    resultH += 15.f;
    // icon h
    resultH += 60.f;
    // icon bottom
    resultH += 15.f;
    
    return resultH;
}

- (void)setCellWithModel:(SAMWalletTokenInfo *)model {
    if (model) {
        if (model.token) {
            SAMTokenInfo *token = [SAMWalletDB fetchToken:model.token];
            if (token.tokenIcon.length > 0) {
                [self.coinIconImageView sd_setImageWithURL:[NSURL URLWithString:token.tokenIcon]];
            }
            if (token.tokenName.length > 0) {
                self.coinNameLabel.text = token.tokenName.capitalizedString;
            }
            if (model.balance > 0.f) {
                self.coinValueLabel.text = [NSString stringWithFormat:@"%.3lf", model.balance];
            }
            SAMCoinRateInfo *rate = [SAMWalletDB rateForCoin:model.token];
            if (rate) {
                NSString *unit = @"¥";
                CGFloat rateUnit = rate.cny;
                NSString *curUnit = [SAMWalletDB fetchCurCoinUnit];
                if ([curUnit isEqualToString:@"USD"]) {
                    unit = @"$";
                    rateUnit = rate.usd;
                }
                
                //xxl 0.0.0 hai to haic
                NSString * tokenName = token.token;
                if([token.token isEqualToString:@"HAI"]){
                    tokenName = @"HAIC";
                }
            
                NSString *rateStr = [NSString stringWithFormat:@"1 %@ = %@ %.3lf", tokenName, unit, rateUnit];
                self.coinRateLabel.text = rateStr;
                NSString *realMoney = [NSString stringWithFormat:@"%@%.3lf", unit, model.balance * rateUnit];
                self.realValueLabel.text = realMoney;
            }
        }

        ///
        SAMWalletInfo *curWallet = [SAMWalletDB fetchCurWallet];
        BOOL isLoked = [SAMWalletDB isTokenLocked:curWallet.walletName];
        if(!isLoked){
            _coinLockButton.enabled = YES;
        }else{
            _coinLockButton.enabled = NO;
            _coinLockButton.titleLabel.textColor = [UIColor grayColor];
        }
    }
    
}

#pragma mark - private methods
- (void)setupSubviews {
    self.coinIconImageView.image = nil;
    self.coinNameLabel.text = @"";
    self.coinRateLabel.text = @"";
    self.coinValueLabel.text = @"";
    self.realValueLabel.text = @"";
}

@end
