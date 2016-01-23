//
//  CloudRecordController.m
//  CrowdfundingShop
//  所有云购记录
//  Created by 吴金林 on 15/12/11.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "CloudRecordController.h"
#import "CloudRecordCell.h"
#import <UIImageView+WebCache.h>
@interface CloudRecordController ()<UITableViewDataSource,UITableViewDelegate>
@property (assign,nonatomic)BOOL flag;
@property (retain,nonatomic)NSArray *content;
@end

@implementation CloudRecordController

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
    self.title=@"所有云购记录";
    //导航栏左侧按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    leftBtn.frame=CGRectMake(-5, 5, 21, 21);
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
    //导航栏右侧按钮
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"buy_record_time_down_unselect"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"buy_record_time_down_unselect"] forState:UIControlStateSelected];
    rightBtn.tag=100;
    rightBtn.frame=CGRectMake(-5, 5, 30, 30);
    [rightBtn addTarget:self action:@selector(sortClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=right;
    //创建xib文件对象
    UINib *nib=[UINib nibWithNibName:@"CloudRecordCell" bundle:[NSBundle mainBundle]];
    //注册到表格视图
    [self.myTableView registerNib:nib forCellReuseIdentifier:@"CloudRecordCell"];
    //    self.myTableView.separatorStyle=NO;
    [self setExtraCellLineHidden:self.myTableView];
    NSLog(@"%@",self.content);
}

/**
 *  按时间排序
 *
 *  @param sender <#sender description#>
 */
- (void)sortClick:(UIButton *)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 100:
            if (_flag) {
                //导航栏右侧按钮
                UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
                [rightBtn setImage:[UIImage imageNamed:@"buy_record_time_down_unselect"] forState:UIControlStateNormal];
                [rightBtn setImage:[UIImage imageNamed:@"buy_record_time_down_unselect"] forState:UIControlStateSelected];
                rightBtn.tag=100;
                rightBtn.frame=CGRectMake(-5, 5, 30, 30);
                [rightBtn addTarget:self action:@selector(sortClick:) forControlEvents:UIControlEventTouchUpInside];
                UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
                self.navigationItem.rightBarButtonItem=right;
                _flag=NO;
            }else{
                //导航栏右侧按钮
                UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
                [rightBtn setImage:[UIImage imageNamed:@"buy_record_time_up_unselect"] forState:UIControlStateNormal];
                [rightBtn setImage:[UIImage imageNamed:@"buy_record_time_up_unselect"] forState:UIControlStateSelected];
                rightBtn.tag=100;
                rightBtn.frame=CGRectMake(-5, 5, 30, 30);
                [rightBtn addTarget:self action:@selector(sortClick:) forControlEvents:UIControlEventTouchUpInside];
                UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
                self.navigationItem.rightBarButtonItem=right;
                _flag=YES;
            }
            break;
            
        default:
            break;
    }
}
//返回
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
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
-(void)searchClick{
    
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
    return self.content.count;
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
    static NSString *cellStr=@"CloudRecordCell";
    CloudRecordCell *cell=[tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell==nil) {
        cell=[[CloudRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.nameLabel.text=self.content[indexPath.row][@"username"];
    cell.numLabel.text=self.content[indexPath.row][@"gonumber"];
    //时间戳转换时间
    NSString *str=self.content[indexPath.row][@"time"];//时间戳
    NSTimeInterval time=[str doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    cell.timeLabel.text=currentDateStr;
    /**商品图片*/
    //拼接图片网址·
    NSString *urlStr =[NSString stringWithFormat:@"%@%@",imgURL,self.content[indexPath.row][@"uphoto"]];
    //转换成url
    NSURL *imgUrl = [NSURL URLWithString:urlStr];
    [cell.peopleImageView sd_setImageWithURL:imgUrl];
    //截取城市
    NSString *string =self.content[indexPath.row][@"ip"];
    NSArray *strArray=[string componentsSeparatedByString:@","];
    cell.cityLabel.text=[NSString stringWithFormat:@"(%@)",strArray[0]];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
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
    return 60;
}

@end
