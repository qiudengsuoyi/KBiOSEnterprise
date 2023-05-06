//
//  OrderItemTableViewCell.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/4/23.
//

#import <UIKit/UIKit.h>
#import "KeyValueEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderItemTableViewCell : UITableViewCell
@property KeyValueEntity* itemModel;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;
@property (weak, nonatomic) IBOutlet UIImageView *ivTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vConstraintHeight;
@property (weak, nonatomic) IBOutlet UILabel *labelContentHint;
-(void)setModel:(KeyValueEntity*)model;
@end

NS_ASSUME_NONNULL_END
