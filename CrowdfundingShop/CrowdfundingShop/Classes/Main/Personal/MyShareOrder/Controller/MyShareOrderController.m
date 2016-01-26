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
@interface MyShareOrderController ()<LXDSegmentControlDelegate>{
    AccountModel *account;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UITableView *shareOrderTableView;
/**已晒单数组*/
@property (retain,nonatomic)NSArray *doArray;
/**未晒单数组*/
@property (retain,nonatomic)NSArray *goodsArray;
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
    [self doShareServer:@"1" andpageSize:@"6"];
    [self shareServer:@"1" andpageSize:@"6"];
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
