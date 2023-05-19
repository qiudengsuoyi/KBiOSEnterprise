//
//  GrabOrderDetailViewController.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/4/18.
//

#import "GrabDetailController.h"
#import "OrderItemTableViewCell.h"
#import "PictureCollectionViewCell.h"
#import "ResultController.h"
#import "SVProgressHUD.h"
#import "APIConst.h"
#import "EnterpriseMainService.h"
#import "NSObject+YYModel.h"
#import "TaskPictureController.h"

@interface GrabDetailController ()

@end

@implementation GrabDetailController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tbOrder.dataSource = self;
    self.tbOrder.delegate = self;
    [self addBackItem];
    self.navigationItem.title = @"抢单任务详情";
    // 1.设置行高为自动撑开
    self.tbOrder.rowHeight = UITableViewAutomaticDimension;
    self.tbOrder.allowsSelection = NO;
    //2.设置一个估计的行高，只要大于0就可以了，但是还是尽量要跟cell的高差不多
    self.tbOrder.estimatedRowHeight = 120;
    self.tbOrder.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tbOrder registerNib:[UINib nibWithNibName:NSStringFromClass([OrderItemTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([OrderItemTableViewCell class])];
    self.starView.currentScore = 0;
 
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [self requstOrderList];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.keyValueList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderItemTableViewCell class])];
    if (cell == nil) {
        cell = [[OrderItemTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])] ;
    }
  KeyValueEntity *itemModel = [self.keyValueList objectAtIndex:indexPath.row];
    cell.itemModel = itemModel;
    cell.itemModel = itemModel;
    CGFloat itemHeight = [(NSString *)itemModel.Value boundingRectWithSize:CGSizeMake((SCREENWIDTH-100), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height+15;
    cell.vConstraintHeight.constant = itemHeight;
       
    [cell setModel: cell.itemModel];
    return cell;
    
    
    
}



-(void)requstOrderList{
    [SVProgressHUD show];
    
 
        NSDictionary *dic = @{@"oid":self.recordID};
        [EnterpriseMainService requestGrabOrderItemDetail:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
            if (data) {
                NSMutableArray *arr = [NSMutableArray array];
                for (NSDictionary *dic in data[@"data"][@"listDetail"]) {
                    KeyValueEntity *model = [KeyValueEntity modelWithJSON:dic];
                    if (model) {
                        [arr addObject:model];
                    }
                }
                if([data[@"orderstate"] intValue] == 1){
                    self.vEvaluate.hidden = NO;
                }else{
                    self.vEvaluate.hidden = YES;
                }
                
                self.keyValueList = arr;
                CGFloat totalHeight = 0;
                for(KeyValueEntity * itemModel in self.keyValueList){
                    CGFloat itemHeight = [(NSString *)itemModel.Value boundingRectWithSize:CGSizeMake((SCREENWIDTH-120), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height+15;
                    totalHeight = totalHeight+itemHeight;
                }
                self.tbOrderConstraintHeight.constant = totalHeight;
                
                [self.tbOrder reloadData];
                
            }
        }];
            
}
 

-(void)evaluateSubmit{
    if(self.starView.currentScore<1){
        [SVProgressHUD showInfoWithStatus:@"请先选择星数再提交！"];
        return;
    }
        
    [SVProgressHUD show];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];
    
 
        NSDictionary *dic = @{@"userid":userID,
                              @"recordID":self.recordID,
                              @"Star":[NSString stringWithFormat:@"%.f",self.starView.currentScore]
        };
        [EnterpriseMainService requestGrabOrderEvaluate:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
            if (data) {
               
                [SVProgressHUD showSuccessWithStatus:data[@"msg"]];
                [self requstOrderList];
                
            }
        }];
            
}
    
- (IBAction)btEvaluate:(id)sender {
    [self evaluateSubmit];
}

- (IBAction)btPicture:(id)sender {
    TaskPictureController *vc = [[TaskPictureController alloc]init];
    vc.recordID = self.recordID;
    
    [self.navigationController pushViewController:vc animated:YES];
}









@end
