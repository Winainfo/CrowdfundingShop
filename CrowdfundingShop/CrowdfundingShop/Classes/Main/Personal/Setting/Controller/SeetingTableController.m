//
//  SeetingTableController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 16/1/4.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import "SeetingTableController.h"
//获得当前屏幕宽高点数（非像素）
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
@interface SeetingTableController ()
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation SeetingTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setExtraCellLineHidden:self.myTableView];
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 40)];
    footerView.backgroundColor=[UIColor clearColor];
    UIButton *addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame=CGRectMake(10, 0, footerView.frame.size.width-20, footerView.frame.size.height);
    [addBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    addBtn.backgroundColor=[UIColor colorWithRed:231.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1];
    addBtn.layer.cornerRadius=4.0;
    addBtn.layer.masksToBounds=YES;
    [footerView addSubview:addBtn];
    self.myTableView.tableFooterView=footerView;
}

/**
 *  退出
 */
-(void)logout{
    //设置故事板为第一启动
}

/**
 *  去掉多余的分割线
 *
 *  @param tableView <#tableView description#>
 */
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
/**
 *  cell 间距
 *
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 */

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

@end
