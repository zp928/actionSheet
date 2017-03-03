//
//  ZPMainViewController.m
//  ZPAlert
//
//  Created by 赵朋 on 17/2/16.
//  Copyright © 2017年 赵朋. All rights reserved.
//

#import "ZPMainViewController.h"
#import "ZPActionSheet.h"
@interface ZPMainViewController ()<ZPActionSheetDelegate>

@property (strong, nonatomic) UIButton *actionSheetButton;

@end

@implementation ZPMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self actionSheet];
    // Do any additional setup after loading the view.
}

- (void)actionSheet{
    
    [self setupUI];
    [self setupDefaultUI];
}
- (void)setupUI{
    _actionSheetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _actionSheetButton.frame = CGRectMake(100, 100, 100, 30);
    [_actionSheetButton setTitle:@"性别设置" forState:UIControlStateNormal];
    [_actionSheetButton setBackgroundColor:[UIColor redColor]];
    [_actionSheetButton addTarget:self action:@selector(popActionSheet) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_actionSheetButton];
}

- (void)setupDefaultUI{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 300, 100, 30);
    [button setTitle:@"默认样式" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor redColor]];
    [button addTarget:self action:@selector(defaultActionSheet) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)popActionSheet{
    
    ZPActionSheet *actionSheet = [[ZPActionSheet alloc] initWithTitle:@"性别设置" delegate:self cancelButtonTitle:@"取消" buttonTitles:@"男",@"女",@"未知", nil];
    //此处设置各部分颜色以及字体大小，可不设置默认字体颜色黑色，背景白色，字体14
    [actionSheet setTitleColor:[UIColor redColor] backColor:[UIColor yellowColor] fontSize:12];
    [actionSheet setButtonTitleColor:nil backColor:nil fontSize:0 buttonIndex:0];
    [actionSheet setButtonTitleColor:nil backColor:[UIColor blueColor] fontSize:10 buttonIndex:1];
    [actionSheet setButtonTitleColor:[UIColor blueColor] backColor:nil fontSize:13 buttonIndex:2];
    [actionSheet setcancelButtonColor:[UIColor redColor] backColor:[UIColor greenColor] fontSize:15];
    
    [actionSheet show];
}
//点击按钮之后执行的代理方法
- (void)actionSheet:(ZPActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"设置之后执行");
    NSString *title = actionSheet.buttonTitleArr[buttonIndex];
    [_actionSheetButton setTitle:title forState:UIControlStateNormal];
}
//点击取消执行代理方法，无特殊处理可不写
- (void)actionSheetCancel:(ZPActionSheet *)actionSheet{
    NSLog(@"取消设置之后执行，可不实现");
}

- (void)defaultActionSheet{
     ZPActionSheet *actionSheet = [[ZPActionSheet alloc] initWithTitle:@"性别设置" delegate:self cancelButtonTitle:@"取消" buttonTitles:@"男",@"女",@"未知", nil];
    [actionSheet show];
    //点击之后的处理同上
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
