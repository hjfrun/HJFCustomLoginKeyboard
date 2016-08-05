//
//  HJFCustomLoginKeyboard.m
//  HJFCustomLoginKeyboardDemo
//
//  Created by hjfrun on 16/7/5.
//  Copyright © 2016年 hjfrun. All rights reserved.
//

#import "HJFCustomLoginKeyboard.h"
#import "HJFKeyboardPopView.h"
#import "HJFPunctuationTabBar.h"
#import "HJFPunctuationView.h"

#import <AVFoundation/AVFoundation.h>
#import "Constant.h"
#import "UIImage+ImageWithColor.h"


@interface HJFCustomLoginKeyboard() <HJFPunctuationTabBarDelegate>


@property (weak, nonatomic) IBOutlet HJFCustomKeyboardButton *backDeleteButton;
@property (weak, nonatomic) IBOutlet HJFCustomKeyboardButton *caseSwitchButton;
@property (weak, nonatomic) IBOutlet HJFCustomKeyboardButton *punctuationButton;
@property (weak, nonatomic) IBOutlet HJFCustomKeyboardButton *spaceButton;
@property (weak, nonatomic) IBOutlet HJFCustomKeyboardButton *foldUpKeyboardButton;
@property (weak, nonatomic) IBOutlet HJFCustomKeyboardButton *nextFieldButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *caseButtonWidthConstraint;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *buttonMarginConstraints;

@property (strong, nonatomic) IBOutletCollection(HJFCustomKeyboardButton) NSArray *letterButtons;
@property (strong, nonatomic) IBOutletCollection(HJFCustomKeyboardButton) NSArray *numberButtons;
@property (strong, nonatomic) IBOutletCollection(HJFCustomKeyboardButton) NSArray *extraPunctuationButtons;

@property (nonatomic, strong) HJFKeyboardPopView *popView;

@property (nonatomic, strong) NSTimer *deleteActionTimer;
@property (nonatomic, strong) UIView *punctuationPanel;
@property (weak, nonatomic) IBOutlet HJFPunctuationView *punctuationView;

@property (weak, nonatomic) IBOutlet HJFPunctuationTabBar *punctuationTabBar;

@property (nonatomic, strong) NSArray *normalButtons;

@property (nonatomic, assign) SystemSoundID soundID;

@property (nonatomic, strong) HJFCustomKeyboardButton *lastButton;


@end

@implementation HJFCustomLoginKeyboard



#pragma mark - Life Cycle

+ (instancetype)keyboard
{
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
    
    HJFCustomLoginKeyboard *keyboard = objects.firstObject;
    keyboard.punctuationPanel = objects.lastObject;
    
    return keyboard;
}

/**
 *  锁定键盘高度
 */
- (void)setFrame:(CGRect)frame
{
    frame.size.height = AUTO_ADAPT_SIZE_VALUE(233, 253, 283);
    [super setFrame:frame];
}

- (void)setBounds:(CGRect)bounds
{
    bounds.size.height = AUTO_ADAPT_SIZE_VALUE(233, 253, 283);
    [super setBounds:bounds];
}

- (void)awakeFromNib
{
    self.buttonHeightConstraint.constant = AUTO_ADAPT_SIZE_VALUE(36, 40, 46);
    self.caseButtonWidthConstraint.constant = self.buttonHeightConstraint.constant;
    for (NSLayoutConstraint *constraint in self.buttonMarginConstraints) {
        constraint.constant = AUTO_ADAPT_SIZE_VALUE(5, 6.5, 7.5);
    }
 
    for (HJFCustomKeyboardButton *btn in self.normalButtons) {
        btn.userInteractionEnabled = NO;
    }
    
    [self setupButtons];
    [self.backDeleteButton addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(backDeleteButtonClick:)]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(punctuationCellDidClicked:) name:PunctuationCellDidClickedNotification object:nil];
}

/**
 *  配置键盘上的特殊按键外观
 */
- (void)setupButtons
{
    UIImage *whiteBackgroundImage = [UIImage imageWithColor:[UIColor whiteColor]];
    UIImage *lightGrayBackgroundImage = [UIImage imageWithColor:[UIColor colorWithRed:170 / 255.f green:178 / 255.f blue:189 / 255.f alpha:.6f]];

    [self.backDeleteButton setBackgroundImage:whiteBackgroundImage forState:UIControlStateHighlighted];
    
    [self.nextFieldButton setBackgroundImage:whiteBackgroundImage forState:UIControlStateHighlighted];
    
    [self.foldUpKeyboardButton setBackgroundImage:whiteBackgroundImage forState:UIControlStateHighlighted];
    
    [self.spaceButton setBackgroundImage:lightGrayBackgroundImage forState:UIControlStateHighlighted];
}

