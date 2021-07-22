//
//  TTextView.h
//  TextViewDemo
//
//  Created by 李成明 on 2021/7/19.
//

#import <UIKit/UIKit.h>
@class TTextView;

enum CountLengthWay {
    CountByChar,
    CountByUnits
};

NS_ASSUME_NONNULL_BEGIN
@protocol TTextViewDelegate<NSObject>

@optional
- (void)textViewDidChangeForTTextView:(TTextView *)textView;
- (BOOL)textViewForTTextView:(TTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)textViewShouldReturn:(TTextView *)textView;//禁止输入回车 且 新的输入为单个回车时触发
- (void)textViewOverMaxCharacterNumForTTextView;  // 输入的字符串长度超限 时触发

- (BOOL)textViewForTTextViewShouldBeginEditing:(TTextView *)textView;
- (void)textViewForTTextViewDidBeginEditing:(TTextView *)textView;
- (void)textViewForTTextViewDidEndEditing:(TTextView *)textView;

// textView内容变化返回的高度
- (void)textViewContentChangeHeight:(CGFloat)height;
@end

@interface TTextView : UIView

@property (nonatomic, weak) id<TTextViewDelegate> textDelegate;
//textView Masonry 布局
@property (nonatomic, strong) UITextView *textView;
//最大长度 默认NSIntegerMax
@property (nonatomic, assign) CGFloat maxLength;
//已经输入的字数
@property (nonatomic, assign) NSUInteger textLength;
//是否可以输入换行 默认为NO 输入 \n会触发return
@property (nonatomic, assign) BOOL canInputReturn;
//是否随字符改变高度
@property (nonatomic, assign) BOOL isAdaptForHeight;
//最大高度 未设置即为无限大
@property (nonatomic, assign) CGFloat maxHeight;
//计算长度的方式 默认ios本身计算方式 和按照单位计算方式 即字符按照utf8字符集编码的字节长度除以三 未除尽则加0.5
@property (nonatomic, assign) enum CountLengthWay countlengthWay;

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, assign) UIKeyboardType keyboardType;
@property (nonatomic, assign) UIReturnKeyType returnKeyType;
@property (nonatomic, assign) UIEdgeInsets textContainerInset;
@property (nonatomic, assign) NSRange selectedRange;
@property (nonatomic, assign) BOOL enablesReturnKeyAutomatically;
@property (nonatomic, assign) BOOL editable;
@property (nonatomic, assign) BOOL scrollEnabled;
@property (nonatomic, strong) CALayer* textViewlayer;



//Placeholder标签
@property (nonatomic, strong) UILabel *placeholderLabel;
//Placeholder
@property (nonatomic, copy) NSString *placeholderText;

//是否展示字数标签 默认为NO
@property (nonatomic, assign) BOOL isShowLength;
//字数标签的formatter L代表现有长度 M代表最大 S代表剩余 默认为 L/M 如最多20字符输入了三个 则显示 3/20
@property (nonatomic, copy) NSString *lengthTextFormate;
// 字数标签 默认为右下角 可以自定义 自定义需要设置isShowLength为TRUE
@property (nonatomic, strong) UILabel *textLengthLable;

//是否展示del按钮 默认为NO
@property (nonatomic, assign) BOOL isShowDelButton;
//删除按钮图片视图 默认为右上角 可以自定义 自定义需要设置isShowDelImg为TRUE
@property (nonatomic, strong) UIButton *delButton;

- (BOOL)becomeFirstResponder;
- (BOOL)resignFirstResponder;
@end

NS_ASSUME_NONNULL_END
