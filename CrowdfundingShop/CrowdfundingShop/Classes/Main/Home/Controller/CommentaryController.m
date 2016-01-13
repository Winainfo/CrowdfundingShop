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
#import <MBProgressHUD.h>
@interface CommentaryController ()<UITextFieldDelegate,MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
    AccountModel *account;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
/**评论框*/
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
/**评论数组*/
@property(retain,nonatomic) NSArray *contentArray;
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
    self.contentArray=@[@"1asdfad",@"测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试",@"1ad"];
    self.prototypeCell=[self.myTableView dequeueReusableCellWithIdentifier:@"CommentaryCell"];
    self.contentTextField.delegate=self;
}
#pragma mark 数据请求
/**
 *  请求即将揭晓商品
 */
-(void)requestData:(NSString *)sd_id andpageIndex:(NSString *)pageindex andpageSize:(NSString *)pagesize{
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:pageindex,@"pageIndex",pagesize,@"pageSize",nil];
    [RequestData reviewListSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.mode = MBProgressHUDModeAnnularDeterminate;
        HUD.delegate = self;
        HUD.labelText = @"加载中...";
        [HUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
        self.contentArray=data[@"content"];
        //更新主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myTableView reloadData];
        });
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
    return self.contentArray.count;
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
    cell.contetnLabel.numberOfLines=0;
//    cell.contetnLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.contetnLabel.text=self.contentArray[indexPath.row];
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
    CommentaryCell *cell=(CommentaryCell *)self.prototypeCell;
    //获得当前cell高度
    CGRect frame=[cell frame];
    //文本赋值
    cell.contetnLabel.text=self.contentArray[indexPath.row];
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
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //沙盒路径
    account=[AccountTool account];
    if ([self.contentTextField.text length]>2) {
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",self.sd_id,@"sdhf_id",self.contentTextField.text,@"sdhf_content",nil];
        [RequestData reviewSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
            NSLog(@"%@",data);
           HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            [self.navigationController.view addSubview:HUD];
            HUD.delegate = self;
            HUD.labelText = @"提交中...";
            [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            //更新主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.myTableView reloadData];
            });
        }];
        self.contentTextField.text=@"";
        [self.contentTextField resignFirstResponder];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"内容为空或不够3位";
        hud.frame=CGRectMake(100, 300, 20, 10);
//        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
    }
    return YES;
}
#pragma mark - Execution code

- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(3);
}

- (void)myProgressTask {
    // This just increases the progress indicator in a loop
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress += 0.01f;
        HUD.progress = progress;
        usleep(50000);
    }
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
