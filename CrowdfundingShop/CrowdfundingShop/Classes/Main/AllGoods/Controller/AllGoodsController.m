//
//  AllGoodsController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/11/23.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "AllGoodsController.h"
#import "AllGoodsCell.h"
#import "GoodsCategoryCell.h"
#import "GoodsSortCell.h"
#import "DetailController.h"
#import "RequestData.h"
#import <MJRefresh.h>
#import <SVPullToRefresh.h>
#import <UIImageView+WebCache.h>
#import <MBProgressHUD.h>
@interface AllGoodsController ()<UITableViewDataSource,UITableViewDelegate>

@property (assign,nonatomic)BOOL flag;
@property (assign,nonatomic)BOOL flag1;
/**排序*/
@property (weak, nonatomic) IBOutlet UITableView *sortTableView;
@property (retain,nonatomic)NSArray *sortNameArray;
/**分类*/
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
@property (retain,nonatomic)NSArray *categoryNameArray;
@property (retain,nonatomic)NSArray *unselectImageArray;
@property (retain,nonatomic)NSArray *selectImageArray;
/**所有商品数组*/
@property (retain,nonatomic)NSMutableArray *allGoodsArray;
@property (assign,nonatomic)int page;
@end
static int pageNum = 1;
@implementation AllGoodsController
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationItem setHidesBackButton:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏标题颜色和字体大小UITextAttributeFont:[UIFont fontWithName:@"Heiti TC" size:0.0]
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Menlo" size:16.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title=@"所有商品";
    //创建xib文件对象
    UINib *nib=[UINib nibWithNibName:@"AllGoodsCell" bundle:[NSBundle mainBundle]];
    //注册到表格视图
    [self.myTableView  registerNib:nib forCellReuseIdentifier:@"AllGoodsCell"];
    [self setExtraCellLineHidden:self.myTableView];
    //创建分类xib文件对象
    UINib *categoryNib=[UINib nibWithNibName:@"GoodsCategoryCell" bundle:[NSBundle mainBundle]];
    //注册到表格视图
    [self.categoryTableView registerNib:categoryNib forCellReuseIdentifier:@"GoodsCategoryCell"];
    [self setExtraCellLineHidden:self.categoryTableView];
    //创建排序xib文件对象
    UINib *sortNib=[UINib nibWithNibName:@"GoodsSortCell" bundle:[NSBundle mainBundle]];
    //注册到表格视图
    [self.sortTableView registerNib:sortNib forCellReuseIdentifier:@"GoodsSortCell"];
    [self setExtraCellLineHidden:self.sortTableView];
    //分类名字
    self.categoryNameArray= @[ @"全部分类", @"手机数码", @"电脑办公", @"家用电器", @"化妆个性" , @"钟表首饰" , @"其他商品" ];
    self.unselectImageArray=@[@"category_2130837504_unselect",@"category_2130837505_unselect",@"category_2130837507_unselect",@"category_2130837506_unselect",@"category_2130837509_unselect",@"category_2130837508_unselect",@"category_2130837510_unselect"];
    self.selectImageArray=@[@"category_2130837504_select",@"category_2130837505_select",@"category_2130837507_select",@"category_2130837506_select",@"category_2130837509_select",@"category_2130837508_select",@"category_2130837510_select"];
    self.sortNameArray=@[@"即将揭晓",@"人气",@"价值(由高到低)",@"价值(由低到高)",@"最新"];
    /**所有商品数据源*/
    [self requestData:@"" andSort:@"" andIndex:@"1" andpagesize:@"8"];
    //上拉加载
    [self pushRefresh];
    //下拉刷新
    [self pullRefresh];
    [self.myTableView addInfiniteScrollingWithActionHandler:^{
    }];
}

/**
 *  下拉刷新
 */
-(void)pullRefresh{
    self.myTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:@"",@"categoryId",@"",@"sort",@"1",@"pageIndex",@"8",@"pageSize",nil];
        [RequestData allGoods:params FinishCallbackBlock:^(NSDictionary *data) {
            self.allGoodsArray=data[@"content"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.myTableView reloadData];
                // 结束刷新
                [self.myTableView.mj_header endRefreshing];
            });
        } andFailure:^(NSError *error) {
            
        }];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.myTableView.mj_header.automaticallyChangeAlpha = YES;
}
/**
 *  上拉加载
 */
-(void)pushRefresh{
    pageNum += 1;
    // 上拉刷新
    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getData];
        // 结束刷新
        [self.myTableView.mj_footer endRefreshing];
    }];
    // 默认先隐藏footer
    self.myTableView.mj_footer.hidden = YES;
}




