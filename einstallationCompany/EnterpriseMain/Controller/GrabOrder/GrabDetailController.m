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
#import "PictureModel.h"
#import "VideoViewController.h"
#import "PictureCarouselViewController.h"
#import "GrabPictureViewController.h"

@interface GrabDetailController ()<UITextViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *   radio;
@property (weak, nonatomic) IBOutlet WSPlaceholderTextView *etAudit;
@property (weak, nonatomic) IBOutlet WSPlaceholderTextView *etEvalute;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightAudit;

@property (weak, nonatomic) IBOutlet WSPlaceholderTextView *etReason;
@property NSString * installState;
@property NSString * orderState;
@property NSMutableArray<PictureModel*> * arrImage;
@property NSMutableArray<PictureModel*> * arrVideo;
@property Boolean checkState;
@property NSString * projectID;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;


@end

@implementation GrabDetailController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.checkState = NO;
    self.projectID = @"0";
    self.etReason.placeholder = @"请填写取消安装理由";
    self.etEvalute.placeholder = @"请填写您评价内容";
    self.etAudit.placeholder = @"请填写不通过的理由";
    self.installState = @"0";
    [self.starView setCurrentScore:5];
    self.arrImage = [NSMutableArray array];
    self.arrVideo = [NSMutableArray array];
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
    [self initCollectionView:self.collectionImage];
    [self initCollectionView:self.collectionVideo];
    [self.collectionImage reloadData];
    [self.collectionVideo reloadData];
    // 设置正常状态下的文字颜色
        NSDictionary *normalTextAttributes = @{
            NSForegroundColorAttributeName: [UIColor blackColor], // 正常状态下的文字颜色
        };
        [self.radio setTitleTextAttributes:normalTextAttributes forState:UIControlStateNormal];
        
        // 设置选中状态下的文字颜色
        NSDictionary *selectedTextAttributes = @{
            NSForegroundColorAttributeName: [UIColor whiteColor], // 选中状态下的文字颜色
        };
        [self.radio setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];

}

- (void)viewWillAppear:(BOOL)animated{
    [self requstOrderList];
}

