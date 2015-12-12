//
//  GoodsDetailController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/11.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "GoodsDetailController.h"
#import "UITabBarController+ShowHideBar.h"
@interface GoodsDetailController ()
/**所有云购记录*/
@property (weak, nonatomic) IBOutlet UITableViewCell *tableViewCell1;
/**图文详情*/
@property (weak, nonatomic) IBOutlet UITableViewCell *tableViewCell2;
/**商品晒单*/
@property (weak, nonatomic) IBOutlet UITableViewCell *tableViewCell3;
@end

@implementation GoodsDetailController
//隐藏和显示底部标签栏
-(void)viewWillAppear:(BOOL)animated
{

//    self.tableViewCell1.selectionStyle=UITableViewCellSelectionStyleDefault;
//     self.tableViewCell2.selectionStyle=UITableViewCellSelectionStyleDefault;
//     self.tableViewCell3.selectionStyle=UITableViewCellSelectionStyleDefault;
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    
    self.tableViewCell1.selectionStyle=UITableViewCellSelectionStyleNone;
//    self.tableViewCell2.selectionStyle=UITableViewCellSelectionStyleNone;
//    self.tableViewCell3.selectionStyle=UITableViewCellSelectionStyleNone;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.goodsImageView.layer.borderWidth=0.5;
    self.goodsImageView.layer.borderColor=[[UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0]CGColor];
    /**圆角*/
    [[self.goodsImageView layer]setCornerRadius:2.0];
    //更改进度条高度
    self.goodsProgressView.transform=CGAffineTransformMakeScale(1.0f, 2.0f);
    //设置进度值并动画显示
    [self.goodsProgressView setProgress:0.7 animated:YES];
    /**头像圆角*/
    self.peopleImageView.layer.cornerRadius=30.0;
    self.peopleImageView.layer.masksToBounds=YES;
    


}

/*
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
