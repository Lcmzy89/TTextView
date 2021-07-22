//
//  TTextView.m
//  TextViewDemo
//
//  Created by 李成明 on 2021/7/19.
//

#import "TTextView.h"
#import "Masonry.h"
#import <objc/runtime.h>

@interface TTextView()<UITextViewDelegate>

@end

@implementation TTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        _maxLength = NSIntegerMax;
        _isShowLength = NO;
        _isShowDelButton = NO;
        _lengthTextFormate = @"L/M";
        _canInputReturn = NO;
        _isAdaptForHeight = NO;
        _scrollEnabled = YES;
        _maxHeight = CGFLOAT_MAX;
        _countlengthWay = CountByChar;
        [self setUI];
    }
    return self;
}

#pragma mark --setUI
- (void)setUI{
    //textView
    _textView = [[UITextView alloc] init];
    _textView.delegate = self;
    _textView.scrollEnabled = YES;
    _textView.font = [UIFont systemFontOfSize:15.0];
    _textView.layoutManager.allowsNonContiguousLayout = NO;
    _textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    //textLengthLable
    _textLengthLable = [[UILabel alloc] init];
    _textLengthLable.font = [UIFont systemFontOfSize:10];
    _textLengthLable.textColor = UIColor.lightGrayColor;
    _textLengthLable.textAlignment = NSTextAlignmentRight;
    
    //delButton
    _delButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_delButton setTintColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0]];
//    [_delButton setTitle:@"⌫" forState:UIControlStateNormal];
    [_delButton addTarget:self action:@selector(clickDelButton) forControlEvents:UIControlEventTouchUpInside];

    //textView里面有placeHolder属性
//    unsigned  int count = 0;
//    Ivar *members = class_copyIvarList([_textView class], &count);
//    for (int i = 0; i < count; i++)
//    {
//        Ivar var = members[i];
//        const char *memberAddress = ivar_getName(var);
//        const char *memberType = ivar_getTypeEncoding(var);
//        NSLog(@"address = %s ; type = %s",memberAddress,memberType);
//    }
    
    //placeholderLabel
    _placeholderLabel = [[UILabel alloc] init];
    _placeholderLabel.textColor = [UIColor lightGrayColor];
    _placeholderLabel.numberOfLines = 0;
    [_placeholderLabel sizeToFit];
    _placeholderLabel.font = _textView.font;
    [_textView addSubview:_placeholderLabel];
    [_textView setValue:_placeholderLabel forKey:@"_placeholderLabel"];
}

	
#pragma mark --setter
//设置isShowLength
- (void)setIsShowLength:(BOOL)isShowLength {
    if(isShowLength && !_isShowLength) {
        _isShowLength = isShowLength;
        [self addSubview:_textLengthLable];
        [_textLengthLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self).inset(5);
            make.right.mas_equalTo(self).inset(5);
            make.size.mas_equalTo(CGSizeMake(1, 1));
        }];
        [self setLengthLabeltext];
    }else if(!isShowLength && _isShowLength){
        _isShowLength = isShowLength;
        [_textLengthLable removeFromSuperview];
    }
}

//设置isShowDel
- (void)setIsShowDelButton:(BOOL)isShowDelButton {
    if(isShowDelButton && !_isShowDelButton) {
        _isShowDelButton = YES;
        [self addSubview:_delButton];
        [_delButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self);
            make.top.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
    }else if(!isShowDelButton && _isShowDelButton) {
        _isShowDelButton = NO;
        [_delButton removeFromSuperview];
    }
}
- (void)setLengthTextFormate:(NSString *)lengthTextFormate {
    _lengthTextFormate = lengthTextFormate;
    [self setLengthLabeltext];
}
//设置font
- (void)setFont:(UIFont *)font{
    _textView.font = font;
    _placeholderLabel.font = font;
}

