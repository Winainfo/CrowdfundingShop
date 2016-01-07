//
//  MyShareOrderController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/30.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "MyShareOrderController.h"
#import "MyShareOrderCell.h"
#import "DoShareOrderCell.h"
#import "LXDSegmentControl.h"
//获得当前屏幕宽高点数（非像素）
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
@interface MyShareOrderController ()<LXDSegmentControlDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet UITableView *shareOrderTableView;
@end

@implementation MyShareOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏标题颜色和字体大小UITextAttributeFont:[UIFont fontWithName:@"Heiti TC" size:0.0]
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Menlo" size:16.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title=@"我的晒单";
    //导航栏右侧按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateSelected];
    leftBtn.frame=CGRectMake(-5, 5, 30, 30);
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
    //创建xib文件对象
    UINib *nib=[UINib nibWithNibName:@"MyShareOrderCell" bundle:[NSBundle mainBundle]];
    //注册到表格视图
    [self.myTableView  registerNib:nib forCellReuseIdentifier:@"MyShareOrderCell"];
    [self setExtraCellLineHidden:self.myTableView];
    //创建xib文件对象
    UINib *nib1=[UINib nibWithNibName:@"DoShareOrderCell" bundle:[NSBundle mainBundle]];
    //注册到表格视图
    [self.shareOrderTableView  registerNib:nib1 forCellReuseIdentifier:@"DoShareOrderCell"];
    [self setExtraCellLineHidden:self.shareOrderTableView];
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
    if (tableView==self.myTableView) {
        return 3;
    }else{
     return 3;
    }
}
/**
 *  设置单元格内容
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.myTableView) {
        static NSString *cellStr=@"MyShareOrderCell";
        MyShareOrderCell *cell=[self.myTableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell==nil) {
            cell=[[MyShareOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        //取消Cell选中时背景
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString *cellStr=@"DoShareOrderCell";
        DoShareOrderCell *cell=[self.shareOrderTableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell==nil) {
            cell=[[DoShareOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        //取消Cell选中时背景
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}
/**
 *  设置单元格高度
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 96;
}
/**
 *  点击事件
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    view.backgroundColor=[UIColor whiteColor];
    CGRect frame = CGRectMake(40, 5, 240.f, 30.f);
    NSArray * items = @[@"已晒单", @"未晒单"];
    LXDSegmentControlConfiguration * select = [LXDSegmentControlConfiguration configurationWithControlType: LXDSegmentControlTypeSelectBlock items: items];
    select.cornerColor=[UIColor colorWithRed:231.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1];
    select.backgroundColor=[UIColor colorWithRed:231.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1];
    select.itemBackgroundColor=[UIColor whiteColor];
    select.itemSelectedColor=[UIColor colorWithRed:231.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1];
    select.itemTextColor=[UIColor colorWithRed:231.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1];
    select.cornerWidth=0.5f;
    LXDSegmentControl * selectControl = [LXDSegmentControl segmentControlWithFrame: frame configuration: select delegate: self];
    selectControl.center=view.center;
    [view addSubview:selectControl];
    UIView *lineview1=[[UIView alloc]initWithFrame:CGRectMake(0, view.frame.size.height, kScreenWidth, 0.5)];
    lineview1.backgroundColor=[UIColor colorWithRed:189.0/255.0 green:189.0/255.0 blue:189.0/255.0 alpha:1];
    [view addSubview:lineview1];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
#pragma mark - LXDSegmentControlDelegate
- (void)segmentControl:(LXDSegmentControl *)segmentControl didSelectAtIndex:(NSUInteger)index
{
    if (index==0) {
        self.myTableView.hidden=YES;
        self.shareOrderTableView.hidden=NO;
    }else if(index==1){
        self.myTableView.hidden=NO;
        self.shareOrderTableView.hidden=YES;
    }
}
@end
