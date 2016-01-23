//
//  IndexController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/4.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "IndexController.h"
#import "PopularGoodsCell.h"
#import "goodsViewCell.h"
#import "AppDelegate.h"
#import "DetailController.h"
#import "DidAnnounceView.h"
#import "InAnnounceView.h"
#import "RequestData.h"
#import <UIImageView+WebCache.h>
#import <MBProgressHUD.h>
#import <MJRefresh.h>
#import "UIViewController+WeChatAndAliPayMethod.h"
@interface IndexController ()<UIScrollViewDelegate,MZTimerLabelDelegate,MBProgressHUDDelegate>{
    MZTimerLabel *timerExample3;
    MBProgressHUD *HUD;
}
@property (strong, nonatomic) IBOutlet UITableView *mytableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidth;
@property (weak, nonatomic) IBOutlet UITableViewCell *noticeCell;//公告
/**最新揭晓*/
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
/**最新揭晓数组*/
@property (retain,nonatomic) NSArray *announcedArray;
/**即将揭晓*/
@property (weak, nonatomic) IBOutlet UICollectionView *goodsCollectionView;
/**即将揭晓数组*/
@property (retain,nonatomic) NSMutableArray *revealedArray;
/**人气推荐*/
@property (weak, nonatomic) IBOutlet UICollectionView *groomCollectionView;
/**人气推荐数组*/
@property (retain,nonatomic) NSArray *groomArray;
/**限购专区*/
@property (weak, nonatomic) IBOutlet UICollectionView *limitCollectionView;

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;//滚动视图
@property (weak, nonatomic) IBOutlet UIPageControl *myPageControl;
@property (retain,nonatomic) NSTimer *time;//定时器对象s

@property(retain,nonatomic)UIView *btnView;
@property(retain,nonatomic)UIView *moveView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView1;

//滚动广告图片的tag值
@property (retain,nonatomic) NSMutableArray *scrollImageTags;
@property (retain,nonatomic) NSArray *imageArray;

@property (nonatomic, strong) NSMutableArray *times;
@property (nonatomic, strong) NSTimer *timer;
//倒计时

@end

@implementation IndexController

- (void)viewDidLoad {
    //设置导航栏标题颜色和字体大小UITextAttributeFont:[UIFont fontWithName:@"Heiti TC" size:0.0]
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Menlo" size:16.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title=@"1元商城";
    CGRect table=self.mytableView.frame;
    table.size.height=800;
    self.mytableView.frame=table;
    //注册Cell
    [self.myCollectionView registerClass:[PopularGoodsCell class] forCellWithReuseIdentifier:@"PopularGoodsCell"];
    //即将揭晓
    [self.goodsCollectionView registerClass:[goodsViewCell class] forCellWithReuseIdentifier:@"goodsViewCell"];
    //人气推荐
    [self.groomCollectionView registerClass:[goodsViewCell class] forCellWithReuseIdentifier:@"goodsViewCell"];
    //限购专区
    [self.limitCollectionView registerClass:[goodsViewCell class] forCellWithReuseIdentifier:@"goodsViewCell"];
    //代理
    self.myScrollView.delegate=self;
    //页面控制的当前页
    self.myPageControl.currentPage = 0;
    //滚动视图
    [self scrollViewAdv];
    //即将揭晓数据请求
    [self requestData:@"1" andpageSize:@"8"];
    //人气推荐数据请求
    [self requestHotData:@"1" andpageSize:@"8"];
    //最新揭晓数据请求
    [self requestAnnouncedData];
    //定时触发数据
    NSTimer *timer=[NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(requestAnnouncedData) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    //    [self requestAnnouncedData];
    self.revealedArray=[[NSMutableArray alloc]initWithCapacity:0];
    self.times=[[NSMutableArray alloc]init];
    [self addTimer];
    
}

/**
 *  更新约束
 */
-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.viewWidth.constant=CGRectGetWidth([UIScreen mainScreen].bounds)*2;
}
#pragma mark 倒计时
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
    [self.myCollectionView reloadData];
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

#pragma mark 数据请求
/**
 *  请求即将揭晓商品
 */
