//
//  HJFPunctuationTabBarButton.m
//  HJFCustomLoginKeyboardDemo
//
//  Created by hjfrun on 16/7/14.
//  Copyright © 2016年 hjfrun. All rights reserved.
//

#import "UIImage+ImageWithColor.h"
#import "HJFPunctuationTabBarButton.h"

@implementation HJFPunctuationTabBarButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
        [self setTitleColor:[UIColor colorWithRed:100 / 255.f green:100 / 255.f blue:100 / 255.f alpha:1.f] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:214 / 255.f green:216 / 255.f blue:220/ 255.f alpha:1.f]] forState:UIControlStateDisabled];
        [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:248 / 255.f green:248 / 255.f blue:248 / 255.f alpha:1.f]] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return self;
}




@end
