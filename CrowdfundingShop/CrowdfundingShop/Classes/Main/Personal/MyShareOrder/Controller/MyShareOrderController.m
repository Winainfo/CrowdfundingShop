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
#import "RequestData.h"
#import "AccountTool.h"
#import <UIImageView+WebCache.h>
#import <MBProgressHUD.h>
#import <MJRefresh.h>
@interface MyShareOrderController ()<LXDSegmentControlDelegate>{
    AccountModel *account;
    NSInteger offset1;
    NSInteger offset2;
}
/**未晒单表*/
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
/**已晒单表*/
@property (weak, nonatomic) IBOutlet UITableView *shareOrderTableView;
/**已晒单数组*/
@property (retain,nonatomic)NSMutableArray *doArray;
/**未晒单数组*/
@property (retain,nonatomic)NSMutableArray *goodsArray;
/**
 *  头部视图
 */
@property (weak, nonatomic) IBOutlet UIView *topView;
@end

@implementation MyShareOrderController
-(NSMutableArray *)doArray
{
    if (_doArray==nil)
    {
        _doArray=[NSMutableArray array];
    }
    return _doArray;
}
-(NSMutableArray *)goodsArray
{
    if (_goodsArray==nil)
    {
        _goodsArray=[NSMutableArray array];
    }
    return _goodsArray;
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
    [self segmentControl];
    /**已晒单数据*/
    self.shareOrderTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDoData)];
    [self.shareOrderTableView.mj_header beginRefreshing];
    self.shareOrderTableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadDoMoreData)];
    offset1=1;
    /**未晒单数据*/
    self.myTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.myTableView.mj_header beginRefreshing];
    self.myTableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    offset2=1;
}
#pragma mark - 加载新数据
/**
 *  已晒单下拉刷新
 */
-(void)loadDoData
{
    if (self.doArray.count==0) {
        //声明对象；
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
        //显示的文本；
        hud.labelText = @"正在加载...";
        account=[AccountTool account];
        offset1=1;
        NSString *pageIndex=[NSString stringWithFormat:@"%li",(long)offset1];
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",pageIndex,@"pageIndex",@"8",@"pageSize",nil];
        [RequestData myShareSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
            int code=[data[@"code"] intValue];
            [self.shareOrderTableView.mj_header endRefreshing];
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
                [self.doArray removeAllObjects];
                NSArray *array=data[@"content"];
                [self.doArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)]];
                //更新主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.shareOrderTableView reloadData];
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
            [self.shareOrderTableView.mj_header endRefreshing];
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
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",pageIndex,@"pageIndex",@"8",@"pageSize",nil];
    [RequestData myShareSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
        int code=[data[@"code"] intValue];
        [self.shareOrderTableView.mj_header endRefreshing];
        if (code==0) {
            [self.doArray removeAllObjects];
            NSArray *array=data[@"content"];
            [self.doArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)]];
            //更新主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.shareOrderTableView reloadData];
            });
        }else{
            
        }
    } andFailure:^(NSError *error) {
        [self.shareOrderTableView.mj_header endRefreshing];
    }];
    }
}
/**
 *  已晒单上拉加载
 */
-(void)loadDoMoreData
{
    account=[AccountTool account];
    offset1+=1;
    NSString *pageIndex=[NSString stringWithFormat:@"%li",(long)offset1];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",@"",@"state",pageIndex,@"pageIndex",@"8",@"pageSize",nil];
    [RequestData myShareSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
        int code=[data[@"code"] intValue];
        [self.shareOrderTableView.mj_footer endRefreshing];
        if (code==0) {
            NSArray *array=data[@"content"];
            [self.doArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.doArray.count, array.count)]];
            //更新主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.shareOrderTableView reloadData];
            });
        }else{
            
        }
    } andFailure:^(NSError *error) {
        [self.shareOrderTableView.mj_footer endRefreshing];
    }];
    
}
/**
 *  未晒单下拉
 */
-(void)loadNewData
{
    account=[AccountTool account];
    offset2=1;
    NSString *pageIndex=[NSString stringWithFormat:@"%li",(long)offset2];
   NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",@"ing",@"state",pageIndex,@"pageIndex",@"8",@"pageSize",nil];
    [RequestData postSingleList:params FinishCallbackBlock:^(NSDictionary *data) {
        int code=[data[@"code"] intValue];
        [self.myTableView.mj_header endRefreshing];
        if (code==0) {
            [self.goodsArray removeAllObjects];
            NSArray *array=data[@"content"];
            [self.goodsArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)]];
            //更新主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.myTableView reloadData];
            });
        }else{
            
        }
    } andFailure:^(NSError *error) {
        [self.myTableView.mj_header endRefreshing];
    }];
}
/**
 *  未晒单上拉加载
 */
