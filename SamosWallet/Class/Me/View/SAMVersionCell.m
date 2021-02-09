//
//  SAMVersionCell.m
//  SamosWallet
//
//  Created by zys on 2018/8/21.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMVersionCell.h"

@interface SAMVersionCell ()

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end


@implementation SAMVersionCell

NSString *const SAMVersionCellID = @"SAMVersionCell";

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
    [tableView registerNib:[UINib nibWithNibName:@"SAMVersionCell" bundle:nil] forCellReuseIdentifier:SAMVersionCellID];
}

+ (CGFloat)cellHeight {
    CGFloat resultH = 60.f;
    
    return resultH;
}

#pragma mark - private methods
- (void)setupSubviews {
    self.versionLabel.text = SAM_APP_VERSION;
    self.titleLabel.text = SAM_LOCALIZED(@"language_check_update");
}

@end
