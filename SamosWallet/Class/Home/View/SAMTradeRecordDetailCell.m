//
//  SAMTradeRecordDetailCell.m
//  SamosWallet
//
//  Created by zys on 2018/12/1.
//  Copyright © 2018 zys. All rights reserved.
//

#import "SAMTradeRecordDetailCell.h"
#import "SAMTradeRecordListModel.h"

@interface SAMTradeRecordDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *headerNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerTokenLabel;
@property (weak, nonatomic) IBOutlet UILabel *senderKeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *senderValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiverKeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiverValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *numKeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *numValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateKeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateValueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;

@end


@implementation SAMTradeRecordDetailCell

NSString *const SAMTradeRecordDetailCellID = @"SAMTradeRecordDetailCell";

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
    [tableView registerNib:[UINib nibWithNibName:@"SAMTradeRecordDetailCell" bundle:nil] forCellReuseIdentifier:SAMTradeRecordDetailCellID];
}

+ (CGFloat)cellHeight {
    CGFloat resultH = 0.f;
    resultH = SAM_SCREEN_HEIGHT - SAM_NAV_HEIGHT + SAM_TABLE_BOTTOM;
    
    return resultH;
}

- (void)setCellWithModel:(SAMTradeRecordListModel *)model explorerUrl:(NSString *)explorerUrl {
    if (model) {
        if (model.delta.length > 0) {
            self.headerNumLabel.text = model.delta;
            self.numValueLabel.text = model.delta;
        }
        if (model.token.length > 0) {
            self.headerTokenLabel.text = model.token;
        }
        if (model.outputs.length > 0) {
            self.senderValueLabel.text = model.outputs;
        }
        if (model.inputs.length > 0) {
            self.receiverValueLabel.text = model.inputs;
        }
        if (model.time > 0) {
            self.dateValueLabel.text = [SAMTool formatTimeStamp:model.time];
        }
        if (explorerUrl.length > 0) {
            NSString *qrcodeStr = [explorerUrl stringByAppendingPathComponent:model.txid];
            UIImage *image = [SAMTool genQRCodeWithString:qrcodeStr];
            self.qrCodeImageView.image = image;
        }
    }
}

#pragma mark - private methods
- (void)setupSubviews {
    self.headerNumLabel.text = @"";
    self.headerTokenLabel.text = @"";
    self.senderKeyLabel.text = SAM_LOCALIZED(@"language_trade_sender");
    self.senderValueLabel.text = @"";
    self.receiverKeyLabel.text = SAM_LOCALIZED(@"language_trade_receiver");
    self.receiverValueLabel.text = @"";
    self.numKeyLabel.text = SAM_LOCALIZED(@"language_trade_num");
    self.numValueLabel.text = @"";
    self.dateKeyLabel.text = SAM_LOCALIZED(@"language_trade_time");
    self.dateValueLabel.text = @"";
}

@end
