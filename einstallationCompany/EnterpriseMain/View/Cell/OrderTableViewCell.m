//
//  OrderTableViewCell.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/4/23.
//

#import "OrderTableViewCell.h"
#import "OrderItemTableViewCell.h"

@implementation OrderTableViewCell

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
    
    return self.orderList.resultarr.count;
    
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
    [self.tbOrder registerNib:[UINib nibWithNibName:NSStringFromClass([OrderItemTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([OrderItemTableViewCell class])];
    [self.tbOrder reloadData];
    // 1. 创建一个点击事件，点击时触发labelClick方法
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                         initWithTarget:self action:@selector(labelClick)];
    // 2. 将点击事件添加到label上
    [self.imageView addGestureRecognizer:labelTapGestureRecognizer];
    self.imageView.userInteractionEnabled = YES; //
    self.labelState.clipsToBounds = YES;
    self.labelState.layer.cornerRadius = 8.f;
    self.labelState.text = self.orderList.InstallState;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderItemTableViewCell class])];
    if (cell == nil) {
        cell = [[OrderItemTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])] ;
    }
    KeyValueEntity *itemModel = [self.orderList.resultarr objectAtIndex:indexPath.row];
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
