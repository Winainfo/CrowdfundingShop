//
//  DidAnnounceController.m
//  CrowdfundingShop
//  已揭晓页面
//  Created by 吴金林 on 15/12/13.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "DidAnnounceController.h"
#import "CloudNumberCell.h"
#import "ShareOrderController.h"
#import "ARLabel.h"
#import "RequestData.h"
#import <UIImageView+WebCache.h>
#import <MBProgressHUD.h>
@interface DidAnnounceController ()
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
/**商品图片*/
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
/**用户头像*/
@property (weak, nonatomic) IBOutlet UIImageView *peopleImageView;
/**用户名字*/
@property (weak, nonatomic) IBOutlet ARLabel *peopleNameLabel;
/**用户所在城市*/
@property (weak, nonatomic) IBOutlet ARLabel *peopleCityLabel;
/**揭晓时间*/
@property (weak, nonatomic) IBOutlet ARLabel *time1Label;
/**云购时间*/
@property (weak, nonatomic) IBOutlet ARLabel *buyTimeLabel;
/**幸运号码*/
@property (weak, nonatomic) IBOutlet ARLabel *numberLabel;
/**参加次数*/
@property (weak, nonatomic) IBOutlet ARLabel *countLabel;
/**计算详情*/
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;

@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@property (retain,nonatomic) NSDictionary *array;
/**云购码*/
@property (retain,nonatomic) NSArray *numArray;
/**晒单次数*/
@property (weak, nonatomic) IBOutlet ARLabel *shareNumLabel;
@property (weak, nonatomic) IBOutlet ARLabel *timeLabel;

@end

@implementation DidAnnounceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.goodsImageView.layer.borderWidth=0.5;
    self.goodsImageView.layer.borderColor=[[UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0]CGColor];
    /**圆角*/
    [[self.goodsImageView layer]setCornerRadius:2.0];
    self.detailBtn.layer.cornerRadius=4.0;
    self.peopleImageView.layer.cornerRadius=25.0;
    self.peopleImageView.layer.masksToBounds=YES;
    //注册Cell
    [self.myCollectionView registerClass:[CloudNumberCell class]  forCellWithReuseIdentifier:@"CloudNumberCell"];
    [self requestData:self.gID];
    NSLog(@"--id:%@",self.gID);
}

#pragma mark 数据请求
/**
 *  商品详情
 *
 *  @param goodsId <#goodsId description#>
 */
-(void)requestData:(NSString *)goodsId{
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:goodsId,@"goodsId",nil];
    //声明对象；
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    //显示的文本；
    hud.labelText = @"正在加载...";
    [RequestData lotteryGoodsDetail:params FinishCallbackBlock:^(NSDictionary *data) {
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
            self.numArray=data[@"content"][@"user_shop_codes"];
            self.numberLabel.text=data[@"content"][@"q_user_code"];
            self.countLabel.text=[NSString stringWithFormat:@"%@",data[@"content"][@"user_shop_number"]];
            /**晒单次数*/
            NSArray *array1=data[@"content"][@"shaidan"];
            self.shareNumLabel.text=[NSString stringWithFormat:@"(%lu)",(unsigned long)array1.count];
//            if([data[@"content"][@"user_ip"] isEqualToString:@""]||[data[@"content"][@"user_ip"] isEqual:@"<null>"]||[data[@"content"][@"user_ip"] isEqual:@"null"]){
//                NSLog(@"ip为空");
////                self.peopleCityLabel.text=@"";
//            }else{
//                //截取城市
//                NSLog(@"ip不为空");
////                NSString *string =data[@"content"][@"user_ip"];
////                NSArray *strArray=[string componentsSeparatedByString:@","];
////                self.peopleCityLabel.text=[NSString stringWithFormat:@"(%@)",strArray[0]];
//            }
            /**揭晓时间*/
              long time=[data[@"content"][@"q_end_time"] integerValue];
            self.time1Label.text=[DidAnnounceController timeFromTimestamp:time formtter:@"YYYY-MM-dd HH:mm:ss"];
            /**购买时间*/
            long buytime=[data[@"content"][@"time"] integerValue];
            self.buyTimeLabel.text=[DidAnnounceController timeFromTimestamp:buytime formtter:@"YYYY-MM-dd HH:mm:ss"];
            self.timeLabel.text=[DidAnnounceController timeFromTimestamp:buytime formtter:@"YYYY-MM-dd HH:mm:ss"];
            self.peopleNameLabel.text=data[@"content"][@"q_user"][@"username"];
            /**商品图片*/
            //拼接图片网址·
            NSString *urlStr1 =[NSString stringWithFormat:@"%@%@",imgURL,data[@"content"][@"q_user"][@"img"]];
            //转换成url
            NSURL *imgUrl1 = [NSURL URLWithString:urlStr1];
            [self.peopleImageView sd_setImageWithURL:imgUrl1];
            /**商品图片*/
            //拼接图片网址·
            NSString *urlStr =[NSString stringWithFormat:@"%@%@",imgURL,data[@"content"][@"thumb"]];
            //转换成url
            NSURL *imgUrl = [NSURL URLWithString:urlStr];
            [self.goodsImageView sd_setImageWithURL:imgUrl];
            //        //更新主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.myTableView reloadData];
                [self.myCollectionView reloadData];
            });
        }else{
            hud.removeFromSuperViewOnHide = true;
            [hud hide:true afterDelay:0];
            //显示失败的提示；
            MBProgressHUD *failHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
            failHUD.labelText = @"加载失败";
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
        failHUD.labelText = @"加载失败";
        failHUD.mode = MBProgressHUDModeCustomView;
        failHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_error"]];
        failHUD.removeFromSuperViewOnHide = true;
        [failHUD hide:true afterDelay:1];
    }];
}

#pragma mark 实现代理方法
//每个section的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.numArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CloudNumberCell *cell = (CloudNumberCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CloudNumberCell" forIndexPath:indexPath];
    cell.numberLabel.text=self.numArray[indexPath.row];
    return cell;
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
/**
 *  该方法在视图跳转时被触发
 *
 *  @param segue  <#segue description#>
 *  @param sender <#sender description#>
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"contentDetailSegue"]) {
        id theSegue=segue.destinationViewController;
        [theSegue setValue:self.array[@"content"] forKey:@"content"];
    }else if([ segue.identifier isEqualToString:@"recoderSegue"]){
        id theSegue=segue.destinationViewController;
        [theSegue setValue:self.gID forKey:@"gid"];
    }else if([ segue.identifier isEqualToString:@"resultSegue"]){
        id theSegue=segue.destinationViewController;
        [theSegue setValue:self.gID forKey:@"goodsId"];
    }else if([segue.identifier isEqualToString:@"cloudnumberSegue"]){
        id theSegue=segue.destinationViewController;
        [theSegue setValue:self.numArray forKey:@"numArray"];
        [theSegue setValue:self.timeLabel.text forKey:@"timeString"];
    }
}
/**
 *  晒单
 *
 *  @param sender <#sender description#>
 */
- (IBAction)shareClick:(UIButton *)sender {
    NSArray *goodsarray=self.array[@"shaidan"];
    if (goodsarray.count==0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"暂无晒单";
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.5];
    }else{
        //设置故事板为第一启动
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ShareOrderController *controller=[storyboard instantiateViewControllerWithIdentifier:@"shareOrderView"];
        controller.shareArray=self.array[@"shaidan"];
        [self.navigationController pushViewController:controller animated:YES];
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
