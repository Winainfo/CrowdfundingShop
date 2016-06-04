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
#import <ShareSDK/ShareSDK.h>
#import <MBProgressHUD.h>
#import <MJRefresh.h>
@interface ShareOrderController ()<UIScrollViewDelegate,CartCellDelegate>
{
    NSInteger offset;
}
@property (assign,nonatomic)BOOL flag;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UITableView *sortTableView;
@property (retain,nonatomic)NSArray *sortNameArray;
@property (retain,nonatomic)NSArray *imageArray;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

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
-(NSMutableArray *)shareArray
{
    if (_shareArray==nil)
    {
        _shareArray=[NSMutableArray array];
    }
    return _shareArray;
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
    //请求分享列表
    if (self.shareArray.count==0) {
        //最新揭晓数据请求
        self.myTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        [self.myTableView.mj_header beginRefreshing];
        self.myTableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        offset=1;
    }else{
        self.shareBtn.hidden=YES;
        NSLog(@"数据%@",_shareArray);
        //更新主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myTableView reloadData];
        });
    }
}



#pragma mark 数据请求
/**
 *  下拉刷新
 */
-(void)loadNewData
{
    if (self.shareArray.count==0) {
        offset=1;
        NSString *pageIndex=[NSString stringWithFormat:@"%li",(long)offset];
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:pageIndex,@"pageIndex",@"8",@"pageSize",nil];
        //声明对象；
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
        //显示的文本；
        hud.labelText = @"正在加载...";
        [RequestData shareOrder:params FinishCallbackBlock:^(NSDictionary *data) {
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
                [self.shareArray removeAllObjects];
                NSArray *array=data[@"content"];
                [self.shareArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)]];
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
            [self.myTableView.mj_header endRefreshing];
        }];
    }else{
        offset=1;
        NSString *pageIndex=[NSString stringWithFormat:@"%li",(long)offset];
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:pageIndex,@"pageIndex",@"8",@"pageSize",nil];
        [RequestData shareOrder:params FinishCallbackBlock:^(NSDictionary *data) {
            int code=[data[@"code"] intValue];
            [self.myTableView.mj_header endRefreshing];
            if (code==0) {
                [self.shareArray removeAllObjects];
                NSArray *array=data[@"content"];
                [self.shareArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)]];
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
    offset+=1;
    NSString *pageIndex=[NSString stringWithFormat:@"%li",(long)offset];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:pageIndex,@"pageIndex",@"8",@"pageSize",nil];
    [RequestData shareOrder:params FinishCallbackBlock:^(NSDictionary *data) {
        int code=[data[@"code"] intValue];
        [self.myTableView.mj_footer endRefreshing];
        if (code==0) {
            NSArray *array=data[@"content"];
            [self.shareArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.shareArray.count, array.count)]];
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
-(void)requestData:(NSString *)pageindex andpageSize:(NSString *)pagesize{
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:pageindex,@"pageIndex",pagesize,@"pageSize",nil];
    //声明对象；
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    //显示的文本；
    hud.labelText = @"正在加载...";
    [RequestData shareOrder:params FinishCallbackBlock:^(NSDictionary *data) {
        self.shareArray=data[@"content"];
        int code=[data[@"code"]intValue];
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

            //更新主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.myTableView reloadData];
            });
        }
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
    long time=[_shareArray[indexPath.row][@"sd_time"] integerValue];//时间戳
    cell.timeLabel.text=[ShareOrderController timeFromTimestamp:time];
    /**晒单图片*/
    self.imageArray=_shareArray[indexPath.row][@"sd_photolist"];
    cell.goodsImageScroll.contentSize=CGSizeMake(cell.goodsImageScroll.frame.size.width, cell.goodsImageScroll.frame.size.height);
    cell.goodsImageScroll.delegate=self;
    [cell.peopleName setTitle:_shareArray[indexPath.row][@"q_user"] forState:UIControlStateNormal];
    /**用户头像*/
    //拼接图片网址·
    NSString *urlStr =[NSString stringWithFormat:@"%@%@",imgURL,_shareArray[indexPath.row][@"userphoto"]];
    //转换成url
    NSURL *imgUrl = [NSURL URLWithString:urlStr];
    [cell.peopleImageView sd_setImageWithURL:imgUrl];
        for (int i=0; i<self.imageArray.count; i++) {
            //拼接图片网址·
            NSString *urlStr =[NSString stringWithFormat:@"%@%@",imgURL,self.imageArray[i]];
            //转换成url
            NSURL *imgUrl = [NSURL URLWithString:urlStr];
            UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake((i*100)+5, 0, 94, 94)];
            imageV.layer.borderWidth=0.5;
            imageV.layer.borderColor=[[UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1]CGColor];
            [imageV sd_setImageWithURL:imgUrl];
            [cell.goodsImageScroll addSubview:imageV];
        }
    cell.delegate=self;
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
    NSIndexPath *index = [_myTableView indexPathForCell:cell];
    switch (flag) {
        case 1001:{
            //设置故事板为第一启动
            UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            CommentaryController *controller=[storyboard instantiateViewControllerWithIdentifier:@"commentaryView"];
            controller.sd_id=sid;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 1002:{
            /**商品图片*/
            //拼接图片网址·
            NSString *urlStr =[NSString stringWithFormat:@"%@%@",imgURL,self.shareArray[index.row][@"sd_thumbs"]];
            //转换成url
            NSURL *imgUrl = [NSURL URLWithString:urlStr];
            UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:imgUrl] scale:0.1];
            id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"%@",self.shareArray[index.row][@"sd_content"]]defaultContent:nil
                                                        image:[ShareSDK pngImageWithImage:image]
                                                        title:[NSString stringWithFormat:@"%@",self.shareArray[index.row][@"sd_title"]] url:[NSString stringWithFormat:@"http://mobile.yiydb.cn/index.php/mobile/shaidan/detail/%@",self.shareArray[index.row][@"sd_id"]]
                                                  description:@""
                                                    mediaType:SSPublishContentMediaTypeNews];
            //1+创建弹出菜单容器（iPad必要）
            id<ISSContainer> container = [ShareSDK container];
            [container setIPadContainerWithView:nil arrowDirect:UIPopoverArrowDirectionUp];
            //2、弹出分享菜单
            [ShareSDK showShareActionSheet:container shareList:nil content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil
                                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                        //可以根据回调提示用户。
                                        if (state == SSResponseStateCancel) {}
                                        if (state == SSResponseStateSuccess)
                                        {
                                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                            message:nil
                                                                                           delegate:self
                                                                                  cancelButtonTitle:@"OK"
                                                                                  otherButtonTitles:nil, nil];
                                            
                                            [alert show];
                                        }
                                        else if (state == SSResponseStateFail)
                                        {
                                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                            message:[NSString stringWithFormat:@"失败描述：%@",[error errorDescription]]
                                                                                           delegate:self
                                                                                  cancelButtonTitle:@"OK"
                                                                                  otherButtonTitles:nil, nil];
                                            [alert show];
                                        }
                                    }];
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
