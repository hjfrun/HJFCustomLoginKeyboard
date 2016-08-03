//
//  ViewController.m
//  HJFCustomLoginKeyboardDemo
//
//  Created by hjfrun on 16/8/3.
//  Copyright © 2016年 hjfrun. All rights reserved.
//

#import "ViewController.h"

#import "HJFCustomLoginKeyboard.h"

@interface ViewController () <HJFCustomLoginKeyboardDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, weak) HJFCustomLoginKeyboard *keyboard;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    HJFCustomLoginKeyboard *keyboard = [HJFCustomLoginKeyboard keyboard];
    keyboard.delegate = self;
    keyboard.needKeyboardSoundEffect = YES;
    self.textView.inputView = keyboard;
    self.keyboard = keyboard;
    
    [self.textView becomeFirstResponder];
    
    // 控制器view上划打开键盘音效
    UISwipeGestureRecognizer *upSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(turnOnSound)];
    upSwipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
    
    // 控制器view上划关闭键盘音效
    UISwipeGestureRecognizer *downSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(turnOffSound)];
    downSwipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.view addGestureRecognizer:upSwipeGesture];
    [self.view addGestureRecognizer:downSwipeGesture];
}


- (void)turnOnSound
{
    self.keyboard.needKeyboardSoundEffect = YES;
}

- (void)turnOffSound
{
    self.keyboard.needKeyboardSoundEffect = NO;
}


- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"text: %@", textView.text);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSLog(@"current text: %@,  text: %@", textView.text, text);
    
    return YES;
}

- (IBAction)clearText:(UIButton *)sender {
    
    self.textView.text = @"";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}



#pragma mark - HJFCustomLoginKeyboardDelegate

- (void)customLoginKeyboard:(HJFCustomLoginKeyboard *)customLoginKeyboard didClickAtNormalButton:(HJFCustomKeyboardButton *)button
{
    [self.textView insertText:button.currentTitle];
}

- (void)customLoginKeyboardDidClickedDelete:(HJFCustomLoginKeyboard *)customLoginKeyboard
{
    [self.textView deleteBackward];
}

- (void)customLoginKeyboardDidClickedSpace:(HJFCustomLoginKeyboard *)customLoginKeyboard
{
    [self.textView insertText:@" "];
}

- (void)customLoginKeyboardDidClickedNextField:(HJFCustomLoginKeyboard *)customLoginKeyboard
{
    [self.textField becomeFirstResponder];
}

- (void)customLoginKeyboardDidClickedFoldUpKeyboard:(HJFCustomLoginKeyboard *)customLoginKeyboard
{
    [self.textView resignFirstResponder];
}

- (void)customLoginKeyboard:(HJFCustomLoginKeyboard *)customLoginKeyboard didClickedAtPunctuation:(NSString *)punctuation
{
    [self.textView insertText:punctuation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
