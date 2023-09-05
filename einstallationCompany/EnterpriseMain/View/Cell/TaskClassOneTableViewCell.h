//
//  OrderNOPictureTableViewCell.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/5/24.
//

#import <UIKit/UIKit.h>
#import "KeyValueEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface TaskClassOneTableViewCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>
@property NSMutableArray<KeyValueEntity*> * keyValueList;
@property (weak, nonatomic) IBOutlet UITableView *tbOrder;
-(void)setTableOrder;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellConstrainHeight;
@property (weak, nonatomic) IBOutlet UILabel *labelCase;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *tvEvaluate;

@property (nonatomic, copy) void (^confirmBlock)(void);
@property (nonatomic, copy) void (^caseBlock)(void);
@property (nonatomic, copy) void (^evaluateBlock)(void);
@end

NS_ASSUME_NONNULL_END
