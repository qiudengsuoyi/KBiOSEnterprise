//
//  BrandTableViewCell.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/6/8.
//

#import "BrandTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation BrandTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
-(void)setBrand{
    NSURL *imageUrl = [NSURL URLWithString:self.model.PictureURL];
//        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    [self.ivLogo sd_setImageWithURL:imageUrl];
//        self.ivLogo.image = image;
    self.labelTitle.text = self.model.Value;
}
@end
