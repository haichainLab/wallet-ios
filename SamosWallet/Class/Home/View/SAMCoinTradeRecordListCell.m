//
//  SAMCoinTradeRecordListCell.m
//  SamosWallet
//
//  Created by zys on 2018/12/1.
//  Copyright © 2018 zys. All rights reserved.
//

#import "SAMCoinTradeRecordListCell.h"
#import "SAMTradeRecordListModel.h"

@interface SAMCoinTradeRecordListCell ()

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end


@implementation SAMCoinTradeRecordListCell

NSString *const SAMCoinTradeRecordListCellID = @"SAMCoinTradeRecordListCell";

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
    [tableView registerNib:[UINib nibWithNibName:@"SAMCoinTradeRecordListCell" bundle:nil] forCellReuseIdentifier:SAMCoinTradeRecordListCellID];
}

+ (CGFloat)cellHeight {
    CGFloat resultH = 0.f;
    // address top
    resultH += 15.f;
    // addresss h
    resultH += 20.f;
    // status top
    resultH += 5.f;
    // status h
    resultH += 20.f;
    // status bottom
    resultH += 15.f;
    
    return resultH;
}

- (void)setCellWithModel:(SAMTradeRecordListModel *)model {
    if (model) {
        if (model.txid.length > 0) {
            self.addressLabel.text = model.txid;
        }
        if (model.delta.length > 0) {
            self.numLabel.text = model.delta;
        }
        if (model.status) {
            self.statusLabel.text = @"confirmed";
        } else {
            self.statusLabel.text = @"unconfirmed";
        }
        if (model.time > 0) {
            self.dateLabel.text = [SAMTool formatTimeStamp:model.time];
        }
    }
}

#pragma mark - private methods
- (void)setupSubviews {
    self.addressLabel.text = @"";
    self.numLabel.text = @"";
    self.statusLabel.text = @"";
    self.dateLabel.text = @"";
}

@end
