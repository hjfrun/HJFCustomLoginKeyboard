//
//  HJFPunctuationTabBar.m
//  HJFCustomLoginKeyboardDemo
//
//  Created by hjfrun on 16/7/14.
//  Copyright © 2016年 hjfrun. All rights reserved.
//

#import "HJFPunctuationTabBar.h"

NSString *const PunctuationTabBarDidClickedNotification = @"PunctuationTabBarDidClickedNotification";

@interface HJFPunctuationTabBar()

@property (nonatomic, weak) HJFPunctuationTabBarButton *selectedBtn;

@property (nonatomic, weak) HJFPunctuationTabBarButton *recentBtn;

@end

@implementation HJFPunctuationTabBar


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        _recentBtn = [self setupTabBarButtonType:HJFPunctuationTabBarButtonTypeRecent title:@"常用"];
        [self setupTabBarButtonType:HJFPunctuationTabBarButtonTypeChinese title:@"中文符"];
        [self setupTabBarButtonType:HJFPunctuationTabBarButtonTypeEnglish title:@"英文符"];
        [self setupTabBarButtonType:HJFPunctuationTabBarButtonTypeEmotion title:@"表情"];
        [self setupTabBarButtonType:HJFPunctuationTabBarButtonTypeCyberSpace title:@"网络"];
        [self setupTabBarButtonType:HJFPunctuationTabBarButtonTypeSpecial title:@"特殊"];
        [self setupTabBarButtonType:HJFPunctuationTabBarButtonTypeMath title:@"数学"];
        [self setupTabBarButtonType:HJFPunctuationTabBarButtonTypeOrder title:@"序号"];
        [self setupTabBarButtonType:HJFPunctuationTabBarButtonTypeGreekAndRussian title:@"希俄"];
        [self setupTabBarButtonType:HJFPunctuationTabBarButtonTypeArrow title:@"箭头"];
        [self setupTabBarButtonType:HJFPunctuationTabBarButtonTypeHiragana title:@"平假"];
        [self setupTabBarButtonType:HJFPunctuationTabBarButtonTypeKatakana title:@"片假"];
        [self setupTabBarButtonType:HJFPunctuationTabBarButtonTypePhonetic title:@"注音"];
        [self setupTabBarButtonType:HJFPunctuationTabBarButtonTypeRadicals title:@"部首"];
        [self setupTabBarButtonType:HJFPunctuationTabBarButtonTypeTabulation title:@"制表"];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger btnCount = self.subviews.count;
    CGFloat btnW = self.frame.size.width;
    CGFloat btnH = self.frame.size.height / btnCount;
    
    for (NSUInteger i = 0; i < btnCount; i++) {
        HJFPunctuationTabBarButton *btn = self.subviews[i];
        btn.frame = CGRectMake(0, i * btnH, btnW, btnH);
    }
}

- (void)awakeFromNib
{
    [self btnClick:self.recentBtn];
}

- (HJFPunctuationTabBarButton *)setupTabBarButtonType:(HJFPunctuationTabBarButtonType)buttonType title:(NSString *)title
{
    HJFPunctuationTabBarButton *button = [[HJFPunctuationTabBarButton alloc] init];
    button.punctuationButtonType = buttonType;
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [button setTitle:title forState:UIControlStateNormal];
    [self addSubview:button];
    
    return button;
}

- (void)btnClick:(HJFPunctuationTabBarButton *)button
{
    self.selectedBtn.enabled = YES;
    button.enabled = NO;
    self.selectedBtn = button;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(punctuationTabBar:didSelectedButtonType:)]) {
        [self.delegate punctuationTabBar:self didSelectedButtonType:button.punctuationButtonType];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PunctuationTabBarDidClickedNotification object:nil userInfo:@{@"buttonType" : @(button.punctuationButtonType)}];
}

@end
