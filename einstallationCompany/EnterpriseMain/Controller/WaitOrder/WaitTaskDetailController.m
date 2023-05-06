//
//  WaitOrderDetailViewController.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/4/24.
//

#import "WaitTaskDetailController.h"
#import "OrderItemTableViewCell.h"
#import "TaskPictureController.h"
#import "EnterpriseMainService.h"
#import "SVProgressHUD.h"
#import "APIConst.h"
#import "OrderListEntity.h"
#import "NSObject+YYModel.h"
#import "TaskDetailTableViewCell.h"
#import "ComplainTableViewCell.h"
#import "DialogOneView.h"
#import "UIView+Extension.h"
#import "WSPlaceholderTextView.h"
#import "ComplainModifyViewController.h"

@interface WaitTaskDetailController ()
@property (weak, nonatomic) IBOutlet UIImageView *ivDetail;

@property (weak, nonatomic) IBOutlet WSPlaceholderTextView *etComplain;

@end

@implementation WaitTaskDetailController

- (void)viewWillAppear:(BOOL)animated{
    [self requstOrderList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.etComplain.placeholder = @"请输入投诉信息";
    self.tbOrder.dataSource = self;
    self.tbOrder.delegate = self;
    
    self.tbDetail.dataSource = self;
    self.tbDetail.delegate = self;
    
    self.tbComplain.dataSource = self;
    self.tbComplain.delegate = self;
    
    [self addBackItem];
    if (self.pageType == 1){
        self.navigationItem.title = @"待接受任务详情";
        
    }else{
        self.navigationItem.title = @"任务详情";
    }
    // 1.设置行高为自动撑开
    self.tbOrder.rowHeight = UITableViewAutomaticDimension;
    self.tbOrder.allowsSelection = NO;
    //2.设置一个估计的行高，只要大于0就可以了，但是还是尽量要跟cell的高差不多
    self.tbOrder.estimatedRowHeight = 120;
    self.tbOrder.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tbOrder registerNib:[UINib nibWithNibName:NSStringFromClass([OrderItemTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([OrderItemTableViewCell class])];
    
    // 1.设置行高为自动撑开
    self.tbDetail.rowHeight = UITableViewAutomaticDimension;
    self.tbDetail.allowsSelection = NO;
    //2.设置一个估计的行高，只要大于0就可以了，但是还是尽量要跟cell的高差不多
    self.tbDetail.estimatedRowHeight = 120;
    self.tbDetail.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tbDetail registerNib:[UINib nibWithNibName:NSStringFromClass([TaskDetailTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TaskDetailTableViewCell class])];
    
    // 1.设置行高为自动撑开
    self.tbComplain.rowHeight = UITableViewAutomaticDimension;
    self.tbComplain.allowsSelection = YES;
    //2.设置一个估计的行高，只要大于0就可以了，但是还是尽量要跟cell的高差不多
    self.tbComplain.estimatedRowHeight = 120;
    self.tbComplain.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tbComplain registerNib:[UINib nibWithNibName:NSStringFromClass([ComplainTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ComplainTableViewCell class])];
    
    self.keyValueList = [NSMutableArray arrayWithCapacity:0];
    self.keyValueDetaliList = [NSMutableArray arrayWithCapacity:0];
    self.keyValueComplainList = [NSMutableArray arrayWithCapacity:0];
    [self.tbOrder reloadData];
    
    if(!(self.pageType == 1)){
        self.etComplain.layer.borderWidth = 0.5;
        self.etComplain.layer.borderColor = [UIColor grayColor].CGColor;
      
    }
        
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)actionComplain:(id)sender {
    if(self.etComplain.text.length<1){
        [SVProgressHUD showErrorWithStatus:@"请输入投诉信息"];
        return;
    }
    NSDictionary *dic = @{
        @"p_id":self.recordID,
        @"ComplaintContent":[self utf82gbk:self.etComplain.text]
    };
    [EnterpriseMainService requestComplain:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
        if (data) {
            if([data[@"code"] intValue] == 1){
                [self showOneDialogView:data[@"msg"] withRightButtonTitle:@"确定"];
            }
        }
    }];
}

- (IBAction)actionPicture:(id)sender {
    
    TaskPictureController *vc = [[TaskPictureController alloc]init];
    vc.recordID = self.recordID;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.tbComplain){
        ComplainModifyViewController *vc = [[ComplainModifyViewController alloc]init];
        vc.complainID = [self.keyValueComplainList objectAtIndex:indexPath.row].ModelID;
        vc.complainContent = [self.keyValueComplainList objectAtIndex:indexPath.row].Value;
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.tbOrder){
        
        return self.keyValueList.count;
        
    }else if(tableView == self.tbDetail){
        return self.keyValueDetaliList.count;
    }else{
        return self.keyValueComplainList.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.tbOrder){
        
        OrderItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderItemTableViewCell class])];
        if (cell == nil) {
            cell = [[OrderItemTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])] ;
        }
        KeyValueEntity *itemModel = [self.keyValueList objectAtIndex:indexPath.row];
        
        cell.itemModel = itemModel;
        CGFloat itemHeight = [(NSString *)itemModel.Value boundingRectWithSize:CGSizeMake((SCREENWIDTH-120), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height+15;
        cell.vConstraintHeight.constant = itemHeight;
        
        [cell setModel: cell.itemModel];
        return cell;
        
    }else if(tableView == self.tbDetail){
            TaskDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TaskDetailTableViewCell class])];
            if (cell == nil) {
                cell = [[TaskDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])] ;
            }
            KeyValueEntity *itemModel = [self.keyValueDetaliList objectAtIndex:indexPath.row];
            
            cell.itemModel = itemModel;
        CGFloat itemHeight = [(NSString *)itemModel.Value boundingRectWithSize:CGSizeMake((SCREENWIDTH-140), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height+15;
        cell.vheight.constant = itemHeight;
            
            [cell setModel: cell.itemModel];
            return cell;
            
    }else{
        ComplainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ComplainTableViewCell class])];
        if (cell == nil) {
            cell = [[ComplainTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])] ;
        }
        KeyValueEntity *itemModel = [self.keyValueComplainList objectAtIndex:indexPath.row];
        
        cell.itemModel = itemModel;
    CGFloat itemHeight = [(NSString *)itemModel.Value boundingRectWithSize:CGSizeMake((SCREENWIDTH-100), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height+45;
    cell.vheight.constant = itemHeight;
        
        [cell setModel: cell.itemModel];
        return cell;
    }
    
    
    
}