//设置text
- (void)setText:(NSString *)text{
    _textView.text = text;
    [self textViewDidChange:_textView];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment{
    _textView.textAlignment = textAlignment;
}

- (void)setEditable:(BOOL)editable{
    _textView.editable = editable;
}

- (void)setReturnKeyType:(UIReturnKeyType)returnKeyType{
    _textView.returnKeyType = returnKeyType;
}

- (void)setEnablesReturnKeyAutomatically:(BOOL)enablesReturnKeyAutomatically{
    _textView.enablesReturnKeyAutomatically = enablesReturnKeyAutomatically;
}
//设置文本内边距
- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset{
    _textView.textContainerInset = textContainerInset;
}

- (void)setSelectedRange:(NSRange)selectedRange{
    _textView.selectedRange = selectedRange;
}

- (void)setTextColor:(UIColor *)textColor{
    _textView.textColor = textColor;
}

- (void)setScrollEnabled:(BOOL)scrollEnabled{
    _scrollEnabled = scrollEnabled;
    _textView.scrollEnabled = scrollEnabled;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    self.textView.keyboardType = keyboardType;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _textView.backgroundColor = backgroundColor;
}

- (void)setTintColor:(UIColor *)tintColor {
    _textView.tintColor = UIColor.yellowColor;
}

- (void)setPlaceholderText:(NSString *)placeholderText {
    _placeholderLabel.text = placeholderText;
}

- (void)setIsAdaptForHeight:(BOOL)isAdaptForHeight {
    _isAdaptForHeight = isAdaptForHeight;
    if(isAdaptForHeight) [self adaptForHeight];
}

#pragma mark --getter
// 获取字符长
- (NSUInteger)textLength{
    return [self countLength:_textView.text];
}
//获取字符
- (NSString *)text {
    return _textView.text;
}

//获取font
- (UIFont *)font {
    return _textView.font;
}

- (BOOL)editable{
    return _textView.editable;
}

- (BOOL)enablesReturnKeyAutomatically{
    return _textView.enablesReturnKeyAutomatically;
}

- (UIEdgeInsets)textContainerInset{
    return _textView.textContainerInset;
}

- (NSRange)selectedRange{
    return _textView.selectedRange;
}

- (UIColor *)textColor{
    return _textView.textColor;
}

- (UIKeyboardType)keyboardType{
    return _textView.keyboardType;
}

- (UIColor *)backgroundColor {
    return _textView.backgroundColor;
}

- (UIColor *)tintColor {
    return _textView.tintColor;
}

- (CALayer *)textViewlayer {
    return _textView.layer;
}
#pragma mark --public 方法
- (BOOL)becomeFirstResponder {
    return [_textView becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    [super resignFirstResponder];
    return [_textView resignFirstResponder];
}

#pragma mark --private 辅助方法
//计算单位数
- (CGFloat)countLength:(NSString *)str{
    switch (_countlengthWay) {
        case CountByChar:
            return str.length;
            break;
        case CountByUnits: {
            NSUInteger temp = [str lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
            return (temp%3==0)?(temp/3):(floor(temp/3.0f)+0.5);
        }
            break;
        default:
            return 0;
            break;
    }
}

//设置lengthLabel标签的字符串
- (void)setLengthLabeltext {
    NSString *temp = [_lengthTextFormate stringByReplacingOccurrencesOfString:@"L" withString:[NSString stringWithFormat:@"%d",(int)([self countLength:_textView.text])]];
    temp = [temp stringByReplacingOccurrencesOfString:@"M" withString:[NSString stringWithFormat:@"%d",(int)_maxLength]];
    temp = [temp stringByReplacingOccurrencesOfString:@"S" withString:[NSString stringWithFormat:@"%d",(int)(_maxLength -[self countLength:_textView.text])]];
    _textLengthLable.text = temp;
    NSDictionary *textAttributes = @{NSFontAttributeName:_textLengthLable.font};
    CGSize textSize = [_textLengthLable.text sizeWithAttributes:textAttributes];
    [_textLengthLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(textSize.width + 15, textSize.height));
    }];
}
//根据内容改变textView的frame
- (void)adaptForHeight {
    //实际textView显示时我们设定的宽
    CGFloat contentWidth = CGRectGetWidth(self.frame);
    //但事实上内容需要除去显示的边框值
    CGFloat broadWith    = (_textView.contentInset.left + _textView.contentInset.right
                            + _textView.textContainerInset.left
                            + _textView.textContainerInset.right
                            + _textView.textContainer.lineFragmentPadding/*左边距*/
                            + _textView.textContainer.lineFragmentPadding/*右边距*/);
    
    CGFloat broadHeight  = (_textView.contentInset.top
                            + _textView.contentInset.bottom
                            + _textView.textContainerInset.top
                            +_textView.textContainerInset.bottom);
    //由于求的是普通字符串产生的Rect来适应textView的宽
    contentWidth -= broadWith;
    CGSize InSize = CGSizeMake(contentWidth, MAXFLOAT);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = _textView.textContainer.lineBreakMode;
    NSDictionary *dic = @{NSFontAttributeName:_textView.font, NSParagraphStyleAttributeName:[paragraphStyle copy]};
    CGSize calculatedSize =  [_textView.text boundingRectWithSize:InSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    CGSize adjustedSize = CGSizeMake(ceilf(calculatedSize.width),calculatedSize.height + broadHeight);//ceilf(calculatedSize.height)
    CGRect frame = self.frame;
    if(adjustedSize.height < _maxHeight){
        frame.size.height = adjustedSize.height;
        self.frame = frame;
    }
}

#pragma mark --删除按钮的点击方法
- (void)clickDelButton {
    _textView.text = @"";
    if(_isShowLength) [self setLengthLabeltext];
}


#pragma mark --代理方法
//有输入时触但对于中文键盘出示的联想字选择时不会触发
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    //优先进行代理的判断 代理若返回NO则直接返回NO
    if ([self.textDelegate respondsToSelector:@selector(textViewForTTextView:shouldChangeTextInRange:replacementText:)] && ![self.textDelegate textViewForTTextView:self shouldChangeTextInRange:range replacementText:text]) {
        return NO;
    }
    //不能输入回车 或者是 单行
    if(!_canInputReturn ) {
        if([text isEqualToString:@"\n"]) {
            [self resignFirstResponder];
            if([_textDelegate respondsToSelector:@selector(textViewShouldReturn:)]) {
                [_textDelegate textViewShouldReturn:self];
            }
            return NO;
        }else if([text containsString:@"\n"]) {
            //包含回车字符 删除回车字符后手动添加 返回NO
            NSString *temp = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            _textView.text = [_textView.text stringByAppendingString:temp];
            [self textViewDidChange:_textView];
            return NO;
        }
    }
    
    //没有高亮 是输入而不是删除时 输入满了 返回NO
    if(![textView markedTextRange] && range.length ==0) {
        if((int)([self countLength:textView.text]) >= _maxLength) {
            if (self.textDelegate != nil && [self.textDelegate respondsToSelector:@selector(textViewOverMaxCharacterNumForTTextView)]) {
                [self.textDelegate textViewOverMaxCharacterNumForTTextView];
            }
            return NO;
        }
    }
    //再改我是狗
//        else if(![text canBeConvertedToEncoding:NSASCIIStringEncoding]){
//            //输入没满但是包含asc以外的字符 手动添加之后 返回NO
//            NSUInteger len = _maxLength - textView.text.length;
//            NSRange  charRange;
//            NSString *temp = @"";
//            for(int i=0; i< text.length; i += charRange.length){
//                charRange = [text rangeOfComposedCharacterSequenceAtIndex:i];
//                if((charRange.location + charRange.length) > len){
//                    break;
//                }
//                temp = [text substringToIndex:charRange.location + charRange.length];
//            }
//            textView.text = [textView.text stringByReplacingCharactersInRange:range withString:temp];
//            [self textViewDidChange:_textView];
//            //设置光标
//            textView.selectedRange = NSMakeRange(range.location + temp.length, 0);
//            return NO;
//        }
//    }
    //其他情况全部返回YES
    return YES;
}

//当输入且上面的代码返回YES时触发。或当选择键盘上的联想字时触发。
- (void)textViewDidChange:(UITextView *)textView
{
    if(_isAdaptForHeight) {
        [self adaptForHeight];
    }
    if(![textView markedTextRange]){
        if([self countLength:textView.text] >_maxLength) {
            NSRange  charRange;
            NSString *temp;
            for(int i=0; i< textView.text.length; i += charRange.length){
                charRange = [textView.text rangeOfComposedCharacterSequenceAtIndex:i];
                temp = [_textView.text substringToIndex:charRange.location + charRange.length];
                if([self countLength:temp] > _maxLength) {
                    temp = [temp substringToIndex:charRange.location];
                    textView.text = temp;
                    break;
                }
            }
            if (self.textDelegate != nil && [self.textDelegate respondsToSelector:@selector(textViewOverMaxCharacterNumForTTextView)]) {
                [self.textDelegate textViewOverMaxCharacterNumForTTextView];
            }
        }
        [self setLengthLabeltext];
    }
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([_textDelegate respondsToSelector:@selector(textViewForTTextViewShouldBeginEditing:)]) {
        return  [_textDelegate textViewForTTextViewShouldBeginEditing:self];
    }
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([_textDelegate respondsToSelector:@selector(textViewForTTextViewDidBeginEditing:)]) {
        [_textDelegate textViewForTTextViewDidBeginEditing:self];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([_textDelegate respondsToSelector:@selector(textViewForTTextViewDidEndEditing:)]) {
        [_textDelegate textViewForTTextViewDidEndEditing:self];
    }
}

@end
