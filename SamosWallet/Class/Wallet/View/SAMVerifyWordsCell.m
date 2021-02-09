//
//  SAMVerifyWordsCell.m
//  SamosWallet
//
//  Created by zys on 2018/9/2.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMVerifyWordsCell.h"

@interface SAMVerifyWordsCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIView *borderView;
@property (weak, nonatomic) IBOutlet UITextView *wordTextView;

@end


@implementation SAMVerifyWordsCell

NSString *const SAMVerifyWordsCellID = @"SAMVerifyWordsCell";

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
    [tableView registerNib:[UINib nibWithNibName:@"SAMVerifyWordsCell" bundle:nil] forCellReuseIdentifier:SAMVerifyWordsCellID];
}

+ (CGFloat)cellHeight {
    CGFloat resultH = 0.f;
    // title top
    resultH += 40.f;
    // title h
    resultH += 20.f;
    // desc top
    resultH += 30.f;
    // desc h
    resultH += 15;
    // border top
    resultH += 30.f;
    // words h
    resultH += 170.f;
    // btn top
    resultH += 20.f;
    // btn h
    resultH += 40.f;
    
    return resultH;
}

#pragma mark - private methods
- (void)setupSubviews {
    self.borderView.layer.borderColor = SAM_DEFAULT_FONT_COLOR.CGColor;
    self.titleLabel.text = SAM_LOCALIZED(@"language_write_seed");
    self.wordTextView.text = @"";
    self.descLabel.text = SAM_LOCALIZED(@"language_input_seed");
    self.titleLabel.text = SAM_LOCALIZED(@"language_rewrite_seed_tip");
}

#pragma mark - words
- (NSString *)words {
    _words = self.wordTextView.text;
    
    return _words;
}

@end
