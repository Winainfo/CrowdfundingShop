//
//个人中心表格设置
//
//  Created by 吴金林 on 15/11/25.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "PerTableController.h"

@interface PerTableController ()

@end

@implementation PerTableController

- (void)viewDidLoad {
    [super viewDidLoad];
}
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;//section头部高度
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
}
@end
