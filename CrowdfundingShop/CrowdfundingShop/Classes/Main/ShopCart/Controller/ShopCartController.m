//
//  ShopCartController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/11/23.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "ShopCartController.h"
#import "shopCartCell.h"
@interface ShopCartController ()
/**未登陆View*/
@property (weak, nonatomic) IBOutlet UIView *view1;
/**已登陆View*/
@property (weak, nonatomic) IBOutlet UIView *view2;
/**有商品View*/
@property (weak, nonatomic) IBOutlet UIView *view3;
/**购物车表*/
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
/**购物车数组*/
@property (retain,nonatomic) NSArray *shopCartArray;
@end

@implementation ShopCartController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏标题颜色和字体大小UITextAttributeFont:[UIFont fontWithName:@"Heiti TC" size:0.0]
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Menlo" size:16.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title=@"购物车";
    //创建xib文件对象
    UINib *nib=[UINib nibWithNibName:@"shopCartCell" bundle:[NSBundle mainBundle]];
    //注册到表格视图
    [self.myTableView  registerNib:nib forCellReuseIdentifier:@"shopCartCell"];
    //    self.myTableView.separatorStyle=NO;
    [self setExtraCellLineHidden:self.myTableView];

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
#pragma mark 实现table代理
/**
 *  设置单元格数量
 *
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
/**
 *  设置单元格内容
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *cellStr=@"shopCartCell";
        shopCartCell *cell=[self.myTableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell==nil) {
            cell=[[shopCartCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        //取消Cell选中时背景
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        /**商品图片*/
//        //拼接图片网址·
//        NSString *urlStr =[NSString stringWithFormat:@"http://www.god-store.com/statics/uploads/%@",self.allGoodsArray[indexPath.row][@"thumb"]];
//        //转换成url
//        NSURL *imgUrl = [NSURL URLWithString:urlStr];
//        [cell.goodsImageView sd_setImageWithURL:imgUrl];
        return cell;
}
/**
 *  设置单元格高度
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}

/**
 *  点击事件
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{

}



@end
