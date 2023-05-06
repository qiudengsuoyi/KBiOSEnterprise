//
//  NoPictureTableViewCell.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/5/16.
//

#import <UIKit/UIKit.h>
#import "KeyValueEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoImageTableViewCell : UITableViewCell
@property KeyValueEntity* itemModel;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vConstraintHeight;
-(void)setModel:(KeyValueEntity*)model;
@end

NS_ASSUME_NONNULL_END