-(void)loadMoreData
{
    account=[AccountTool account];
    offset2+=1;
    NSString *pageIndex=[NSString stringWithFormat:@"%li",(long)offset2];
   NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",@"ing",@"state",pageIndex,@"pageIndex",@"8",@"pageSize",nil];
    [RequestData postSingleList:params FinishCallbackBlock:^(NSDictionary *data) {
        int code=[data[@"code"] intValue];
        [self.myTableView.mj_footer endRefreshing];
        if (code==0) {
            NSArray *array=data[@"content"];
            [self.goodsArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.goodsArray.count, array.count)]];
            //更新主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.myTableView reloadData];
            });
        }else{
            
        }
    } andFailure:^(NSError *error) {
        [self.myTableView.mj_footer endRefreshing];
    }];
    
}
#pragma mark 数据源
/**
 *  已晒单
 */
-(void)doShareServer:(NSString *)pageindex andpageSize:(NSString *)pagesize{
    account=[AccountTool account];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",@"",@"state",pageindex,@"pageIndex",pagesize,@"pageSize",nil];
    //声明对象；
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    //显示的文本；
    hud.labelText = @"正在加载...";
    [RequestData myShareSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
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
        self.doArray=data[@"content"];
        //更新主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.shareOrderTableView reloadData];
        });
    }andFailure:^(NSError *error) {
        hud.removeFromSuperViewOnHide = true;
        [hud hide:true afterDelay:0];
        //显示失败的提示；
        MBProgressHUD *failHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
        failHUD.labelText = @"加载失败";
        failHUD.mode = MBProgressHUDModeCustomView;
        failHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_error"]];
        failHUD.removeFromSuperViewOnHide = true;
        [failHUD hide:true afterDelay:1];
    }];
}
/**
 *  未晒单
 */
-(void)shareServer:(NSString *)pageindex andpageSize:(NSString *)pagesize{
    account=[AccountTool account];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",@"ing",@"state",pageindex,@"pageIndex",pagesize,@"pageSize",nil];
    [RequestData postSingleList:params FinishCallbackBlock:^(NSDictionary *data) {
       
        int code=[data[@"code"] intValue];
        if (code==0) {
            self.goodsArray=data[@"content"];
            NSLog(@"未晒单:%@",self.goodsArray);
        }else{
            
        }
        //更新主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myTableView reloadData];
        });
    }andFailure:^(NSError *error) {
        
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
        return self.goodsArray.count;
    }else{
     return self.doArray.count;
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
        cell.goodsTitleLabel.text=_goodsArray[indexPath.row][@"title"];
        cell.numLabel.text=_goodsArray[indexPath.row][@"q_user_code"];
        cell.timeLabel.text=_goodsArray[indexPath.row][@"q_end_time"];
        /**商品图片*/
        //拼接图片网址·
        NSString *urlStr =[NSString stringWithFormat:@"%@%@",imgURL,_goodsArray[indexPath.row][@"thumb"]];
        //转换成url
        NSURL *imgUrl = [NSURL URLWithString:urlStr];
        [cell.goodsImageView sd_setImageWithURL:imgUrl];
        return cell;
    }else{
        static NSString *cellStr=@"DoShareOrderCell";
        DoShareOrderCell *cell=[self.shareOrderTableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell==nil) {
            cell=[[DoShareOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        //取消Cell选中时背景
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.timeLabel.text=_doArray[indexPath.row][@"sd_time"];
        cell.goodsTitleLabel.text=_doArray[indexPath.row][@"sd_title"];
        /**商品图片*/
        //拼接图片网址·
        NSString *urlStr =[NSString stringWithFormat:@"%@%@",imgURL,_doArray[indexPath.row][@"thumb"]];
        //转换成url
        NSURL *imgUrl = [NSURL URLWithString:urlStr];
        [cell.goodsImageView sd_setImageWithURL:imgUrl];
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

/**
 *  选项卡
 */
-(void)segmentControl{
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
    [_topView addSubview:selectControl];
    
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
