//
//  ShopCartController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/11/23.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "ShopCartController.h"
#import "shopCartCell.h"
#import "AllGoodsController.h"
#import "AccountTool.h"
#import "GoodsNavController.h"
#import <UIImageView+WebCache.h>
#import "CartModel.h"
#import "Database.h"
#import "UITabBar+badge.h"
#import "JSONKit.h"
@interface ShopCartController ()<CartCellDelegate>{
    NSInteger sumPrice;
}
/**未登陆View*/
@property (weak, nonatomic) IBOutlet UIView *view1;
/**已登陆View*/
@property (weak, nonatomic) IBOutlet UIView *view2;
/**有商品View*/
@property (weak, nonatomic) IBOutlet UIView *view3;
/**购物车表*/
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
/**购物车数组*/
@property (retain,nonatomic) NSMutableArray *shopCartArray;
@property (retain,nonatomic) NSMutableArray *shopArray;
@property (retain,nonatomic) NSString *strData;
@property(retain,nonatomic)UIAlertView *alert;
/**商品数量*/
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
/**总价格*/
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end

@implementation ShopCartController
-(void)viewWillAppear:(BOOL)animated{
    //创建通知
    NSNotification *notificationLogin =[NSNotification notificationWithName:@"loginAction" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notificationLogin];
}

-(NSMutableArray *)shopCartArray
{
    if (_shopCartArray==nil)
    {
        _shopCartArray=[NSMutableArray array];
    }
    return _shopCartArray;
}
-(NSMutableArray *)shopArray
{
    if (_shopArray==nil)
    {
        _shopArray=[NSMutableArray array];
    }
    return _shopArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏标题颜色和字体大小UITextAttributeFont:[UIFont fontWithName:@"Heiti TC" size:0.0]
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Menlo" size:16.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title=@"购物车";
    //创建xib文件对象
    UINib *nib=[UINib nibWithNibName:@"shopCartCell" bundle:[NSBundle mainBundle]];
    //注册到表格视图
    [self.myTableView  registerNib:nib forCellReuseIdentifier:@"shopCartCell"];
    [self setExtraCellLineHidden:self.myTableView];
    //判断
//    [self flagLogin];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delCart:) name:@"delCart" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginAction:) name:@"loginAction" object:nil];
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
/**
 *  判断是否有登录
 */
-(void)flagLogin
{
    self.strData= @"";
    //初始化
    sumPrice=0;
    //数据
    Database *db=[[Database alloc]init];
    _shopCartArray=[db getList];
    //总数量
    self.numLabel.text=[NSString stringWithFormat:@"共%lu件商品",(unsigned long)self.shopCartArray.count];
    dispatch_async(dispatch_get_main_queue(), ^{
         [_myTableView reloadData];
    });
    //沙盒路径
    AccountModel *account=[AccountTool account];
    if(account)
    {
        if (_shopCartArray.count>0) {
            _shopArray=[[NSMutableArray alloc]initWithCapacity:0];
            for (int i=0; i<_shopCartArray.count; i++) {
                CartModel *cartList=_shopCartArray[i];
                sumPrice=sumPrice+cartList.price;
                NSString *shopidStr=[[_shopCartArray objectAtIndex:i]valueForKey:@"shopId"];
                NSString *numStr=[[_shopCartArray objectAtIndex:i]valueForKey:@"num"];
                NSDictionary *Dic=[NSDictionary dictionaryWithObjectsAndKeys:shopidStr,@"shopid",numStr,@"num",nil];
                [_shopArray addObject:Dic];
            }
            NSData *strData=[NSJSONSerialization dataWithJSONObject:_shopArray options:NSJSONWritingPrettyPrinted error:nil];
            NSString *str = [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];
            self.strData = [self.strData stringByAppendingString:str];
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)self.shopCartArray.count];
            [self.navigationController.tabBarController.tabBar showBadgeWithIndex:self.navigationController.tabBarController.selectedIndex];
            self.priceLabel.text=[NSString stringWithFormat:@"%lu",(unsigned long)sumPrice];
            self.view1.hidden=YES;
            self.view2.hidden=YES;
            self.view3.hidden=NO;
        }else{
            self.priceLabel.text=@"0";
            self.view1.hidden=YES;
            self.view2.hidden=NO;
            self.view3.hidden=YES;
        }
        //注册通知
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delCart:) name:@"delCart" object:nil];
    }else{
        self.view1.hidden=NO;
        self.view2.hidden=YES;
        self.view3.hidden=YES;
    }
    
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
    return _shopCartArray.count;
}
/**
 *  设置单元格内容
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellStr=@"shopCartCell";
    shopCartCell *cell=[self.myTableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell==nil) {
        cell=[[shopCartCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    //取消Cell选中时背景
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    CartModel *cartList=_shopCartArray[indexPath.row];
    cell.goodsTitle.text=cartList.title;
    cell.goodsPriceLabel.text=[NSString stringWithFormat:@"¥%d",cartList.price];
    cell.numLabel.text=[NSString stringWithFormat:@"剩余%@人次",cartList.shenyurenshu];
    cell.numTextField.text=[NSString stringWithFormat:@"%i",cartList.num];
    /**商品图片*/
    //拼接图片网址·
    NSString *urlStr =[NSString stringWithFormat:@"%@%@",imgURL,cartList.thumb];
    //转换成url
    NSURL *imgUrl = [NSURL URLWithString:urlStr];
    [cell.goodsImageView sd_setImageWithURL:imgUrl];
    cell.delegate=self;
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

