//
//  ItemNoPictureTableViewCell.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/5/16.
//

#import "ItemClassOneTableViewCell.h"
#import "NoImageTableViewCell.h"

@implementation ItemClassOneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.keyValueList.count;
    
}

-(void)setTableOrder{
    self.tbOrder.dataSource = self;
    self.tbOrder.delegate = self;
    // 1.设置行高为自动撑开
    self.tbOrder.rowHeight = UITableViewAutomaticDimension;
    self.tbOrder.allowsSelection = NO;
    //2.设置一个估计的行高，只要大于0就可以了，但是还是尽量要跟cell的高差不多
    self.tbOrder.estimatedRowHeight = 40;
    self.tbOrder.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tbOrder registerNib:[UINib nibWithNibName:NSStringFromClass([NoImageTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([NoImageTableViewCell class])];
    [self.tbOrder reloadData];
    // 1. 创建一个点击事件，点击时触发labelClick方法
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                         initWithTarget:self action:@selector(labelClick)];
    // 2. 将点击事件添加到label上
    [self.imageView addGestureRecognizer:labelTapGestureRecognizer];
    self.imageView.userInteractionEnabled = YES; //

    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NoImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NoImageTableViewCell class])];
    if (cell == nil) {
        cell = [[NoImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])] ;
    }
    KeyValueEntity *itemModel = [self.keyValueList objectAtIndex:indexPath.row];
    cell.itemModel = itemModel;
    CGFloat itemHeight = [(NSString *)itemModel.Value boundingRectWithSize:CGSizeMake((SCREENWIDTH-180), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height+15;
    cell.vConstraintHeight.constant = itemHeight;
    [cell setModel: cell.itemModel];
    return cell;
    
    
    
}

- (void)labelClick {
//    WaitOrderListViewController *vc = [[WaitOrderListViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
   
}

@end