- (void)dealloc
{
    [self.deleteActionTimer invalidate];
    self.deleteActionTimer = nil;
    self.popView = nil;
    AudioServicesDisposeSystemSoundID(_soundID);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Touch Responders

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.lastButton = nil;
    [self touchesMoved:touches withEvent:event]; 
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    
    if (touch.view == self.punctuationPanel || touch.view.superview == self.punctuationPanel || touch.view.superview.superview == self.punctuationPanel) {
        return;
    }
    
    CGPoint location = [touch locationInView:touch.view];
    HJFCustomKeyboardButton *btn = [self keyboardButtonWithLocation:location];
    
    if (btn) {
        self.lastButton = btn;
        [self.popView showFromButton:btn];
    }
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.popView removeFromSuperview];
    
    UITouch *touch = touches.anyObject;
    
    if (touch.view == self.punctuationPanel || touch.view.superview == self.punctuationPanel || touch.view.superview.superview == self.punctuationPanel) {
        return;
    }
    
    CGPoint location = [touch locationInView:touch.view];
    HJFCustomKeyboardButton *btn = [self keyboardButtonWithLocation:location];
    
    if (btn) {
        [self playSoundEffect];
        if (self.delegate && [self.delegate respondsToSelector:@selector(customLoginKeyboard:didClickAtNormalButton:)]) {
            [self.delegate customLoginKeyboard:self didClickAtNormalButton:btn];
        }
    } else if (self.lastButton) {
        [self playSoundEffect];
        if (self.delegate && [self.delegate respondsToSelector:@selector(customLoginKeyboard:didClickAtNormalButton:)]) {
            [self.delegate customLoginKeyboard:self didClickAtNormalButton:self.lastButton];
        }
    }
    
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.popView removeFromSuperview];
}


#pragma mark - Notifications & Timers

- (void)punctuationCellDidClicked:(NSNotification *)notification
{
    NSString *punctuation = notification.userInfo[@"punctuation"];
    [self playSoundEffect];
    if (self.delegate && [self.delegate respondsToSelector:@selector(customLoginKeyboard:didClickedAtPunctuation:)]) {
        [self.delegate customLoginKeyboard:self didClickedAtPunctuation:punctuation];
    }
}

- (void)backDeleteButtonClick:(UILongPressGestureRecognizer *)recognizer
{
    switch (recognizer.state) {
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            [self.deleteActionTimer invalidate];
            self.deleteActionTimer = nil;
            break;
        case UIGestureRecognizerStateBegan:
            self.deleteActionTimer = [NSTimer timerWithTimeInterval:0.1f target:self selector:@selector(deleteTimerAction) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.deleteActionTimer forMode:NSRunLoopCommonModes];
            
            break;
        case UIGestureRecognizerStateChanged:
            
            
        default:
            break;
    }
}

- (void)deleteTimerAction
{
    [self playSoundEffect];
    if (self.delegate && [self.delegate respondsToSelector:@selector(customLoginKeyboardDidClickedDelete:)]) {
        [self.delegate customLoginKeyboardDidClickedDelete:self];
    }
}




#pragma mark - IBAction

- (IBAction)punctuationClick:(HJFCustomKeyboardButton *)sender {
    [self playSoundEffect];
    sender.selected = !sender.isSelected;
    
    NSArray *punctations = @[@"~", @"/", @":", @";", @"(", @")", @"\"", @"\'", @"-", @"#", @"$", @"%", @"^", @"&", @"*", @"[", @"]", @"{", @"}", @"|", @"<", @">", @"+", @"=", @".", @"…"];
    NSArray *letters = @[@"q", @"w", @"e", @"r", @"t", @"y", @"u", @"i", @"o", @"p", @"a", @"s", @"d", @"f", @"g", @"h", @"j", @"k", @"l", @"z", @"x", @"c", @"v", @"b", @"n", @"m"];
    if (sender.isSelected) {
        [self.caseSwitchButton setImage:nil forState:UIControlStateNormal];
        [self.caseSwitchButton setImage:nil forState:UIControlStateSelected];
        [self.caseSwitchButton setTitle:@"更多" forState:UIControlStateNormal];
        for (NSUInteger i = 0; i < punctations.count; i++) {
            HJFCustomKeyboardButton *button = self.letterButtons[i];
            [button setTitle:punctations[i] forState:UIControlStateNormal];
        }
    } else {
        [self.caseSwitchButton setTitle:nil forState:UIControlStateNormal];
        [self.caseSwitchButton setImage:[UIImage imageNamed:@"keyboard_case_lower"] forState:UIControlStateNormal];
        [self.caseSwitchButton setImage:[UIImage imageNamed:@"keyboard_case_upper"] forState:UIControlStateSelected];
        self.caseSwitchButton.selected = NO;
        for (NSUInteger i = 0; i < letters.count; i++) {
            HJFCustomKeyboardButton *button = self.letterButtons[i];
            [button setTitle:letters[i] forState:UIControlStateNormal];
        }
    }
}

