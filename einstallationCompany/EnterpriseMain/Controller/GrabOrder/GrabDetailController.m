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
#import "WSPlaceholderTextView.h"
#import "UIView+Extension.h"

@interface GrabDetailController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *radio;
@property (weak, nonatomic) IBOutlet WSPlaceholderTextView *etAudit;
@property (weak, nonatomic) IBOutlet WSPlaceholderTextView *etEvalute;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightAudit;

@property (weak, nonatomic) IBOutlet WSPlaceholderTextView *etReason;
@property NSString * installState;
@property NSString * orderState;

@end

@implementation GrabDetailController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.etReason.placeholder = @"请填写安装不通过理由";
    self.etEvalute.placeholder = @"请填写您评价内容";
    self.etAudit.placeholder = @"请填写不通过的理由";
    self.installState = @"0";
    [self.starView setCurrentScore:5];
  
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

    if (@available(iOS 13.0, *)) {
//        self.radio.selectedSegmentTintColor = [UIColor blackColor];
    } else {
        // Fallback on earlier versions
    }
  
//    self.etReason.backgroundColor = [UIColor whiteColor];
    self.etReason.layer.borderWidth = 0.5;
    self.etReason.layer.borderColor = [UIColor grayColor].CGColor;
    self.etReason.delegate = self;
    
    self.etEvalute.layer.borderWidth = 0.5;
    self.etEvalute.layer.borderColor = [UIColor grayColor].CGColor;
    self.etEvalute.delegate = self;
    
    self.etAudit.layer.borderWidth = 0.5;
    self.etAudit.layer.borderColor = [UIColor grayColor].CGColor;
    self.etAudit.hidden = YES;
    self.etAudit.delegate = self;
    self.heightAudit.constant = 1.0f;
    // Do any additional setup after loading the view from its nib.
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];

}

- (void)viewWillAppear:(BOOL)animated{
    [self requstOrderList];
}

- (void)segmentedControlValueChanged:(UISegmentedControl *)sender {
    // 获取所选段的索引
    NSInteger selectedIndex = sender.selectedSegmentIndex;
    if(selectedIndex == 0){
        self.heightAudit.constant = 1.0f;
        self.etAudit.hidden = YES;
        if([self.orderState isEqualToString:@"3"]){
            self.installState = @"0";
        }else{
            self.installState = @"2";
        }
    }else{
        self.heightAudit.constant = 60.0f;
        self.etAudit.hidden = NO;
        if([self.orderState isEqualToString:@"3"]){
            self.installState = @"1";
        }else{
            self.installState = @"4";
        }
    }
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
                self.orderState = data[@"orderstate"];
                [self.radio addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
                NSMutableArray *arr = [NSMutableArray array];
                for (NSDictionary *dic in data[@"listDetail"]) {
                    KeyValueEntity *model = [KeyValueEntity modelWithJSON:dic];
                    if (model) {
                        [arr addObject:model];
                    }
                }
                NSString *applyState  = data[@"appealstate"];
            
                if([data[@"orderstate"] intValue] == 2){
                    if([applyState intValue] == 3){
                        self.vEvaluate.hidden = NO;
                        self.vIssue.hidden = YES;
                    }else{
                        self.vEvaluate.hidden = YES;
                        self.vIssue.hidden = NO;
                    }
                }else{
                    self.vEvaluate.hidden = NO;
                    self.vIssue.hidden = YES;
                }
                
                if([data[@"orderstate"] intValue] == 3){
                    if([applyState intValue] == 2){
                        self.vEvaluate.hidden = YES;
                    }else{
                        self.vEvaluate.hidden = NO;
                    }
                }
                
                if([data[@"orderstate"] intValue] == 4){
                    if([applyState intValue] == 0){
                        self.vEvaluate.hidden = YES;
                    }
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
                              @"Star":[NSString stringWithFormat:@"%.f",self.starView.currentScore],
                              @"installstate":self.installState,
                              @"evaluateContent": [self utf82gbk:self.etEvalute.text]
        };
        [EnterpriseMainService requestGrabOrderEvaluate:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
            if (data) {
               
                [SVProgressHUD showSuccessWithStatus:data[@"msg"]];
                [self requstOrderList];
                
            }
        }];
            
}


-(void)auditSubmit{

        
    [SVProgressHUD show];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];
    
 
        NSDictionary *dic = @{@"userid":userID,
                              @"recordID":self.recordID,
                              @"examineState":self.installState
        };
        [EnterpriseMainService requestGrabOrderIssue:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
            if (data) {
               
                [SVProgressHUD showSuccessWithStatus:data];
                [self.navigationController popViewControllerAnimated:YES];
                
            }
        }];
            
}
- (IBAction)btIssue:(id)sender {
    if(self.etReason.text.length<1){
        [SVProgressHUD showInfoWithStatus:@"请填写安装不通过理由！"];
        return;
    }
    [SVProgressHUD show];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];
    
 
        NSDictionary *dic = @{@"userid":userID,
                              @"recordID":self.recordID,
                              @"appealReason":[self utf82gbk: self.etReason.text]
        };
        [EnterpriseMainService requestIssue:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
            if (data) {
               
                [self requstOrderList];
                
            }
        }];
}

- (IBAction)btEvaluate:(id)sender {
   
    if([self.orderState isEqualToString:@"3"]){
        if(self.etAudit.text.length<1 && [self.installState isEqualToString:@"1"]){
            [SVProgressHUD showInfoWithStatus:@"请填写申请理由！"];
            return;
        }
        [self auditSubmit];
    }else{
        [self evaluateSubmit];
    }

}

- (IBAction)btPicture:(id)sender {
    TaskPictureController *vc = [[TaskPictureController alloc]init];
    vc.recordID = self.recordID;
    
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)textViewDidChange:(WSPlaceholderTextView *)textView // 此处取巧，把代理方法参数类型直接改成自定义的WSTextView类型，为了可以使用自定义的placeholder属性，省去了通过给控制器WSTextView类型属性这样一步。
{
    if (textView.hasText) { // textView.text.length
        textView.placeholder = @"";
        
    }
}







@end
