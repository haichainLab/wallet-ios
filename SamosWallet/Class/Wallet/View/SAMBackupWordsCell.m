//
//  SAMBackupWordsCell.m
//  SamosWallet
//
//  Created by zys on 2018/9/2.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMBackupWordsCell.h"

@interface SAMBackupWordsCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIView *borderView;
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;
@property (weak, nonatomic) IBOutlet UIButton *recreateBtn;
@property (weak, nonatomic) IBOutlet UILabel *btnTitleLabel;

@end


@implementation SAMBackupWordsCell

NSString *const SAMBackupWordsCellID = @"SAMBackupWordsCell";

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
    [tableView registerNib:[UINib nibWithNibName:@"SAMBackupWordsCell" bundle:nil] forCellReuseIdentifier:SAMBackupWordsCellID];
}

+ (CGFloat)cellHeightWithWord:(NSString *)word {
    CGFloat resultH = 0.f;
    // title top
    resultH += 40.f;
    // title h
    resultH += 20.f;
    // desc top
    resultH += 30.f;
    // desc h
    resultH += [self calculateDescHeightWith:SAM_LOCALIZED(@"language_write_seed_guide")];
    // border top
    resultH += 30.f;
    // words top
    resultH += 50.f;
    // words h
    resultH += [self calculateWordHeightWith:word];
    // words bottom
    resultH += 50.f;
    // btn top
    resultH += 25.f;
    // btn h
    resultH += 44.f;
    // bottom
    resultH += 30.f;
    
    return resultH;
}

- (void)setCellWithWords:(NSString *)word {
    if (word.length > 0) {
        [self setupWord:word];
    }
}

#pragma mark - event response
- (IBAction)copyBtnClicked:(id)sender {
    if (self.wordLabel.text.length > 0) {
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        [pb setString:self.wordLabel.text];
        [SVProgressHUD showSuccessWithStatus:SAM_LOCALIZED(@"language_copy_success")];
    }
}

- (IBAction)recreateBtnClicked:(id)sender {
    if (self.recreateBlock) {
        self.recreateBlock();
    }
}

#pragma mark - private methods
- (void)setupSubviews {
    self.borderView.layer.borderColor = SAM_DEFAULT_FONT_COLOR.CGColor;
    self.recreateBtn.layer.borderColor = SAM_BLUE_COLOR.CGColor;
    self.titleLabel.text = SAM_LOCALIZED(@"language_write_seed");
    self.wordLabel.text = @"";
    [self setupDesc];
    self.btnTitleLabel.text = SAM_LOCALIZED(@"language_gen_new_seed");
}

- (void)setupWord:(NSString *)word {
    if (word.length > 0) {
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:word attributes:[self.class wordAtt]];
        self.wordLabel.attributedText = attStr;
    }
}

/// 计算word h
+ (CGFloat)calculateWordHeightWith:(NSString *)word {
    CGFloat resultH = 0.f;
    if (word && word.length > 0) {
        resultH = [word boundingRectWithSize:CGSizeMake(SAM_SCREEN_WIDTH - 80.f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[self wordAtt] context:nil].size.height + 1.f;
    }
    
    return resultH;
}

+ (NSDictionary *)wordAtt {
    NSMutableDictionary *att = [NSMutableDictionary new];
    att[NSForegroundColorAttributeName] = SAM_DEFAULT_FONT_COLOR;
    att[NSFontAttributeName] = [UIFont systemFontOfSize:16.f];
    NSMutableParagraphStyle *para = [NSMutableParagraphStyle new];
    para.lineSpacing = 4.f;
    att[NSParagraphStyleAttributeName] = para;
    
    return att;
}

- (void)setupDesc {
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:SAM_LOCALIZED(@"language_write_seed_guide") attributes:[self.class descAtt]];
    self.descLabel.attributedText = attStr;
}

/// 计算desc h
+ (CGFloat)calculateDescHeightWith:(NSString *)desc {
    CGFloat resultH = 0.f;
    if (desc && desc.length > 0) {
        resultH = [desc boundingRectWithSize:CGSizeMake(SAM_SCREEN_WIDTH - 40.f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[self descAtt] context:nil].size.height + 1.f;
    }
    
    return resultH;
}

+ (NSDictionary *)descAtt {
    NSMutableDictionary *att = [NSMutableDictionary new];
    att[NSForegroundColorAttributeName] = SAM_GRAY_COLOR;
    att[NSFontAttributeName] = [UIFont systemFontOfSize:12.f];
    NSMutableParagraphStyle *para = [NSMutableParagraphStyle new];
    para.lineSpacing = 4.f;
    att[NSParagraphStyleAttributeName] = para;
    
    return att;
}

@end
