//
//  DetailController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/11.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "DetailController.h"
#import "RequestData.h"
#import <UIImageView+WebCache.h>
#import <ShareSDK/ShareSDK.h>
#import "Database.h"
#import "CartModel.h"
#import "ShopCartController.h"
#import "UITabBar+badge.h"
#import "AppDelegate.h"
@interface DetailController ()
/**立即购买*/
@property (weak, nonatomic) IBOutlet UIButton *buyGoodsBtn;
/**添加购物车*/
@property (weak, nonatomic) IBOutlet UIButton *addCarBtn;
@property (retain,nonatomic) NSString *flag;
@property (retain,nonatomic)NSMutableArray *array;

@end

@implementation DetailController

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
    self.buyGoodsBtn.layer.cornerRadius=4.0;
    self.addCarBtn.layer.cornerRadius=4.0;
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
    if ([segue.identifier isEqualToString:@"goodsDetail"]) {
        id theSegue=segue.destinationViewController;
        [theSegue setValue:self.goodsID forKey:@"gID"];
    }
}
/**
 *  分享
 *
 *  @param sender <#sender description#>
 */
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
                                                    title:[NSString stringWithFormat:@"%@",_dic[@"title"]] url:[NSString stringWithFormat:@"http://mobile.yiydb.cn/index.php/mobile/mobile/item/%@",_dic[@"id"]]
                                              description:[NSString stringWithFormat:@"%@",_dic[@"description"]]
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
        [RequestData goodsDetail:params FinishCallbackBlock:^(NSDictionary *data) {
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
                                                            title:[NSString stringWithFormat:@"%@",data[@"content"][@"title"]] url:[NSString stringWithFormat:@"http://mobile.yiydb.cn/index.php/mobile/mobile/item/%@",data[@"content"][@"id"]]
                                                      description:[NSString stringWithFormat:@"%@",data[@"content"][@"description"]]
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

- (IBAction)addCartClick:(id)sender {

    //初始化数据库
    Database *db=[Database new];
    _array=[db searchTestList:_dic[@"id"]];
    if (_array.count>0) {
        CartModel *cartList=_array[0];
        int pkid=cartList.pk_id;
        NSLog(@"%i",pkid);
        cartList.num=cartList.num+1;
        cartList.price=cartList.price+1;
        cartList.pk_id=pkid;
        if ([db updateList:cartList]) {
            //创建通知
            NSNotification *notification =[NSNotification notificationWithName:@"addCart" object:nil userInfo:nil];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }else{
            NSLog(@"失败");
        }
    }else{
        CartModel *cartList=[CartModel new];
        //数据库 插入
        cartList.shopId=_dic[@"id"];
        cartList.title=_dic[@"title"];
        cartList.shenyurenshu=_dic[@"shenyurenshu"];
        cartList.thumb=_dic[@"thumb"];
        cartList.num=1;
        cartList.price=[_dic[@"yunjiage"]intValue];
        if([db insertList:cartList])
        {
            //创建通知
            NSNotification *notification =[NSNotification notificationWithName:@"addCart" object:nil userInfo:nil];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"添加成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"添加失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}
- (IBAction)BuyClick:(UIButton *)sender {
     NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@"3",@"Index", nil];
    //初始化数据库
    Database *db=[Database new];
    _array=[db searchTestList:_dic[@"id"]];
    if (_array.count>0) {
        CartModel *cartList=_array[0];
        int pkid=cartList.pk_id;
        cartList.num=cartList.num+1;
        cartList.price=cartList.price+1;
        cartList.pk_id=pkid;
        if ([db updateList:cartList]) {
            AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate tabRootView];
            //创建通知
            NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }else{
            
        }
    }else{
        CartModel *cartList=[CartModel new];
        //数据库 插入
        cartList.shopId=_dic[@"id"];
        cartList.title=_dic[@"title"];
        cartList.shenyurenshu=_dic[@"shenyurenshu"];
        cartList.thumb=_dic[@"thumb"];
        cartList.num=1;
        cartList.price=[_dic[@"yunjiage"]intValue];
        if([db insertList:cartList])
        {
            AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate tabRootView];
            //创建通知
            NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"添加失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

@end
