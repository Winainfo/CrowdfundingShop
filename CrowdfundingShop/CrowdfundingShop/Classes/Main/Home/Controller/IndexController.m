//
//  IndexController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/4.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "IndexController.h"
#import "PopularGoodsCell.h"
#import "goodsViewCell.h"
//获得当前屏幕宽高点数（非像素）
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
@interface IndexController ()<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *mytableView;

@property (weak, nonatomic) IBOutlet UITableViewCell *noticeCell;//公告
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
/**即将揭晓*/
@property (weak, nonatomic) IBOutlet UICollectionView *goodsCollectionView;
/**人气推荐*/
@property (weak, nonatomic) IBOutlet UICollectionView *groomCollectionView;
/**限购专区*/
@property (weak, nonatomic) IBOutlet UICollectionView *limitCollectionView;

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;//滚动视图
@property (weak, nonatomic) IBOutlet UIPageControl *myPageControl;
@property (retain,nonatomic) NSTimer *time;//定时器对象s

@property(retain,nonatomic)UIView *btnView;
@property(retain,nonatomic)UIView *moveView;
@end

@implementation IndexController

- (void)viewDidLoad {
    //设置导航栏标题颜色和字体大小UITextAttributeFont:[UIFont fontWithName:@"Heiti TC" size:0.0]
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Menlo" size:16.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title=@"一元云购";
    CGRect table=self.mytableView.frame;
    table.size.height=800;
    self.mytableView.frame=table;
//    //导航栏右侧按钮
//    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    [rightBtn setImage:[UIImage imageNamed:@"iconfont-search"] forState:UIControlStateNormal];
//    rightBtn.frame=CGRectMake(-5, 5, 30, 30);
//    [rightBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem=right;
    //注册Cell
    [self.myCollectionView registerClass:[PopularGoodsCell class] forCellWithReuseIdentifier:@"PopularGoodsCell"];
    //即将揭晓
    [self.goodsCollectionView registerClass:[goodsViewCell class] forCellWithReuseIdentifier:@"goodsViewCell"];
    //人气推荐
    [self.groomCollectionView registerClass:[goodsViewCell class] forCellWithReuseIdentifier:@"goodsViewCell"];
    //限购专区
    [self.limitCollectionView registerClass:[goodsViewCell class] forCellWithReuseIdentifier:@"goodsViewCell"];
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
    if(collectionView==self.myCollectionView){
        return 6;
    }else if(collectionView==self.groomCollectionView){ //人气推荐
        return 4;
    } else if(collectionView==self.limitCollectionView){ //限购专区
        return 2;
    }else{
        return 6;
    }
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView==self.myCollectionView) {
        PopularGoodsCell *cell = (PopularGoodsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PopularGoodsCell" forIndexPath:indexPath];
        return cell;
    }else if(collectionView==self.goodsCollectionView){ //即将揭晓
        goodsViewCell *cell = (goodsViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"goodsViewCell" forIndexPath:indexPath];
        return cell;
    }else if(collectionView==self.groomCollectionView){//人气推荐
        goodsViewCell *cell = (goodsViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"goodsViewCell" forIndexPath:indexPath];
        return cell;
    }else if(collectionView==self.limitCollectionView){//限购专区
        goodsViewCell *cell = (goodsViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"goodsViewCell" forIndexPath:indexPath];
        return cell;
    }
    return nil;
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



/*设置标题头的宽度*/
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==2) {
        return 40;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==2) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        self.btnView=[[UIView alloc]initWithFrame:CGRectMake(0,0 , kScreenWidth, 40)];
        NSArray *arr=@[@"即将揭晓",@"人气推荐",@"限购专区"];
        for(int i=0;i<3;i++)
        {
            [self creatButton:arr[i] andTag:i+1];
        }
        [view addSubview:self.btnView];
        //分割线
        UIView *lineview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        lineview.backgroundColor=[UIColor colorWithRed:189.0/255.0 green:189.0/255.0 blue:189.0/255.0 alpha:1];
        [view addSubview:lineview];
        UIView *lineview2=[[UIView alloc]initWithFrame:CGRectMake(0, view.frame.size.height, kScreenWidth, 0.5)];
        lineview2.backgroundColor=[UIColor colorWithRed:189.0/255.0 green:189.0/255.0 blue:189.0/255.0 alpha:1];
        [view addSubview:lineview2];
         [self creatMoveView];
        return view;
    }
    return nil;
}
-(void)creatButton:(NSString *)title andTag:(int)index
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];//初始化按钮
    btn.tag=index;//设置标识
    [btn setTitle:title forState:UIControlStateNormal];//设置标题
    btn.frame=CGRectMake((index-1)*kScreenWidth/3.0, 0, kScreenWidth/3.0, 40);//设置位置尺寸
    [btn setBackgroundColor:[UIColor whiteColor]];//设置背景颜色
    [btn setTintColor:[UIColor blackColor]];//设置标题颜色
    btn.titleLabel.font=[UIFont fontWithName:@"Menlo" size:14.0];//设置字体及大小
    [btn addTarget:self action:@selector(selectMoveAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnView addSubview:btn];//添加子视图
}

-(void)selectMoveAction:(UIButton *)sender
{
    //0.2秒动画改变self.movView的frame使它移动
    [UIView animateWithDuration:0.2 animations:^{
        self.moveView.frame=CGRectMake(sender.frame.origin.x, self.moveView.frame.origin.y, self.moveView.frame.size.width, self.moveView.frame.size.height);
    }];
    static int currentSelectButtonIndex = 0;
    static int previousSelectButtonIndex=10;
    currentSelectButtonIndex=(int)sender.tag;//获取Button的tag值
    UIButton *previousBtn=(UIButton *)[self.view viewWithTag:previousSelectButtonIndex];
    [previousBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIButton *currentBtn = (UIButton *)[self.view viewWithTag:currentSelectButtonIndex];
    [currentBtn setTitleColor:[UIColor colorWithRed:239.0/255.0 green:31.0/255.0 blue:48.0/255.0 alpha:1] forState:UIControlStateNormal];
    previousSelectButtonIndex=currentSelectButtonIndex;
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 1:{ //即将揭晓
            self.goodsCollectionView.hidden=NO;
            self.groomCollectionView.hidden=YES;
            self.limitCollectionView.hidden=YES;
        }break;
        case 2:{ //人气推荐
            self.goodsCollectionView.hidden=YES;
            self.groomCollectionView.hidden=NO;
            self.limitCollectionView.hidden=YES;
        }break;
        case 3:{//限购专区
            self.goodsCollectionView.hidden=YES;
            self.groomCollectionView.hidden=YES;
            self.limitCollectionView.hidden=NO;
        }break;
        default:break;
    }
}

-(void)creatMoveView
{
    self.moveView=[[UIView alloc]initWithFrame:CGRectMake(0,self.btnView.frame.size.height-3,(self.btnView.frame.size.width/3.0),3)];//设置位置及尺寸
    self.moveView.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:31.0/255.0 blue:48.0/255.0 alpha:1];//设置背景颜色
    
    [self.btnView addSubview:self.moveView];//将视图添加到self.btnView上
    
}
@end
