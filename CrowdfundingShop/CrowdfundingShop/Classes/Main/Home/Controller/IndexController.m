//
//  IndexController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/4.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "IndexController.h"
#import "PopularGoodsCell.h"
//获得当前屏幕宽高点数（非像素）
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
@interface IndexController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableViewCell *noticeCell;//公告
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;//滚动视图
@property (weak, nonatomic) IBOutlet UIPageControl *myPageControl;
@property (retain,nonatomic) NSTimer *time;//定时器对象s
@end

@implementation IndexController

- (void)viewDidLoad {
    //设置导航栏标题颜色和字体大小UITextAttributeFont:[UIFont fontWithName:@"Heiti TC" size:0.0]
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Menlo" size:16.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title=@"一元云购";
//    //导航栏右侧按钮
//    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    [rightBtn setImage:[UIImage imageNamed:@"iconfont-search"] forState:UIControlStateNormal];
//    rightBtn.frame=CGRectMake(-5, 5, 30, 30);
//    [rightBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem=right;
    //注册Cell
    [self.myCollectionView registerClass:[PopularGoodsCell class] forCellWithReuseIdentifier:@"PopularGoodsCell"];
    //添加代理
    self.myScrollView.delegate=self;
    //页面控制的当前页
    self.myPageControl.currentPage = 0;
    //滚动视图
    [self Carousel];
}

#pragma mark 实现代理方法
//每个section的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PopularGoodsCell *cell = (PopularGoodsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PopularGoodsCell" forIndexPath:indexPath];
    
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
    return UIEdgeInsetsMake(0,0,0,0);
}


//图片滚动
-(void)Carousel
{
    //设置显示文本内容的大小
    self.myScrollView.contentSize=CGSizeMake(kScreenWidth*3, 150);
    //添加要显示的图片
    for(int i=1;i<4;i++)
    {
        UIImageView *imgv=[[UIImageView alloc]initWithFrame:CGRectMake((i-1)*kScreenWidth, 0,kScreenWidth, 150)];
        imgv.image=[UIImage imageNamed:[NSString stringWithFormat:@"1.jpg"]];
        self.myScrollView.pagingEnabled=YES;
        self.myScrollView.showsVerticalScrollIndicator=NO;
        self.myScrollView.showsHorizontalScrollIndicator=NO;
        //添加到滚动视图
        [self.myScrollView addSubview:imgv];
        
    }
    [self.view addSubview:self.myScrollView];
    //创建定时器对象
    self.time=[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(gun:) userInfo:nil repeats:YES];
}

//横幅滚动
-(void)gun:(id)sender{
    self.myPageControl.currentPage=self.myScrollView.contentOffset.x/kScreenWidth;//获取当前页
    int currentpage=(int)(self.myScrollView.contentOffset.x/kScreenWidth+1)%3;
    [self.myScrollView setContentOffset:CGPointMake(currentpage*kScreenWidth, 0)];//控制偏移量
}

@end