-(void)requestData:(NSString *)pageindex andpageSize:(NSString *)pagesize{
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:pageindex,@"pageIndex",pagesize,@"pageSize",nil];
        //声明对象；
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
        //显示的文本；
        hud.labelText = @"正在加载";
        hud.detailsLabelText = @"请稍候。。。";
    [RequestData beginRevealed:params FinishCallbackBlock:^(NSDictionary *data) {
        //加载成功，先移除原来的HUD；
        hud.removeFromSuperViewOnHide = true;
        [hud hide:true afterDelay:0];
        
        //然后显示一个成功的提示；
        MBProgressHUD *successHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
        successHUD.labelText = @"加载成功";
        successHUD.mode = MBProgressHUDModeCustomView;
        //可以设置对应的图片；
        successHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
        successHUD.removeFromSuperViewOnHide = true;
        [successHUD hide:true afterDelay:1];
        
        self.revealedArray=data[@"content"];
        //更新主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.goodsCollectionView reloadData];
        });
    } andFailure:^(NSError *failure) {
        NSLog(@"%@",failure);
        //        hud.removeFromSuperViewOnHide = true;
        //        [hud hide:true afterDelay:0];
        //显示失败的提示；
        MBProgressHUD *failHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
        failHUD.labelText = @"加载失败";
        failHUD.mode = MBProgressHUDModeCustomView;
        failHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
        failHUD.removeFromSuperViewOnHide = true;
        [failHUD hide:true afterDelay:1];
    }];
}

/**
 *  请求人气商品
 *
 *  @param pageindex 当前页
 *  @param pagesize  当前有几条
 */
-(void)requestHotData:(NSString *)pageindex andpageSize:(NSString *)pagesize{
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:pageindex,@"pageIndex",pagesize,@"pageSize",nil];
    [RequestData hotGoods:params FinishCallbackBlock:^(NSDictionary *data) {
        self.groomArray=data[@"content"];
        //更新主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.groomCollectionView reloadData];
        });
    }];
}
/**
 *  请求最新揭晓商品
 *
 *  @param pageindex 当前页
 *  @param pagesize  当前有几条
 */
-(void)requestAnnouncedData{
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"pageIndex",@"6",@"pageSize",nil];
    [RequestData newAnnounced:params FinishCallbackBlock:^(NSDictionary *data) {
        self.announcedArray=data[@"content"];
        //时间差
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
        }
        //更新主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myCollectionView reloadData];
        });
    }];
}

#pragma mark 图片滚动
/**
 *  请求数据
 */
-(void)scrollViewAdv
{
    //获取首页广告图片数组
    NSDictionary *prama = [NSDictionary dictionaryWithObjectsAndKeys: nil];
    [RequestData slides:prama FinishCallbackBlock:^(NSDictionary * data) {
        self.imageArray=data[@"content"];
        //设置滚动视图的包含的视图大小和图片
        [self scrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 150) andImages:self.imageArray];
        //设置定时滚动
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scrollAdView) userInfo:nil repeats:YES];
    }];
}

-(void)scrollViewWithFrame:(CGRect)frame andImages:(NSArray *)images
{
    self.myScrollView.showsHorizontalScrollIndicator = NO;
    self.myScrollView.showsVerticalScrollIndicator = NO;
    self.myScrollView.pagingEnabled = YES;
    //不显示边框外视图
    self.myScrollView.bounces= NO;
    self.myScrollView.contentSize = CGSizeMake(self.myScrollView.frame.size.width*images.count, self.myScrollView.frame.size.height);
    self.myPageControl.numberOfPages = images.count;
    //为滚动视图添加图片
    for (int i=0; i<images.count; i++) {
        //拼接图片网址·
        NSString *urlStr =[NSString stringWithFormat:@"%@",images[i][@"src"]];
        //        //获取图片的ID存入tag值数组
        //        [self.scrollImageTags addObject:images[i][@"id"]];
        
        //转换成url
        NSURL *imgUrl = [NSURL URLWithString:urlStr];
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(i*frame.size.width, 0, kScreenWidth, frame.size.height)];
        [imageV sd_setImageWithURL:imgUrl];
        [self.myScrollView addSubview:imageV];
        
        //为图片添加Tag值
        imageV.tag = (int)([self.scrollImageTags[i] intValue]+100);
        imageV.userInteractionEnabled = YES;
        UITapGestureRecognizer *scrollTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollViewClick)];
        [imageV addGestureRecognizer:scrollTap];
        
        
    }
}

//定时器自动滚动广告
- (void)scrollAdView
{
    int currentNum=(self.myScrollView.contentOffset.x/self.myScrollView.frame.size.width+1);
    if (currentNum == self.imageArray.count) {
        currentNum = 0;
    }
    self.myScrollView.contentOffset=CGPointMake(self.myScrollView.frame.size.width*currentNum,0);
    self.myPageControl.currentPage = currentNum;
    
}

#pragma mark 手动拖动的代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x/self.myScrollView.frame.size.width;
    self.myPageControl.currentPage=page;
}

/**
 *  图片滚动
 *
 *  @return <#return value description#>
 */
