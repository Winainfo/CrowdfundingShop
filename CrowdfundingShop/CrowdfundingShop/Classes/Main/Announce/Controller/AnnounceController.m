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
@interface AnnounceController ()<UITableViewDataSource,UITableViewDelegate,MZTimerLabelDelegate>{
    MZTimerLabel *timerExample3;
}
@property (assign,nonatomic)BOOL flag;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
@property (retain,nonatomic)NSArray *categoryNameArray;
@property (retain,nonatomic)NSArray *unselectImageArray;
@property (retain,nonatomic)NSArray *selectImageArray;
/**最新揭晓数组*/
@property (retain,nonatomic) NSArray *announcedArray;
/**用户数组*/
@property (retain,nonatomic) NSMutableArray *userNameArray;
@property (retain,nonatomic) NSArray *array;

@property (nonatomic, strong) NSMutableArray *times;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation AnnounceController

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
    //最新揭晓数据请求
    [self requestAnnouncedData:@"1" andpageSize:@"6"];
    
    //    self.myTableView.tableHeaderView=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //        [self requestAnnouncedData:@"2" andpageSize:@"3"];
    //    }];
    
    _times = @[].mutableCopy;
    [self addTimer];
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


/**
 *  请求最新揭晓商品
 *
 *  @param pageindex 当前页
 *  @param pagesize  当前有几条
 */
-(void)requestAnnouncedData:(NSString *)pageindex andpageSize:(NSString *)pagesize{
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:pageindex,@"pageIndex",pagesize,@"pageSize",nil];
    [RequestData newAnnounced:params FinishCallbackBlock:^(NSDictionary *data) {
        self.announcedArray=data[@"content"];
        //声明空间
        self.userNameArray=[[NSMutableArray alloc]initWithCapacity:self.announcedArray.count];
        //        获取用户名
        for (int i=0; i<self.announcedArray.count; i++) {
            if ([self.announcedArray[i][@"q_showtime"]isEqualToString:@"Y"]) {
                //获取当前时间
                //实例化一个NSDateFormatter对象
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                NSDate *currentDate = [NSDate date];//获取当前时间，日期
                [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss.SS"];
                NSString *dateString = [dateFormatter stringFromDate:currentDate];
                NSDateFormatter *date=[[NSDateFormatter alloc] init];
                [date setDateFormat:@"YYYY-MM-dd HH:mm:ss.SS"];
                NSCalendar *cal=[NSCalendar currentCalendar];
                unsigned int unitFlags=NSYearCalendarUnit| NSMonthCalendarUnit| NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
                NSDateComponents *d = [cal components:unitFlags fromDate:[date dateFromString:dateString] toDate:[date dateFromString:self.announcedArray[i][@"q_end_time"]] options:0];
                NSLog(@"%ld分钟%ld秒",(long)[d minute],(long)[d second]);
                long m=[d minute];
                long s=[d second];
                long time=m*60+s;
                [_times addObject:@(time)];
            }
            NSDictionary *params1=[NSDictionary dictionaryWithObjectsAndKeys:self.announcedArray[i][@"q_uid"],@"uid",nil];
            [RequestData userDetail:params1 FinishCallbackBlock:^(NSDictionary *block) {
                int code=[block[@"code"] intValue];
                NSDictionary *dic;
                if (code==0) {
                    dic=[NSDictionary dictionaryWithObjectsAndKeys:block[@"content"][@"username"],@"name", nil];
                }else{
                    dic=[NSDictionary dictionaryWithObjectsAndKeys:@"",@"name", nil];
                }
                [self.userNameArray addObject:dic];
            }];
        }
        //更新主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myTableView reloadData];
        });
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
    NSLog(@"%@",self.userNameArray);
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
            [self requestAnnouncedData:@"1" andpageSize:@"6"];
            cell.timeLabel2.text=@"正在计算结果";
        }
        return cell;
    }else{
        cell.view1.hidden=NO;
        cell.view2.hidden=YES;
        //姓名
        //    cell.nameLabel.text=self.announcedArray[indexPath.row][@""];
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
        //用户名
        //    NSLog(@"----%@",self.array);
        //    cell.nameLabel.text=self.array[indexPath.row][@"name"];
        //    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:_announcedArray[indexPath.row][@"q_uid"],@"uid",nil];
        //    [RequestData userDetail:params FinishCallbackBlock:^(NSDictionary *data) {
        ////        [cell.nameLabel.text setTitle:data[@"content"][@"username"] forState:UIControlStateNormal];
        //        cell.nameLabel.text=data[@"content"][@"username"];
        //    }];
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


@end
