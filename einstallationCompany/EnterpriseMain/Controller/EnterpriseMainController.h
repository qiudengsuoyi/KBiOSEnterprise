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
#import "MainNumEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface EnterpriseMainController : EnterpriseBaseController
@property (weak, nonatomic) IBOutlet UIView *view01;
@property (weak, nonatomic) IBOutlet UIView *vCircle01;
@property (weak, nonatomic) IBOutlet UIView *vCircle02;
@property (weak, nonatomic) IBOutlet UIView *vCircle03;
@property (weak, nonatomic) IBOutlet UIView *vNotice01;
@property (weak, nonatomic) IBOutlet UIView *vNotice02;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle01;
@property (weak, nonatomic) IBOutlet UILabel *labelContent01;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle02;
@property (weak, nonatomic) IBOutlet UILabel *labelContent02;



@property MainNumEntity * mainNumModel;
@end

NS_ASSUME_NONNULL_END
