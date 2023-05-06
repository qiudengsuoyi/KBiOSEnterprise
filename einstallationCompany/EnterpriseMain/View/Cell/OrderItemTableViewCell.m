//
//  OrderItemTableViewCell.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/4/23.
//

#import "OrderItemTableViewCell.h"
#import <YYKit/YYKit.h>
#import "UIImageView+WebCache.h"

@implementation OrderItemTableViewCell

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
   
    NSURL *imageUrl = [NSURL URLWithString:model.PictureURL];
    [self.ivTitle sd_setImageWithURL:imageUrl];
//        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
//        self.ivTitle.image = image;
    self.labelContent.text = model.Value;
    self.labelContent.textColor = [UIColor colorWithHexString:self.itemModel.Color];
    if([model.State intValue] ==1){
        self.labelContentHint.text = model.ValueHint;
        self.labelContentHint.hidden = NO;
    }else{
        self.labelContentHint.hidden = YES;
    }

}
@end
