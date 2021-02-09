//
//  SAMGuideScrollViewItem.m
//  SamosWallet
//
//  Created by zys on 2018/8/28.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMGuideScrollViewItem.h"

@interface SAMGuideScrollViewItem ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@end


@implementation SAMGuideScrollViewItem

#pragma mark - life cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupSubviews];
}

#pragma mark - public methods
+ (instancetype)item {
    SAMGuideScrollViewItem *item = [[NSBundle mainBundle] loadNibNamed:@"SAMGuideScrollViewItem" owner:nil options:nil].firstObject;
    
    return item;
}

- (void)setItemWithImageName:(NSString *)imageName {
    if (imageName && imageName.length > 0) {
        self.coverImageView.image = [UIImage imageNamed:imageName];
    }
}

- (void)showStartBtn:(BOOL)show {
    self.startBtn.hidden = !show;
}

#pragma mark - event response
- (IBAction)startBtnClicked:(id)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

#pragma mark - private methods
- (void)setupSubviews {
    self.coverImageView.image = nil;
    self.startBtn.hidden = YES;
}

@end
