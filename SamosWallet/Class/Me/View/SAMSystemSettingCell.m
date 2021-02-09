//
//  SAMSystemSettingCell.m
//  SamosWallet
//
//  Created by zys on 2018/8/21.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMSystemSettingCell.h"

@interface SAMSystemSettingCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end


@implementation SAMSystemSettingCell

NSString *const SAMSystemSettingCellID = @"SAMSystemSettingCell";

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
    [tableView registerNib:[UINib nibWithNibName:@"SAMSystemSettingCell" bundle:nil] forCellReuseIdentifier:SAMSystemSettingCellID];
}

+ (CGFloat)cellHeight {
    CGFloat resultH = 60.f;
    
    return resultH;
}

- (void)setCellWithTitle:(NSString *)title
                   value:(NSString *)value {
    if (title && title.length > 0) {
        self.titleLabel.text = title;
    }
    if (value && value.length > 0) {
        self.valueLabel.text = value;
    }
}

#pragma mark - private methods
- (void)setupSubviews {
    self.titleLabel.text = @"";
    self.valueLabel.text = @"";
}

@end
