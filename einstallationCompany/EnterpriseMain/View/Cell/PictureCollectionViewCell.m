//
//  PictureCollectionViewCell.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/4/23.
//

#import "PictureCollectionViewCell.h"
#import <SDWebImage/SDWebImage.h>

@implementation PictureCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
 
}

-(void)setPicture{
    [self.iv sd_setImageWithURL:[NSURL URLWithString:self.pictureModel.thumbnail]
                 placeholderImage:[UIImage imageNamed:@"picture_occupy.png"]];
    
    
 
}





@end
