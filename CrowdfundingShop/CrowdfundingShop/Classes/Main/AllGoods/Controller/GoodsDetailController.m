//
//  GoodsDetailController.m
//  CrowdfundingShop
//  正在揭晓
//  Created by 吴金林 on 15/12/11.
//  Copyright © 2015年 吴金林. All rights reserved.
//
#import "GoodsDetailController.h"
#import "DetailController.h"
#import "UITabBarController+ShowHideBar.h"
#import "RequestData.h"
#import "ShareOrderController.h"
#import <UIImageView+WebCache.h>
#import <MBProgressHUD.h>
@interface GoodsDetailController ()
/**所有云购记录*/
@property (weak, nonatomic) IBOutlet UITableViewCell *tableViewCell1;
/**图文详情*/
@property (weak, nonatomic) IBOutlet UITableViewCell *tableViewCell2;
/**商品晒单*/
@property (weak, nonatomic) IBOutlet UITableViewCell *tableViewCell3;
@property (retain,nonatomic)NSDictionary *goodsDictionary;
@end

@implementation GoodsDetailController
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
    self.goodsImageView.layer.borderWidth=0.5;
    self.goodsImageView.layer.borderColor=[[UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0]CGColor];
    /**圆角*/
    [[self.goodsImageView layer]setCornerRadius:2.0];
    //更改进度条高度
    self.goodsProgressView.transform=CGAffineTransformMakeScale(1.0f, 2.0f);
    //设置进度值并动画显示
    [self.goodsProgressView setProgress:0.7 animated:YES];
    /**头像圆角*/
    self.peopleImageView.layer.cornerRadius=30.0;
    self.peopleImageView.layer.masksToBounds=YES;
    /**数据请求*/
    [self requestData:self.gID];
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
    [RequestData goodsDetail:params FinishCallbackBlock:^(NSDictionary *data) {
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

            self.goodsDictionary=data[@"content"];
            /**商品名字*/
            self.goodsNameLabel.text=data[@"content"][@"title"];
            /**商品描述*/
            self.goodsDescLabel.text=data[@"content"][@"title2"];
            /**参与人次*/
            self.goodsLabel1.text=data[@"content"][@"canyurenshu"];
            /**总需人次*/
            self.goodsLabel2.text=data[@"content"][@"zongrenshu"];
            /**剩余人次*/
            self.goodsLabel3.text=data[@"content"][@"shenyurenshu"];
            /**晒单次数*/
            NSArray *array=data[@"content"][@"shaidan"];
            self.goodsNumLabel.text=[NSString stringWithFormat:@"(%lu)",(unsigned long)array.count];
            /**商品图片*/
            //拼接图片网址·
            NSString *urlStr =[NSString stringWithFormat:@"%@%@",imgURL,data[@"content"][@"thumb"]];
            //转换成url
            NSURL *imgUrl = [NSURL URLWithString:urlStr];
            [self.goodsImageView sd_setImageWithURL:imgUrl];
            /**进度条*/
            float curreNum=[data[@"content"][@"canyurenshu"] floatValue];
            float countNum=[data[@"content"][@"zongrenshu"] floatValue];
            self.goodsProgressView.progress=curreNum/countNum;
            //更新主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.myTableView reloadData];
            });
            
        }else{

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
 *  该方法在视图跳转时被触发
 *
 *  @param segue  <#segue description#>
 *  @param sender <#sender description#>
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"contentDetail"]) {
        id theSegue=segue.destinationViewController;
        [theSegue setValue:self.goodsDictionary[@"content"] forKey:@"content"];
    }else if([ segue.identifier isEqualToString:@"cloudRecordSegue"]){
        id theSegue=segue.destinationViewController;
        [theSegue setValue:self.goodsDictionary[@"us"] forKey:@"content"];
    }
}
/**
 *  分享
 *
 *  @param sender <#sender description#>
 */
- (IBAction)shareOrderClick:(UIButton *)sender {
    NSArray *array=self.goodsDictionary[@"shaidan"];
    if (array.count==0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"暂无晒单";
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.5];
    }else{
        //设置故事板为第一启动
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ShareOrderController *controller=[storyboard instantiateViewControllerWithIdentifier:@"shareOrderView"];
        controller.shareArray=self.goodsDictionary[@"shaidan"];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