-(void)Carousel
{
    //设置显示文本内容的大小
    self.myScrollView.contentSize=CGSizeMake(kScreenWidth*3, 150);
    //添加要显示的图片
    for(int i=1;i<4;i++)
    {
        UIImageView *imgv=[[UIImageView alloc]initWithFrame:CGRectMake((i-1)*kScreenWidth, 0,kScreenWidth, 150)];
        imgv.image=[UIImage imageNamed:[NSString stringWithFormat:@"1.jpg"]];
        self.myScrollView.pagingEnabled=YES;
        self.myScrollView.showsVerticalScrollIndicator=NO;
        self.myScrollView.showsHorizontalScrollIndicator=NO;
        //添加到滚动视图
        [self.myScrollView addSubview:imgv];
        
    }
    [self.view addSubview:self.myScrollView];
    //创建定时器对象
    self.time=[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(gun:) userInfo:nil repeats:YES];
}

/**
 *  横幅滚动
 *
 *  @param sender <#sender description#>
 */
-(void)gun:(id)sender{
    self.myPageControl.currentPage=self.myScrollView.contentOffset.x/kScreenWidth;//获取当前页
    int currentpage=(int)(self.myScrollView.contentOffset.x/kScreenWidth+1)%3;
    [self.myScrollView setContentOffset:CGPointMake(currentpage*kScreenWidth, 0)];//控制偏移量
}


/**
 *  点击滚动视图图片进入详情页
 */
-(void)scrollViewClick
{
}

#pragma mark 实现代理方法
//每个section的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView==self.myCollectionView){
        return self.announcedArray.count;
    }else if(collectionView==self.groomCollectionView){ //人气推荐
        return self.groomArray.count;
    } else if(collectionView==self.limitCollectionView){ //限购专区
        return 2;
    }else{
        return self.revealedArray.count; //即将揭晓
    }
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView==self.myCollectionView) {
        PopularGoodsCell *cell = (PopularGoodsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PopularGoodsCell" forIndexPath:indexPath];
        /**商品名字*/
        cell.goodsNameLabel.text=self.announcedArray[indexPath.row][@"title"];
        /**商品图片*/
        //拼接图片网址·
        NSString *urlStr =[NSString stringWithFormat:@"%@%@",imgURL,self.announcedArray[indexPath.row][@"thumb"]];
        //转换成url
        NSURL *imgUrl = [NSURL URLWithString:urlStr];
        [cell.goodsImageView sd_setImageWithURL:imgUrl];
        
        if ([self.announcedArray[indexPath.row][@"q_showtime"]isEqualToString:@"Y"]) {
            int time=[self.times[indexPath.row] intValue];
            if (time>0) {
                //倒计时
                cell.timeLabel.text=[NSString stringWithFormat:@"%02d:%02d",(time%3600/60),(time%60)];
            }else{
                cell.timeLabel.text=@"已揭晓";
            }
        }else{
            cell.timeLabel.text=@"已揭晓";
        }
        return cell;
    }else if(collectionView==self.goodsCollectionView){ //即将揭晓
        goodsViewCell *cell = (goodsViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"goodsViewCell" forIndexPath:indexPath];
        /**商品名称*/
        cell.goodsTitle.text=self.revealedArray[indexPath.row][@"title"];
        /**总人数*/
        cell.numLabel1.text=self.revealedArray[indexPath.row][@"zongrenshu"];
        /**参与人数*/
        cell.numLabel2.text=self.revealedArray[indexPath.row][@"shenyurenshu"];
        /**商品id*/
        cell.goodsID.text=self.revealedArray[indexPath.row][@"id"];
        /**商品图片*/
        //拼接图片网址·
        NSString *urlStr =[NSString stringWithFormat:@"%@%@",imgURL,self.revealedArray[indexPath.row][@"thumb"]];
        //转换成url
        NSURL *imgUrl = [NSURL URLWithString:urlStr];
        [cell.goodsImageView sd_setImageWithURL:imgUrl];
        /**进度条*/
        float curreNum=[self.revealedArray[indexPath.row][@"canyurenshu"] floatValue];
        float countNum=[self.revealedArray[indexPath.row][@"zongrenshu"] floatValue];
        cell.progressView.progress=curreNum/countNum;
        return cell;
    }else if(collectionView==self.groomCollectionView){//人气推荐
        goodsViewCell *cell = (goodsViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"goodsViewCell" forIndexPath:indexPath];
        /**商品名称*/
        cell.goodsTitle.text=self.groomArray[indexPath.row][@"title"];
        /**总人数*/
        cell.numLabel1.text=self.groomArray[indexPath.row][@"zongrenshu"];
        /**参与人数*/
        cell.numLabel2.text=self.groomArray[indexPath.row][@"shenyurenshu"];
        /**商品id*/
        cell.goodsID.text=self.groomArray[indexPath.row][@"id"];
        /**商品图片*/
        //拼接图片网址·
        NSString *urlStr =[NSString stringWithFormat:@"%@%@",imgURL,self.groomArray[indexPath.row][@"thumb"]];
        //转换成url
        NSURL *imgUrl = [NSURL URLWithString:urlStr];
        [cell.goodsImageView sd_setImageWithURL:imgUrl];
        /**进度条*/
        float curreNum=[self.groomArray[indexPath.row][@"canyurenshu"] floatValue];
        float countNum=[self.groomArray[indexPath.row][@"zongrenshu"] floatValue];
        cell.progressView.progress=curreNum/countNum;
        return cell;
    }else if(collectionView==self.limitCollectionView){//限购专区
        goodsViewCell *cell = (goodsViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"goodsViewCell" forIndexPath:indexPath];
        return cell;
    }
    return nil;
}

