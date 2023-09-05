//
//  ListBaseCell.h
//  einstallationCompany
//
//  Created by 云位 on 2023/8/17.
//

#import <UIKit/UIKit.h>
#import "KeyValueEntity.h"
#import "OrderListEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface ListBaseCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tbOrder;
-(void)setTableOrder;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellConstrainHeight;
@property OrderListEntity*orderList;
@end

NS_ASSUME_NONNULL_END
