//
//  SearchWordController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/17.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "SearchWordController.h"
#import "UIView+Extension.h"
#import "HWSearchBar.h"
#import "HistoryTableViewCell.h"
#import "HistoryClass.h"
#import "RequestData.h"
#import <UIImageView+WebCache.h>
#import <MBProgressHUD.h>
#import <MJRefresh.h>
#import "AllGoodsCell.h"
#import "CartModel.h"
#import "Database.h"
#import "DetailController.h"
@interface SearchWordController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,CartCellDelegate>{
    NSInteger offset;
}
@property (retain,nonatomic) NSString *nameStr;
@property (nonatomic,assign)BOOL flag;
@property (retain,nonatomic) NSArray *keyWordArray;
/**搜索历史表*/
@property (weak, nonatomic) IBOutlet UITableView *hitoryTable;
@property (retain,nonatomic) HWSearchBar *mySearchBar;
/**历史数组*/
@property (retain,nonatomic) NSArray *hisArr;
/**历史*/
@property (weak, nonatomic) IBOutlet UIView *myView;
/**搜索结果表*/
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
/**所有商品数组*/
@property (retain,nonatomic)NSMutableArray *allGoodsArray;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (retain,nonatomic)NSMutableArray *array1;
@end

@implementation SearchWordController
-(NSMutableArray *)allGoodsArray
{
    if (_allGoodsArray==nil)
    {
        _allGoodsArray=[NSMutableArray array];
    }
    return _allGoodsArray;
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
    //查询所有搜索历史
    self.hisArr = [HistoryClass findall];
    //为导航栏视图添加搜索栏
    _mySearchBar = [HWSearchBar searchBar];
    _mySearchBar.width =300;
    _mySearchBar.height = 30;
    self.navigationItem.titleView = _mySearchBar;
    //设置搜索栏的代理
    _mySearchBar.delegate=self;
    _mySearchBar.placeholder=@"搜索您要的宝贝";
    _mySearchBar.returnKeyType=UIReturnKeySearch;
    //导航栏左侧按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateSelected];
    leftBtn.frame=CGRectMake(-5, 5, 30, 30);
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
    //注册自定义搜索历史单元格
    UINib *nib = [UINib nibWithNibName:@"HistoryTableViewCell" bundle:[NSBundle mainBundle]];
    [self.hitoryTable registerNib:nib forCellReuseIdentifier:@"HistoryTableViewCell"];
//    self.hisArr=@[@"iPhone",@"奥迪",@"充值卡",@"苹果"];
    [self setExtraCellLineHidden:self.hitoryTable];
    //创建xib文件对象
    UINib *nib1=[UINib nibWithNibName:@"AllGoodsCell" bundle:[NSBundle mainBundle]];
    //注册到表格视图
    [self.searchTableView  registerNib:nib1 forCellReuseIdentifier:@"AllGoodsCell"];
    [self setExtraCellLineHidden:self.searchTableView];
    offset=1;
    //查询所有搜索历史
    self.hisArr = [HistoryClass findall];
    NSLog(@"数组:%lu",(unsigned long)self.hisArr.count);
}

#pragma mark textField监听
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

//返回
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 加载新数据
/**
 *  下拉刷新
 */
