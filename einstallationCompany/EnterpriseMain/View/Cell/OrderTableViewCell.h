//
//  OrderTableViewCell.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/4/23.
//

#import <UIKit/UIKit.h>
#import "KeyValueEntity.h"
#import "OrderListEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderTableViewCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>
@property NSMutableArray<KeyValueEntity*> * keyValueList;
@property (weak, nonatomic) IBOutlet UITableView *tbOrder;
-(void)setTableOrder;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellConstrainHeight;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property OrderListEntity*orderList;
@property (weak, nonatomic) IBOutlet UILabel *labelState;

@end

NS_ASSUME_NONNULL_END