/**
 *  该方法在视图跳转时被触发
 *
 *  @param segue  <#segue description#>
 *  @param sender <#sender description#>
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"shopCart"]) {
        id theSegue=segue.destinationViewController;
        [theSegue setValue:@"shopCart" forKey:@"type"];
    }else if([segue.identifier isEqualToString:@"balanceSegue"]){
        id theSegue=segue.destinationViewController;
        [theSegue setValue:self.numLabel.text forKey:@"sumNum"];
        [theSegue setValue:self.priceLabel.text forKey:@"sumPrice"];
        [theSegue setValue:self.strData forKey:@"jsonStr"];
    }
}
#pragma mark 数据库操作
/**
 *  编辑数据
 *
 *  @param editing  <#editing description#>
 *  @param animated <#animated description#>
 */
-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if(_myTableView.editing==NO)
    {
        _myTableView.editing=YES;
    }else
    {
        _myTableView.editing=NO;
    }
}
#pragma mark 删除
/**
 *  表格提交编辑样式
 *
 *  @param tableView    <#tableView description#>
 *  @param editingStyle <#editingStyle description#>
 *  @param indexPath    <#indexPath description#>
 */
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //删除样式
    if(editingStyle==UITableViewCellEditingStyleDelete)
    {
        //删除方法
       CartModel *cartList=_shopCartArray[indexPath.row];
        int row=cartList.pk_id;
        Database *db=[[Database alloc]init];
        if([db deleteList:row])
        {
            _alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"删除商品成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [_alert show];
            //删除成功后重新获取数据更新列表
            _shopCartArray=[db getList];
            [_myTableView reloadData];
            [self.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%ld",(unsigned long)_shopCartArray.count]];
            self.numLabel.text=[NSString stringWithFormat:@"共%lu件商品",(unsigned long)self.shopCartArray.count];
            int price=[self.priceLabel.text intValue];
            price=price-cartList.price;
              self.priceLabel.text=[NSString stringWithFormat:@"%lu",(unsigned long)price];
            if (_shopCartArray.count>0) {
                self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)self.shopCartArray.count];
                [self.navigationController.tabBarController.tabBar showBadgeWithIndex:self.navigationController.tabBarController.selectedIndex];
            }else{
                //创建通知
                NSNotification *notification =[NSNotification notificationWithName:@"delCart" object:nil userInfo:nil];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                [self.navigationController.tabBarController.tabBar hideBadgeWithIndex:self.navigationController.tabBarController.selectedIndex];
            }
        }else
        {
            _alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"删除商品失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [_alert show];
        }
        
    }
}
#pragma mark -- 实现加减按钮点击代理事件
/**
 *  实现加减按钮点击代理事件
 *
 *  @param cell 当前单元格
 *  @param flag 按钮标识，11 为减按钮，12为加按钮
 */