-(void)loadNewData;
{
    if (self.allGoodsArray.count==0) {
        offset=1;
        NSString *pageIndex=[NSString stringWithFormat:@"%li",(long)offset];
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:self.nameStr,@"keyword",pageIndex,@"pageIndex",@"8",@"pageSize",nil];
        //声明对象；
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
        //显示的文本；
        hud.labelText = @"正在加载...";
        [RequestData search:params FinishCallbackBlock:^(NSDictionary *data) {
            int code=[data[@"code"] intValue];
            [self.searchTableView.mj_header endRefreshing];
            if (code==0) {
                self.searchView.hidden=NO;
                self.myView.hidden=YES;
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
                
                [self.allGoodsArray removeAllObjects];
                NSArray *array=data[@"content"];
                [self.allGoodsArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.searchTableView reloadData];
                });
            }else{
                self.searchView.hidden=YES;
                self.myView.hidden=NO;
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
        }andFailure:^(NSError *error) {
            hud.removeFromSuperViewOnHide = true;
            [hud hide:true afterDelay:0];
            //显示失败的提示；
            MBProgressHUD *failHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
            failHUD.labelText = @"数据加载异常";
            failHUD.mode = MBProgressHUDModeCustomView;
            failHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_error"]];
            failHUD.removeFromSuperViewOnHide = true;
            [failHUD hide:true afterDelay:1];
            [self.searchTableView.mj_header endRefreshing];
        }];
    }else{
        offset=1;
        NSString *pageIndex=[NSString stringWithFormat:@"%li",(long)offset];
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:self.nameStr,@"keyword",pageIndex,@"pageIndex",@"8",@"pageSize",nil];
        [RequestData search:params FinishCallbackBlock:^(NSDictionary *data) {
            int code=[data[@"code"] intValue];
            [self.searchTableView.mj_header endRefreshing];
            if (code==0) {
                self.searchView.hidden=NO;
                self.myView.hidden=YES;
                [self.allGoodsArray removeAllObjects];
                NSArray *array=data[@"content"];
                [self.allGoodsArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.searchTableView reloadData];
                });
            }else{
                self.searchView.hidden=YES;
                self.myView.hidden=NO;
            }
        }andFailure:^(NSError *error) {
            [self.searchTableView.mj_header endRefreshing];
        }];
    }
}
/**
 *  上拉加载
 */
-(void)loadMoreData
{
    offset+=1;
    NSString *pageIndex=[NSString stringWithFormat:@"%li",(long)offset];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:self.nameStr,@"keyword",pageIndex,@"pageIndex",@"8",@"pageSize",nil];
    [RequestData search:params FinishCallbackBlock:^(NSDictionary *data) {
        int code=[data[@"code"] intValue];
        [self.searchTableView.mj_footer endRefreshing];
        if (code==0) {
            self.searchView.hidden=NO;
            self.myView.hidden=YES;
            NSArray *array=data[@"content"];
            [self.allGoodsArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.allGoodsArray.count, array.count)]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.searchTableView reloadData];
            });
        }else{
            self.searchView.hidden=YES;
            self.myView.hidden=NO;
        }
    }andFailure:^(NSError *error) {
        [self.searchTableView.mj_footer endRefreshing];
    }];
}
#pragma mark 表格代理
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
//单元格个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.searchTableView) {
        return self.allGoodsArray.count;
    }
    return self.hisArr.count;
}
//单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.searchTableView) {
        static NSString *cellStr=@"AllGoodsCell";
        AllGoodsCell *cell=[self.searchTableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell==nil) {
            cell=[[AllGoodsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        //取消Cell选中时背景
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        /**商品名称*/
        cell.goodsLabel.text=[NSString stringWithFormat:@"%@",self.allGoodsArray[indexPath.row][@"title"]]
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
        cell.delegate=self;
        return cell;
    }else{
        HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryTableViewCell"];
        if (!cell) {
            cell = [[HistoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HistoryTableViewCell"];
        }
        HistoryClass *history = self.hisArr[(self.hisArr.count-1-indexPath.row)];
        cell.foodName.text =history.Hname;
        return cell ;
    }
}
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.searchTableView) {
        return 96;
    }
    return 35;
}
//点击历史记录，跳转到分类结果页
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.searchTableView) {
        //设置故事板为第一启动
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DetailController *detailController=[storyboard instantiateViewControllerWithIdentifier:@"DetailControllerView"];
        detailController.goodsID=_allGoodsArray[indexPath.row][@"id"];
        detailController.dic=_allGoodsArray[indexPath.row];
        [self.navigationController pushViewController:detailController animated:YES];
    }else{
        HistoryTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        self.nameStr=cell.foodName.text;
//        self.searchTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//        [self.searchTableView.mj_header beginRefreshing];
//        self.searchTableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [self searchData:cell.foodName.text];
    }
}
#pragma mark 表头
/*设置标题头的宽度*/
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView==self.searchTableView) {
        return 30;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView==self.searchTableView) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        view.backgroundColor=[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
        UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, kScreenWidth-20, 20)];
        NSString *str=[NSString stringWithFormat:@"共%lu个关于“%@”的搜索结果",(unsigned long)self.allGoodsArray.count,self.nameStr];
        lbl.text=str;
        [lbl setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1]];
        lbl.font=[UIFont fontWithName:@"Helvetica" size:14];
        [view addSubview:lbl];
        return view;
    }
    return nil;
}
#pragma 实现数据源协议中一些关于编辑操作方法

