//
//  CommentaryController.m
//  CrowdfundingShop
//  评论页面
//  Created by 吴金林 on 15/12/21.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "CommentaryController.h"
#import "RequestData.h"
#import "AccountTool.h"
#import "LoginController.h"
#import <QuartzCore/QuartzCore.h>
#import <UIImageView+WebCache.h>
#import <JGProgressHUD.h>
@interface CommentaryController ()<UITextFieldDelegate,JGProgressHUDDelegate>{
    AccountModel *account;
    BOOL _blockUserInteraction;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
/**评论框*/
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
/**评论数组*/
@property(retain,nonatomic) NSMutableArray *contentArray;
@property (nonatomic, strong) UITableViewCell *prototypeCell;
@end

@implementation CommentaryController
//隐藏和显示底部标签栏
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Menlo" size:16.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title=@"评论";
    //导航栏左侧按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateSelected];
    leftBtn.frame=CGRectMake(-5, 5, 21, 21);
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
    //创建xib文件对象
    UINib *nib=[UINib nibWithNibName:@"CommentaryCell" bundle:[NSBundle mainBundle]];
    //注册到表格视图
    [self.myTableView  registerNib:nib forCellReuseIdentifier:@"CommentaryCell"];
    self.myTableView.separatorStyle=NO;
    [self setExtraCellLineHidden:self.myTableView];
    self.prototypeCell=[self.myTableView dequeueReusableCellWithIdentifier:@"CommentaryCell"];
    self.contentTextField.delegate=self;
    self.contentArray=[[NSMutableArray alloc]initWithCapacity:0];
    [self requestData:self.sd_id andpageIndex:@"1" andpageSize:@"8"];
    _blockUserInteraction=YES;
}
#pragma mark 数据请求
/**
 *  评论列表
 */
-(void)requestData:(NSString *)sd_id andpageIndex:(NSString *)pageindex andpageSize:(NSString *)pagesize{
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"type",sd_id,@"sd_id",pageindex,@"pageIndex",pagesize,@"pageSize",nil];
    [RequestData reviewListSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
        int code=[data[@"code"] intValue];
        if (code==0) {
            self.contentArray=data[@"content"];
            //更新主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.myTableView reloadData];
            });
        }else{
            
        }
    }];
}
/**
 *  返回
 */
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
    if (self.contentArray.count!=0) {
        return self.contentArray.count;
    }else{
        return 0;
    }
    
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
    
    static NSString *cellStr=@"CommentaryCell";
    CommentaryCell *cell=[tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell==nil) {
        cell=[[CommentaryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    if (self.contentArray.count!=0) {
        cell.contetnLabel.text=self.contentArray[indexPath.row][@"sdhf_content"];
        [cell.peopleNameBtn setTitle:[NSString stringWithFormat:@"%@",self.contentArray[indexPath.row][@"sdhf_username"]] forState:UIControlStateNormal];
        /**商品图片*/
        //拼接图片网址·
        NSString *urlStr =[NSString stringWithFormat:@"%@%@",imgURL,self.contentArray[indexPath.row][@"sdhf_img"]];
        //转换成url
        NSURL *imgUrl = [NSURL URLWithString:urlStr];
        [cell.peopleImageView sd_setImageWithURL:imgUrl];
        
        //时间戳转换时间
        NSString *str=self.contentArray[indexPath.row][@"sdhf_time"];//时间戳
        NSTimeInterval time=[str doubleValue];
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
        cell.timeLabel.text=currentDateStr;

    }
    //取消Cell选中时背景
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
    if (self.contentArray.count!=0) {
        CommentaryCell *cell=(CommentaryCell *)self.prototypeCell;
        //获得当前cell高度
        CGRect frame=[cell frame];
        //文本赋值
        cell.contetnLabel.text=self.contentArray[indexPath.row][@"sdhf_content"];
        //设置label的最大行数
        cell.contetnLabel.numberOfLines=0;
        CGSize labelSize=[cell.contetnLabel sizeThatFits:CGSizeMake(cell.contetnLabel.frame.size.width, 1000)];
        CGRect sFrame=cell.contetnLabel.frame;
        sFrame.size=labelSize;
        cell.contetnLabel.frame=sFrame;
        //计算出自适应的高度
        frame.size.height=labelSize.height+60;
        cell.frame=frame;
        return cell.frame.size.height;
    }else{
        return 50;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //沙盒路径
    account=[AccountTool account];
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    if ([self.contentTextField.text length]>2) {
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",self.sd_id,@"sdhf_id",self.contentTextField.text,@"sdhf_content",nil];
        HUD.textLabel.text = @"提交中...";//
        [HUD showInView:self.navigationController.view];
        HUD.square = YES;
        HUD.delegate=self;
        [RequestData reviewSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
            HUD.userInteractionEnabled=_blockUserInteraction;
            HUD.square = YES;
            HUD.delegate=self;
            HUD.textLabel.text = @"提交成功";
            HUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
            [HUD showInView:self.navigationController.view];
            [HUD dismissAfterDelay:1.5];
            [self requestData:self.sd_id andpageIndex:@"1" andpageSize:@"8"];
            //更新主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.myTableView reloadData];
            });
        } andFailure:^(NSError *error) {
            HUD.userInteractionEnabled=_blockUserInteraction;
            HUD.square = YES;
            HUD.delegate=self;
            HUD.textLabel.text = @"提交失败";
            HUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
            [HUD showInView:self.navigationController.view];
            [HUD dismissAfterDelay:1.5];
        }];
        self.contentTextField.text=@"";
        [self.contentTextField resignFirstResponder];
    }else{
        HUD.indicatorView = nil;
        HUD.textLabel.text = @"输入内容不够3位";
        HUD.position = JGProgressHUDPositionBottomCenter;
        [HUD showInView:self.navigationController.view];
        [HUD dismissAfterDelay:1.5];
    }
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    //沙盒路径
    account=[AccountTool account];
    if (textField.tag!=1009) {
        return YES;
    }else if(account){
        return YES;
    }else{
        //设置故事板为第一启动
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginController *controller=[storyboard instantiateViewControllerWithIdentifier:@"loginView"];
        controller.type=@"commentary";
        [self.navigationController pushViewController:controller animated:YES];
        return NO;
    }
}


@end
