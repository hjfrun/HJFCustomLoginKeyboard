//
//  HJFPunctuationTabBarButton.h
//  HJFCustomLoginKeyboardDemo
//
//  Created by hjfrun on 16/7/14.
//  Copyright © 2016年 hjfrun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HJFPunctuationTabBarButtonType) {
    HJFPunctuationTabBarButtonTypeRecent,            // 常用
    HJFPunctuationTabBarButtonTypeChinese,           // 中文
    HJFPunctuationTabBarButtonTypeEnglish,           // 英文
    HJFPunctuationTabBarButtonTypeEmotion,           // 表情
    HJFPunctuationTabBarButtonTypeCyberSpace,        // 网络
    HJFPunctuationTabBarButtonTypeSpecial,           // 特殊
    HJFPunctuationTabBarButtonTypeMath,              // 数学
    HJFPunctuationTabBarButtonTypeOrder,             // 序号
    HJFPunctuationTabBarButtonTypeGreekAndRussian,   // 希腊或俄语字母
    HJFPunctuationTabBarButtonTypeArrow,             // 箭头
    HJFPunctuationTabBarButtonTypeHiragana,          // 平假名
    HJFPunctuationTabBarButtonTypeKatakana,          // 片假名
    HJFPunctuationTabBarButtonTypePhonetic,          // 注音
    HJFPunctuationTabBarButtonTypeRadicals,          // 部首
    HJFPunctuationTabBarButtonTypeTabulation         // 制表
};


@interface HJFPunctuationTabBarButton : UIButton

@property (nonatomic, assign) HJFPunctuationTabBarButtonType punctuationButtonType;

@end
