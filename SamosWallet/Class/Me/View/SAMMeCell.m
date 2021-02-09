//
//  SAMMeCell.m
//  SamosWallet
//
//  Created by zys on 2018/8/21.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMMeCell.h"

@interface SAMMeCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end


@implementation SAMMeCell

NSString *const SAMMeCellID = @"SAMMeCell";

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
    [tableView registerNib:[UINib nibWithNibName:@"SAMMeCell" bundle:nil] forCellReuseIdentifier:SAMMeCellID];
}

+ (CGFloat)cellHeight {
    CGFloat resultH = 60.f;
    
    return resultH;
}

- (void)setCellWithTitle:(NSString *)title {
    if (title && title.length > 0) {
        self.titleLabel.text = title;
    }
}

#pragma mark - private methods
- (void)setupSubviews {
    self.titleLabel.text = @"";
}

@end
