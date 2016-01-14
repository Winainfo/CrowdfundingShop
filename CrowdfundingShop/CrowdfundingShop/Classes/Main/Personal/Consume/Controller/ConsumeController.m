//
//  ConsumeController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/30.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "ConsumeController.h"
#import "ConsumeCell.h"
#import "RechargeCell.h"
#import "ARLabel.h"
#import "LXDSegmentControl.h"
#import "RequestData.h"
#import "AccountTool.h"
#import <UIImageView+WebCache.h>
#import <MBProgressHUD.h>
@interface ConsumeController ()<LXDSegmentControlDelegate>{
    AccountModel *account;
}

/**充值明细表*/
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
/**消费明细表*/
@property (weak, nonatomic) IBOutlet UITableView *rechargeTableView;
/**充值数组*/
@property (retain,nonatomic) NSArray *rechargeArray;
/**消费数组*/
@property (retain,nonatomic) NSArray *consumeArray;
//表头
@property (retain,nonatomic) UIView *recharView;
/**总金额*/
@property (retain,nonatomic) UILabel *moneyLabel;
@property (retain,nonatomic) UILabel *label1;
@property (retain,nonatomic) UILabel *label2;
@property (retain,nonatomic) UILabel *label3;
@property (retain,nonatomic) UILabel *consume;
@property (retain,nonatomic) UIView *lineview1;
@property (retain,nonatomic) UIView *lineview2;
@property (retain,nonatomic) UIView *lineview3;
@property (retain,nonatomic) UILabel *consumeMoney;
@end

@implementation ConsumeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏标题颜色和字体大小UITextAttributeFont:[UIFont fontWithName:@"Heiti TC" size:0.0]
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Menlo" size:16.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title=@"账号明细";
    //导航栏右侧按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateSelected];
    leftBtn.frame=CGRectMake(-5, 5, 30, 30);
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
    //创建xib文件对象
    UINib *nib=[UINib nibWithNibName:@"ConsumeCell" bundle:[NSBundle mainBundle]];
    //注册到表格视图
    [self.myTableView  registerNib:nib forCellReuseIdentifier:@"ConsumeCell"];
    [self setExtraCellLineHidden:self.myTableView];
    //创建xib文件对象
    UINib *nib1=[UINib nibWithNibName:@"RechargeCell" bundle:[NSBundle mainBundle]];
    //注册到表格视图
    [self.rechargeTableView registerNib:nib1 forCellReuseIdentifier:@"RechargeCell"];
    [self setExtraCellLineHidden:self.rechargeTableView];
    [self consumeServer:@"1" andpageSize:@"20"];
}
#pragma mark 数据源
/**
 *  充值明细
 */
-(void)rechargeServer:(NSString *)pageindex andpageSize:(NSString *)pagesize{
    account=[AccountTool account];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",@"",@"state",pageindex,@"pageIndex",pagesize,@"pageSize",nil];
    [RequestData myRechargeSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
        self.rechargeArray=data[@"content"];
        //更新主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myTableView reloadData];
        });
    }];
}
/**
 * 消费明细
 */