- (IBAction)backDeleteClick:(UIButton *)sender {
    [self playSoundEffect];
    if (self.delegate && [self.delegate respondsToSelector:@selector(customLoginKeyboardDidClickedDelete:)]) {
        [self.delegate customLoginKeyboardDidClickedDelete:self];
    }
    
}
- (IBAction)nextFieldClick:(UIButton *)sender {
    [self playSoundEffect];
    if (self.delegate && [self.delegate respondsToSelector:@selector(customLoginKeyboardDidClickedNextField:)]) {
        [self.delegate customLoginKeyboardDidClickedNextField:self];
    }
    
}
- (IBAction)foldUpKeyboardClick:(UIButton *)sender {
    [self playSoundEffect];
    if (self.delegate && [self.delegate respondsToSelector:@selector(customLoginKeyboardDidClickedFoldUpKeyboard:)]) {
        [self.delegate customLoginKeyboardDidClickedFoldUpKeyboard:self];
    }
}
- (IBAction)spaceClick:(HJFCustomKeyboardButton *)sender {
    [self playSoundEffect];
    if (self.delegate && [self.delegate respondsToSelector:@selector(customLoginKeyboardDidClickedSpace:)]) {
        [self.delegate customLoginKeyboardDidClickedSpace:self];
    }
}

- (IBAction)caseSwitchClick:(HJFCustomKeyboardButton *)sender {
    [self playSoundEffect];
    if ([sender.currentTitle isEqualToString:@"更多"]) {
        self.punctuationPanel.frame = self.bounds;
        [self addSubview:self.punctuationPanel];
        return;
    }
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        for (HJFCustomKeyboardButton *button in self.letterButtons) {
            [button setTitle:button.currentTitle.uppercaseString forState:UIControlStateNormal];
        }
    } else {
        for (HJFCustomKeyboardButton *button in self.letterButtons) {
            [button setTitle:button.currentTitle.lowercaseString forState:UIControlStateNormal];
        }
    }
}

- (IBAction)removePunctuationView:(UIButton *)sender {
    [self.punctuationPanel removeFromSuperview];
    
    [self punctuationClick:self.punctuationButton];
    self.caseSwitchButton.selected = NO;
}




#pragma mark - Private Methods

- (HJFCustomKeyboardButton *)keyboardButtonWithLocation:(CGPoint)location
{
    NSUInteger count = self.normalButtons.count;
    for (NSUInteger i = 0; i < count; i++) {
        HJFCustomKeyboardButton *btn = self.normalButtons[i];
        if (CGRectContainsPoint(btn.frame, location)) {
            return btn;
        }
    }
    return nil;
}

- (void)playSoundEffect
{
    if (self.needKeyboardSoundEffect) {
        AudioServicesPlaySystemSound(self.soundID);
    }
}

#pragma mark - Lazy Load

- (SystemSoundID)soundID
{
    if (_soundID == 0) {
        NSURL *soundURL = [[NSBundle mainBundle] URLForResource:@"keyboard-click-1.aiff" withExtension:nil];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(soundURL), &_soundID);
    }
    return _soundID;
}

- (NSArray *)normalButtons
{
    if (_normalButtons == nil) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.letterButtons];
        [array addObjectsFromArray:self.numberButtons];
        [array addObjectsFromArray:self.extraPunctuationButtons];
        _normalButtons = array;
    }
    return _normalButtons;
}

- (HJFKeyboardPopView *)popView
{
    if (_popView == nil) {
        _popView = [HJFKeyboardPopView popView];
    }
    return _popView;
}


@end
