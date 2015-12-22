//
//  CommentaryController.m
//  CrowdfundingShop
//  评论页面
//  Created by 吴金林 on 15/12/21.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "CommentaryController.h"
#import <QuartzCore/QuartzCore.h>
@interface CommentaryController ()
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
/**评论框*/
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
/**评论数组*/
@property(retain,nonatomic) NSArray *contentArray;

@property (nonatomic, strong) UITableViewCell *prototypeCell;
@end

@implementation CommentaryController
//隐藏和显示底部标签栏
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Menlo" size:16.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title=@"评论";
    //导航栏左侧按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateSelected];
    leftBtn.frame=CGRectMake(-5, 5, 21, 21);
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
    //创建xib文件对象
    UINib *nib=[UINib nibWithNibName:@"CommentaryCell" bundle:[NSBundle mainBundle]];
    //注册到表格视图
    [self.myTableView  registerNib:nib forCellReuseIdentifier:@"CommentaryCell"];
    self.myTableView.separatorStyle=NO;
    [self setExtraCellLineHidden:self.myTableView];
    self.contentArray=@[@"1asdfad",@"测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试",@"1ad"];
    self.prototypeCell=[self.myTableView dequeueReusableCellWithIdentifier:@"CommentaryCell"];
}
/**
 *  返回
 */
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark 实现table代理
/**
 *  设置单元格数量
 *
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentArray.count;
}
/**
 *  设置单元格内容
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellStr=@"CommentaryCell";
    CommentaryCell *cell=[tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell==nil) {
        cell=[[CommentaryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.contetnLabel.numberOfLines=0;
//    cell.contetnLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.contetnLabel.text=self.contentArray[indexPath.row];
    //取消Cell选中时背景
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

/**
 *  设置单元格高度
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentaryCell *cell=(CommentaryCell *)self.prototypeCell;
    //获得当前cell高度
    CGRect frame=[cell frame];
    //文本赋值
    cell.contetnLabel.text=self.contentArray[indexPath.row];
      //设置label的最大行数
    cell.contetnLabel.numberOfLines=0;
    CGSize labelSize=[cell.contetnLabel sizeThatFits:CGSizeMake(cell.contetnLabel.frame.size.width, 1000)];
    CGRect sFrame=cell.contetnLabel.frame;
    sFrame.size=labelSize;
    cell.contetnLabel.frame=sFrame;
     //计算出自适应的高度
    frame.size.height=labelSize.height+60;
    cell.frame=frame;
    return cell.frame.size.height;
}


@end
