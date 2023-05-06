//
//  ComplainTableViewCell.h
//  einstallationCompany
//
//  Created by 云位 on 2022/9/9.
//

#import <UIKit/UIKit.h>
#import "KeyValueEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface ComplainTableViewCell : UITableViewCell
@property KeyValueEntity* itemModel;
@property (weak, nonatomic) IBOutlet UILabel *labelKey;
@property (weak, nonatomic) IBOutlet UILabel *labelValue;
-(void)setModel:(KeyValueEntity*)model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vheight;
@end

NS_ASSUME_NONNULL_END
