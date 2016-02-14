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
#import <MJRefresh.h>
@interface ConsumeController ()<LXDSegmentControlDelegate>{
    AccountModel *account;
    NSInteger offset1;
    NSInteger offset2;
}

/**充值明细表*/
@property (weak, nonatomic) IBOutlet UITableView *rechargeTableView;
/**充值数组*/
@property (retain,nonatomic) NSMutableArray *rechargeArray;
/**消费明细表*/
@property (weak, nonatomic) IBOutlet UITableView *consumeTableView;
/**消费数组*/
@property (retain,nonatomic) NSMutableArray *consumeArray;
@property (weak, nonatomic) IBOutlet UIView *topView;
/**充值View*/
@property (weak, nonatomic) IBOutlet UIView *rechargeView;
/**充值金额*/
@property (weak, nonatomic) IBOutlet ARLabel *rechargeLabel;
/**消费View*/
@property (weak, nonatomic) IBOutlet UIView *consumeView;
/**消费金额*/
@property (weak, nonatomic) IBOutlet ARLabel *consumeLabel;
@end

@implementation ConsumeController
-(NSMutableArray *)rechargeArray
{
    if (_rechargeArray==nil)
    {
        _rechargeArray=[NSMutableArray array];
    }
    return _rechargeArray;
}
-(NSMutableArray *)consumeArray
{
    if (_consumeArray==nil)
    {
        _consumeArray=[NSMutableArray array];
    }
    return _consumeArray;
}
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
    [self.rechargeTableView  registerNib:nib forCellReuseIdentifier:@"ConsumeCell"];
    [self setExtraCellLineHidden:self.rechargeTableView];
    //创建xib文件对象
    UINib *nib1=[UINib nibWithNibName:@"RechargeCell" bundle:[NSBundle mainBundle]];
    //注册到表格视图
    [self.consumeTableView registerNib:nib1 forCellReuseIdentifier:@"RechargeCell"];
    [self setExtraCellLineHidden:self.consumeTableView];
    /**已充值数据*/
    self.rechargeTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDoData)];
    [self.rechargeTableView.mj_header beginRefreshing];
    self.rechargeTableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadDoMoreData)];
    offset1=1;
    /**已消费数据*/
    self.consumeTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.consumeTableView.mj_header beginRefreshing];
    self.consumeTableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    offset2=1;
    [self segmentControl];
}

#pragma mark - 加载新数据
/**
 *  充值明细下拉刷新
 */
-(void)loadDoData
{
    if (self.rechargeArray.count==0) {
        //声明对象；
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
        //显示的文本；
        hud.labelText = @"正在加载...";
        account=[AccountTool account];
        offset1=1;
        NSString *pageIndex=[NSString stringWithFormat:@"%li",(long)offset1];
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",pageIndex,@"pageIndex",@"20",@"pageSize",nil];
        [RequestData myRechargeSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
            int code=[data[@"code"] intValue];
            [self.rechargeTableView.mj_header endRefreshing];
            if (code==0) {
                //加载成功，先移除原来的HUD；
                hud.removeFromSuperViewOnHide = true;
                [hud hide:true afterDelay:0];
                //然后显示一个成功的提示；
                MBProgressHUD *successHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
                successHUD.labelText = @"加载成功";
                successHUD.mode = MBProgressHUDModeCustomView;
                //可以设置对应的图片；
                successHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_success"]];
                successHUD.removeFromSuperViewOnHide = true;
                [successHUD hide:true afterDelay:1];
                [self.rechargeArray removeAllObjects];
                NSArray *array=data[@"content"];
                [self.rechargeArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)]];
                int money=0;
                for (int i=0; i<self.rechargeArray.count; i++) {
                    money+=[self.rechargeArray[i][@"money"] intValue];
                }
                self.rechargeLabel.text=[NSString stringWithFormat:@"¥%i",money];
                //更新主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.rechargeTableView reloadData];
                });
            }else{
                hud.removeFromSuperViewOnHide = true;
                [hud hide:true afterDelay:0];
                //显示失败的提示；
                MBProgressHUD *failHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
                failHUD.labelText = @"暂无数据";
                failHUD.mode = MBProgressHUDModeCustomView;
                failHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_error"]];
                failHUD.removeFromSuperViewOnHide = true;
                [failHUD hide:true afterDelay:1];
                
            }
        } andFailure:^(NSError *error) {
            [self.rechargeTableView.mj_header endRefreshing];
            hud.removeFromSuperViewOnHide = true;
            [hud hide:true afterDelay:0];
            //显示失败的提示；
            MBProgressHUD *failHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
            failHUD.labelText = @"数据加载异常";
            failHUD.mode = MBProgressHUDModeCustomView;
            failHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_error"]];
            failHUD.removeFromSuperViewOnHide = true;
            [failHUD hide:true afterDelay:1];
            
        }];
    }else {
        account=[AccountTool account];
        offset1=1;
        NSString *pageIndex=[NSString stringWithFormat:@"%li",(long)offset1];
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",pageIndex,@"pageIndex",@"20",@"pageSize",nil];
        [RequestData myRechargeSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
            int code=[data[@"code"] intValue];
            [self.rechargeTableView.mj_header endRefreshing];
            if (code==0) {
                [self.rechargeArray removeAllObjects];
                NSArray *array=data[@"content"];
                [self.rechargeArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)]];
                int money=0;
                for (int i=0; i<self.rechargeArray.count; i++) {
                    money+=[self.rechargeArray[i][@"money"] intValue];
                }
                self.rechargeLabel.text=[NSString stringWithFormat:@"¥%i",money];
                //更新主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.rechargeTableView reloadData];
                });
            }else{
                
            }
        } andFailure:^(NSError *error) {
            [self.rechargeTableView.mj_header endRefreshing];
        }];
    }
}
/**
 *  充值明细上拉加载
 */
