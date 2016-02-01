//
//  AnnounceController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/11/23.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "AnnounceController.h"
#import "NewGoodsCell.h"
#import "GoodsCategoryCell.h"
#import "DetailController.h"
#import "RequestData.h"
#import "DidAnnounceView.h"
#import "InAnnounceView.h"
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>
#import <MBProgressHUD.h>
@interface AnnounceController ()<UITableViewDataSource,UITableViewDelegate>{
    NSInteger offset;
}
@property (assign,nonatomic)BOOL flag;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
@property (retain,nonatomic)NSArray *categoryNameArray;
@property (retain,nonatomic)NSArray *unselectImageArray;
@property (retain,nonatomic)NSArray *selectImageArray;
/**最新揭晓数组*/
@property (retain,nonatomic) NSMutableArray *announcedArray;
/**时间数组*/
@property (nonatomic, strong) NSMutableArray *times;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation AnnounceController
-(NSMutableArray *)announcedArray
{
    if (_announcedArray==nil)
    {
        _announcedArray=[NSMutableArray array];
    }
    return _announcedArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏标题颜色和字体大小UITextAttributeFont:[UIFont fontWithName:@"Heiti TC" size:0.0]
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Menlo" size:16.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title=@"最新揭晓";
    //创建xib文件对象
    UINib *nib=[UINib nibWithNibName:@"NewGoodsCell" bundle:[NSBundle mainBundle]];
    //注册到表格视图
    [self.myTableView  registerNib:nib forCellReuseIdentifier:@"NewGoodsCell"];
    self.myTableView.separatorStyle=NO;
    [self setExtraCellLineHidden:self.myTableView];
    //创建分类xib文件对象
    UINib *categoryNib=[UINib nibWithNibName:@"GoodsCategoryCell" bundle:[NSBundle mainBundle]];
    //注册到表格视图
    [self.categoryTableView registerNib:categoryNib forCellReuseIdentifier:@"GoodsCategoryCell"];
    [self setExtraCellLineHidden:self.categoryTableView];
    //分类名字
    self.categoryNameArray= @[ @"全部分类", @"手机数码", @"电脑办公", @"家用电器", @"化妆个性" , @"钟表首饰" , @"其他商品" ];
    self.unselectImageArray=@[@"category_2130837504_unselect",@"category_2130837505_unselect",@"category_2130837507_unselect",@"category_2130837506_unselect",@"category_2130837509_unselect",@"category_2130837508_unselect",@"category_2130837510_unselect"];
    self.selectImageArray=@[@"category_2130837504_select",@"category_2130837505_select",@"category_2130837507_select",@"category_2130837506_select",@"category_2130837509_select",@"category_2130837508_select",@"category_2130837510_select"];
    _times = @[].mutableCopy;
    [self addTimer];
    //最新揭晓数据请求
    self.myTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.myTableView.mj_header beginRefreshing];
      self.myTableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    offset=1;

}

/**
 *  倒计时
 */
- (void)addTimer {
    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timeDecrement) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    [_timer fire];
}

- (void)timeDecrement {
    [self.times enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSNumber *number = (NSNumber *)obj;
        NSInteger currentTime = number.integerValue;
        currentTime --;
        if (currentTime >= 0) {
            NSNumber *currentNumber = [NSNumber numberWithInteger:currentTime];
            self.times[idx] = currentNumber;
        }
    }];
    [self.myTableView reloadData];
}

- (void)invalidTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)dealloc {
    [self invalidTimer];
}

#pragma mark - 加载新数据
/**
 *  下拉刷新
 */
