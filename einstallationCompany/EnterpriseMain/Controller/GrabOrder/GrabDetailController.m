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

@interface GrabDetailController ()

@end

@implementation GrabDetailController
- (IBAction)actionConfirm:(id)sender {
    ResultController * vc = [ResultController alloc];
    vc.resultType = 1;
    vc.strTitle = @"成功参与抢单";
    vc.strContent01 = @"恭喜您已经成功参与抢单";
    vc.strContent02 = @"请保持电话畅通等待客户和您进一步沟通";
    [self jumpViewControllerAndCloseSelf:vc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tbOrder.dataSource = self;
    self.tbOrder.delegate = self;
    if(self.pageType  == 2){
        self.btConfirm.hidden = YES;
    }
    [self addBackItem];
    self.navigationItem.title = @"抢单任务详情";
    // 1.设置行高为自动撑开
    self.tbOrder.rowHeight = UITableViewAutomaticDimension;
    self.tbOrder.allowsSelection = NO;
    //2.设置一个估计的行高，只要大于0就可以了，但是还是尽量要跟cell的高差不多
    self.tbOrder.estimatedRowHeight = 120;
    self.tbOrder.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tbOrder registerNib:[UINib nibWithNibName:NSStringFromClass([OrderItemTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([OrderItemTableViewCell class])];
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
   
    for(int i = 0;i<2;i++){
      
        KeyValueEntity * keyValueModel = [KeyValueEntity alloc];
        keyValueModel.PictureURL = @"";
        keyValueModel.Value = @"商场海报安装";
        keyValueModel.Color = @"#000000";
        [arr addObject:keyValueModel];
        keyValueModel = [KeyValueEntity alloc];
        keyValueModel.PictureURL = @"";
        keyValueModel.Value = @"商场海报安装商场海报安装商场海报安装商场海报安装商场海报安装商场海报安装商场海报安装";
        keyValueModel.Color = @"#7D7D7D";
        [arr addObject:keyValueModel];
        keyValueModel = [KeyValueEntity alloc];
        keyValueModel.PictureURL = @"";
        keyValueModel.Value = @"商场海报安装";
        keyValueModel.Color = @"#5586DE";
        [arr addObject:keyValueModel];

    
    }
    CGFloat totalHeight = 0;
    for(KeyValueEntity * itemModel in arr){
        CGFloat itemHeight = [(NSString *)itemModel.Value boundingRectWithSize:CGSizeMake((SCREENWIDTH-100), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height+15;
        totalHeight = totalHeight+itemHeight;
    }
    self.tbOrderConstraintHeight.constant = totalHeight;
    self.vConstraintHeight.constant = totalHeight+80+(SCREENWIDTH-90)/3*0.81*2+35;
    self.keyValueList = arr;
    [self.tbOrder reloadData];
    
    [self initCollectionView];
    [self.collectionView reloadData];
    // Do any additional setup after loading the view from its nib.
}

- (void) initCollectionView
{
    //设置CollectionView的属性
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = YES;
    //    [self.view addSubview:self.collectionView];
    //注册Cell
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PictureCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"identifier"];

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



- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *identify = @"identifier";
    PictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    cell.layer.cornerRadius = 4;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

#pragma mark  设置CollectionView的组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath
{
    return CGSizeMake((SCREENWIDTH-100)/3, (SCREENWIDTH-90)/3*0.81);//可以根据indexpath 设置item 的size
}

#pragma mark  定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 10, 0);//（上、左、下、右）
}

#pragma mark  点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    

    PictureCollectionViewCell *cell = (PictureCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];

    
    
    
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