-(void)loadDoMoreData
{
    account=[AccountTool account];
    offset1+=1;
    NSString *pageIndex=[NSString stringWithFormat:@"%li",(long)offset1];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",@"",@"state",pageIndex,@"pageIndex",@"20",@"pageSize",nil];
    [RequestData myRechargeSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
        int code=[data[@"code"] intValue];
        [self.rechargeTableView.mj_footer endRefreshing];
        if (code==0) {
            NSArray *array=data[@"content"];
            [self.rechargeArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.rechargeArray.count, array.count)]];
            int money=0;
            for (int i=0; i<self.rechargeArray.count; i++) {
                money+=[self.rechargeArray[i][@"money"] intValue];
            }
            self.rechargeLabel.text=[NSString stringWithFormat:@"¥%i",money];
            //更新主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.rechargeTableView reloadData];
            });
        }else{
            
        }
    } andFailure:^(NSError *error) {
        [self.rechargeTableView.mj_footer endRefreshing];
    }];
    
}
/**
 *  消费明细下拉
 */
-(void)loadNewData
{
    account=[AccountTool account];
    offset2=1;
    NSString *pageIndex=[NSString stringWithFormat:@"%li",(long)offset2];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",pageIndex,@"pageIndex",@"20",@"pageSize",nil];
    [RequestData myConsumeSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
        int code=[data[@"code"] intValue];
        [self.consumeTableView.mj_header endRefreshing];
        if (code==0) {
            [self.consumeArray removeAllObjects];
            NSArray *array=data[@"content"];
            [self.consumeArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)]];
            int money=0;
            for (int i=0; i<self.consumeArray.count; i++) {
                money+=[self.consumeArray[i][@"money"] intValue];
            }
            self.consumeLabel.text=[NSString stringWithFormat:@"¥%i",money];
            //更新主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.consumeTableView reloadData];
            });
        }else{
            
        }
    } andFailure:^(NSError *error) {
        [self.consumeTableView.mj_header endRefreshing];
    }];
}
/**
 *  消费明细上拉加载
 */
-(void)loadMoreData
{
    account=[AccountTool account];
    offset2+=1;
    NSString *pageIndex=[NSString stringWithFormat:@"%li",(long)offset2];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",pageIndex,@"pageIndex",@"20",@"pageSize",nil];
    [RequestData myConsumeSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
        int code=[data[@"code"] intValue];
        [self.consumeTableView.mj_footer endRefreshing];
        if (code==0) {
            NSArray *array=data[@"content"];
            [self.consumeArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.consumeArray.count, array.count)]];
            //更新主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.consumeTableView reloadData];
            });
        }else{
            
        }
    } andFailure:^(NSError *error) {
        [self.consumeTableView.mj_footer endRefreshing];
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
    if (tableView==self.rechargeTableView) {
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
    if (tableView==self.rechargeTableView) {
        static NSString *cellStr=@"ConsumeCell";
        ConsumeCell *cell=[self.rechargeTableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell==nil) {
            cell=[[ConsumeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        //取消Cell选中时背景
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.timeLabel.text=_rechargeArray[indexPath.row][@"time"];
        cell.moneyLabel.text=[NSString stringWithFormat:@"¥%@",_rechargeArray[indexPath.row][@"money"]];
        cell.channelLabel.text=_rechargeArray[indexPath.row][@"content"];
        return cell;
    }else if(tableView==self.consumeTableView){
        static NSString *cellStr=@"RechargeCell";
        RechargeCell *cell=[self.consumeTableView dequeueReusableCellWithIdentifier:cellStr];
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

/**
 *  选项卡
 */
-(void)segmentControl{
    CGRect frame = CGRectMake(40,9, 240.f, 30.f);
    NSArray * items = @[@"充值明细", @"消费明细"];
    LXDSegmentControlConfiguration * select = [LXDSegmentControlConfiguration configurationWithControlType: LXDSegmentControlTypeSelectBlock items: items];
    select.cornerColor=[UIColor colorWithRed:231.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1];
    select.backgroundColor=[UIColor colorWithRed:231.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1];
    select.itemBackgroundColor=[UIColor whiteColor];
    select.itemSelectedColor=[UIColor colorWithRed:231.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1];
    select.itemTextColor=[UIColor colorWithRed:231.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1];
    select.cornerWidth=0.5f;
    LXDSegmentControl * selectControl = [LXDSegmentControl segmentControlWithFrame: frame configuration: select delegate: self];
    [_topView addSubview:selectControl];
    
}
#pragma mark - LXDSegmentControlDelegate
- (void)segmentControl:(LXDSegmentControl *)segmentControl didSelectAtIndex:(NSUInteger)index
{
    if (index==0) {
        self.rechargeTableView.hidden=NO;
        self.consumeTableView.hidden=YES;
        self.consumeView.hidden=YES;
        self.rechargeView.hidden=NO;
    }else if(index==1){
        self.rechargeTableView.hidden=YES;
        self.consumeTableView.hidden=NO;
        self.consumeView.hidden=NO;
        self.rechargeView.hidden=YES;
    }
}
@end
