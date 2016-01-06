//
//  SeetingTableController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 16/1/4.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import "SeetingTableController.h"
#import "PersonalController.h"
#import "AccountTool.h"
//获得当前屏幕宽高点数（非像素）
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
@interface SeetingTableController ()
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (retain,nonatomic) UIView *footerView;
@property (weak, nonatomic) IBOutlet UITableViewCell *ViewCell1;

@property (weak, nonatomic) IBOutlet UITableViewCell *ViewCell2;


@end

@implementation SeetingTableController
-(void)viewWillAppear:(BOOL)animated{
    //判断是否有登录
    [self flagLogin];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setExtraCellLineHidden:self.myTableView];
    self.footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 40)];
    self.footerView.backgroundColor=[UIColor clearColor];
    UIButton *addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame=CGRectMake(10, 0, self.footerView.frame.size.width-20, self.footerView.frame.size.height);
    [addBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    addBtn.backgroundColor=[UIColor colorWithRed:231.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1];
    addBtn.layer.cornerRadius=4.0;
    addBtn.layer.masksToBounds=YES;
    [self.footerView addSubview:addBtn];
    self.myTableView.tableFooterView=self.footerView;
}
/**
 *  判断是否有登录
 */
-(void)flagLogin
{
    //沙盒路径
    AccountModel *account=[AccountTool account];
    if(account)
    {
        //显示尾部退出按钮
        [self.myTableView.tableFooterView setHidden:NO ];
        [self.ViewCell1 setHidden:NO];
    }else{
        //隐藏尾部退出按钮
        [self.myTableView.tableFooterView setHidden:YES ];
        [self.ViewCell1 setHidden:YES];
        [self.ViewCell2 setHidden:YES];
        self.myTableView.frame=CGRectMake(0, -115, kScreenWidth, kScreenHeight+240);
    }
}
/**
 *  退出
 */
-(void)logout{
    //初始化AlertView
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定退出？"message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteFile];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
/**
 *删除沙盒里的文件
 *
 *  @return <#return value description#>
 */
-(void)deleteFile {
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    //文件名
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"userInfo.archive"];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        return ;
    }else {
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDele) {
            //设置故事板为第一启动
            UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            PersonalController *personalController=[storyboard instantiateViewControllerWithIdentifier:@"PersonalView"];
            [self.navigationController pushViewController:personalController animated:YES];
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
        
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
/**
 *  cell 间距
 *
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 */

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

@end
