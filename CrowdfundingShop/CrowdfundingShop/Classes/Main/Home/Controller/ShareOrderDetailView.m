//
//  ShareOrderDetailView.m
//  CrowdfundingShop
//  晒单详情
//  Created by 吴金林 on 15/12/21.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "ShareOrderDetailView.h"
#import "ARLabel.h"
#import "RequestData.h"
#import "CommentaryController.h"
//获得当前屏幕宽高点数（非像素）
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
@interface ShareOrderDetailView ()
/**点赞*/
@property (weak, nonatomic) IBOutlet ARLabel *dianZanLabel;
/**评论*/
@property (weak, nonatomic) IBOutlet ARLabel *pinglunLabel;

@property (weak, nonatomic) IBOutlet UIButton *dianzanBtn;
@end

@implementation ShareOrderDetailView
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
    self.title=@"晒单详情";
    //导航栏左侧按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateSelected];
    leftBtn.frame=CGRectMake(-5, 5, 21, 21);
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
    [self requestData];
}
#pragma mark 数据源
-(void)requestData{
    if (self.dic!=NULL) {
        self.dianZanLabel.text=self.dic[@"sd_zhan"];
        self.pinglunLabel.text=self.dic[@"sd_ping"];
    }else{
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:self.sd_id,@"sd_id",nil];
        [RequestData shareOrderDetail:params FinishCallbackBlock:^(NSDictionary *data) {
            self.dianZanLabel.text=data[@"content"][@"sd_zhan"];
            self.pinglunLabel.text=data[@"content"][@"sd_ping"];
        }];
    }
}
/**
 *  返回
 */
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  分享
 *
 *  @param sender <#sender description#>
 */
- (IBAction)shareClick:(UIButton *)sender {
}
/**
 *  点赞
 *
 *  @param sender <#sender description#>
 */
- (IBAction)dianClick:(UIButton *)sender {
    int i= [self.dianZanLabel.text intValue];
    self.dianZanLabel.text=[NSString stringWithFormat:@"%i",++i];
    self.dianzanBtn.enabled=NO;
    [self.dianzanBtn setImage:[UIImage imageNamed:@"share_order_heart_select"] forState:UIControlStateNormal];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:self.sd_id,@"sd_id",nil];
    [RequestData dianZanSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
    }];
}
/**
 *  评论
 *
 *  @param sender <#sender description#>
 */
- (IBAction)pingClick:(id)sender {
    //设置故事板为第一启动
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CommentaryController *controller=[storyboard instantiateViewControllerWithIdentifier:@"commentaryView"];
    controller.sd_id=self.sd_id;
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  该方法在视图跳转时被触发
 *
 *  @param segue  <#segue description#>
 *  @param sender <#sender description#>
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"shareOrderDetailView"]) {
        id theSegue=segue.destinationViewController;
        [theSegue setValue:self.sd_id forKey:@"sd_id"];
        [theSegue setValue:self.dic forKey:@"dic"];
    }
}

@end