-(void)loadNewData
{
    offset=1;
    NSString *pageIndex=[NSString stringWithFormat:@"%li",(long)offset];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:pageIndex,@"pageIndex",@"8",@"pageSize",nil];
    [RequestData newAnnounced:params FinishCallbackBlock:^(NSDictionary *data) {
        int code=[data[@"code"] intValue];
        [self.myTableView.mj_header endRefreshing];
        if (code==0) {
            [self.announcedArray removeAllObjects];
            NSArray *array=data[@"content"];
            [self.announcedArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)]];
            //获取用户名
            for (int i=0; i<self.announcedArray.count; i++) {
                if ([self.announcedArray[i][@"q_showtime"]isEqualToString:@"Y"]) {
                    //获取当前时间
                    //实例化一个NSDateFormatter对象
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    NSDate *currentDate = [NSDate date];//获取当前时间，日期
                    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                    NSString *dateString = [dateFormatter stringFromDate:currentDate];
                    NSDateFormatter *date=[[NSDateFormatter alloc] init];
                    [date setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                    NSCalendar *cal=[NSCalendar currentCalendar];
                    unsigned int unitFlags=NSYearCalendarUnit| NSMonthCalendarUnit| NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
                    NSDateComponents *d = [cal components:unitFlags fromDate:[date dateFromString:dateString] toDate:[date dateFromString:self.announcedArray[i][@"q_end_time"]] options:0];
                    long m=[d minute];
                    long s=[d second];
                    long time=m*60+s;
                    [_times addObject:@(time)];
                }
            }
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
 *  上拉加载
 */
-(void)loadMoreData
{
    offset+=1;
    NSString *pageIndex=[NSString stringWithFormat:@"%li",(long)offset];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:pageIndex,@"pageIndex",@"8",@"pageSize",nil];
    [RequestData newAnnounced:params FinishCallbackBlock:^(NSDictionary *data) {
        int code=[data[@"code"] intValue];
        [self.myTableView.mj_footer endRefreshing];
        if (code==0) {
            NSArray *array=data[@"content"];
            [self.announcedArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.announcedArray.count, array.count)]];
            //获取用户名
            for (int i=0; i<self.announcedArray.count; i++) {
                if ([self.announcedArray[i][@"q_showtime"]isEqualToString:@"Y"]) {
                    //获取当前时间
                    //实例化一个NSDateFormatter对象
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    NSDate *currentDate = [NSDate date];//获取当前时间，日期
                    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                    NSString *dateString = [dateFormatter stringFromDate:currentDate];
                    NSDateFormatter *date=[[NSDateFormatter alloc] init];
                    [date setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                    NSCalendar *cal=[NSCalendar currentCalendar];
                    unsigned int unitFlags=NSYearCalendarUnit| NSMonthCalendarUnit| NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
                    NSDateComponents *d = [cal components:unitFlags fromDate:[date dateFromString:dateString] toDate:[date dateFromString:self.announcedArray[i][@"q_end_time"]] options:0];
                    long m=[d minute];
                    long s=[d second];
                    long time=m*60+s;
                    [_times addObject:@(time)];
                }
            }
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
 *  请求最新揭晓商品
 *
 *  @param pageindex 当前页
 *  @param pagesize  当前有几条
 */
-(void)requestAnnouncedData:(NSString *)pageindex andpageSize:(NSString *)pagesize{
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:pageindex,@"pageIndex",pagesize,@"pageSize",nil];
    //声明对象；
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    //显示的文本；
    hud.labelText = @"正在加载...";
    [RequestData newAnnounced:params FinishCallbackBlock:^(NSDictionary *data) {
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
            self.announcedArray=data[@"content"];
            //获取用户名
            for (int i=0; i<self.announcedArray.count; i++) {
                if ([self.announcedArray[i][@"q_showtime"]isEqualToString:@"Y"]) {
                    //获取当前时间
                    //实例化一个NSDateFormatter对象
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    NSDate *currentDate = [NSDate date];//获取当前时间，日期
                    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                    NSString *dateString = [dateFormatter stringFromDate:currentDate];
                    NSDateFormatter *date=[[NSDateFormatter alloc] init];
                    [date setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                    NSCalendar *cal=[NSCalendar currentCalendar];
                    unsigned int unitFlags=NSYearCalendarUnit| NSMonthCalendarUnit| NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
                    NSDateComponents *d = [cal components:unitFlags fromDate:[date dateFromString:dateString] toDate:[date dateFromString:self.announcedArray[i][@"q_end_time"]] options:0];
                    long m=[d minute];
                    long s=[d second];
                    long time=m*60+s;
                    [_times addObject:@(time)];
                }
            }
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
    if(tableView==self.categoryTableView){
        return self.categoryNameArray.count;
    }
    return self.announcedArray.count;
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
    if(tableView==self.categoryTableView){
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
    }
    static NSString *cellStr=@"NewGoodsCell";
    NewGoodsCell *cell=[tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell==nil) {
        cell=[[NewGoodsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    //取消Cell选中时背景
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if ([self.announcedArray[indexPath.row][@"q_showtime"]isEqualToString:@"Y"]) {
        cell.view1.hidden=YES;
        cell.view2.hidden=NO;
        cell.goodsNameLabel.text=self.announcedArray[indexPath.row][@"title"];
        cell.priceLabel2.text=[NSString stringWithFormat:@"¥%@",self.announcedArray[indexPath.row][@"money"]];
        /**商品图片*/
        //拼接图片网址·
        NSString *urlStr =[NSString stringWithFormat:@"%@%@",imgURL,self.announcedArray[indexPath.row][@"thumb"]];
        //转换成url
        NSURL *imgUrl = [NSURL URLWithString:urlStr];
        [cell.goodsImageView2 sd_setImageWithURL:imgUrl];
        int time=[self.times[indexPath.row] intValue];
        if (time>0) {
            //倒计时
            cell.timeLabel2.text=[NSString stringWithFormat:@"%02d:%02d",(time%3600/60),(time%60)];
        }else if(time==0){
            //最新揭晓数据请求
//            [self requestAnnouncedData:@"1" andpageSize:@"6"];
            //更新主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.myTableView reloadData];
            });
            cell.timeLabel2.text=@"正在计算结果";
        }
        return cell;
    }else{
        cell.view1.hidden=NO;
        cell.view2.hidden=YES;
        //姓名
        cell.nameLabel.text=self.announcedArray[indexPath.row][@"username"];
        cell.priceLabel.text=[NSString stringWithFormat:@"¥%@",self.announcedArray[indexPath.row][@"money"]];
        cell.numLabel.text=self.announcedArray[indexPath.row][@"gonumber"];
        cell.timeLabel.text=self.announcedArray[indexPath.row][@"q_end_time"];
        /**商品图片*/
        //拼接图片网址·
        NSString *urlStr =[NSString stringWithFormat:@"%@%@",imgURL,self.announcedArray[indexPath.row][@"thumb"]];
        //转换成url
        NSURL *imgUrl = [NSURL URLWithString:urlStr];
        [cell.goodsImageView sd_setImageWithURL:imgUrl];
        /**商品图片*/
        //拼接图片网址·
        NSString *urlStr1 =[NSString stringWithFormat:@"%@%@",imgURL,self.announcedArray[indexPath.row][@"userphoto"]];
        //转换成url
        NSURL *imgUrl1 = [NSURL URLWithString:urlStr1];
        [cell.faceImageView sd_setImageWithURL:imgUrl1];
        return cell;
    }
}


/**
 *  点击事件
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
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
        self.categoryTableView.hidden=YES;
        self.myTableView.hidden=NO;
        _flag=NO;
    }else{
        if([self.announcedArray[indexPath.row][@"q_showtime"] isEqualToString:@"N"]){
            //设置故事板为第一启动
            UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            DidAnnounceView *controller=[storyboard instantiateViewControllerWithIdentifier:@"didAnnounceView"];
            controller.goodsID=self.announcedArray[indexPath.row][@"sid"];
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            //设置故事板为第一启动
            UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            InAnnounceView *controller=[storyboard instantiateViewControllerWithIdentifier:@"inAnnounceView"];
            controller.goodsID=self.announcedArray[indexPath.row][@"sid"];
            [self.navigationController pushViewController:controller animated:YES];
        }
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
    if(tableView==self.categoryTableView){
        return 44;
    }
    return 103;
}

/**
 *  显示隐藏分类
 *
 *  @param sender <#sender description#>
 */
- (IBAction)showHiddenClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 100:
            if (_flag) {
                self.categoryTableView.hidden=YES;
                self.myTableView.hidden=NO;
                _flag=NO;
            }else{
                self.categoryTableView.hidden=NO;
                self.myTableView.hidden=YES;
                _flag=YES;
            }
            break;
            
        default:
            break;
    }
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
