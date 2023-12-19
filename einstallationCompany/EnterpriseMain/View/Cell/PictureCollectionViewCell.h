//
//  PictureCollectionViewCell.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/4/23.
//

#import <UIKit/UIKit.h>
#import "PictureEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface PictureCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ivConstraintWidth;
@property (weak, nonatomic) IBOutlet UIImageView *iv;
@property PictureEntity * pictureModel;

-(void)setPicture;
-(void)setVideo;
@end

NS_ASSUME_NONNULL_END
