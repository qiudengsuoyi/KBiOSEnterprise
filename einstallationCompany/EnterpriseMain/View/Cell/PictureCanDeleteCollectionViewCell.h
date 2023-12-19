//
//  PictureCanDeleteCollectionViewCell.h
//  einstallationCompany
//
//  Created by 云位 on 2023/9/17.
//

#import <UIKit/UIKit.h>
#import "PictureEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface PictureCanDeleteCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ivConstraintWidth;
@property (weak, nonatomic) IBOutlet UIImageView *iv;
@property PictureEntity * pictureModel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

-(void)setPicture;
-(void)setVideo;
@end

NS_ASSUME_NONNULL_END