-(void)consumeServer:(NSString *)pageindex andpageSize:(NSString *)pagesize{
    account=[AccountTool account];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",@"ing",@"state",pageindex,@"pageIndex",pagesize,@"pageSize",nil];
    [RequestData myConsumeSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
        self.consumeArray=data[@"content"];
        int money=0;
        for (int i=0; i<self.consumeArray.count; i++) {
            money+=[self.consumeArray[i][@"money"] intValue];
        }
        self.consumeMoney.text=[NSString stringWithFormat:@"%i",money];
        //更新主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.rechargeTableView reloadData];
        });
    }];
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
        return self.rechargeArray.count;
    }
    return self.consumeArray.count;
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
        static NSString *cellStr=@"ConsumeCell";
        ConsumeCell *cell=[self.myTableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell==nil) {
            cell=[[ConsumeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        //取消Cell选中时背景
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
//        cell.timeLabel.text=_rechargeArray[indexPath.row][@""];
//        cell.moneyLabel.text=_rechargeArray[indexPath.row][@""];
//        cell.channelLabel.text=_rechargeArray[indexPath.row][@""];
        return cell;
    }else if(tableView==self.rechargeTableView){
        static NSString *cellStr=@"RechargeCell";
        RechargeCell *cell=[self.rechargeTableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell==nil) {
            cell=[[RechargeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        //取消Cell选中时背景
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.timeLabel.text=_consumeArray[indexPath.row][@"time"];
        cell.moneyLabel.text=[NSString stringWithFormat:@"¥%@",_consumeArray[indexPath.row][@"money"]];
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
    return 30;
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
    self.recharView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 115)];
    self.recharView.backgroundColor=[UIColor whiteColor];
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, 40)];
    [self.recharView addSubview:view1];
    CGRect frame = CGRectMake(40, 5, 240.f, 30.f);
    NSArray * items = @[@"充值明细", @"消费明细"];
    LXDSegmentControlConfiguration * select = [LXDSegmentControlConfiguration configurationWithControlType: LXDSegmentControlTypeSelectBlock items: items];
    select.currentIndex=1;
    select.cornerColor=[UIColor colorWithRed:231.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1];
    select.backgroundColor=[UIColor colorWithRed:231.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1];
    select.itemBackgroundColor=[UIColor whiteColor];
    select.itemSelectedColor=[UIColor colorWithRed:231.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1];
    select.itemTextColor=[UIColor colorWithRed:231.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1];
    select.cornerWidth=0.5f;
    LXDSegmentControl * selectControl = [LXDSegmentControl segmentControlWithFrame: frame configuration: select delegate: self];
    selectControl.center=view1.center;
    if (tableView==self.myTableView) {
        /**充值明细表头*/
        self.lineview1=[[UIView alloc]initWithFrame:CGRectMake(0, 43, kScreenWidth, 0.5)];
        self.lineview1.backgroundColor=[UIColor colorWithRed:189.0/255.0 green:189.0/255.0 blue:189.0/255.0 alpha:1];
        [self.recharView addSubview:self.lineview1];
        self.consume=[[UILabel alloc] initWithFrame:CGRectMake(96,57, 75, 21)];
        self.consume.text=@"总充值金额";
        self.consume.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        self.consume.font=[UIFont fontWithName:@"Menlo" size:14];
        [self.recharView addSubview:self.consume];
        self.moneyLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.consume.frame.origin.x+self.consume.frame.size.width+5,57, 75, 21)];
        self.moneyLabel.text=@"¥11.00";
        self.moneyLabel.textColor=[UIColor colorWithRed:231.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1];
        self.moneyLabel.font=[UIFont fontWithName:@"Menlo" size:14];
        [self.recharView addSubview:self.moneyLabel];
        self.lineview2=[[UIView alloc]initWithFrame:CGRectMake(0, 85, kScreenWidth, 0.5)];
        self.lineview2.backgroundColor=[UIColor colorWithRed:189.0/255.0 green:189.0/255.0 blue:189.0/255.0 alpha:1];
        [self.recharView addSubview:self.lineview2];
        self.label1=[[UILabel alloc] initWithFrame:CGRectMake(10,91, 48, 18)];
        self.label1.text=@"充值时间";
        self.label1.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        self.label1.font=[UIFont fontWithName:@"Menlo" size:12];
        [self.recharView addSubview:self.label1];
        self.label2=[[UILabel alloc] initWithFrame:CGRectMake(160, 91, 48, 18)];
        self.label2.text=@"资金渠道";
        self.label2.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        self.label2.font=[UIFont fontWithName:@"Menlo" size:12];
        [self.recharView addSubview:self.label2];
        self.label3=[[UILabel alloc] initWithFrame:CGRectMake(250, 91, 48, 18)];
        self.label3.text=@"充值金额";
        self.label3.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        self.label3.font=[UIFont fontWithName:@"Menlo" size:12];
        [self.recharView addSubview:self.label3];
        self.lineview3=[[UIView alloc]initWithFrame:CGRectMake(0, self.recharView.frame.size.height, kScreenWidth, 0.5)];
        self.lineview3.backgroundColor=[UIColor colorWithRed:189.0/255.0 green:189.0/255.0 blue:189.0/255.0 alpha:1];
        [self.recharView addSubview:self.lineview3];
    }else if(tableView==self.rechargeTableView){
        static NSString *cellStr=@"RechargeCell";
        RechargeCell *cell=[self.rechargeTableView dequeueReusableCellWithIdentifier:cellStr];
        self.lineview1=[[UIView alloc]initWithFrame:CGRectMake(0, 50, kScreenWidth, 0.5)];
        self.lineview1.backgroundColor=[UIColor colorWithRed:189.0/255.0 green:189.0/255.0 blue:189.0/255.0 alpha:1];
        [self.recharView addSubview:self.lineview1];
        self.consume=[[UILabel alloc] initWithFrame:CGRectMake(96,57, 75, 21)];
        self.consume.text=@"总消费金额";
        self.consume.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        self.consume.font=[UIFont fontWithName:@"Menlo" size:14];
        [self.recharView addSubview:self.consume];
        self.moneyLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.consume.frame.origin.x+self.consume.frame.size.width+5,57, 75, 21)];
        self.consumeMoney.text=@"¥11.00";
        self.consumeMoney.textColor=[UIColor colorWithRed:231.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1];
        self.consumeMoney.font=[UIFont fontWithName:@"Menlo" size:14];
        [self.recharView addSubview:self.consumeMoney];
        self.lineview2=[[UIView alloc]initWithFrame:CGRectMake(0, 85, kScreenWidth, 0.5)];
        self.lineview2.backgroundColor=[UIColor colorWithRed:189.0/255.0 green:189.0/255.0 blue:189.0/255.0 alpha:1];
        [self.recharView addSubview:self.lineview2];
        self.label1=[[UILabel alloc] initWithFrame:CGRectMake(cell.timeLabel.frame.origin.x,91, cell.timeLabel.frame.size.width, 18)];
        self.label1.text=@"消费时间";
        self.label1.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        self.label1.font=[UIFont fontWithName:@"Menlo" size:12];
        [self.recharView addSubview:self.label1];
        self.label3=[[UILabel alloc] initWithFrame:CGRectMake(cell.moneyLabel.frame.origin.x, 91, 20+cell.moneyLabel.frame.size.width, 18)];
        self.label3.text=@"消费金额";
        self.label3.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        self.label3.font=[UIFont fontWithName:@"Menlo" size:12];
        [self.recharView addSubview:self.label3];
        self.lineview3=[[UIView alloc]initWithFrame:CGRectMake(0, self.recharView.frame.size.height, kScreenWidth, 0.5)];
        self.lineview3.backgroundColor=[UIColor colorWithRed:189.0/255.0 green:189.0/255.0 blue:189.0/255.0 alpha:1];
        [self.recharView addSubview:self.lineview3];
    }
    [view1 addSubview:selectControl];
    return self.recharView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 115;
}

#pragma mark - LXDSegmentControlDelegate
- (void)segmentControl:(LXDSegmentControl *)segmentControl didSelectAtIndex:(NSUInteger)index
{
    if (index==0) {
        self.myTableView.hidden=NO;
        self.rechargeTableView.hidden=YES;
    }else if(index==1){
        self.myTableView.hidden=YES;
        self.rechargeTableView.hidden=NO;
    }
}
@end