-(void)requstOrderList{
    [SVProgressHUD show];
    
    if(self.pageType == 1){
        NSDictionary *dic = @{@"recordID":self.recordID};
        [EnterpriseMainService requestWaitOrderItemDetail:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
            if (data) {
                self.keyValueList = data;
                CGFloat totalHeight = 0;
                for(KeyValueEntity * itemModel in self.keyValueList){
                    CGFloat itemHeight = [(NSString *)itemModel.Value boundingRectWithSize:CGSizeMake((SCREENWIDTH-120), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height+15;
                    totalHeight = totalHeight+itemHeight;
                }
                self.tbOrderConstraintHeight.constant = totalHeight;
                self.vConstraintHeight.constant = totalHeight+30;
                [self.tbOrder reloadData];
                
            }
        }];}else{
            
            
            NSDictionary *dic = @{@"p_id":self.recordID};
            [EnterpriseMainService requestInstallOrderItemDetail:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
                if (data) {
                    NSMutableArray *arr = [NSMutableArray array];
                    for (NSDictionary *dic in data[@"data"][@"listDetail"]) {
                        KeyValueEntity *model = [KeyValueEntity modelWithJSON:dic];
                        if (model) {
                            [arr addObject:model];
                        }
                    }
                    
                    NSMutableArray *arrDetail = [NSMutableArray array];
                    for (NSDictionary *dic in data[@"data"][@"listRequire"][@"orderRequire"]) {
                        KeyValueEntity *model = [KeyValueEntity alloc];
                        model.Key = dic[@"title"];
                        model.Value = dic[@"value"];
                        [arrDetail addObject:model];
                        
                    }
                    
                    NSMutableArray *arrComplain = [NSMutableArray array];
                    for (NSDictionary *dic in data[@"ComplaintList"][@"Complaint"]) {
                        KeyValueEntity *model = [KeyValueEntity alloc];
                        model.Key = dic[@"ComplaintDate"];
                        model.Value = dic[@"ComplaintContent"];
                        model.ModelID = dic[@"cid"];
                        if (model) {
                            [arrComplain addObject:model];
                        }
                    }
                    
                    NSURL *imageUrl = [NSURL URLWithString:data[@"data"][@"listRequire"][@"icon"]];
                        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
                        self.ivDetail.image = image;
                    
                    self.keyValueDetaliList = arrDetail;
                    
                    
                    self.keyValueList = arr;
                    self.keyValueComplainList = arrComplain;
                    
                    
                    CGFloat totalHeight = 0;
                    CGFloat tbDetailHeight = 0;
                    CGFloat tbComplainHeight = 0;
                    for(KeyValueEntity * itemModel in self.keyValueList){
                        CGFloat itemHeight = [(NSString *)itemModel.Value boundingRectWithSize:CGSizeMake((SCREENWIDTH-120), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height+15;
                        totalHeight = totalHeight+itemHeight;
                    }
                    
                    self.tbOrderConstraintHeight.constant = totalHeight;
                    
                    for(KeyValueEntity * itemModel in self.keyValueDetaliList){
                        CGFloat itemHeight = [(NSString *)itemModel.Value boundingRectWithSize:CGSizeMake((SCREENWIDTH-140), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height+15;
                        tbDetailHeight = tbDetailHeight+itemHeight;
                    }
                    self.tbDetailHeight.constant = tbDetailHeight;
                    
                    
                    for(KeyValueEntity * itemModel in self.keyValueComplainList){
                        CGFloat itemHeight = [(NSString *)itemModel.Value boundingRectWithSize:CGSizeMake((SCREENWIDTH-140), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height+50;
                        tbComplainHeight = tbComplainHeight+itemHeight;
                    }
                    self.tbComplainHeight.constant = tbComplainHeight;
                    self.vComplainHeight.constant = tbComplainHeight+190;
                    self.vConstraintHeight.constant = totalHeight+tbDetailHeight+30;
                    [self.tbOrder reloadData];
                    [self.tbDetail reloadData];
                    [self.tbComplain reloadData];
                }
            }];
        }
    
    
}

- (void)showOneDialogView:(NSString *) strContent withRightButtonTitle:(NSString *) strRightButtonName{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    DialogOneView *view = [DialogOneView LoadView_FromXib];
    view.frame = window.frame;
    view.laContent.text = strContent;
    [view.btRight setTitle:strRightButtonName forState:UIControlStateNormal];
    CGFloat itemHeight = [(NSString *)strContent boundingRectWithSize:CGSizeMake((SCREENWIDTH-80), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    view.constraintViewHeight.constant = 220+itemHeight;
    __weak typeof(view) weakView = view;
    view.confirmBlock  = ^{
        [self requstOrderList];
        [weakView removeFromSuperview];
    };
    
    [window addSubview:view];
}

@end
