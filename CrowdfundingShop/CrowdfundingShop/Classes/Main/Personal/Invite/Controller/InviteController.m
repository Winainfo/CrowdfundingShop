//
//  InviteController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 16/2/16.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import "InviteController.h"
#import <ShareSDK/ShareSDK.h>
#import "RequestData.h"
#import "AccountTool.h"
#import <MBProgressHUD.h>
#import <MJRefresh.h>
@interface InviteController (){
     AccountModel *account;
}
/**分享按钮*/
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
/**分享文本*/
@property (weak, nonatomic) IBOutlet UITextView *shareTextView;
/**好友数*/
@property (weak, nonatomic) IBOutlet UILabel *friendsNumLabel;
/**佣金余额*/
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
/**提现按钮*/
@property (weak, nonatomic) IBOutlet UIButton *cashButton;
/**转账按钮*/
@property (weak, nonatomic) IBOutlet UIButton *transferButton;

@end

@implementation InviteController
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
    self.title=@"分享赚钱";
    //导航栏右侧按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateSelected];
    leftBtn.frame=CGRectMake(-5, 5, 30, 30);
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
    [self initStyle];
    [self requestServer];
}
#pragma mark 数据
-(void)requestServer{
    account=[AccountTool account];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",@"",@"pageIndex",@"",@"pageSize",nil];
    //好友列表
    [RequestData friendsSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
        NSArray *array=[[NSArray alloc]init];
        int code=[data[@"code"]intValue];
        if (code==0) {
             array=data[@"content"];
            self.friendsNumLabel.text=[NSString stringWithFormat:@"%lu",(unsigned long)array.count];
        }else{
            self.friendsNumLabel.text=@"0";
        }
    }andFailure:^(NSError *error) {}];
    //佣金
    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",@"1",@"type",@"",@"pageIndex",@"",@"pageSize",nil];
    [RequestData commissionsSerivce:param FinishCallbackBlock:^(NSDictionary *data) {
        NSArray *array=[[NSArray alloc]init];
        NSLog(@"佣金:%@",data);
        array=data[@"content"];
//        self.moneyLabel.text=[NSString stringWithFormat:@"¥%lu",(unsigned long)array.count];
    }andFailure:^(NSError *error) {}];
    
     NSDictionary *params1=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",nil];
    [RequestData inviteManageSerivce:params1 FinishCallbackBlock:^(NSDictionary *data) {
        self.shareTextView.text=[NSString stringWithFormat:@"1元就能买iPhone 6S，一种很有意思的购物方式，快来看看吧！http://mobile.yiydb.cn/index.php/mobile/user/register/%@",data[@"content"]];
    } andFailure:^(NSError *error) {
        
    }];
}
/**
 *  返回
 */
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  控件样式
 */
-(void)initStyle{
    //分享按钮
    self.shareButton.layer.cornerRadius=5.0;
    //分享文本
    self.shareTextView.layer.borderWidth=1.0;
    self.shareTextView.layer.borderColor=[[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]CGColor];
    self.shareTextView.userInteractionEnabled=NO;
    //提现按钮
    self.cashButton.layer.cornerRadius=5.0;
    self.cashButton.layer.borderWidth=1.0;
    self.cashButton.layer.borderColor=[[UIColor colorWithRed:231.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1.0]CGColor];
    //转账按钮
    self.transferButton.layer.cornerRadius=5.0;
}
/**
 *  分享事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)shareClick:(UIButton *)sender {
    account=[AccountTool account];
    NSDictionary *params1=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",nil];
    [RequestData inviteManageSerivce:params1 FinishCallbackBlock:^(NSDictionary *data) {
        NSString *str=[NSString stringWithFormat:@"http://mobile.yiydb.cn/index.php/mobile/user/register/%@",data[@"content"]];
        id<ISSContent> publishContent = [ShareSDK content:@"1元就能买iPhone6S，一种很有意思的购物方式，快来看看吧!"
                                           defaultContent:nil
                                                    image:[ShareSDK pngImageWithImage:[UIImage imageNamed:@"iPhone.jpg"]]
                                                    title:@"1元就能买iPhone6S，一种很有意思的购物方式，快来看看吧!"
                                                      url:str
                                              description:@"1元就能买iPhone6S，一种很有意思的购物方式，快来看看吧!"
                                                mediaType:SSPublishContentMediaTypeNews];
        //1+创建弹出菜单容器（iPad必要）
        id<ISSContainer> container = [ShareSDK container];
        [container setIPadContainerWithView:nil arrowDirect:UIPopoverArrowDirectionUp];
        //2、弹出分享菜单
        [ShareSDK showShareActionSheet:container
                             shareList:nil
                               content:publishContent
                         statusBarTips:YES
                           authOptions:nil
                          shareOptions:nil
                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                    
                                    //可以根据回调提示用户。
                                    
                                    if (state == SSResponseStateCancel) {
                                        
                                    }
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

    } andFailure:^(NSError *error) {
        
    }];
}
/**
 *  一键转入云购账户
 *
 *  @param sender <#sender description#>
 */
- (IBAction)cashActionClick:(UIButton *)sender {
    account=[AccountTool account];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",@"2",@"txtCZMoney",nil];
    //声明对象；
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    //显示的文本；
    hud.labelText = @"正在转入中...";
    [RequestData cashMoneySerivce:params FinishCallbackBlock:^(NSDictionary *data) {
        int code=[data[@"code"] intValue];
        if (code==0) {
            account.money=data[@"content"];
             [AccountTool saveAccount:account];
            //加载成功，先移除原来的HUD；
            hud.removeFromSuperViewOnHide = true;
            [hud hide:true afterDelay:0];
            //然后显示一个成功的提示；
            MBProgressHUD *successHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
            successHUD.labelText = @"转入成功";
            successHUD.mode = MBProgressHUDModeCustomView;
            //可以设置对应的图片；
            successHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_success"]];
            successHUD.removeFromSuperViewOnHide = true;
            [successHUD hide:true afterDelay:1];
        }else{
            hud.removeFromSuperViewOnHide = true;
            [hud hide:true afterDelay:0];
            //显示失败的提示；
            MBProgressHUD *failHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
            failHUD.labelText = @"转入失败";
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
        failHUD.labelText = @"网络异常";
        failHUD.mode = MBProgressHUDModeCustomView;
        failHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_error"]];
        failHUD.removeFromSuperViewOnHide = true;
        [failHUD hide:true afterDelay:1];
    }];
}

@end
