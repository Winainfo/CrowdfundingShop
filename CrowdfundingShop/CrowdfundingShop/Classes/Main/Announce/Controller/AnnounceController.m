//
//  AnnounceController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/11/23.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "AnnounceController.h"
#import "NewGoodsCell.h"
#import "GoodsCategoryCell.h"
#import "DetailController.h"
@interface AnnounceController ()<UITableViewDataSource,UITableViewDelegate>
@property (assign,nonatomic)BOOL flag;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
@property (retain,nonatomic)NSArray *categoryNameArray;
@property (retain,nonatomic)NSArray *unselectImageArray;
@property (retain,nonatomic)NSArray *selectImageArray;

@end

@implementation AnnounceController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏标题颜色和字体大小UITextAttributeFont:[UIFont fontWithName:@"Heiti TC" size:0.0]
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Menlo" size:16.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title=@"最新揭晓";
    //创建xib文件对象
    UINib *nib=[UINib nibWithNibName:@"NewGoodsCell" bundle:[NSBundle mainBundle]];
    //注册到表格视图
    [self.myTableView  registerNib:nib forCellReuseIdentifier:@"NewGoodsCell"];
    self.myTableView.separatorStyle=NO;
    [self setExtraCellLineHidden:self.myTableView];
    //创建分类xib文件对象
    UINib *categoryNib=[UINib nibWithNibName:@"GoodsCategoryCell" bundle:[NSBundle mainBundle]];
    //注册到表格视图
    [self.categoryTableView registerNib:categoryNib forCellReuseIdentifier:@"GoodsCategoryCell"];
    [self setExtraCellLineHidden:self.categoryTableView];
    //分类名字
    self.categoryNameArray= @[ @"全部分类", @"手机数码", @"电脑办公", @"家用电器", @"化妆个性" , @"钟表首饰" , @"其他商品" ];
    self.unselectImageArray=@[@"category_2130837504_unselect",@"category_2130837505_unselect",@"category_2130837507_unselect",@"category_2130837506_unselect",@"category_2130837509_unselect",@"category_2130837508_unselect",@"category_2130837510_unselect"];
    self.selectImageArray=@[@"category_2130837504_select",@"category_2130837505_select",@"category_2130837507_select",@"category_2130837506_select",@"category_2130837509_select",@"category_2130837508_select",@"category_2130837510_select"];
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
    if(tableView==self.categoryTableView){
        return self.categoryNameArray.count;
    }
    return 20;
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
    
    if(tableView==self.categoryTableView){
        static NSString *cellStr=@"GoodsCategoryCell";
        GoodsCategoryCell *cell=[tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell==nil) {
            cell=[[GoodsCategoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        //取消Cell选中时背景
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.CategoryLabel.text=_categoryNameArray[indexPath.row];
        cell.imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",_unselectImageArray[indexPath.row]]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([indexPath isEqual:_lastIndexPath])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    }
    static NSString *cellStr=@"NewGoodsCell";
    NewGoodsCell *cell=[tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell==nil) {
        cell=[[NewGoodsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    //取消Cell选中时背景
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}


/**
 *  点击事件
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(tableView==self.categoryTableView){
        //取出上次出现的 checkmark 的所在行
        GoodsCategoryCell *cellLast = [tableView cellForRowAtIndexPath:_lastIndexPath];
        cellLast.accessoryType = UITableViewCellAccessoryNone;
        cellLast.CategoryLabel.textColor=[UIColor blackColor];
        cellLast.imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",_unselectImageArray[_lastIndexPath.row]]];
        //将新点击的行加上 checkmark 的标记
        GoodsCategoryCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.CategoryLabel.textColor=[UIColor colorWithRed:252.0/255.0 green:102.0/255.0 blue:33.0/255.0 alpha:1];
        cell.imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",_selectImageArray[indexPath.row]]];
        _lastIndexPath = indexPath;
        self.categoryTableView.hidden=YES;
        self.myTableView.hidden=NO;
        _flag=NO;
    }else{
        //设置故事板为第一启动
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DetailController *detailController=[storyboard instantiateViewControllerWithIdentifier:@"DetailControllerView"];
        [self.navigationController pushViewController:detailController animated:YES];
    }
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
    if(tableView==self.categoryTableView){
        return 44;
    }
    return 103;
}

/**
 *  显示隐藏分类
 *
 *  @param sender <#sender description#>
 */
- (IBAction)showHiddenClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 100:
            if (_flag) {
                self.categoryTableView.hidden=YES;
                self.myTableView.hidden=NO;
                _flag=NO;
            }else{
                self.categoryTableView.hidden=NO;
                self.myTableView.hidden=YES;
                _flag=YES;
            }
            break;
            
        default:
            break;
    }
}


@end
