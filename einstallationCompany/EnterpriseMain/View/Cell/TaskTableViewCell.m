//
//  TaskTableViewCell.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/6/8.
//

#import "TaskTableViewCell.h"

@implementation TaskTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setTableOrder{
    self.labelTitle.text = self.taskModel.Value;
    self.labelNum.text = [self.taskModel.num stringByAppendingString:@"条"];
}

@end
