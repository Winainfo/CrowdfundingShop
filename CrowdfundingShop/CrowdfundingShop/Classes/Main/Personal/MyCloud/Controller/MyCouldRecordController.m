//
//  MyCouldRecordController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/29.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "MyCouldRecordController.h"
#import "MyCouldRecordCell.h"
#import "DoMyCouldRecordCell.h"
#import "LXDSegmentControl.h"
#import "RequestData.h"
#import "AccountTool.h"
#import <UIImageView+WebCache.h>
#import <MBProgressHUD.h>
#import <MJRefresh.h>
@interface MyCouldRecordController ()<LXDSegmentControlDelegate>{
    AccountModel *account;
    NSInteger offset1;
    NSInteger offset2;
}
/**已揭晓表*/
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
/**进行中表*/
@property (weak, nonatomic) IBOutlet UITableView *doMyTableView;
/**已揭晓数组*/
@property (retain,nonatomic) NSMutableArray *didArray;
/**进行中数组*/
@property (retain,nonatomic) NSMutableArray *inArray;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end

@implementation MyCouldRecordController
-(NSMutableArray *)didArray
{
    if (_didArray==nil)
    {
        _didArray=[NSMutableArray array];
    }
    return _didArray;
}
-(NSMutableArray *)inArray
{
    if (_inArray==nil)
    {
        _inArray=[NSMutableArray array];
    }
    return _inArray;
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
    self.title=@"我的夺宝记录";
    //导航栏右侧按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateSelected];
    leftBtn.frame=CGRectMake(-5, 5, 30, 30);
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
    //创建xib文件对象
    UINib *nib=[UINib nibWithNibName:@"MyCouldRecordCell" bundle:[NSBundle mainBundle]];
    //注册到表格视图
    [self.myTableView  registerNib:nib forCellReuseIdentifier:@"MyCouldRecordCell"];
    [self setExtraCellLineHidden:self.myTableView];
    //创建xib文件对象
    UINib *nib1=[UINib nibWithNibName:@"DoMyCouldRecordCell" bundle:[NSBundle mainBundle]];
    //注册到表格视图
    [self.doMyTableView  registerNib:nib1 forCellReuseIdentifier:@"DoMyCouldRecordCell"];
    [self setExtraCellLineHidden:self.doMyTableView];
    /**已揭晓数据*/
    self.myTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDoData)];
    [self.myTableView.mj_header beginRefreshing];
    self.myTableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadDoMoreData)];
    offset1=1;
    /**进行中数据*/
    self.doMyTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.doMyTableView.mj_header beginRefreshing];
    self.doMyTableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    offset2=1;
    [self segmentControl];
}
#pragma mark - 加载新数据
/**
 *  已揭晓下拉刷新
 */
-(void)loadDoData
{
    if (self.didArray.count==0) {
        //声明对象；
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
        //显示的文本；
        hud.labelText = @"正在加载...";
        account=[AccountTool account];
        offset1=1;
        NSString *pageIndex=[NSString stringWithFormat:@"%li",(long)offset1];
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",@"",@"state",pageIndex,@"pageIndex",@"8",@"pageSize",nil];
        [RequestData myRecordSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
            int code=[data[@"code"] intValue];
            [self.myTableView.mj_header endRefreshing];
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
                [self.didArray removeAllObjects];
                NSArray *array=data[@"content"];
                [self.didArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)]];
                //更新主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.myTableView reloadData];
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
            [self.myTableView.mj_header endRefreshing];
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
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",@"",@"state",pageIndex,@"pageIndex",@"8",@"pageSize",nil];
        [RequestData myRecordSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
            int code=[data[@"code"] intValue];
            [self.myTableView.mj_header endRefreshing];
            if (code==0) {
                [self.didArray removeAllObjects];
                NSArray *array=data[@"content"];
                [self.didArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)]];
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
}
/**
 *  已揭晓上拉加载
 */
-(void)loadDoMoreData
{
    account=[AccountTool account];
    offset1+=1;
    NSString *pageIndex=[NSString stringWithFormat:@"%li",(long)offset1];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",@"",@"state",pageIndex,@"pageIndex",@"8",@"pageSize",nil];
    [RequestData myRecordSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
        int code=[data[@"code"] intValue];
        [self.doMyTableView.mj_footer endRefreshing];
        if (code==0) {
            NSArray *array=data[@"content"];
            [self.inArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.inArray.count, array.count)]];
            //更新主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.doMyTableView reloadData];
            });
        }else{
            
        }
    } andFailure:^(NSError *error) {
        [self.doMyTableView.mj_footer endRefreshing];
    }];
    
}
/**
 *  进行中下拉刷新
 */
