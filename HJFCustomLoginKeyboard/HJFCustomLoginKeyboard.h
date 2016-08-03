//
//  HJFCustomLoginKeyboard.h
//  HJFCustomLoginKeyboardDemo
//
//  Created by hjfrun on 16/7/5.
//  Copyright © 2016年 hjfrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJFCustomKeyboardButton.h"

@class HJFCustomLoginKeyboard;

@protocol HJFCustomLoginKeyboardDelegate <NSObject>

@optional

/** 点击了普通按钮, 包括自负标点符号等 */
- (void)customLoginKeyboard:(HJFCustomLoginKeyboard *)customLoginKeyboard didClickAtNormalButton:(HJFCustomKeyboardButton *)button;

/** 点击了删除键 */
- (void)customLoginKeyboardDidClickedDelete:(HJFCustomLoginKeyboard *)customLoginKeyboard;

/** 点击了空格键 */
- (void)customLoginKeyboardDidClickedSpace:(HJFCustomLoginKeyboard *)customLoginKeyboard;

/** 点击了下一步按钮 */
- (void)customLoginKeyboardDidClickedNextField:(HJFCustomLoginKeyboard *)customLoginKeyboard;

/** 收起键盘 */
- (void)customLoginKeyboardDidClickedFoldUpKeyboard:(HJFCustomLoginKeyboard *)customLoginKeyboard;

/** 点击了符号面板上的标点符号 */
- (void)customLoginKeyboard:(HJFCustomLoginKeyboard *)customLoginKeyboard didClickedAtPunctuation:(NSString *)punctuation;

@end

@interface HJFCustomLoginKeyboard : UIView

@property (nonatomic, weak) id<HJFCustomLoginKeyboardDelegate> delegate;

/**
 *  键盘是否需要音效
 */
@property (nonatomic, assign) BOOL needKeyboardSoundEffect;

+ (instancetype)keyboard;

@end
