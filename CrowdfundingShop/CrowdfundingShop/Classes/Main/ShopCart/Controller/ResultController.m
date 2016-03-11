//
//  ResultController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 16/3/7.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import "ResultController.h"
#import "ARLabel.h"
#import "MyCouldRecordController.h"
#import "HomeNavController.h"
#import "IndexController.h"
@interface ResultController ()
/**商品数量*/
@property (weak, nonatomic) IBOutlet ARLabel *numLabel;
/**记录*/
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
/**继续购买*/
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
/**表格*/
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@end

@implementation ResultController
//隐藏和显示底部标签栏
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏标题颜色和字体大小UITextAttributeFont:[UIFont fontWithName:@"Heiti TC" size:0.0]
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Menlo" size:16.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title=@"云购结果";
    //导航栏左侧按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateSelected];
    leftBtn.frame=CGRectMake(-5, 5, 21, 21);
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
    [self initStyle];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"addCart" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
//返回
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  样式初始化
 */
-(void)initStyle{
    self.recordBtn.layer.borderWidth=0.5;
    self.recordBtn.layer.borderColor=[[UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1]CGColor];
    self.recordBtn.layer.cornerRadius=4.0;
    self.buyBtn.layer.cornerRadius=4.0;
}
/**
 *  查看云购记录
 *
 *  @param sender <#sender description#>
 */
- (IBAction)recordClick:(UIButton *)sender {
    //设置故事板为第一启动
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MyCouldRecordController *controller=[storyboard instantiateViewControllerWithIdentifier:@"MyCouldRecord"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)buyShopClick:(UIButton *)sender {
     NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@"0",@"Index", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
