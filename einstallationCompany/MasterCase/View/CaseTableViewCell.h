//
//  CaseTableViewCell.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2022/3/14.
//

#import <UIKit/UIKit.h>
#import "CaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CaseTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectHeight;
@property CaseModel *model;
-(void)setData:(CaseModel*)model;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelModify;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vHeight;
@property (nonatomic, copy) void (^confirmBlock)(void);
@end

NS_ASSUME_NONNULL_END
