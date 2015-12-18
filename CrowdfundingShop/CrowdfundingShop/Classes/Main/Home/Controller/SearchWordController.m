//
//  SearchWordController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/17.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "SearchWordController.h"
#import "UIView+Extension.h"
#import "HWSearchBar.h"
#import "HistoryTableViewCell.h"
#import "HistoryClass.h"

@interface SearchWordController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,assign)BOOL flag;
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (retain,nonatomic) NSArray *keyWordArray;
/**搜索历史表*/
@property (weak, nonatomic) IBOutlet UITableView *hitoryTable;
@property (retain,nonatomic) HWSearchBar *mySearchBar;
/**历史数组*/
@property (retain,nonatomic) NSArray *hisArr;
/**取消btn*/
@property (weak, nonatomic) IBOutlet UIButton *canleBtn;
/**推荐*/
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
/**历史*/
@property (weak, nonatomic) IBOutlet UIView *myView;

@end

@implementation SearchWordController
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
    //查询所有搜索历史
    self.hisArr = [HistoryClass findall];
    //为导航栏视图添加搜索栏
    _mySearchBar = [HWSearchBar searchBar];
    _mySearchBar.width =300;
    _mySearchBar.height = 30;
    self.navigationItem.titleView = _mySearchBar;
    //设置搜索栏的代理
    _mySearchBar.delegate=self;
    _mySearchBar.placeholder=@"搜索您要的宝贝";
    //导航栏左侧按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateSelected];
    leftBtn.frame=CGRectMake(-5, 5, 30, 30);
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
    //注册Cell
    [self.myCollectionView registerClass:[SearchWordCell class] forCellWithReuseIdentifier:@"SearchWordCell"];
    self.keyWordArray=@[@"iPhone6",@"宝马X5",@"iPad",@"汽车",@"单反相机",@"小米3",@"电视",@"奥迪",@"电脑"];
    //注册自定义搜索历史单元格
    UINib *nib = [UINib nibWithNibName:@"HistoryTableViewCell" bundle:[NSBundle mainBundle]];
    [self.hitoryTable registerNib:nib forCellReuseIdentifier:@"HistoryTableViewCell"];
    self.hisArr=@[@"iPhone6S",@"奥迪",@"充值卡"];
    [self setExtraCellLineHidden:self.hitoryTable];
}


#pragma mark textField监听
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.myView.hidden=NO;
    self.myScrollView.hidden=YES;
    self.canleBtn.hidden=NO;
    _flag=NO;
    return NO;
}

//返回
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 实现代理方法
//每个section的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.keyWordArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SearchWordCell *cell = (SearchWordCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"SearchWordCell" forIndexPath:indexPath];
    cell.titleLabel.text=_keyWordArray[indexPath.row];
    return cell;
}

#pragma mark 实现UICollectionViewDelegateFlowLayout代理
/**
 *  定义每个UICollectionView的间距
 *
 *  @param collectionView       <#collectionView description#>
 *  @param collectionViewLayout <#collectionViewLayout description#>
 *  @param section              <#section description#>
 *
 *  @return <#return value description#>
 */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5,10,15,10);
}


#pragma mark 表格代理
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
//单元格个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.hisArr.count;
}
//单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryTableViewCell"];
    if (!cell) {
        cell = [[HistoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HistoryTableViewCell"];
    }
    cell.foodName.text =self.hisArr[indexPath.row];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.backgroundColor = [UIColor colorWithWhite:0.956 alpha:1.000];
    return cell ;
}
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}
//点击历史记录，跳转到分类结果页
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    HistoryClass *history = self.hisArr[(self.hisArr.count-1-indexPath.row)];
}

#pragma 实现数据源协议中一些关于编辑操作方法

//调用编辑方法,修改数据
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle==UITableViewCellEditingStyleDelete) {
//        //删除方法
//        HistoryClass *his=self.hisArr[(self.hisArr.count-1-indexPath.row)];
//        int hid=his.Hid;
//        //        NSLog(@"tv.vid=%d;Vid=%d",tv.Vid,Vid);
//        [HistoryClass deleteHISTORY:hid];
//        self.hisArr = [HistoryClass findall];
//        //        NSLog(@"%lu",self.hisArr.count);
//        [self.hitoryTable reloadData];
//    }
//}
//提交表格编辑样式
-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:YES];
    if (self.hitoryTable.editing==NO) {
        self.hitoryTable.editing=YES;
    }else{
        self.hitoryTable.editing=NO;
    }
}



#pragma mark 视图切换
/**
 *  视图切换事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)showHidnClick:(UIButton *)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 100:
            if (_flag) {
                self.myView.hidden=NO;
                self.myScrollView.hidden=YES;
                self.canleBtn.hidden=NO;
                _flag=NO;
            }else{
                self.myView.hidden=YES;
                self.myScrollView.hidden=NO;
                self.canleBtn.hidden=YES;
                _flag=YES;
            }
            break;
            
        default:
            break;
    }
}


@end
