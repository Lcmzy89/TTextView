//
//  ViewController.m
//  TestTTextView
//
//  Created by 李成明 on 2021/7/22.
//

#import "ViewController.h"
#import "TTextView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    CGFloat winWidth = [UIScreen mainScreen].bounds.size.width;
//    CGFloat winHeight = [UIScreen mainScreen].bounds.size.height;
    
    TTextView *nicktextView = [[TTextView alloc] initWithFrame:CGRectMake(winWidth/2-42, 100, 84, 25)];
    nicktextView.placeholderLabel.textAlignment = NSTextAlignmentCenter;
    nicktextView.textAlignment = NSTextAlignmentCenter;
    nicktextView.placeholderText = @"输入昵称";
    nicktextView.scrollEnabled = NO;
    nicktextView.isAdaptForHeight = NO;
    nicktextView.font = [UIFont systemFontOfSize:18];
    nicktextView.maxLength = 4;
    [self.view addSubview:nicktextView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(winWidth/2-75, 126, 150, 0.3)];
    line.backgroundColor = UIColor.lightGrayColor;
    [self.view addSubview:line];
    
    
    TTextView *experience = [[TTextView alloc] initWithFrame:CGRectMake(10, 150, winWidth-20, 200)];
    experience.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
    experience.placeholderText = @"例：19年、20两年,整体收益率超过200%";
    experience.font = [UIFont systemFontOfSize:14];
    experience.textContainerInset = UIEdgeInsetsMake(10, 7, 10, 7);
    experience.maxLength = 200;
    experience.countlengthWay = CountByUnits;
    experience.isShowLength = YES;
    experience.lengthTextFormate = @"S";
    experience.textLengthLable.font = [UIFont systemFontOfSize:14];
    experience.layer.borderColor = UIColor.lightGrayColor.CGColor;
    experience.layer.borderWidth = 1;
    experience.layer.cornerRadius = 8;
    [self.view addSubview:experience];
}


@end
