//
//  TaskViewController.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/5/10.
//

#import "TaskPictureController.h"
#import "PictureCollectionViewCell.h"
#import "EnterpriseMainService.h"
#import "SVProgressHUD.h"
#import "APIConst.h"
#import "PictureCarouselViewController.h"

@interface TaskPictureController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collection01;
@property (weak, nonatomic) IBOutlet UICollectionView *collection02;
@property (weak, nonatomic) IBOutlet UICollectionView *collection03;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cHeightConstraint01;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cHeightConstraint02;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cHeightConstraint03;

@end

@implementation TaskPictureController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackItem];
    self.navigationItem.title = @"任务图片";
    [self requstOrderPicture];
    [self initCollectionView:self.collection01];
    [self initCollectionView:self.collection02];
    [self initCollectionView:self.collection03];
    [self.collection01 reloadData];
    [self.collection02 reloadData];
    [self.collection03 reloadData];
    // Do any additional setup after loading the view from its nib.
}

- (void) initCollectionView:(UICollectionView *)collectionView
{
    //设置CollectionView的属性
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.scrollEnabled = NO;
    //    [self.view addSubview:self.collectionView];
    //注册Cell
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PictureCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"identifier"];
   

}

-(void)configData{
    self.cHeightConstraint01.constant = 10+(SCREENWIDTH-90)/3*0.81*ceil(self.pictureListModel.imagsarr.count/3.0);
    self.cHeightConstraint02.constant = 10+(SCREENWIDTH-90)/3*0.81*ceil(self.pictureListModel.imagsarr1.count/3.0);
    self.cHeightConstraint03.constant = (10+(SCREENWIDTH-90)/3*0.81)*ceil(self.pictureListModel.imagsarr2.count/3.0);
    self.vHeightConstraint.constant = self.cHeightConstraint01.constant+self.cHeightConstraint02.constant+self.cHeightConstraint03.constant
    +80*3;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"identifier";
    
    PictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    PictureEntity *itemModelList;
    if(collectionView == self.collection01){
        itemModelList = [self.pictureListModel.imagsarr objectAtIndex:indexPath.row+indexPath.section*3];
    }else if(collectionView == self.collection02){
        itemModelList = [self.pictureListModel.imagsarr1 objectAtIndex:indexPath.row+indexPath.section*3];
    }else if(collectionView == self.collection03){
        itemModelList = [self.pictureListModel.imagsarr2 objectAtIndex:indexPath.row+indexPath.section*3];
    }
    cell.pictureModel = itemModelList;
    [cell setPicture];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(collectionView == self.collection01){
        return self.pictureListModel.imagsarr.count;
    }else if(collectionView == self.collection02){
        return self.pictureListModel.imagsarr1.count;
    }else if(collectionView == self.collection03){

        return self.pictureListModel.imagsarr2.count;
    }
    return 0;
    
}

#pragma mark  设置CollectionView的组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{

        return 1;

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
    PictureCarouselViewController *vc = [PictureCarouselViewController alloc];
    vc.page = indexPath.section *3 + indexPath.row;
    NSMutableArray * arrImage = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * arrThumbnail = [NSMutableArray arrayWithCapacity:0];
    if(collectionView == self.collection01){
       arrImage = [NSMutableArray arrayWithCapacity:0];
        arrThumbnail = [NSMutableArray arrayWithCapacity:0];
        for(PictureEntity * item in self.pictureListModel.imagsarr){
            [arrImage addObject:item.images];
            [arrThumbnail addObject:item.thumbnail];
        }
        
       
        vc.arrImage = arrImage ;
        vc.arrThumbnail = arrThumbnail ;
    }else if(collectionView == self.collection02){
        arrImage = [NSMutableArray arrayWithCapacity:0];
         arrThumbnail = [NSMutableArray arrayWithCapacity:0];
        for(PictureEntity * item in self.pictureListModel.imagsarr1){
            [arrImage addObject:item.images];
            [arrThumbnail addObject:item.thumbnail];
        }
        
        
        vc.arrImage = arrImage ;
        vc.arrThumbnail = arrThumbnail ;
    }else if(collectionView == self.collection03){
        arrImage = [NSMutableArray arrayWithCapacity:0];
         arrThumbnail = [NSMutableArray arrayWithCapacity:0];
        for(PictureEntity * item in self.pictureListModel.imagsarr2){
            [arrImage addObject:item.images];
            [arrThumbnail addObject:item.thumbnail];
        }
        
        
        vc.arrImage = arrImage ;
        vc.arrThumbnail = arrThumbnail ;
    }
    
  
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
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

-(void)requstOrderPicture{
    
    [SVProgressHUD show];
    NSDictionary *dic = @{@"recordID":self.recordID};
    [EnterpriseMainService requestOrderPicture:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
        if (data) {
            self.pictureListModel = data;
            PictureEntity * pictureModel;
            if(self.pictureListModel.imagsarr.count == 0){
                pictureModel
                = [PictureEntity alloc];
                pictureModel.images = @"";
                pictureModel.text = @"";
                pictureModel.thumbnail = @"";
                [self.pictureListModel.imagsarr addObject:pictureModel];
            }
            
            
            if(self.pictureListModel.imagsarr1.count == 0){
                 pictureModel
                = [PictureEntity alloc];
                pictureModel.images = @"";
                pictureModel.text = @"";
                pictureModel.thumbnail = @"";
                [self.pictureListModel.imagsarr1 addObject:pictureModel];
            }
            
            
            if(self.pictureListModel.imagsarr2.count == 0){
                pictureModel
                = [PictureEntity alloc];
                pictureModel.images = @"";
                pictureModel.text = @"";
                pictureModel.thumbnail = @"";
                [self.pictureListModel.imagsarr2 addObject:pictureModel];
            }
            [self configData];
            
            [self.collection01 reloadData];
            [self.collection02 reloadData];
            [self.collection03 reloadData];
            //    [self.view addSubview:self.collectionView];
            //注册Cell
          
           
        }
    }];

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