#pragma mark 实现UICollectionViewDelegateFlowLayout代理
/**
 *  定义每个UICollectionView的间距
 *
 *  @param collectionView       <#collectionView description#>
 *  @param collectionViewLayout <#collectionViewLayout description#>
 *  @param section              <#section description#>
 *
 *  @return <#return value description#>
 */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0,0,0);
}
//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView==self.myCollectionView) {
        return CGSizeMake(108, 148);
    }
    return CGSizeMake(kScreenWidth/2.0, 222);
}
/**
 *  点击事件
 *
 *  @param collectionView <#collectionView description#>
 *  @param indexPath      <#indexPath description#>
 */
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    if (collectionView==self.myCollectionView) {
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
        
    }else if(collectionView==self.goodsCollectionView){ //即将揭晓
        //设置故事板为第一启动
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DetailController *detailController=[storyboard instantiateViewControllerWithIdentifier:@"DetailControllerView"];
        detailController.goodsID=self.revealedArray[indexPath.row][@"id"];
        detailController.dic=self.revealedArray[indexPath.row];
        [self.navigationController pushViewController:detailController animated:YES];
    }else if(collectionView==self.groomCollectionView){//人气推荐
        //设置故事板为第一启动
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DetailController *detailController=[storyboard instantiateViewControllerWithIdentifier:@"DetailControllerView"];
        detailController.goodsID=self.groomArray[indexPath.row][@"id"];
        detailController.dic=self.groomArray[indexPath.row];
        [self.navigationController pushViewController:detailController animated:YES];
    }else if(collectionView==self.limitCollectionView){//限购专区
        //设置故事板为第一启动
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DetailController *detailController=[storyboard instantiateViewControllerWithIdentifier:@"DetailControllerView"];
        detailController.goodsID=@"21";
        [self.navigationController pushViewController:detailController animated:YES];
    }
}

#pragma mark 表头
/*设置标题头的宽度*/
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==2) {
        return 40;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==2) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        self.btnView=[[UIView alloc]initWithFrame:CGRectMake(0,0 , kScreenWidth, 40)];
        NSArray *arr=@[@"即将揭晓",@"人气推荐",@"限购专区"];
        for(int i=0;i<3;i++)
        {
            [self creatButton:arr[i] andTag:i+1];
        }
        [view addSubview:self.btnView];
        //分割线
        UIView *lineview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        lineview.backgroundColor=[UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1];
        [view addSubview:lineview];
        UIView *lineview2=[[UIView alloc]initWithFrame:CGRectMake(0, view.frame.size.height, kScreenWidth, 0.5)];
        lineview2.backgroundColor=[UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1];
        [view addSubview:lineview2];
        [self creatMoveView];
        return view;
    }
    return nil;
}
-(void)creatButton:(NSString *)title andTag:(int)index
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];//初始化按钮
    btn.tag=index;//设置标识
    [btn setTitle:title forState:UIControlStateNormal];//设置标题
    btn.frame=CGRectMake((index-1)*kScreenWidth/3.0, 0, kScreenWidth/3.0, 40);//设置位置尺寸
    [btn setBackgroundColor:[UIColor whiteColor]];//设置背景颜色
    [btn setTintColor:[UIColor blackColor]];//设置标题颜色
    btn.titleLabel.font=[UIFont fontWithName:@"Menlo" size:14.0];//设置字体及大小
    [btn addTarget:self action:@selector(selectMoveAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnView addSubview:btn];//添加子视图
}

