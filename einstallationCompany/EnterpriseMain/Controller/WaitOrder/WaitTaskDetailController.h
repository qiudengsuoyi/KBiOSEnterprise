//
//                       _oo0oo_
//                      o8888888o
//                      88" . "88
//                      (| -_- |)
//                      0\  =  /0
//                    ___/`---'\___
//                  .' \\|     |// '.
//                 / \\|||  :  |||// \
//                / _||||| -:- |||||- \
//               |   | \\\  -  /// |   |
//               | \_|  ''\---/''  |_/ |
//               \  .-\__  '-'  ___/-. /
//             ___'. .'  /--.--\  `. .'___
//          ."" '<  `.___\_<|>_/___.' >' "".
//         | | :  `- \`.;`\ _ /`;.`/ - ` : | |
//         \  \ `_.   \_ __\ /__ _/   .-` /  /
//     =====`-.____`.___ \_____/___.-`___.-'=====
//                       `=---='
//
//
//     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
//               佛祖保佑         永无BUG
//
//
//


#import "EnterpriseBaseController.h"
#import "KeyValueEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface WaitTaskDetailController : EnterpriseBaseController
<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tbOrder;
@property (weak, nonatomic) IBOutlet UITableView *tbDetail;
@property (weak, nonatomic) IBOutlet UITableView *tbComplain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vComplainHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tbComplainHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vConstraintHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tbOrderConstraintHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tbDetailHeight;
@property NSMutableArray <KeyValueEntity*> * keyValueList;
@property NSMutableArray <KeyValueEntity*> * keyValueDetaliList;
@property NSMutableArray <KeyValueEntity*> * keyValueComplainList;
@property NSInteger pageType;
@property NSString* recordID;
@end

NS_ASSUME_NONNULL_END
