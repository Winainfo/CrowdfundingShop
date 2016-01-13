//
//  ContentDetailController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 16/1/7.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import "ContentDetailController.h"

@interface ContentDetailController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (retain,nonatomic)NSString *content;
@end

@implementation ContentDetailController
//隐藏和显示底部标签栏
-(void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏标题颜色和字体大小UITextAttributeFont:[UIFont fontWithName:@"Heiti TC" size:0.0]
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Menlo" size:16.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title=@"商品图文详情－欢乐夺宝";
    //导航栏左侧按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateSelected];
    leftBtn.frame=CGRectMake(-5, 5, 21, 21);
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
    NSLog(@"%@",self.content);
    [self.webView loadHTMLString:self.content baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    _webView.backgroundColor=[UIColor clearColor];
    for (UIView *subView in [_webView subviews])
    {
        if ([subView isKindOfClass:[UIScrollView class]])
        {
            ((UIScrollView *)subView).bounces = NO; //去掉UIWebView的底图
            //            [(UIScrollView *)_aView setShowsVerticalScrollIndicator:NO]; //右侧的滚动条
            
            for (UIView *scrollview in subView.subviews)
            {
                if ([scrollview isKindOfClass:[UIImageView class]])
                {
                    scrollview.hidden = YES;  //上下滚动出边界时的黑色的图片
                }
            }
        }
    }
    [_webView.scrollView setContentInset:UIEdgeInsetsMake(50, 0, -50, 0)];
}

//返回
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