-(void)selectMoveAction:(UIButton *)sender
{
    //0.2秒动画改变self.movView的frame使它移动
    [UIView animateWithDuration:0.2 animations:^{
        self.moveView.frame=CGRectMake(sender.frame.origin.x, self.moveView.frame.origin.y, self.moveView.frame.size.width, self.moveView.frame.size.height);
    }];
    static int currentSelectButtonIndex = 0;
    static int previousSelectButtonIndex=10;
    currentSelectButtonIndex=(int)sender.tag;//获取Button的tag值
    UIButton *previousBtn=(UIButton *)[self.view viewWithTag:previousSelectButtonIndex];
    [previousBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIButton *currentBtn = (UIButton *)[self.view viewWithTag:currentSelectButtonIndex];
    [currentBtn setTitleColor:[UIColor colorWithRed:239.0/255.0 green:31.0/255.0 blue:48.0/255.0 alpha:1] forState:UIControlStateNormal];
    previousSelectButtonIndex=currentSelectButtonIndex;
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 1:{ //即将揭晓
            self.goodsCollectionView.hidden=NO;
            self.groomCollectionView.hidden=YES;
            self.limitCollectionView.hidden=YES;
        }break;
        case 2:{ //人气推荐
            self.goodsCollectionView.hidden=YES;
            self.groomCollectionView.hidden=NO;
            self.limitCollectionView.hidden=YES;
        }break;
        case 3:{//限购专区
            self.goodsCollectionView.hidden=YES;
            self.groomCollectionView.hidden=YES;
            self.limitCollectionView.hidden=NO;
        }break;
        default:break;
    }
}

-(void)creatMoveView
{
    self.moveView=[[UIView alloc]initWithFrame:CGRectMake(0,self.btnView.frame.size.height-3,(self.btnView.frame.size.width/3.0),3)];//设置位置及尺寸
    self.moveView.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:31.0/255.0 blue:48.0/255.0 alpha:1];//设置背景颜色
    [self.btnView addSubview:self.moveView];//将视图添加到self.btnView上
    
}
#pragma mark - Execution code

- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(3);
}
- (void)myProgressTask {
    // This just increases the progress indicator in a loop
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress += 0.01f;
        HUD.progress = progress;
        usleep(50000);
    }
}
/**
 *  微信支付
 *
 *  @param sender <#sender description#>
 */
- (IBAction)payWithWeChatPay:(UIButton *)sender {
    //这里调用我自己写的catagoary中的方法，方法里集成了微信支付的步骤，并会发送一个通知，用来传递是否支付成功的信息
    //这里填写的两个参数是后台会返回给你的
    [self payTheMoneyUseWeChatPayWithPrepay_id:@"这里填写后台返回的Prepay_id" nonce_str:@"这里填写后台给你返回的nonce_str"];
    //所以这里添加一个监听，用来接收是否成功的消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPayResultNoti:) name:WX_PAY_RESULT object:nil];
}
/**
 *  支付宝支付
 *
 *  @param sender <#sender description#>
 */
- (IBAction)payWithAliPay:(id)sender {
    //    NSLog(@"AliPay MoneyNum Is %@",self.moneyTextField.text);
    //这里调用我自己写的catagoary中的方法，方法里集成了支付宝支付的步骤，并会发送一个通知，用来传递是否支付成功的信息
    [self payTHeMoneyUseAliPayWithOrderId:@"123431" totalMoney:@"0.01" payTitle:@"这里告诉客户花钱买了啥，力求简短"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AliPayResultNoti:) name:ALI_PAY_RESULT object:nil];
}

//微信支付付款成功失败
-(void)weChatPayResultNoti:(NSNotification *)noti{
    NSLog(@"%@",noti);
    if ([[noti object] isEqualToString:IS_SUCCESSED]) {
        [self showMessage:@"支付成功"];
        //在这里填写支付成功之后你要做的事情
        
    }else{
        [self showMessage:@"支付失败"];
    }
    //上边添加了监听，这里记得移除
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WX_PAY_RESULT object:nil];
}


//支付宝支付成功失败
-(void)AliPayResultNoti:(NSNotification *)noti
{
    NSLog(@"%@",noti);
    if ([[noti object] isEqualToString:ALIPAY_SUCCESSED]) {
        [self showMessage:@"支付成功"];
        //在这里填写支付成功之后你要做的事情
        
    }else{
        [self showMessage:@"支付失败"];
    }
    //上边添加了监听，这里记得移除
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ALI_PAY_RESULT object:nil];
}

- (void) showMessage:(NSString*)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:alert.cancelButtonIndex animated:YES];
    });
}
@end
