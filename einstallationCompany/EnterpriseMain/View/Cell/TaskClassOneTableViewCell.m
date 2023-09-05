//
//  OrderNOPictureTableViewCell.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/5/24.
//

#import "TaskClassOneTableViewCell.h"
#import "OrderItemTableViewCell.h"

@implementation TaskClassOneTableViewCell

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
- (IBAction)actionSubmit:(id)sender {
    if (self.confirmBlock) {
        self.confirmBlock();
    }
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
    
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                         initWithTarget:self action:@selector(caseShow)];
    // 2. 将点击事件添加到label上
    [self.labelCase addGestureRecognizer:labelTapGestureRecognizer];
    self.labelCase.userInteractionEnabled = YES;
    
    labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                         initWithTarget:self action:@selector(evaluate)];
    // 2. 将点击事件添加到label上
    [self.tvEvaluate addGestureRecognizer:labelTapGestureRecognizer];
    self.tvEvaluate.userInteractionEnabled = YES;

    
}

-(void)caseShow{
    self.caseBlock();
}

-(void)evaluate{
    self.evaluateBlock();
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderItemTableViewCell class])];
    if (cell == nil) {
        cell = [[OrderItemTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])] ;
    }
    KeyValueEntity *itemModel = [self.keyValueList objectAtIndex:indexPath.row];
    cell.itemModel = itemModel;
    CGFloat itemHeight = [(NSString *)itemModel.Value boundingRectWithSize:CGSizeMake((SCREENWIDTH-80), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height+15;
    cell.vConstraintHeight.constant = itemHeight;
       
    [cell setModel: cell.itemModel];
    return cell;
    
    
    
}

@end