-(void)btnClick:(UITableViewCell *)cell andFlag:(int)flag
{
    //初始化
    sumPrice=0;
    NSIndexPath *index = [_myTableView indexPathForCell:cell];
    CartModel *model = _shopCartArray[index.row];
    switch (flag) {
        case 11:
        {
            //做减法
            //先获取到当期行数据源内容，改变数据源内容，刷新表格
            if (model.num > 1)
            {
                model.num --;
                model.price--;
            }
        }
            break;
        case 12:
        {
            //做加法
            model.num ++;
            model.price++;
        }
            break;
        default:
            break;
    }

    //初始化数据库
    Database *db=[Database new];
    //数据更新
    if([db updateList:model])
    {
        NSLog(@"成功");
        for (int i=0; i<_shopCartArray.count; i++) {
            CartModel *cartList=_shopCartArray[i];
            sumPrice=sumPrice+cartList.price;
        }
        self.priceLabel.text=[NSString stringWithFormat:@"%lu",(unsigned long)sumPrice];
    }else
    {
    }
    //刷新表格
    [_myTableView reloadData];
    
}
#pragma mark 监听通知
/**
 *  监听通知
 *
 *  @param text <#text description#>
 */
- (void)delCart:(NSNotification *)text{
    if (_shopCartArray.count>0) {
        _shopArray=[[NSMutableArray alloc]initWithCapacity:0];
        for (int i=0; i<_shopCartArray.count; i++) {
            CartModel *cartList=_shopCartArray[i];
            sumPrice=sumPrice+cartList.price;
            NSString *shopidStr=[[_shopCartArray objectAtIndex:i]valueForKey:@"shopId"];
            NSString *numStr=[[_shopCartArray objectAtIndex:i]valueForKey:@"num"];
            NSDictionary *Dic=[NSDictionary dictionaryWithObjectsAndKeys:shopidStr,@"shopid",numStr,@"num",nil];
            [_shopArray addObject:Dic];
        }
        NSData *strData=[NSJSONSerialization dataWithJSONObject:_shopArray options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];
        self.strData = [self.strData stringByAppendingString:str];
        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)self.shopCartArray.count];
        [self.navigationController.tabBarController.tabBar showBadgeWithIndex:self.navigationController.tabBarController.selectedIndex];
        self.priceLabel.text=[NSString stringWithFormat:@"%lu",(unsigned long)sumPrice];
        self.view1.hidden=YES;
        self.view2.hidden=YES;
        self.view3.hidden=NO;
    }else{
        self.priceLabel.text=@"0";
        self.view1.hidden=YES;
        self.view2.hidden=NO;
        self.view3.hidden=YES;
    }
}
/**
 *  监听通知
 *
 *  @param text <#text description#>
 */
- (void)loginAction:(NSNotification *)text{
    self.strData= @"";
    //初始化
    sumPrice=0;
    //数据
    Database *db=[[Database alloc]init];
    _shopCartArray=[db getList];
    //总数量
    self.numLabel.text=[NSString stringWithFormat:@"共%lu件商品",(unsigned long)self.shopCartArray.count];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_myTableView reloadData];
    });
    //沙盒路径
    AccountModel *account=[AccountTool account];
    if(account)
    {
        if (_shopCartArray.count>0) {
            _shopArray=[[NSMutableArray alloc]initWithCapacity:0];
            for (int i=0; i<_shopCartArray.count; i++) {
                CartModel *cartList=_shopCartArray[i];
                sumPrice=sumPrice+cartList.price;
                NSString *shopidStr=[[_shopCartArray objectAtIndex:i]valueForKey:@"shopId"];
                NSString *numStr=[[_shopCartArray objectAtIndex:i]valueForKey:@"num"];
                NSDictionary *Dic=[NSDictionary dictionaryWithObjectsAndKeys:shopidStr,@"shopid",numStr,@"num",nil];
                [_shopArray addObject:Dic];
            }
            NSData *strData=[NSJSONSerialization dataWithJSONObject:_shopArray options:NSJSONWritingPrettyPrinted error:nil];
            NSString *str = [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];
            self.strData = [self.strData stringByAppendingString:str];
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)self.shopCartArray.count];
            [self.navigationController.tabBarController.tabBar showBadgeWithIndex:self.navigationController.tabBarController.selectedIndex];
            self.priceLabel.text=[NSString stringWithFormat:@"%lu",(unsigned long)sumPrice];
            self.view1.hidden=YES;
            self.view2.hidden=YES;
            self.view3.hidden=NO;
        }else{
            self.priceLabel.text=@"0";
            self.view1.hidden=YES;
            self.view2.hidden=NO;
            self.view3.hidden=YES;
        }
        //注册通知
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delCart:) name:@"delCart" object:nil];
    }else{
        self.view1.hidden=NO;
        self.view2.hidden=YES;
        self.view3.hidden=YES;
    }
}
@end
