//
//  AccessGoodsController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/30.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "AccessGoodsController.h"
#import "AccessGoodsCell.h"
#import "RequestData.h"
#import "AccountTool.h"
#import <UIImageView+WebCache.h>
#import <MBProgressHUD.h>
#import <MJRefresh.h>
@interface AccessGoodsController (){
    AccountModel *account;
     NSInteger offset;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (retain,nonatomic) NSMutableArray *goodsArray;
@end

@implementation AccessGoodsController
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
    self.title=@"获得的商品";
    //导航栏右侧按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateSelected];
    leftBtn.frame=CGRectMake(-5, 5, 30, 30);
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
    //创建xib文件对象
    UINib *nib=[UINib nibWithNibName:@"AccessGoodsCell" bundle:[NSBundle mainBundle]];
    //注册到表格视图
    [self.myTableView  registerNib:nib forCellReuseIdentifier:@"AccessGoodsCell"];
    [self setExtraCellLineHidden:self.myTableView];
    /**未晒单数据*/
    self.myTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.myTableView.mj_header beginRefreshing];
    self.myTableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    offset=1;
}
#pragma mark 数据源
/**
 *  下拉刷新
 */
-(void)loadNewData
{
    if (self.goodsArray.count==0) {
        account=[AccountTool account];
        offset=1;
        NSString *pageIndex=[NSString stringWithFormat:@"%li",(long)offset];
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",@"ing",@"state",pageIndex,@"pageIndex",@"8",@"pageSize",nil];
        //声明对象；
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
        //显示的文本；
        hud.labelText = @"正在加载...";
        [RequestData gainGoodsSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
            int code=[data[@"code"] intValue];
            NSLog(@"数据:%@",data);
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
                [self.goodsArray removeAllObjects];
                NSArray *array=data[@"content"];
                [self.goodsArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)]];
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
    }else{
        account=[AccountTool account];
        offset=1;
        NSString *pageIndex=[NSString stringWithFormat:@"%li",(long)offset];
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",@"ing",@"state",pageIndex,@"pageIndex",@"8",@"pageSize",nil];
        [RequestData gainGoodsSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
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
}
/**
 *  上拉加载
 */
-(void)loadMoreData
{
    account=[AccountTool account];
    offset+=1;
    NSString *pageIndex=[NSString stringWithFormat:@"%li",(long)offset];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",@"ing",@"state",pageIndex,@"pageIndex",@"8",@"pageSize",nil];
    [RequestData gainGoodsSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
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

/**
 *  获得的商品
 */
-(void)requestServer:(NSString *)pageindex andpageSize:(NSString *)pagesize{
    account=[AccountTool account];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",pageindex,@"pageIndex",pagesize,@"pageSize",nil];
    //声明对象；
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    //显示的文本；
    hud.labelText = @"正在加载...";
    [RequestData gainGoodsSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
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
        
        self.goodsArray=data[@"content"];
        //更新主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myTableView reloadData];
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
    return self.goodsArray.count;
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
    static NSString *cellStr=@"AccessGoodsCell";
    AccessGoodsCell *cell=[self.myTableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell==nil) {
        cell=[[AccessGoodsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    //取消Cell选中时背景
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.goodsTitleLabel.text=_goodsArray[indexPath.row][@"shopname"];
    cell.timeLabel.text=_goodsArray[indexPath.row][@"q_end_time"];
    cell.numLabel.text=_goodsArray[indexPath.row][@"q_user_code"];
    /**商品图片*/
    //拼接图片网址·
    NSString *urlStr =[NSString stringWithFormat:@"%@%@",imgURL,_goodsArray[indexPath.row][@"thumb"]];
    //转换成url
    NSURL *imgUrl = [NSURL URLWithString:urlStr];
    [cell.goodsImageView sd_setImageWithURL:imgUrl];
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



@end
