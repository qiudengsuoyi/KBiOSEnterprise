//
//  GrabOrderTableViewCell.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/6/28.
//

#import <UIKit/UIKit.h>
#import "KeyValueEntity.h"
#import "OrderListEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface GrabTaskTableViewCell :UITableViewCell<UITableViewDelegate,UITableViewDataSource>
@property NSMutableArray<KeyValueEntity*> * keyValueList;
@property (weak, nonatomic) IBOutlet UITableView *tbOrder;
-(void)setTableOrder;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellConstrainHeight;
@property NSString * recordID;
@property NSString * OrderState;
@property OrderListEntity * model;
@property (nonatomic, copy) void (^cancelBlock)(void);
@property (nonatomic, copy) void (^confirmBlock)(void);
@property (nonatomic, copy) void (^editBlock)(void);
@property (weak, nonatomic) IBOutlet UIButton *btEdit;

@property (weak, nonatomic) IBOutlet UIButton *bt01;
@property (weak, nonatomic) IBOutlet UIButton *bt02;
@property (weak, nonatomic) IBOutlet UIButton *bt03;


@end

NS_ASSUME_NONNULL_END
