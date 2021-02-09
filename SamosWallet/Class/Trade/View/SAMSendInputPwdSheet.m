//
//  SAMSendInputPwdSheet.m
//  SamosWallet
//
//  Created by zys on 2018/12/2.
//  Copyright © 2018 zys. All rights reserved.
//

#import "SAMSendInputPwdSheet.h"

@interface SAMSendInputPwdSheet ()

@property (weak, nonatomic) IBOutlet UILabel *pwdKeyLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end


@implementation SAMSendInputPwdSheet

#pragma mark - life cycle
- (void)dealloc {
    [self removeObservers];
}

#pragma mark - public methods
+ (instancetype)sheet {
    SAMSendInputPwdSheet *sheet = [[NSBundle mainBundle] loadNibNamed:@"SAMSendInputPwdSheet" owner:nil options:nil].firstObject;
    sheet.orgSize = CGSizeMake(SAM_SCREEN_WIDTH, [self sheetHeight]);
    
    return sheet;
}

+ (CGFloat)sheetHeight {
    CGFloat resultH = 0.f;
    // nav h
    resultH += 44.f;
    // text top
    resultH += 20.f;
    // text h
    resultH += 17.f;
    // text field top
    resultH += 10.f;
    // text field h
    resultH += 30.f;
    // btn top
    resultH += 20.f;
    // btn h
    resultH += 40.f;
    // btn bottom
    resultH += (25.f - SAM_TABLE_BOTTOM);
    
    return resultH;
}

#pragma mark - event response
- (IBAction)closeBtnClicked:(id)sender {
    [self dismiss];
}

- (IBAction)confirmBtnClicked:(id)sender {
    if (self.confirmBlock) {
        self.confirmBlock(self.pwdTextField.text);
    }
}

#pragma mark - private methods
- (void)setupSubviews {
    [super setupSubviews];
    self.confirmBtn.layer.borderColor = SAM_BLUE_COLOR.CGColor;
    [self addObservers];
    self.titleLabel.text = SAM_LOCALIZED(@"language_wallet_pwd");
    self.pwdKeyLabel.text = SAM_LOCALIZED(@"language_pwd");
    self.pwdTextField.placeholder = SAM_LOCALIZED(@"language_input_pwd");
    [self.confirmBtn setTitle:SAM_LOCALIZED(@"language_confirm_big") forState:UIControlStateNormal];
}

#pragma mark - 监听键盘
- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

// 键盘弹出，上移self，遮挡住submit按钮
- (void)keyboardWillShow:(NSNotification *)note {
    SAMWeakSelf
    NSDictionary *userInfo = note.userInfo;
    // 动画时间
    NSValue *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration;
    [durationValue getValue:&duration];
    // 键盘高度
    NSValue *aValue = userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = aValue.CGRectValue;
    CGFloat keyboardH = keyboardRect.size.height;
    // 键盘弹出，上移self
    CGRect frame = self.frame;
    frame.origin.y = SAM_SCREEN_HEIGHT - SAM_TABLE_BOTTOM - frame.size.height - keyboardH;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.frame = frame;
    }];
}

- (void)keyboardWillHide:(NSNotification *)note {
    SAMWeakSelf
    [UIView animateWithDuration:.25f animations:^{
        weakSelf.frame = weakSelf.showFrame;
    }];
}

@end
