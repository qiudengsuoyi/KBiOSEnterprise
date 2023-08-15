//
//  ApproveViewController.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/5/16.
//

#import "ApproveViewController.h"
#import "ItemClassOneTableViewCell.h"
#import "WalletListViewController.h"
#import "SVProgressHUD.h"
#import "APIConst.h"
#import "EnterpriseWalletService.h"
#import "UITableView+Refresh.h"
#import "YYLrefresh/UITableView+Refresh.h"
#import "UITableView+Refresh.h"
#import "UIView+RefreshData.h"
#import "YYKit.h"

@interface ApproveViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *fSearch;
@property (weak, nonatomic) IBOutlet UILabel *labelMoneyTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelMoney;


@end

@implementation ApproveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackItem];
    NSMutableArray *arrList = [NSMutableArray arrayWithCapacity:0];
    self.navigationItem.title = self.strTitle;
    
    self.labelMoneyTitle.text = self.strTitle;
    self.labelMoney.text = self.strMoney;
    
    self.muKeyValueList = arrList;
    
    self.tbList.dataSource = self;
    self.tbList.delegate = self;
    // 1.设置行高为自动撑开
    self.tbList.rowHeight = UITableViewAutomaticDimension;
    self.tbList.allowsSelection = NO;
    //2.设置一个估计的行高，只要大于0就可以了，但是还是尽量要跟cell的高差不多
    self.tbList.estimatedRowHeight = 120;
    self.tbList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tbList registerNib:[UINib nibWithNibName:NSStringFromClass([ItemClassOneTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ItemClassOneTableViewCell class])];
    self.tbList.allowsSelection = YES;
    [self.tbList reloadData];
    [self requstOrderList:true];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)requstOrderList:(BOOL)refresh{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];
    if(self.pageType == 1){
        [SVProgressHUD show];
        NSDictionary *dic = @{@"userid":userID,
                              @"searchStr":[self utf82gbk:self.fSearch.text]};
        [EnterpriseWalletService requestRechargeOrderList:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
            if (data) {
                
                NSMutableArray *arr = [NSMutableArray array];
               
                    for (NSDictionary *dic in data) {
                        OrderListEntity *model = [OrderListEntity
                                                  modelWithJSON:dic];
                        if (model) {
                            [arr addObject:model];
                        }
                    }
                
           
                
                if (error) {
                    self.view.loadErrorType = [error integerValue];
                    return ;
                }
                if (refresh) {
                    [self.muKeyValueList removeAllObjects];
                }
                OrderListEntity *model = [arr lastObject];
                if (model) {
                    [self.muKeyValueList addObjectsFromArray:arr];
                }
                if (self.muKeyValueList.count == 0) {
                    self.view.loadErrorType = YYLLoadErrorTypeNoData;
                }else{
                    
                    self.view.loadErrorType = YYLLoadErrorTypeDefalt;
                    
                }
                [self.tbList reloadData];
            }
        }];}else if(self.pageType == 2){
            
            [SVProgressHUD show];
            NSDictionary *dic = @{@"userid":userID,
                                  @"searchStr":[self utf82gbk:self.fSearch.text]
                                  
            };
            [EnterpriseWalletService requestCostOrderList:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
                if (data) {
                    NSMutableArray *arr = [NSMutableArray array];
                    for (NSDictionary *dic in data) {
                        OrderListEntity *model = [OrderListEntity
                                                  modelWithJSON:dic];
                        if (model) {
                            [arr addObject:model];
                        }
                    }
                    
                    
                    if (error) {
                        self.view.loadErrorType = [error integerValue];
                        return ;
                    }
                    if (refresh) {
                        [self.muKeyValueList removeAllObjects];
                    }
                    OrderListEntity *model = [arr lastObject];
                    if (model) {
                        
                        [self.muKeyValueList addObjectsFromArray:arr];
                    }
                    if (self.muKeyValueList.count == 0) {
                        self.view.loadErrorType = YYLLoadErrorTypeNoData;
                    }else{
                        
                        self.view.loadErrorType = YYLLoadErrorTypeDefalt;
                        
                    }
                    [self.tbList reloadData];
                    
                }
            }];
        }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
   
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.muKeyValueList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ItemClassOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ItemClassOneTableViewCell class])];
    if (cell == nil) {
        cell = [[ItemClassOneTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])] ;
    }
    OrderListEntity * itemModelList = [self.muKeyValueList objectAtIndex:indexPath.row];
    cell.keyValueList = itemModelList.resultarr;
    if(itemModelList.clickVisible){
        cell.ivClick.hidden = NO;
    }else{
        cell.ivClick.hidden = YES;
    }
    CGFloat itemHeight;
    CGFloat totalHeight = 0;
    for (KeyValueEntity *itemModel in itemModelList.resultarr) {
        itemHeight = [(NSString *)itemModel.Value boundingRectWithSize:CGSizeMake((SCREENWIDTH-180), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height+15;
        totalHeight = totalHeight+itemHeight;
    }
    cell.cellConstrainHeight.constant = totalHeight+15;
    [cell setTableOrder];
    return cell;
    
    
    
}




@end
