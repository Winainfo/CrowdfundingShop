//
//  ShareOrderController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/16.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "ShareOrderController.h"
#import "ShareOrderCell.h"
#import "GoodsSortCell.h"
#import "ShareOrderDetailView.h"
#import "RequestData.h"
#import "CommentaryController.h"
#import <UIImageView+WebCache.h>
@interface ShareOrderController ()<UIScrollViewDelegate,CartCellDelegate>
@property (assign,nonatomic)BOOL flag;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UITableView *sortTableView;
@property (retain,nonatomic)NSArray *sortNameArray;
/**晒单*/
@property (retain,nonatomic)NSArray *shareArray;
@end

@implementation ShareOrderController

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
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Menlo" size:16.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title=@"晒单分享";
    //导航栏左侧按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateSelected];
    leftBtn.frame=CGRectMake(-5, 5, 21, 21);
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
    //创建xib文件对象
    UINib *nib=[UINib nibWithNibName:@"ShareOrderCell" bundle:[NSBundle mainBundle]];
    //注册到表格视图
    [self.myTableView  registerNib:nib forCellReuseIdentifier:@"ShareOrderCell"];
    self.myTableView.separatorStyle=NO;
    [self setExtraCellLineHidden:self.myTableView];
    //创建排序xib文件对象
    UINib *sortNib=[UINib nibWithNibName:@"GoodsSortCell" bundle:[NSBundle mainBundle]];
    //注册到表格视图
    [self.sortTableView  registerNib:sortNib forCellReuseIdentifier:@"GoodsSortCell"];
    [self setExtraCellLineHidden:self.sortTableView];
    //分类名字
    self.sortNameArray= @[ @"最新晒单", @"人气晒单", @"评论最多"];
    //即将揭晓数据请求
    [self requestData:@"1" andpageSize:@"8"];
}
#pragma mark 数据请求
/**
 *  请求即将揭晓商品
 */
-(void)requestData:(NSString *)pageindex andpageSize:(NSString *)pagesize{
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:pageindex,@"pageIndex",pagesize,@"pageSize",nil];
    [RequestData shareOrder:params FinishCallbackBlock:^(NSDictionary *data) {
        self.shareArray=data[@"content"];
        //更新主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myTableView reloadData];
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
    if(tableView==self.sortTableView){
        return self.sortNameArray.count;
    }
    return _shareArray.count;
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
    
    if(tableView==self.sortTableView){
        static NSString *cellStr=@"GoodsSortCell";
        GoodsSortCell *cell=[tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell==nil) {
            cell=[[GoodsSortCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        //取消Cell选中时背景
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.sortLabel.text=_sortNameArray[indexPath.row];
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
    }
    static NSString *cellStr=@"ShareOrderCell";
    ShareOrderCell *cell=[tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell==nil) {
        cell=[[ShareOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.idLabel.text=_shareArray[indexPath.row][@"sd_id"];
    cell.titleLabel.text=_shareArray[indexPath.row][@"sd_title"];
    cell.contentLabel.text=_shareArray[indexPath.row][@"sd_content"];
    cell.praiseLabel.text=_shareArray[indexPath.row][@"sd_zhan"];
    cell.commentaryLabel.text=_shareArray[indexPath.row][@"sd_ping"];
    //时间戳转换时间
    NSString *str=_shareArray[indexPath.row][@"sd_time"];//时间戳
    NSTimeInterval time=[str doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    cell.timeLabel.text=currentDateStr;
    /**晒单图片*/
    NSArray *imageArray=_shareArray[indexPath.row][@"sd_photolist"];
    cell.goodsImageScroll.contentSize=CGSizeMake(cell.goodsImageScroll.frame.size.width, cell.goodsImageScroll.frame.size.height);
    cell.goodsImageScroll.delegate=self;
    cell.delegate=self;
    for (int i=0; i<imageArray.count; i++) {
        //拼接图片网址·
        NSString *urlStr =[NSString stringWithFormat:@"%@%@",imgURL,imageArray[i]];
        //转换成url
        NSURL *imgUrl = [NSURL URLWithString:urlStr];
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake((i*100)+5, 0, 94, 94)];
        imageV.layer.borderWidth=0.5;
        imageV.layer.borderColor=[[UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1]CGColor];
        [imageV sd_setImageWithURL:imgUrl];
        [cell.goodsImageScroll addSubview:imageV];
    }
//    //获取头像和用户名
//     NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:_shareArray[indexPath.row][@"sd_userid"],@"uid",nil];
//    [RequestData userDetail:params FinishCallbackBlock:^(NSDictionary *data) {
//        [cell.peopleName setTitle:data[@"content"][@"username"] forState:UIControlStateNormal];
//        //拼接图片网址·
//        NSString *urlStr =[NSString stringWithFormat:@"%@%@",URL,data[@"content"][@"img"]];
//        //转换成url
//        NSURL *imgUrl = [NSURL URLWithString:urlStr];
//        [cell.peopleImageView sd_setImageWithURL:imgUrl];
//    }];

    //取消Cell选中时背景
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}


/**
 *  点击事件
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(tableView==self.sortTableView){
        //取出上次出现的 checkmark 的所在行
        GoodsSortCell *cellLast = [tableView cellForRowAtIndexPath:_lastIndexPath];
        cellLast.accessoryType = UITableViewCellAccessoryNone;
        cellLast.sortLabel.textColor=[UIColor blackColor];
        //将新点击的行加上 checkmark 的标记
        GoodsSortCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.sortLabel.textColor=[UIColor colorWithRed:252.0/255.0 green:102.0/255.0 blue:33.0/255.0 alpha:1];
        _lastIndexPath = indexPath;
        self.sortTableView.hidden=YES;
        self.myTableView.hidden=NO;
        _flag=NO;
    }else{
        //设置故事板为第一启动
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ShareOrderDetailView *shareOrderDetailView=[storyboard instantiateViewControllerWithIdentifier:@"ShareOrderDetailView"];
        shareOrderDetailView.sd_id=_shareArray[indexPath.row][@"sd_id"];
        shareOrderDetailView.dic=_shareArray[indexPath.row];
        [self.navigationController pushViewController:shareOrderDetailView animated:YES];
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
    if (tableView==self.sortTableView) {
        return 44;
    }
    return 260;
}

- (IBAction)sortBtnClick:(UIButton *)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 100:
            if (_flag) {
                self.sortTableView.hidden=YES;
                self.myTableView.hidden=NO;
                _flag=NO;
            }else{
                self.sortTableView.hidden=NO;
                self.myTableView.hidden=YES;
                _flag=YES;
            }
            break;
            
        default:
            break;
    }
}

#pragma mark -- 实现代理事件
/**
 *  实现加代理事件
 *
 *  @param cell 当前单元格
 *  @param flag 按钮标识，100为点赞，101为评论
 */
-(void)btnClick:(UITableViewCell *)cell andFlag:(int)flag andS_id:(NSString *)sid{
    switch (flag) {
        case 1001:{
            //设置故事板为第一启动
            UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            CommentaryController *controller=[storyboard instantiateViewControllerWithIdentifier:@"commentaryView"];
            controller.sd_id=sid;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 1002:
            NSLog(@"去分享");
            break;
        default:
            break;
    }
}
@end
