//
//  ShareOrderDetailController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/21.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "ShareOrderDetailController.h"
#import "CommentaryCell.h"
#import "CommentaryController.h"
#import "RequestData.h"
#import <UIImageView+WebCache.h>
#import <MBProgressHUD.h>
@interface ShareOrderDetailController ()
@property (nonatomic, strong) UITableViewCell *prototypeCell;
/**评论数组*/
@property(retain,nonatomic) NSArray *contentArray;
@property (weak, nonatomic) IBOutlet UIView *myView;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet UITableViewCell *imageCell;
@end

@implementation ShareOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myView.layer.cornerRadius=3.0;
    self.myView.layer.masksToBounds=YES;
    [self requestData:self.sd_id];
    self.peopleImageView.layer.cornerRadius=self.peopleImageView.frame.size.width/2.0;
    self.peopleImageView.layer.masksToBounds=YES;
}

#pragma mark 数据请求
/**
 *  商品详情
 *
 *  @param goodsId <#goodsId description#>
 */
-(void)requestData:(NSString *)sd_Id{
    if (self.dic!=nil) {
        NSLog(@"%@",_dic);
        self.titleLabel.text=_dic[@"sd_title"];
        self.contentTextView.text=_dic[@"sd_content"];
        self.numberLabel.text=_dic[@"sd_ping"];
        //时间戳转换时间
        long time=[_dic[@"sd_time"] integerValue];//时间戳
        self.timeLabel.text=[ShareOrderDetailController timeFromTimestamp:time];
        /**商品详情*/
        [self getShopDetail:_dic[@"sd_shopid"]];
        /**晒单图片*/
                NSArray *imageArray=_dic[@"sd_photolist"];
                for (int i=0; i<imageArray.count; i++) {
                    //拼接图片网址·
                    NSString *urlStr =[NSString stringWithFormat:@"%@%@",imgURL,imageArray[i]];
                    //转换成url
                    NSURL *imgUrl = [NSURL URLWithString:urlStr];
                    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, (i*220)+130, 300, 220)];
                    [imageV sd_setImageWithURL:imgUrl];
                    [self.view addSubview:imageV];
                }
        [self.peopleNameBtn setTitle:_dic[@"username"] forState:UIControlStateNormal];
        /**头像图片*/
        //拼接图片网址·
        NSString *urlStr =[NSString stringWithFormat:@"%@%@",imgURL,_dic[@"userphoto"]];
        //转换成url
        NSURL *imgUrl = [NSURL URLWithString:urlStr];
        [self.peopleImageView sd_setImageWithURL:imgUrl];
        //更新主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myTableView reloadData];
        });
        
    }else{
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:sd_Id,@"sd_id",nil];
        //声明对象；
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
        //显示的文本；
        hud.labelText = @"正在加载...";
        [RequestData shareOrderDetail:params FinishCallbackBlock:^(NSDictionary *data) {
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

                self.titleLabel.text=data[@"content"][@"sd_title"];
                self.contentTextView.text=data[@"content"][@"sd_content"];
                self.numberLabel.text=data[@"content"][@"sd_ping"];
                //时间戳转换时间
                long time=[data[@"content"][@"sd_time"] integerValue];//时间戳
                self.timeLabel.text=[ShareOrderDetailController timeFromTimestamp:time];
                /**商品详情*/
                [self getShopDetail:data[@"content"][@"sd_shopid"]];
                /**晒单图片*/
                NSArray *imageArray=data[@"content"][@"sd_photolist"];
                // 1. 用一个临时变量保存返回值。
                CGRect temp=self.imageCell.frame;
                // 2. 给这个变量赋值。因为变量都是L-Value，可以被赋值
                temp.size.height=2200;
                // 3. 修改frame的值
                self.imageCell.frame=temp;
                for (int i=0; i<imageArray.count; i++) {
                    //拼接图片网址·
                    NSString *urlStr =[NSString stringWithFormat:@"%@%@",imgURL,imageArray[i]];
                    //转换成url
                    NSURL *imgUrl = [NSURL URLWithString:urlStr];
                    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, (i*220)+130, 300, 220)];
                    [imageV sd_setImageWithURL:imgUrl];
                    [self.view addSubview:imageV];
                }
                [self.peopleNameBtn setTitle:data[@"content"][@"username"] forState:UIControlStateNormal];
                /**商品图片*/
                //拼接图片网址·
                NSString *urlStr =[NSString stringWithFormat:@"%@%@",imgURL,data[@"content"][@"img"]];
                //转换成url
                NSURL *imgUrl = [NSURL URLWithString:urlStr];
                [self.peopleImageView sd_setImageWithURL:imgUrl];
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
            failHUD.labelText = @"数据请求异常";
            failHUD.mode = MBProgressHUDModeCustomView;
            failHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_error"]];
            failHUD.removeFromSuperViewOnHide = true;
            [failHUD hide:true afterDelay:1];

        }];
    }
}
-(void)getShopDetail:(NSString *)goodsId{
      NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:goodsId,@"goodsId",nil];
    [RequestData lotteryGoodsDetail:params FinishCallbackBlock:^(NSDictionary *data) {
        self.numLabel.text=[NSString stringWithFormat:@"%@",data[@"content"][@"user_shop_number"]];
        self.goodsNameLabel.text=[NSString stringWithFormat:@"(第%@期)%@",data[@"content"][@"qishu"],data[@"content"][@"title"]];
    } andFailure:^(NSError *error) {
        
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
- (IBAction)clickBtn:(UIButton *)sender {
    //设置故事板为第一启动
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CommentaryController *controller=[storyboard instantiateViewControllerWithIdentifier:@"commentaryView"];
    controller.sd_id=self.sd_id;
    [self.navigationController pushViewController:controller animated:YES];
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
