//
//  SAMFirstManageWalletCell.m
//  SamosWallet
//
//  Created by zys on 2018/9/8.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMFirstManageWalletCell.h"

@interface SAMFirstManageWalletCell ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UIButton *createBtn;
@property (weak, nonatomic) IBOutlet UIButton *immportBtn;
@property (weak, nonatomic) IBOutlet UILabel *copyrightLabel;

@end


@implementation SAMFirstManageWalletCell

NSString *const SAMFirstManageWalletCellID = @"SAMFirstManageWalletCell";

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
    [tableView registerNib:[UINib nibWithNibName:@"SAMFirstManageWalletCell" bundle:nil] forCellReuseIdentifier:SAMFirstManageWalletCellID];
}

+ (CGFloat)cellHeight {
    CGFloat resultH = SAM_SCREEN_HEIGHT;
    
    return resultH;
}

- (void)setCellWithModel:(id)model {
    if (model) {
        
    }
}

#pragma mark - event response
- (IBAction)createBtnClicked:(id)sender {
    [SAMControllerTool chooseVCWithScheme:@"samwallet://create_wallet"];
}

- (IBAction)importBtnClicked:(id)sender {
    [SAMControllerTool chooseVCWithScheme:@"samwallet://import_wallet"];
}

#pragma mark - private methods
- (void)setupSubviews {
    self.createBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.immportBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [self setupDesc];
    [self.createBtn setTitle:SAM_LOCALIZED(@"language_create_new_wallet") forState:UIControlStateNormal];
    [self.immportBtn setTitle:SAM_LOCALIZED(@"language_import_a_wallet") forState:UIControlStateNormal];
}

- (void)setupDesc {
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:SAM_LOCALIZED(@"language_welcome_use_wallet") attributes:[self.class descAtt]];
    self.welcomeLabel.attributedText = attStr;
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
    att[NSForegroundColorAttributeName] = [UIColor whiteColor];
    att[NSFontAttributeName] = [UIFont systemFontOfSize:13.f];
    NSMutableParagraphStyle *para = [NSMutableParagraphStyle new];
    para.lineSpacing = 4.f;
    para.alignment = NSTextAlignmentCenter;
    att[NSParagraphStyleAttributeName] = para;
    
    return att;
}

@end
