//
//  BrandTableViewCell.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/6/8.
//

#import <UIKit/UIKit.h>
#import "KeyValueEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface BrandTableViewCell : UITableViewCell
@property KeyValueEntity* model;
@property (weak, nonatomic) IBOutlet UIImageView *ivLogo;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
-(void)setBrand;
@end

NS_ASSUME_NONNULL_END