//调用编辑方法,修改数据
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView!=self.searchTableView) {
        if (editingStyle==UITableViewCellEditingStyleDelete) {
            //删除方法
            HistoryClass *his=self.hisArr[(self.hisArr.count-1-indexPath.row)];
            int hid=his.Hid;
            [HistoryClass deleteHISTORY:hid];
            self.hisArr = [HistoryClass findall];
            [self.hitoryTable reloadData];
        }
    }
}
//提交表格编辑样式
-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:YES];
    if (self.hitoryTable.editing==NO) {
        self.hitoryTable.editing=YES;
    }else{
        self.hitoryTable.editing=NO;
    }
}

-(void)searchData:(NSString *)name{
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:name,@"keyword",@"1",@"pageIndex",@"",@"pageSize",nil];
    //声明对象；
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    //显示的文本；
    hud.labelText = @"正在搜索...";
    [RequestData search:params FinishCallbackBlock:^(NSDictionary *data) {
        int code=[data[@"code"] intValue];
        if (code==0) {
            //加载成功，先移除原来的HUD；
            hud.removeFromSuperViewOnHide = true;
            [hud hide:true afterDelay:0];
            //然后显示一个成功的提示；
            MBProgressHUD *successHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
            successHUD.labelText = @"搜索成功";
            successHUD.mode = MBProgressHUDModeCustomView;
            //可以设置对应的图片；
            successHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_success"]];
            successHUD.removeFromSuperViewOnHide = true;
            [successHUD hide:true afterDelay:1];
            self.searchView.hidden=NO;
            self.myView.hidden=YES;
            [self.allGoodsArray removeAllObjects];
            NSArray *array=data[@"content"];
            [self.allGoodsArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.searchTableView reloadData];
            });
        }else{
            self.searchView.hidden=YES;
            self.myView.hidden=NO;
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
    }andFailure:^(NSError *error) {
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

}

#pragma mark -- 实现添加购物车点击代理事件
/**
 *  实现添加购物车点击代理事件
 *
 *  @param cell 当前单元格
 *  @param flag 按钮标识，101
 */
-(void)btnClick:(UITableViewCell *)cell andFlag:(int)flag
{
    NSIndexPath *index = [_searchTableView indexPathForCell:cell];
    switch (flag) {
        case 101:
        {
            //初始化数据库
            Database *db=[Database new];
            _array1=[db searchTestList:_allGoodsArray[index.row][@"id"]];
            if (_array1.count>0) {
                CartModel *cartList=_array1[0];
                int pkid=cartList.pk_id;
                cartList.num=cartList.num+1;
                cartList.price=cartList.price+1;
                cartList.pk_id=pkid;
                if ([db updateList:cartList]) {
                    NSLog(@"成功");
                }else{
                    NSLog(@"失败");
                }
            }else{
                CartModel *cartList=[CartModel new];
                //数据库 插入
                cartList.shopId=_allGoodsArray[index.row][@"id"];
                cartList.title=_allGoodsArray[index.row][@"title"];
                cartList.shenyurenshu=_allGoodsArray[index.row][@"shenyurenshu"];
                cartList.thumb=_allGoodsArray[index.row][@"thumb"];
                cartList.num=1;
                cartList.price=[_allGoodsArray[index.row][@"yunjiage"]intValue];
                if([db insertList:cartList])
                {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"添加成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }else
                {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"添加失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
        }
            break;
        default:
            break;
    }
}
/**
 *  搜索按钮
 *
 *  @param textField <#textField description#>
 *
 *  @return <#return value description#>
 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if ([self.mySearchBar.text length]>1) {
        //将搜索历史存到本地数据库
        [HistoryClass insertHname:_mySearchBar.text];
        //查询所有搜索历史
        self.hisArr = [HistoryClass findall];
        //刷新表格
        [self.hitoryTable reloadData];
        self.nameStr=self.mySearchBar.text;
        [self searchData:self.mySearchBar.text];
    }
    //搜索完成清空输入框的文字
    textField.text = nil;
    return YES;
}
/**
 *  清除所有搜索历史
 *
 *  @param sender <#sender description#>
 */
- (IBAction)cleanAllHistory:(id)sender {
    
    [HistoryClass deleteAllHistory];
    //查询所有搜索历史
    self.hisArr = [HistoryClass findall];
    //刷新表格
    [self.hitoryTable reloadData];
}
@end