-(void)getData{
    self.allGoodsArray=[NSMutableArray array];
    NSString *pageIndex=[NSString stringWithFormat:@"%i",pageNum];
    NSLog(@"---%@",pageIndex);
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:@"",@"categoryId",@"",@"sort",pageIndex,@"pageIndex",@"8",@"pageSize",nil];
    [RequestData allGoods:params FinishCallbackBlock:^(NSDictionary *data) {
        NSLog(@"参数%@",data);
        self.allGoodsArray=data[@"content"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myTableView reloadData];
            [self.myTableView.mj_footer endRefreshing];
        });
    }andFailure:^(NSError *error) {
    }];
}

#pragma mark 数据请求
/**
 *  请求所有商品
 */
-(void)requestData:(NSString *)categoryid andSort:(NSString *)sortid andIndex:(NSString *)pageindex andpagesize:(NSString *)pagesize{
    self.allGoodsArray=[NSMutableArray array];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:categoryid,@"categoryId",sortid,@"sort",pageindex,@"pageIndex",pagesize,@"pageSize",nil];
    //声明对象；
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    //显示的文本；
    hud.labelText = @"正在加载...";
    [RequestData allGoods:params FinishCallbackBlock:^(NSDictionary *data) {
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
        self.allGoodsArray=data[@"content"];
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
-(void)searchClick{
    
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
        return _allGoodsArray.count;
    }else if(tableView==self.categoryTableView){
        return _categoryNameArray.count;
    }else
    {
        return _sortNameArray.count;
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==self.myTableView){
        static NSString *cellStr=@"AllGoodsCell";
        AllGoodsCell *cell=[self.myTableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell==nil) {
            cell=[[AllGoodsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        //取消Cell选中时背景
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        /**商品名称*/
        cell.goodsLabel.text=[NSString stringWithFormat:@"(第%@期)%@",self.allGoodsArray[indexPath.row][@"qishu"],self.allGoodsArray[indexPath.row][@"title"]]
        ;
        /**商品价格*/
        cell.goodsPriceLabel.text=self.allGoodsArray[indexPath.row][@"money"];
        /**总需人次*/
        cell.goodsLabel2.text=self.allGoodsArray[indexPath.row][@"zongrenshu"];
        /**参与人次*/
        cell.goodsLabel1.text=self.allGoodsArray[indexPath.row][@"canyurenshu"];
        /**剩余人次*/
        cell.goodsLabel3.text=self.allGoodsArray[indexPath.row][@"shenyurenshu"];
        /**商品图片*/
        //拼接图片网址·
        NSString *urlStr =[NSString stringWithFormat:@"%@%@",imgURL,self.allGoodsArray[indexPath.row][@"thumb"]];
        //转换成url
        NSURL *imgUrl = [NSURL URLWithString:urlStr];
        [cell.goodsImageView sd_setImageWithURL:imgUrl];
        /**进度条*/
        float curreNum=[self.allGoodsArray[indexPath.row][@"canyurenshu"] floatValue];
        float countNum=[self.allGoodsArray[indexPath.row][@"zongrenshu"] floatValue];
        cell.ProgressView.progress=curreNum/countNum;
        return cell;
    }else if(tableView==self.categoryTableView){
        static NSString *cellStr=@"GoodsCategoryCell";
        GoodsCategoryCell *cell=[tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell==nil) {
            cell=[[GoodsCategoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        //取消Cell选中时背景
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.CategoryLabel.text=_categoryNameArray[indexPath.row];
        cell.imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",_unselectImageArray[indexPath.row]]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([indexPath isEqual:_lastIndexPath])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    }else if(tableView==self.sortTableView){
        static NSString *cellStr=@"GoodsSortCell";
        GoodsSortCell *cell=[_sortTableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell==nil) {
            cell=[[GoodsSortCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        //取消Cell选中时背景
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.sortLabel.text=_sortNameArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([indexPath isEqual:_sortIndexPath])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    }else{
        return NULL;
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
    if (tableView==self.myTableView) {
        return 96;
    }else if(tableView==self.categoryTableView){
        return 44;
    }else if(tableView==self.sortTableView)
    {
        return 44;
    }else{
        return 44;
    }
}

/**
 *  点击事件
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==self.categoryTableView){
        //取出上次出现的 checkmark 的所在行
        GoodsCategoryCell *cellLast = [tableView cellForRowAtIndexPath:_lastIndexPath];
        cellLast.accessoryType = UITableViewCellAccessoryNone;
        cellLast.CategoryLabel.textColor=[UIColor blackColor];
        cellLast.imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",_unselectImageArray[_lastIndexPath.row]]];
        //将新点击的行加上 checkmark 的标记
        GoodsCategoryCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.CategoryLabel.textColor=[UIColor colorWithRed:252.0/255.0 green:102.0/255.0 blue:33.0/255.0 alpha:1];
        cell.imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",_selectImageArray[indexPath.row]]];
        _lastIndexPath = indexPath;
        //切换图标
        [_categoryBtn setImage:[UIImage imageNamed:@"product_pull_down_bg"] forState:UIControlStateNormal];
        [_sortBtn setImage:[UIImage imageNamed:@"product_pull_down_bg"] forState:UIControlStateNormal];
        [self.categoryBtn setTitle:[NSString stringWithFormat:@"%@",_categoryNameArray[indexPath.row]] forState:UIControlStateNormal];
        self.categoryTableView.hidden=YES;
        self.sortTableView.hidden=YES;
        self.myTableView.hidden=NO;
        _flag=NO;
    }else if(tableView==self.sortTableView){
        //取出上次出现的 checkmark 的所在行
        GoodsSortCell *cellLast = [tableView cellForRowAtIndexPath:_sortIndexPath];
        cellLast.accessoryType = UITableViewCellAccessoryNone;
        cellLast.sortLabel.textColor=[UIColor blackColor];
        //将新点击的行加上 checkmark 的标记
        GoodsSortCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.sortLabel.textColor=[UIColor colorWithRed:252.0/255.0 green:102.0/255.0 blue:33.0/255.0 alpha:1];
        _sortIndexPath = indexPath;
        //切换图标
        [_categoryBtn setImage:[UIImage imageNamed:@"product_pull_down_bg"] forState:UIControlStateNormal];
        [_sortBtn setImage:[UIImage imageNamed:@"product_pull_down_bg"] forState:UIControlStateNormal];
        [self.sortBtn setTitle:[NSString stringWithFormat:@"%@",_sortNameArray[indexPath.row]] forState:UIControlStateNormal];
        self.categoryTableView.hidden=YES;
        self.sortTableView.hidden=YES;
        self.myTableView.hidden=NO;
        //        [self requestData:@"" andSort:@"40" andPageSize:@"1" andpageIndex:@"6"];
        [self.myTableView reloadData];
        _flag1=NO;
    }else{
        //设置故事板为第一启动
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DetailController *detailController=[storyboard instantiateViewControllerWithIdentifier:@"DetailControllerView"];
        detailController.goodsID=_allGoodsArray[indexPath.row][@"id"];
        detailController.dic=_allGoodsArray[indexPath.row];
        [self.navigationController pushViewController:detailController animated:YES];
    }
}


- (IBAction)click:(UIButton *)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 100:
            if (_flag) {
                [_categoryBtn setImage:[UIImage imageNamed:@"product_pull_down_bg"] forState:UIControlStateNormal];
                [_sortBtn setImage:[UIImage imageNamed:@"product_pull_down_bg"] forState:UIControlStateNormal];
                self.categoryTableView.hidden=YES;
                self.sortTableView.hidden=YES;
                self.myTableView.hidden=NO;
                _flag=NO;
            }else{
                [_categoryBtn setImage:[UIImage imageNamed:@"product_pull_up_bg"] forState:UIControlStateNormal];
                [_sortBtn setImage:[UIImage imageNamed:@"product_pull_down_bg"] forState:UIControlStateNormal];
                self.categoryTableView.hidden=NO;
                self.myTableView.hidden=YES;
                self.sortTableView.hidden=YES;
                _flag=YES;
            }
            break;
        case 101:
            if (_flag1) {
                [_sortBtn setImage:[UIImage imageNamed:@"product_pull_down_bg"] forState:UIControlStateNormal];
                [_categoryBtn setImage:[UIImage imageNamed:@"product_pull_down_bg"] forState:UIControlStateNormal];
                self.categoryTableView.hidden=YES;
                self.sortTableView.hidden=YES;
                self.myTableView.hidden=NO;
                _flag1=NO;
            }else{
                [_sortBtn setImage:[UIImage imageNamed:@"product_pull_up_bg"] forState:UIControlStateNormal];
                [_categoryBtn setImage:[UIImage imageNamed:@"product_pull_down_bg"] forState:UIControlStateNormal];
                self.sortTableView.hidden=NO;
                self.categoryTableView.hidden=YES;
                self.myTableView.hidden=YES;
                _flag1=YES;
            }
            break;
            
        default:
            break;
    }
    
}


@end
