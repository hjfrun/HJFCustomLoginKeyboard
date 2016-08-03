//
//  HJFPunctuationView.h
//  HJFCustomLoginKeyboardDemo
//
//  Created by hjfrun on 16/7/16.
//  Copyright © 2016年 hjfrun. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const PunctuationCellDidClickedNotification;

@interface HJFPunctuationView : UIView

@property (nonatomic, strong) NSArray<NSString *> *punctuations;

@end
