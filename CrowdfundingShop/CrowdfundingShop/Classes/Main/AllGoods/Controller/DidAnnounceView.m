//
//  DidAnnounceView.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 16/1/13.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import "DidAnnounceView.h"
#import "RequestData.h"
#import <UIImageView+WebCache.h>
#import <ShareSDK/ShareSDK.h>
@interface DidAnnounceView ()
@property (weak, nonatomic) IBOutlet UIButton *runBtn;

@end

@implementation DidAnnounceView
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
    self.title=@"商品详情";
    //导航栏左侧按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateSelected];
    leftBtn.frame=CGRectMake(-5, 5, 21, 21);
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
    //设置圆角
    self.runBtn.layer.cornerRadius=4.0;
}

//返回
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  该方法在视图跳转时被触发
 *
 *  @param segue  <#segue description#>
 *  @param sender <#sender description#>
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"didAnnounceSegue"]) {
        id theSegue=segue.destinationViewController;
        [theSegue setValue:self.goodsID forKey:@"gID"];
    }
}

- (IBAction)shareClick:(UIButton *)sender {
    if (self.dic!=nil) {
        /**商品图片*/
        //拼接图片网址·
        NSString *urlStr =[NSString stringWithFormat:@"%@%@",imgURL,_dic[@"thumb"]];
        //转换成url
        NSURL *imgUrl = [NSURL URLWithString:urlStr];
        UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:imgUrl] scale:0.1];
        id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"%@",_dic[@"title"]]defaultContent:nil
                                                    image:[ShareSDK pngImageWithImage:image]
                                                    title:[NSString stringWithFormat:@"%@",_dic[@"title"]] url:[NSString stringWithFormat:@"http://mobile.yiydb.cn/index.php/mobile/mobile/dataserver/%@",_dic[@"id"]]
                                              description:[NSString stringWithFormat:@"%@",_dic[@"title2"]]
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
    }else{
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:self.goodsID,@"goodsId",nil];
        [RequestData lotteryGoodsDetail:params FinishCallbackBlock:^(NSDictionary *data) {
            int code=[data[@"code"] intValue];
            if (code==0) {
                /**商品图片*/
                //拼接图片网址·
                NSString *urlStr =[NSString stringWithFormat:@"%@%@",imgURL,data[@"content"][@"thumb"]];
                //转换成url
                NSURL *imgUrl = [NSURL URLWithString:urlStr];
                UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:imgUrl] scale:0.1];
                id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"%@",data[@"content"][@"title"]]defaultContent:nil
                                                            image:[ShareSDK pngImageWithImage:image]
                                                            title:[NSString stringWithFormat:@"%@",data[@"content"][@"title"]] url:[NSString stringWithFormat:@"http://mobile.yiydb.cn/index.php/mobile/mobile/dataserver/%@",data[@"content"][@"id"]]
                                                      description:[NSString stringWithFormat:@"%@",data[@"content"][@"title2"]]
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
            }else{
            }
        } andFailure:^(NSError *error) {
        }];
    }
}


@end
