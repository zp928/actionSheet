//
//  ZPActionSheet.m
//  ZPAlert
//
//  Created by 赵朋 on 17/2/16.
//  Copyright © 2017年 赵朋. All rights reserved.
//

#import "ZPActionSheet.h"
#define DefaultFontSize 14
#define DefaultLineHeight 0.5
#define DefaultButtonHeight 40

@interface  ZPActionSheet()

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIView *buttonView;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) NSMutableArray *buttonArr;

@property (assign,nonatomic) CGFloat contentViewWidth;
@property (assign,nonatomic) CGFloat contentViewHeight;

@end

@implementation ZPActionSheet

- (instancetype)initWithTitle:(NSString *)title delegate:(id<ZPActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle buttonTitles:(NSString *)buttonTitles, ...{
    
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _title = title;
        _delegate = delegate;
        _cancelButtonTitle = cancelButtonTitle;
        _buttonArr = [NSMutableArray array];
        _buttonTitleArr = [NSMutableArray array];
        
        va_list args;
        va_start(args, buttonTitles);
        if (buttonTitles) {
            [_buttonTitleArr addObject:buttonTitles];
            while (1) {
                NSString *otherButtonTitle = va_arg(args, NSString *);
                if (otherButtonTitle == nil) {
                    break;
                } else {
                    [_buttonTitleArr addObject:otherButtonTitle];
                }
            }
        }
        va_end(args);
        self.backgroundColor = [UIColor clearColor];
        _backgroundView = [[UIView alloc] initWithFrame:self.frame];
        _backgroundView.alpha = 0;
        _backgroundView.backgroundColor = [UIColor blackColor];
        [self addSubview:_backgroundView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [_backgroundView addGestureRecognizer:tap];
        
        [self setupUI];
        
    }
    return self;
}

- (void)setupUI{
    
    _contentViewWidth = self.frame.size.width*0.9;
    _contentViewHeight = 0;
    
    _contentView = [UIView new];
    _contentView.backgroundColor = [UIColor clearColor];
    
    _buttonView = [UIView new];
    _buttonView.backgroundColor = [UIColor whiteColor];
    
    [self setupTitle];
    [self setupButtons];
    [self setupCancel];
    _contentView.frame = CGRectMake((self.frame.size.width-_contentViewWidth)/2, self.frame.size.height, _contentViewWidth, _contentViewHeight);
    [self addSubview:_contentView];

}

- (void)setupTitle{
    if (_title != nil && ![_title isEqualToString:@""]) {
        _titleLabel = ({
            UILabel *label = [UILabel new];
            label.frame = CGRectMake(0, 0, _contentViewWidth, 50);
            label.backgroundColor = [UIColor whiteColor];
            label.textColor = [UIColor blackColor];
            label.text = _title;
            label.font = [UIFont systemFontOfSize:DefaultFontSize];
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
        [_buttonView addSubview:_titleLabel];
        _contentViewHeight +=_titleLabel.frame.size.height;
    }
}

- (void)setupButtons{
    if (_buttonTitleArr.count > 0) {
        [_buttonTitleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            UIView *line = [UIView new];
            line.frame = CGRectMake(0, _contentViewHeight, _contentViewWidth, DefaultLineHeight);
            line.backgroundColor = [UIColor lightGrayColor];
            [_buttonView addSubview:line];

            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(0, _contentViewHeight+DefaultLineHeight, _contentViewWidth, DefaultButtonHeight);
            [button setTitle:_buttonTitleArr[idx] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor whiteColor]];
            [button addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [UIFont systemFontOfSize:DefaultFontSize];
            button.tag = 10+idx;
            [_buttonView addSubview:button];
            [_buttonArr addObject:button];
            _contentViewHeight += line.frame.size.height + button.frame.size.height;
        }];
        _buttonView.backgroundColor = [UIColor whiteColor];
        _buttonView.frame = CGRectMake(0, 0, _contentViewWidth, _contentViewHeight);
        _buttonView.layer.cornerRadius = 5;
        _buttonView.layer.masksToBounds = YES;
        [_contentView addSubview:_buttonView];
    }
}

- (void)setupCancel{
    if (_cancelButtonTitle != nil && ![_cancelButtonTitle isEqualToString:@""]) {
        _cancelButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, _contentViewHeight+10, _contentViewWidth, 50);
            [button setTitle:_cancelButtonTitle forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor whiteColor]];
            [button addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [UIFont systemFontOfSize:DefaultFontSize];
            button.layer.cornerRadius = 5;
            button.layer.masksToBounds = YES;
            button;
        });
        [_contentView addSubview:_cancelButton];
        _contentViewHeight += _cancelButton.frame.size.height+20;
    }
}

- (void)selectButton:(UIButton *)button{
    if (_delegate &&[_delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [self.delegate actionSheet:self clickedButtonAtIndex:button.tag-10];
        [self hide];
    }
}

- (void)setTitleColor:(UIColor *)color backColor:(UIColor *)backColor fontSize:(CGFloat)size{
    if (color != nil) {
        _titleLabel.textColor = color;
    }
    if (backColor != nil) {
        _titleLabel.backgroundColor = backColor;
    }
    if (size > 0) {
        _titleLabel.font = [UIFont systemFontOfSize:size];
    }
}

- (void)setButtonTitleColor:(UIColor *)color backColor:(UIColor *)backColor fontSize:(CGFloat)size buttonIndex:(NSInteger)buttonIndex{
    UIButton *button = _buttonArr[buttonIndex];
    if (color != nil) {
        [button setTitleColor:color forState:UIControlStateNormal];
    }
    
    if (backColor != nil) {
        [button setBackgroundColor:backColor];
    }
    
    if (size > 0) {
        button.titleLabel.font = [UIFont systemFontOfSize:size];
    }
}

- (void)setcancelButtonColor:(UIColor *)color backColor:(UIColor *)backColor fontSize:(CGFloat)size{
    if (color != nil) {
        [_cancelButton setTitleColor:color forState:UIControlStateNormal];
    }
    
    if (backColor != nil) {
        [_cancelButton setBackgroundColor:backColor];
    }
    
    if (size > 0) {
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:size];
    }
}

- (void)setTitle:(NSString *)title{
    _title = title;
}

- (void)setCancelButtonTitle:(NSString *)cancelButtonTitle{
    _cancelButtonTitle = cancelButtonTitle;
}


- (void)show {
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    [window addSubview:self];
    [self addAnimation];
}

- (void)hide{
    [self removeAnimation];
}

- (void)addAnimation{
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.frame = CGRectMake(_contentView.frame.origin.x, self.frame.size.height - _contentView.frame.size.height, _contentViewWidth, _contentViewHeight);
        _backgroundView.alpha = 0.7;
    } completion:^(BOOL finished) {
    }];
}
- (void)removeAnimation{
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.frame = CGRectMake(_contentView.frame.origin.x, self.frame.size.height, _contentViewWidth, _contentViewHeight);
        _backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