-(void)loadNewData
{
    account=[AccountTool account];
    offset2=1;
    NSString *pageIndex=[NSString stringWithFormat:@"%li",(long)offset2];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",@"ing",@"state",pageIndex,@"pageIndex",@"8",@"pageSize",nil];
    [RequestData myRecordSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
        int code=[data[@"code"] intValue];
        [self.doMyTableView.mj_header endRefreshing];
        if (code==0) {
            [self.inArray removeAllObjects];
            NSArray *array=data[@"content"];
            [self.inArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)]];
            //更新主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.doMyTableView reloadData];
            });
        }else{
            
        }
    } andFailure:^(NSError *error) {
        [self.doMyTableView.mj_header endRefreshing];
    }];
}
/**
 *  进行中上拉加载
 */
-(void)loadMoreData
{
    account=[AccountTool account];
    offset2+=1;
    NSString *pageIndex=[NSString stringWithFormat:@"%li",(long)offset2];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",@"ing",@"state",pageIndex,@"pageIndex",@"8",@"pageSize",nil];
    [RequestData myRecordSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
        int code=[data[@"code"] intValue];
        [self.doMyTableView.mj_footer endRefreshing];
        if (code==0) {
            NSArray *array=data[@"content"];
            [self.inArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.inArray.count, array.count)]];
            //更新主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.doMyTableView reloadData];
            });
        }else{
            
        }
    } andFailure:^(NSError *error) {
        [self.doMyTableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark 数据源
/**
 *  已揭晓
 */
-(void)didAnnounceServer:(NSString *)pageindex andpageSize:(NSString *)pagesize{
    account=[AccountTool account];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",@"",@"state",pageindex,@"pageIndex",pagesize,@"pageSize",nil];
    //声明对象；
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    //显示的文本；
    hud.labelText = @"正在加载...";
    [RequestData myRecordSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
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
        self.didArray=data[@"content"];
        //更新主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myTableView reloadData];
        });
    } andFailure:^(NSError *error) {
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
 *  进行中
 */
-(void)inAnnounceServer:(NSString *)pageindex andpageSize:(NSString *)pagesize{
    account=[AccountTool account];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",@"ing",@"state",pageindex,@"pageIndex",pagesize,@"pageSize",nil];
    [RequestData myRecordSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
        int code=[data[@"code"] intValue];
        if (code==0) {
            self.inArray=data[@"content"];
            //更新主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.doMyTableView reloadData];
            });
        }else{
            
        }
    }andFailure:^(NSError *error) {
        
    }];
}
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
        return _didArray.count;
    }else{
        return _inArray.count;
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
        static NSString *cellStr=@"MyCouldRecordCell";
        MyCouldRecordCell *cell=[self.myTableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell==nil) {
            cell=[[MyCouldRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        //取消Cell选中时背景
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.goodsTitleLabel.text=_didArray[indexPath.row][@"shopname"];
        cell.timeLabel.text=_didArray[indexPath.row][@"q_end_time"];
        /**商品图片*/
        //拼接图片网址·
        NSString *urlStr =[NSString stringWithFormat:@"%@%@",imgURL,_didArray[indexPath.row][@"thumb"]];
        //转换成url
        NSURL *imgUrl = [NSURL URLWithString:urlStr];
        [cell.goodsImageView sd_setImageWithURL:imgUrl];
        return cell;
    }else{
        static NSString *cellStr=@"DoMyCouldRecordCell";
        DoMyCouldRecordCell *cell=[self.doMyTableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell==nil) {
            cell=[[DoMyCouldRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        //取消Cell选中时背景
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.goodsLabel.text=_inArray[indexPath.row][@"shopname"];
        cell.goodsLabel1.text=_inArray[indexPath.row][@"canyurenshu"];
        cell.goodsLabel2.text=_inArray[indexPath.row][@"zongrenshu"];
        cell.goodsLabel3.text=_inArray[indexPath.row][@"shenyurenshu"];
        cell.goodsPriceLabel.text=[NSString stringWithFormat:@"¥%@",_inArray[indexPath.row][@"money"]];
        /**进度条*/
        float curreNum=[_inArray[indexPath.row][@"canyurenshu"] floatValue];
        float countNum=[_inArray[indexPath.row][@"zongrenshu"] floatValue];
        cell.ProgressView.progress=curreNum/countNum;
        /**商品图片*/
        //拼接图片网址·
        NSString *urlStr =[NSString stringWithFormat:@"%@%@",imgURL,_inArray[indexPath.row][@"thumb"]];
        //转换成url
        NSURL *imgUrl = [NSURL URLWithString:urlStr];
        [cell.goodsImageView sd_setImageWithURL:imgUrl];
        return cell;
    }
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
    return 97;
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
    NSArray * items = @[@"已揭晓", @"进行中"];
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
        self.myTableView.hidden=NO;
        self.doMyTableView.hidden=YES;
    }else if(index==1){
        self.myTableView.hidden=YES;
        self.doMyTableView.hidden=NO;
    }
}

@end
