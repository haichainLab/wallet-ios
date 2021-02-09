//
//  SAMSendBottomBar
//  SamosWallet
//
//  Created by zys on 2018/12/1.
//  Copyright © 2018 zys. All rights reserved.
//

#import "SAMSendBottomBar.h"

@interface SAMSendBottomBar ()

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end


@implementation SAMSendBottomBar

#pragma mark - life cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupSubviews];
}

#pragma mark - public methods
+ (instancetype)bottomBar {
    SAMSendBottomBar *view = [[NSBundle mainBundle] loadNibNamed:@"SAMSendBottomBar" owner:nil options:nil].firstObject;
    
    return view;
}

+ (CGFloat)barHeight {
    CGFloat resultH = 0.f;
    // btn h
    resultH += 40.f;
    // btn bottom
    resultH += 20.f;
    
    return resultH;
}

#pragma mark - event response
- (IBAction)nextBtnClicked:(id)sender {
    if (self.nextBlock) {
        self.nextBlock();
    }
}

#pragma mark - private methods
- (void)setupSubviews {
    self.nextBtn.layer.borderColor = SAM_BLUE_COLOR.CGColor;
    [self.nextBtn setTitle:SAM_LOCALIZED(@"language_next_big") forState:UIControlStateNormal];
}

@end
