//
//  SAMHomeMenuToolCell.m
//  SamosWallet
//
//  Created by zys on 2018/8/21.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMHomeMenuToolCell.h"

@interface SAMHomeMenuToolCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end


@implementation SAMHomeMenuToolCell

NSString *const SAMHomeMenuToolCellID = @"SAMHomeMenuToolCell";

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
    [tableView registerNib:[UINib nibWithNibName:@"SAMHomeMenuToolCell" bundle:nil] forCellReuseIdentifier:SAMHomeMenuToolCellID];
}

+ (CGFloat)cellHeight {
    CGFloat resultH = 60.f;
    
    return resultH;
}

- (void)setCellWithIconName:(NSString *)iconName
                      title:(NSString *)title {
    if (iconName && iconName.length > 0) {
        self.iconImageView.image = [UIImage imageNamed:iconName];
    }
    if (title && title.length > 0) {
        self.titleLabel.text = title;
    }
}

#pragma mark - private methods
- (void)setupSubviews {
    self.iconImageView.image = nil;
    self.titleLabel.text = @"";
}

@end
