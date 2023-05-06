//
//  CaseTableViewCell.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2022/3/14.
//

#import "CaseTableViewCell.h"
#import "PictureCollectionViewCell.h"
#import "PictureCarouselViewController.h"
#import "UIViewController+GetCurrentUIVC.h"

@implementation CaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initCollectionView:self.collection];
    [self.collection reloadData];
    
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                         initWithTarget:self action:@selector(modify)];
    // 2. 将点击事件添加到label上
    [self.labelModify addGestureRecognizer:labelTapGestureRecognizer];
    self.labelModify.userInteractionEnabled = YES;
}

- (void)modify {
  
    if (self.confirmBlock) {
        self.confirmBlock();
        
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(CaseModel*)model{
    model = self.model;
  
    [self initCollectionView:self.collection];
    [self.collection reloadData];
    self.labelTitle.text = self.model.caseTitle;
    
   

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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"identifier";
    
    PictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    PictureModel *itemModelList;
    itemModelList = [self.model.pictureList objectAtIndex:indexPath.row+indexPath.section*3];
    
    cell.pictureModel = itemModelList;
    [cell setPicture];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   
        return self.model.pictureList.count;
    

    
}

#pragma mark  设置CollectionView的组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
 
        return ceil(self.model.pictureList.count/3.0);

}

-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath
{
    return CGSizeMake((SCREENWIDTH-120)/3, (SCREENWIDTH-90)/3*0.81);//可以根据indexpath 设置item 的size
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
    vc.pageType =@"1";
    NSMutableArray * arrImage = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * arrThumbnail = [NSMutableArray arrayWithCapacity:0];
 
       arrImage = [NSMutableArray arrayWithCapacity:0];
        arrThumbnail = [NSMutableArray arrayWithCapacity:0];
        for(PictureModel * item in self.model.pictureList){
            [arrImage addObject:item.images];
            [arrThumbnail addObject:item.thumbnail];
        }
        
       
        vc.arrImage = arrImage ;
        vc.arrThumbnail = arrThumbnail ;
    
    
  
    vc.hidesBottomBarWhenPushed = YES;
    [[UIViewController getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    
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
