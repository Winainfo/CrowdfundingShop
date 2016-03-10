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
#import <MBProgressHUD.h>
#import "UIImageView+WebCache.h"
@interface SeetingTableController ()
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (retain,nonatomic) UIView *footerView;
@property (weak, nonatomic) IBOutlet UITableViewCell *ViewCell1;

@property (weak, nonatomic) IBOutlet UITableViewCell *ViewCell2;

@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

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
    self.sizeLabel.text=[self fileSize];
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
            //popToViewController
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[PersonalController class]]) {
                    [self.navigationController popToViewController:temp animated:YES];
                }
            }
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

#pragma mark - 计算缓存大小
/**
 *  计算缓存大小
 *
 *  @return
 */
- (NSString *)fileSize{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSArray *files = [manager subpathsOfDirectoryAtPath:cachePath error:nil]; // 递归所有子路径
    float totalSize = 0;
    for (NSString *filePath in files) {
        NSString *path = [cachePath stringByAppendingPathComponent:filePath];
        // 判断是否为文件
        BOOL isDir = NO;
        [manager fileExistsAtPath:path isDirectory:&isDir];
        if (!isDir) {
            NSDictionary *attrs = [manager attributesOfItemAtPath:path error:nil];
            totalSize += [attrs[NSFileSize] integerValue];
        }
    }
    totalSize=totalSize/(1000*1000);
    float size = [[SDImageCache sharedImageCache] getSize] / 1000.0 / 1000.0;//图片缓存
    float sizeCache=size+totalSize;
    return [NSString stringWithFormat:@"%.2fM",sizeCache];
}

- (NSString *)getCacheSize
{
    
    //定义变量存储总的缓存大小
    long long sumSize = 0;
    //01.获取当前图片缓存路径
    NSString *cacheFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    NSLog(@"缓存目录:%@",cacheFilePath);
    //02.创建文件管理对象
    NSFileManager *filemanager = [NSFileManager defaultManager];
    //获取当前缓存路径下的所有子路径
    NSArray *subPaths = [filemanager subpathsOfDirectoryAtPath:cacheFilePath error:nil];
    //遍历所有子文件
    for (NSString *subPath in subPaths) {
        //1）.拼接完整路径
        NSString *filePath = [cacheFilePath stringByAppendingFormat:@"/%@",subPath];//2）.计算文件的大小
        long long fileSize = [[filemanager attributesOfItemAtPath:filePath error:nil]fileSize];
        //3）.加载到文件的大小
        sumSize += fileSize;
    }
    float size_m = sumSize/(1000*1000);
    NSLog(@"缓存大小%f",size_m);
    return [NSString stringWithFormat:@"%.2fM",size_m];
}

- (IBAction)clearBtn:(id)sender {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cacheFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    [fileManager removeItemAtPath:cacheFilePath error:nil];
    //声明对象；
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    //显示的文本；
    hud.labelText = @"正在清除";
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        //加载成功，先移除原来的HUD；
        hud.removeFromSuperViewOnHide = true;
        [hud hide:true afterDelay:0];
        self.sizeLabel.text=@"0M";
    }];
}

@end