- (void)segmentedControlValueChanged:(UISegmentedControl *)sender {
    // 获取所选段的索引
    self.checkState = YES;
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
    CGFloat itemHeight = [(NSString *)itemModel.Value boundingRectWithSize:CGSizeMake((SCREENWIDTH-120), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height+15;
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
                self.projectID = data[@"projectid"];
                if(!self.checkState){
                    if([self.orderState isEqualToString:@"3"]){
                        self.installState = @"0";
                    }else{
                        self.installState = @"2";
                    }
                }
                
                if([self.orderState intValue] == 4){
                    self.topHeight.constant = 40;
                }
                
                if([self.orderState intValue] == 2 || [self.orderState intValue] == 3 ||[self.orderState intValue] == 4){
                    self.btPicture.hidden = NO;
                }else{
                    self.btPicture.hidden = YES;
                }
                
                [self.radio addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
                NSMutableArray *arr = [NSMutableArray array];
                for (NSDictionary *dic in data[@"listDetail"]) {
                    KeyValueEntity *model = [KeyValueEntity modelWithJSON:dic];
                    if (model) {
                        [arr addObject:model];
                    }
                }
                
                self.arrImage = [NSMutableArray new];
                for (NSDictionary *dic in data[@"imagsarr"]) {
                    PictureModel *model = [PictureModel modelWithJSON:dic];
                    if (model) {
                        [self.arrImage addObject:model];
                    }
                }
                if(self.arrImage.count == 0){
                    PictureModel *model
                    = [PictureModel alloc];
                    model.images = @"";
                    model.text = @"";
                    model.thumbnail = @"";
                    [self.arrImage addObject:model];
                }
                [self.collectionImage reloadData];
                
                
                self.arrVideo = [NSMutableArray new];
                for (NSDictionary *dic in data[@"videoarr"]) {
                    PictureModel *model = [PictureModel modelWithJSON:dic];
                    if (model) {
                        [self.arrVideo addObject:model];
                    }
                }
                if(self.arrVideo.count == 0){
                    PictureModel *model
                    = [PictureModel alloc];
                    model.images = @"";
                    model.text = @"";
                    model.thumbnail = @"";
                    [self.arrVideo addObject:model];
                }
                [self.collectionVideo reloadData];
                NSString *applyState  = data[@"appealstate"];
                
                
                if([applyState intValue] == 3 && [data[@"orderstate"] intValue] == 2){
                    self.vEvaluate.hidden = NO;
                }else{
                    self.vEvaluate.hidden = YES;
                }
                
              
            
                if([data[@"orderstate"] intValue] == 2){
                    if([applyState intValue] == 0){
                        self.vIssue.hidden = NO;
                    }else{
                        self.vIssue.hidden = YES;
                    }
                }else{
                    self.vIssue.hidden = YES;
                }

                
                self.keyValueList = arr;
                CGFloat totalHeight = 0;
                for(KeyValueEntity * itemModel in self.keyValueList){
                    CGFloat itemHeight = [(NSString *)itemModel.Value boundingRectWithSize:CGSizeMake((SCREENWIDTH-120), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height+15;
                    totalHeight = totalHeight+itemHeight;
                }
                
                self.collectionImageHeight.constant = ((SCREENWIDTH-100)/3*0.81+10)*ceil(self.arrImage.count/3.0);
                self.collectionVideoHeight.constant = ((SCREENWIDTH-100)/3*0.81+10)*ceil(self.arrVideo.count/3.0);
                self.tbOrderConstraintHeight.constant = totalHeight;
                self.viewConstraintHeight.constant = totalHeight+self.collectionImageHeight.constant+self.collectionVideoHeight.constant+120;
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
                              @"evaluateContent": [self utf82gbk:self.etEvalute.text],
                              @"AuditDetails": [self utf82gbk:self.etAudit.text]
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

- (IBAction)actionPicture:(id)sender {
    GrabPictureViewController *vc = [[GrabPictureViewController alloc]init];
    vc.recordID = self.projectID;
    
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)textViewDidChange:(WSPlaceholderTextView *)textView // 此处取巧，把代理方法参数类型直接改成自定义的WSTextView类型，为了可以使用自定义的placeholder属性，省去了通过给控制器WSTextView类型属性这样一步。
{
    if (textView.hasText) { // textView.text.length
        textView.placeholder = @"";
        
    }
}

- (void) initCollectionView:(UICollectionView *)collectionView
{
    //设置CollectionView的属性
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.scrollEnabled = YES;
    //    [self.view addSubview:self.collectionView];
    //注册Cell
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PictureCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"identifier"];

}



- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *identify = @"identifier";
    PictureCollectionViewCell *cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    NSInteger index;
    if(collectionView == self.collectionImage){
        index = indexPath.row + indexPath.section * 3;
            PictureModel *itemModelList = [self.arrImage objectAtIndex:index];
            cell.pictureModel = itemModelList;
            [cell setPicture];
    }else{
        index = indexPath.row + indexPath.section * 3;
            PictureModel *itemModelList = [self.arrVideo objectAtIndex:index];
            cell.pictureModel = itemModelList;
            [cell setVideo];
    }
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(collectionView == self.collectionImage){
        return self.arrImage.count;
    }else{
        return self.arrVideo.count;
    }
}

#pragma mark  设置CollectionView的组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
        return 1;
}

-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath
{
    return CGSizeMake((SCREENWIDTH-120)/3-1, (SCREENWIDTH-120)/3*0.81);//可以根据indexpath 设置item 的size
}

#pragma mark  定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 10, 0);//（上、左、下、右）
}

#pragma mark  点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == self.collectionImage){
        PictureCarouselViewController *vc = [PictureCarouselViewController alloc];
        vc.page = indexPath.section *3 + indexPath.row;
        NSMutableArray * arrImage = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray * arrThumbnail = [NSMutableArray arrayWithCapacity:0];
        
        arrImage = [NSMutableArray arrayWithCapacity:0];
        arrThumbnail = [NSMutableArray arrayWithCapacity:0];
        for(PictureModel * item in self.arrImage){
            [arrImage addObject:item.images];
            [arrThumbnail addObject:item.thumbnail];
        }
        
        
        vc.arrImage = arrImage ;
        vc.arrThumbnail = arrThumbnail ;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        VideoViewController *vc = [VideoViewController alloc];
        PictureModel * model = [self.arrVideo objectAtIndex:indexPath.section *3 + indexPath.row];
        vc.videoURL = model.images;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

#pragma mark  设置CollectionViewCell是否可以被点击
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//取消选中操作
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}



@end
