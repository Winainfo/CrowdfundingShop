//
//  GoodsDetailController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/11.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "GoodsDetailController.h"
#import "UITabBarController+ShowHideBar.h"
#import "RequestData.h"
#import <UIImageView+WebCache.h>
#define URL @"http://wn.winainfo.com/statics/uploads/"
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
    
    self.tableViewCell1.selectionStyle=UITableViewCellSelectionStyleNone;
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
    [RequestData goodsDetail:params FinishCallbackBlock:^(NSDictionary *data) {
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
        /**商品图片*/
        //拼接图片网址·
        NSString *urlStr =[NSString stringWithFormat:@"%@%@",URL,data[@"content"][@"thumb"]];
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
    NSLog(@"%@",self.goodsDictionary[@"cateid"]);
    if ([segue.identifier isEqualToString:@"contentDetail"]) {
        id theSegue=segue.destinationViewController;
        [theSegue setValue:self.goodsDictionary[@"content"] forKey:@"content"];
    }
}
@end
