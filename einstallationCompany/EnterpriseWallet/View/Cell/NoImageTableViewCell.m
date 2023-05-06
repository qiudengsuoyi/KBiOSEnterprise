//
//  NoPictureTableViewCell.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/5/16.
//

#import "NoImageTableViewCell.h"
#import <YYKit/YYKit.h>

@implementation NoImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(KeyValueEntity*)model{
    model = self.itemModel;

    self.labelContent.text = model.Value;
    self.labelContent.textColor = [UIColor colorWithHexString:self.itemModel.Color];
   
    if([model.State intValue] ==1){
        self.labelContent.font = [UIFont systemFontOfSize:12];
    }
   

}

@end
