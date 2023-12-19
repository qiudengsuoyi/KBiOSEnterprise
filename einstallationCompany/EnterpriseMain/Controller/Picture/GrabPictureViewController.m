//
//  GrabPictureViewController.m
//  einstallationCompany
//
//  Created by 云位 on 2023/9/14.
//

#import "GrabPictureViewController.h"
#import "PictureCollectionViewCell.h"
#import "EnterpriseMainService.h"
#import "SVProgressHUD.h"
#import "APIConst.h"
#import "PictureCarouselViewController.h"
#import "VideoViewController.h"
#import "PictureModel.h"

@interface GrabPictureViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collection01;
@property (weak, nonatomic) IBOutlet UICollectionView *collection02;
@property (weak, nonatomic) IBOutlet UICollectionView *collection03;
@property (weak, nonatomic) IBOutlet UICollectionView *collection04;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cHeightConstraint01;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cHeightConstraint02;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cHeightConstraint03;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cHeightConstraint04;
@end

@implementation GrabPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    [self addBackItem];
    self.navigationItem.title = @"任务图片";
    [self requstOrderPicture];
    [self initCollectionView:self.collection01];
    [self initCollectionView:self.collection02];
    [self initCollectionView:self.collection03];
    [self initCollectionView:self.collection04];
    [self.collection01 reloadData];
    [self.collection02 reloadData];
    [self.collection03 reloadData];
    [self.collection04 reloadData];

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
    self.cHeightConstraint01.constant = 10+(SCREENWIDTH-90)/3*0.81*ceil(self.pictureListModel.imagsarr1.count/3.0);
    self.cHeightConstraint02.constant = 10+(SCREENWIDTH-90)/3*0.81*ceil(self.pictureListModel.imagsarr2.count/3.0);
    
    self.cHeightConstraint03.constant = 10+(SCREENWIDTH-90)/3*0.81*ceil(self.pictureListModel.imagsarr3.count/3.0);
    self.cHeightConstraint04.constant = 10+(SCREENWIDTH-90)/3*0.81*ceil(self.pictureListModel.imagsarr4.count/3.0);

    self.vHeightConstraint.constant = self.cHeightConstraint01.constant+self.cHeightConstraint02.constant
    +self.cHeightConstraint03.constant+self.cHeightConstraint04.constant+65*4;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"identifier";
    
    PictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    PictureEntity *itemModelList;
    if(collectionView == self.collection01){
        itemModelList = [self.pictureListModel.imagsarr1 objectAtIndex:indexPath.row+indexPath.section*3];
        cell.pictureModel = itemModelList;
        [cell setPicture];
    }else if(collectionView == self.collection02){
        itemModelList = [self.pictureListModel.imagsarr2 objectAtIndex:indexPath.row+indexPath.section*3];
        cell.pictureModel = itemModelList;
        [cell setPicture];
    }else if(collectionView == self.collection03){
        itemModelList = [self.pictureListModel.imagsarr3 objectAtIndex:indexPath.row+indexPath.section*3];
        cell.pictureModel = itemModelList;
        [cell setPicture];
    }else {
        itemModelList = [self.pictureListModel.imagsarr4 objectAtIndex:indexPath.row+indexPath.section*3];
        cell.pictureModel = itemModelList;
        [cell setVideo];
    }
  

    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(collectionView == self.collection01){
        return self.pictureListModel.imagsarr1.count;
    }else if(collectionView == self.collection02){
        return self.pictureListModel.imagsarr2.count;
    }else if(collectionView == self.collection03){
        return self.pictureListModel.imagsarr3.count;
    }else{
        return self.pictureListModel.imagsarr4.count;
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
   
    if(collectionView == self.collection01){
        PictureCarouselViewController *vc = [PictureCarouselViewController alloc];
        vc.page = indexPath.section *3 + indexPath.row;
        NSMutableArray * arrImage = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray * arrThumbnail = [NSMutableArray arrayWithCapacity:0];
    
        for(PictureEntity * item in self.pictureListModel.imagsarr1){
            [arrImage addObject:item.images];
            [arrThumbnail addObject:item.thumbnail];
        }
        
       
        vc.arrImage = arrImage ;
        vc.arrThumbnail = arrThumbnail ;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(collectionView == self.collection02){
        PictureCarouselViewController *vc = [PictureCarouselViewController alloc];
        vc.page = indexPath.section *3 + indexPath.row;
        NSMutableArray * arrImage = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray * arrThumbnail = [NSMutableArray arrayWithCapacity:0];
     
        for(PictureEntity * item in self.pictureListModel.imagsarr2){
            [arrImage addObject:item.images];
            [arrThumbnail addObject:item.thumbnail];
        }
        
        
        vc.arrImage = arrImage ;
        vc.arrThumbnail = arrThumbnail ;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(collectionView == self.collection03){
        PictureCarouselViewController *vc = [PictureCarouselViewController alloc];
        vc.page = indexPath.section *3 + indexPath.row;
        NSMutableArray * arrImage = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray * arrThumbnail = [NSMutableArray arrayWithCapacity:0];
     
        for(PictureEntity * item in self.pictureListModel.imagsarr3){
            [arrImage addObject:item.images];
            [arrThumbnail addObject:item.thumbnail];
        }
        
        
        vc.arrImage = arrImage ;
        vc.arrThumbnail = arrThumbnail ;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        VideoViewController *vc = [VideoViewController alloc];
        PictureEntity * model = [self.pictureListModel.imagsarr4 objectAtIndex:indexPath.section *3 + indexPath.row];
        
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

-(void)requstOrderPicture{
    
    [SVProgressHUD show];
    NSDictionary *dic = @{@"recordID":self.recordID};
    [EnterpriseMainService requestGrapMasterPicture:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
        if (data) {
            self.pictureListModel = data;
            PictureEntity * pictureModel;
         
            
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
            
            if(self.pictureListModel.imagsarr3.count == 0){
                pictureModel
                = [PictureEntity alloc];
                pictureModel.images = @"";
                pictureModel.text = @"";
                pictureModel.thumbnail = @"";
                [self.pictureListModel.imagsarr3 addObject:pictureModel];
            }
            
            if(self.pictureListModel.imagsarr4.count == 0){
                pictureModel
                = [PictureEntity alloc];
                pictureModel.images = @"";
                pictureModel.text = @"";
                pictureModel.thumbnail = @"";
                [self.pictureListModel.imagsarr4 addObject:pictureModel];
            }
            [self configData];
            
            [self.collection01 reloadData];
            [self.collection02 reloadData];
            [self.collection03 reloadData];
            [self.collection04 reloadData];
            //    [self.view addSubview:self.collectionView];
            //注册Cell
          
           
        }
    }];

}


@end
