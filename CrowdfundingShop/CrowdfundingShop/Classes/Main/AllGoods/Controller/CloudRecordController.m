//
//  CloudRecordController.m
//  CrowdfundingShop
//  所有云购记录
//  Created by 吴金林 on 15/12/11.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "CloudRecordController.h"
#import "CloudRecordCell.h"
#import "RequestData.h"
#import <MBProgressHUD.h>
#import <UIImageView+WebCache.h>
@interface CloudRecordController ()<UITableViewDataSource,UITableViewDelegate>
@property (assign,nonatomic)BOOL flag;
@property (retain,nonatomic)NSArray *content;
@property (retain,nonatomic)NSArray *array;
@property (retain,nonatomic)NSString *gid;
@end

@implementation CloudRecordController

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
    self.title=@"所有云购记录";
    //导航栏左侧按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    leftBtn.frame=CGRectMake(-5, 5, 21, 21);
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
    //导航栏右侧按钮
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"buy_record_time_down_unselect"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"buy_record_time_down_unselect"] forState:UIControlStateSelected];
    rightBtn.tag=100;
    rightBtn.frame=CGRectMake(-5, 5, 30, 30);
    [rightBtn addTarget:self action:@selector(sortClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=right;
    //创建xib文件对象
    UINib *nib=[UINib nibWithNibName:@"CloudRecordCell" bundle:[NSBundle mainBundle]];
    //注册到表格视图
    [self.myTableView registerNib:nib forCellReuseIdentifier:@"CloudRecordCell"];
    [self setExtraCellLineHidden:self.myTableView];
    if (self.gid!=nil) {
        [self requestData:self.gid andpageIndex:@"1" andpageSize:@"8"];
    }else{
        self.array=self.content;
    }
}
#pragma mark 数据请求
/**
 *  商品详情
 *
 *  @param goodsId <#goodsId description#>
 */
-(void)requestData:(NSString *)goodsId andpageIndex:(NSString *)pageindex andpageSize:(NSString *)pagesize{
     NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:goodsId,@"itemId",pageindex,@"pageIndex",pagesize,@"pageSize",nil];
    //声明对象；
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    //显示的文本；
    hud.labelText = @"正在加载...";
    [RequestData buyRecordSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
        int code=[data[@"code"] intValue];
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
            
            self.array=data[@"content"];
            //更新主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.myTableView reloadData];
            });

        }else{
            
        }
    } andFailure:^(NSError *error) {
        
    }];
}
/**
 *  按时间排序
 *
 *  @param sender <#sender description#>
 */
- (void)sortClick:(UIButton *)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 100:
            if (_flag) {
                //导航栏右侧按钮
                UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
                [rightBtn setImage:[UIImage imageNamed:@"buy_record_time_down_unselect"] forState:UIControlStateNormal];
                [rightBtn setImage:[UIImage imageNamed:@"buy_record_time_down_unselect"] forState:UIControlStateSelected];
                rightBtn.tag=100;
                rightBtn.frame=CGRectMake(-5, 5, 30, 30);
                [rightBtn addTarget:self action:@selector(sortClick:) forControlEvents:UIControlEventTouchUpInside];
                UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
                self.navigationItem.rightBarButtonItem=right;
                _flag=NO;
            }else{
                //导航栏右侧按钮
                UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
                [rightBtn setImage:[UIImage imageNamed:@"buy_record_time_up_unselect"] forState:UIControlStateNormal];
                [rightBtn setImage:[UIImage imageNamed:@"buy_record_time_up_unselect"] forState:UIControlStateSelected];
                rightBtn.tag=100;
                rightBtn.frame=CGRectMake(-5, 5, 30, 30);
                [rightBtn addTarget:self action:@selector(sortClick:) forControlEvents:UIControlEventTouchUpInside];
                UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
                self.navigationItem.rightBarButtonItem=right;
                _flag=YES;
            }
            break;
            
        default:
            break;
    }
}
//返回
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
    return self.array.count;
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
    static NSString *cellStr=@"CloudRecordCell";
    CloudRecordCell *cell=[tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell==nil) {
        cell=[[CloudRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.nameLabel.text=self.array[indexPath.row][@"username"];
    cell.numLabel.text=self.array[indexPath.row][@"gonumber"];
    //时间戳转换时间
    long time=[self.array[indexPath.row][@"time"]intValue];//时间戳
    cell.timeLabel.text=[CloudRecordController timeFromTimestamp:time formtter:@"yyyy-MM-dd HH:mm"];
    /**商品图片*/
    //拼接图片网址·
    NSString *urlStr =[NSString stringWithFormat:@"%@%@",imgURL,self.array[indexPath.row][@"uphoto"]];
    //转换成url
    NSURL *imgUrl = [NSURL URLWithString:urlStr];
    [cell.peopleImageView sd_setImageWithURL:imgUrl];
    //截取城市
    NSString *string =self.array[indexPath.row][@"ip"];
    NSArray *strArray=[string componentsSeparatedByString:@","];
    cell.cityLabel.text=[NSString stringWithFormat:@"(%@)",strArray[0]];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
#define mark - 时间
/**
 *  时间戳转成字符串
 *
 *  @param timestamp 时间戳
 *
 *  @return 格式化后的字符串
 */
+ (NSString *)timeFromTimestamp:(NSInteger)timestamp{
    NSDateFormatter *dateFormtter =[[NSDateFormatter alloc] init];
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSTimeInterval late=[d timeIntervalSince1970]*1;	//转记录的时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;   //获取当前时间戳
    NSString *timeString=@"";
    NSTimeInterval cha=now-late;
    // 发表在一小时之内
    if (cha/3600<1) {
        if (cha/60<1) {
            timeString = @"1";
        }
        else
        {
            timeString = [NSString stringWithFormat:@"%f", cha/60];
            timeString = [timeString substringToIndex:timeString.length-7];
        }
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
    }
    // 在一小时以上24小以内
    else if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    // 发表在24以上10天以内
    else if (cha/86400>1&&cha/86400*3<1)	 //86400 = 60(分)*60(秒)*24(小时)   3天内
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@天前", timeString];
    }
    // 发表时间大于10天
    else
    {
        [dateFormtter setDateFormat:@"yyyy-MM-dd"];
        timeString = [dateFormtter stringFromDate:d];
    }
    return timeString;
}
/**
 *  根据格式将时间戳转换成时间
 *
 *  @param timestamp	时间戳
 *  @param dateFormtter 日期格式
 *
 *  @return 带格式的日期
 */
+ (NSString *)timeFromTimestamp:(NSInteger)timestamp formtter:(NSString *)formtter{
    NSDateFormatter *dataFormtter =[[NSDateFormatter alloc] init];
    [dataFormtter setDateFormat:formtter];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSString *time = [dataFormtter stringFromDate:date];
    return time;
}
/**
 *  获取当前时间戳
 */
+ (NSString *)timeIntervalGetFromNow{
    // 获取时间（非本地时区，需转换）
    NSDate * today = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:today];
    // 转换成当地时间
    NSDate *localeDate = [today dateByAddingTimeInterval:interval];
    // 时间转换成时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[localeDate timeIntervalSince1970]];
    return timeSp;
}


@end
