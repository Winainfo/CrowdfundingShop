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
}

#pragma mark 数据请求
/**
 *  商品详情
 *
 *  @param goodsId <#goodsId description#>
 */
-(void)requestData:(NSString *)sd_Id{
    if (self.dic!=nil) {
        NSLog(@"----%@",self.dic);
        self.titleLabel.text=_dic[@"sd_title"];
        self.contentTextView.text=_dic[@"sd_content"];
        self.numberLabel.text=_dic[@"sd_ping"];
        /**晒单图片*/
        //        NSArray *imageArray=_dic[@"sd_photolist"];
        //        for (int i=0; i<imageArray.count; i++) {
        //            //拼接图片网址·
        //            NSString *urlStr =[NSString stringWithFormat:@"%@%@",imgURL,imageArray[i]];
        //            //转换成url
        //            NSURL *imgUrl = [NSURL URLWithString:urlStr];
        //            UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, (i*220)+130, 300, 220)];
        //            [imageV sd_setImageWithURL:imgUrl];
        //            [self.view addSubview:imageV];
        //        }
        NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:_dic[@"sd_userid"],@"uid",nil];
        [RequestData userDetail:param FinishCallbackBlock:^(NSDictionary *userInfo) {
            int code=[userInfo[@"code"] intValue];
            if (code==0) {
                [self.peopleNameBtn setTitle:userInfo[@"content"][@"username"] forState:UIControlStateNormal];
                /**商品图片*/
                //拼接图片网址·
                NSString *urlStr =[NSString stringWithFormat:@"%@%@",imgURL,userInfo[@"content"][@"img"]];
                //转换成url
                NSURL *imgUrl = [NSURL URLWithString:urlStr];
                [self.peopleImageView sd_setImageWithURL:imgUrl];
            }else{
                
            }
            
        }];
        //更新主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myTableView reloadData];
        });
        
    }else{
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:sd_Id,@"sd_id",nil];
        [RequestData shareOrderDetail:params FinishCallbackBlock:^(NSDictionary *data) {
            int code=[data[@"code"] intValue];
            if (code==0) {
                self.titleLabel.text=data[@"content"][@"sd_title"];
                self.contentTextView.text=data[@"content"][@"sd_content"];
                self.numberLabel.text=data[@"content"][@"sd_ping"];
                NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:data[@"content"][@"sd_userid"],@"uid",nil];
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
                    //                imageV.layer.borderWidth=0.5;
                    //                imageV.layer.borderColor=[[UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1]CGColor];
                    [imageV sd_setImageWithURL:imgUrl];
                    [self.view addSubview:imageV];
                }
                
                [RequestData userDetail:param FinishCallbackBlock:^(NSDictionary *userInfo) {
                    int code=[userInfo[@"code"] intValue];
                    if (code==0) {
                        [self.peopleNameBtn setTitle:userInfo[@"content"][@"username"] forState:UIControlStateNormal];
                        /**商品图片*/
                        //拼接图片网址·
                        NSString *urlStr =[NSString stringWithFormat:@"%@%@",imgURL,userInfo[@"content"][@"img"]];
                        //转换成url
                        NSURL *imgUrl = [NSURL URLWithString:urlStr];
                        [self.peopleImageView sd_setImageWithURL:imgUrl];
                    }
                }];
                //更新主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.myTableView reloadData];
                });
                
            }else{
                
            }
        }];
    }
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

#pragma mark - 表格代理
@end
