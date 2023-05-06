//
//  PayOrderTableViewCell.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/8/23.
//

#import "PayOrderTableViewCell.h"

@implementation PayOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel{
    self.labelContent.text = self.strContent;
}

@end
