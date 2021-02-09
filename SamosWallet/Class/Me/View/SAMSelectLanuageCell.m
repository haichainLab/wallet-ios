//
//  SAMSelectLanuageCell.m
//  SamosWallet
//
//  Created by zys on 2018/8/21.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMSelectLanuageCell.h"

@interface SAMSelectLanuageCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightMarkImageView;

@end


@implementation SAMSelectLanuageCell

NSString *const SAMSelectLanuageCellID = @"SAMSelectLanuageCell";

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
    [tableView registerNib:[UINib nibWithNibName:@"SAMSelectLanuageCell" bundle:nil] forCellReuseIdentifier:SAMSelectLanuageCellID];
}

+ (CGFloat)cellHeight {
    CGFloat resultH = 60.f;
    
    return resultH;
}

- (void)setCellWithLanguageName:(NSString *)name
                       selected:(BOOL)selected {
    if (name && name.length > 0) {
        self.nameLabel.text = name;
    }
    self.rightMarkImageView.hidden = !selected;
}

#pragma mark - private methods
- (void)setupSubviews {
    self.nameLabel.text = @"";
    self.rightMarkImageView.hidden = YES;
}

@end
