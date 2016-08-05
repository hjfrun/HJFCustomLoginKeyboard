# HJFCustomLoginKeyboard

### 缘起：
产品经理脑洞不仅开得大，还开得偏😂，要求给登录用户名框增加一个自定义键盘。就是要在字母面板上再增加一行数字按键。但又不能直接加在系统自带键盘上面。

零零散散折腾了两个星期，高仿了一个自定义键盘。
以下是效果图。

![键盘效果图](http://upload-images.jianshu.io/upload_images/1417137-3eec835900c639f1.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

宗旨是尽量高仿系统键盘，除了常用的简单输入之外，还有几个要点：
* 手指按下立即弹出**气泡**；
* 手指可以在键盘上长按、滑动、轻扫，随着手指的移动气泡也跟着移动；
* 松开手指即输入字母、数字或符号；
* 中间、左边和右边气泡形状不一样，要能保证流畅滑动以及显示正确气泡；
* 主面板有**透明效果**；
* 为了给按键增加**立体感**，模仿系统键盘，在按键下方画一条弧线；
* 给按键添加音效反馈；
* 不同屏幕适配，4寸、4.7寸、5.5寸屏均能很好适配

##### 安装方法
* 手动安装，直接下载项目文件，将`HJFCustomLoginKeyboard`文件夹拖入到项目；
* pod 安装，`pod 'HJFCustomLoginKeyboard'` 

##### 使用方法
导入`HJFCustomLoginKeyboard.h`头文件，实现代理以下代理方法。

```objc

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

```
具体详细的使用方法，demo里面有，可以看看。
有什么好想法，欢迎提出。


