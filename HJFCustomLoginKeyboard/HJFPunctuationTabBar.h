//
//  HJFPunctuationTabBar.h
//  HJFCustomLoginKeyboardDemo
//
//  Created by hjfrun on 16/7/14.
//  Copyright © 2016年 hjfrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJFPunctuationTabBarButton.h"


extern NSString *const PunctuationTabBarDidClickedNotification;


@class HJFPunctuationTabBar;

@protocol HJFPunctuationTabBarDelegate <NSObject>

@optional

- (void)punctuationTabBar:(HJFPunctuationTabBar *)tabBar didSelectedButtonType:(HJFPunctuationTabBarButtonType)buttonType;

@end

@interface HJFPunctuationTabBar : UIView

@property (nonatomic, weak) id<HJFPunctuationTabBarDelegate> delegate;

@end
