//
//  NoticeTableViewCell.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/5/5.
//

#import "NoticeTableViewCell.h"

@implementation NoticeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setNotice:(NoticeEntity*)model{
    model = self.model;
  
    self.labelContent.text = model.title;
    self.labelTitle.text  = model.profile;
   

}
@end
