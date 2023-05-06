//
//  PicturePlayViewController.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/6/7.
//

#import "PictureCarouselViewController.h"
#import "Masonry.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "SDCycleScrollView.h"


@interface PictureCarouselViewController ()<UIScrollViewDelegate,SDCycleScrollViewDelegate>

////底部srollView
//@property (nonatomic, strong) UIScrollView *scrolleView;
////显示图片

@property  NSMutableArray<UIImageView*> *arrImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *btImageType;
@property (weak, nonatomic) IBOutlet UIButton *btSave;

@property (strong, nonatomic) NSMutableArray *contentList;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *labelNum;

@property float previousScale;
@end

@implementation PictureCarouselViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if([self.pageType intValue] == 1){
        self.btImageType.hidden = YES;
        self.btSave.hidden = YES;
        
    }
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}







- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth) + 1;
    [self.arrImageView objectAtIndex:self.page].transform = CGAffineTransformIdentity;
    
    for(NSInteger i = 0 ;i<self.arrImageView.count;i++){
        if(i == page){
            [self.arrImageView objectAtIndex:i].hidden = NO;
        }else{
            [self.arrImageView objectAtIndex:i].hidden = YES;
        }
    }
    self.page = page;
    self.labelNum.text = [NSString stringWithFormat:@"%ld/%ld",self.page+1,self.contentList.count];
    NSString* curretImageState = [self.arrThumbnailState objectAtIndex:self.page];
    if([curretImageState intValue] == 1){
        [self.btImageType setTitle:@"查看原图" forState:UIControlStateNormal];
        
    }else{
        [self.btImageType setTitle:@"查看缩略图" forState:UIControlStateNormal];
    }
    [[self.arrImageView objectAtIndex:self.page] sd_setImageWithURL:[NSURL URLWithString:[self.contentList objectAtIndex:self.page ]] placeholderImage:[UIImage imageNamed:@"000"] options:SDWebImageQueryMemoryData progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        CGFloat progress = ((CGFloat)receivedSize / (CGFloat)expectedSize);
        [SVProgressHUD showProgress:progress status:@"加载中"];
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [SVProgressHUD dismiss];
    }];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.previousScale = 1.f;
    self.contentList = [NSMutableArray arrayWithCapacity:0] ;
    self.arrThumbnailState = [NSMutableArray arrayWithCapacity:0] ;
    self.arrImageView = [NSMutableArray arrayWithCapacity:0] ;
    for (NSInteger i = 0;i<self.arrThumbnail.count; i++) {
        [self.arrThumbnailState addObject:@"1"];
        [self.contentList addObject:[self.arrThumbnail objectAtIndex:i]];
        
    }
    if(self.arrThumbnailState.count == 0){
        self.labelNum.text = @"0/0";
    }else{
        
        self.labelNum.text = [NSString stringWithFormat:@"%ld/%ld",self.page+1,self.contentList.count];
    }
    
    _scrollView.contentSize = CGSizeMake(SCREENWIDTH*self.contentList.count, SCREENHEIGHT-125-[self getStatusBarHight]);
    
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    // 3.为scrollView每一页添加图片
    UITapGestureRecognizer *labelTapGestureRecognizer;
    UIRotationGestureRecognizer *rotationGesture;
    UIPinchGestureRecognizer *pinchGesture;
    for (NSUInteger i=0; i<self.contentList.count; ++i) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH * i, 0, SCREENWIDTH, SCREENHEIGHT-125-[self getStatusBarHight])];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.scrollView addSubview:imageView];
        labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                     initWithTarget:self action:@selector(labelClick)];
        [imageView addGestureRecognizer:labelTapGestureRecognizer];
        imageView.userInteractionEnabled = YES;
        
        rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateView:)];
        [imageView addGestureRecognizer:rotationGesture];
        
        
        pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
        [imageView addGestureRecognizer:pinchGesture];
        
        
        [self.arrImageView addObject:imageView];
    }
    
    
    [[self.arrImageView objectAtIndex:self.page] sd_setImageWithURL:[NSURL URLWithString:[self.contentList objectAtIndex:self.page ]] placeholderImage:[UIImage imageNamed:@"000"] options:SDWebImageQueryMemoryData progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        CGFloat progress = ((CGFloat)receivedSize / (CGFloat)expectedSize);
        [SVProgressHUD showProgress:progress status:@"加载中"];
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [SVProgressHUD dismiss];
    }];
    [self.scrollView  setContentOffset:CGPointMake(SCREENWIDTH*self.page, 0)];
    //
    //      //初始化imageview，设置图片
    //    self.myImageView = [[UIImageView alloc]init];
    //        [self.myImageView sd_setImageWithURL:[NSURL URLWithString:self.dataArr[0]] placeholderImage:[UIImage imageNamed:@"000"]];
    
    
    //    self.myImageView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    //    self.myImageView.contentMode = UIViewContentModeScaleAspectFit;
    //      [_scrolleView addSubview:self.myImageView];
    //
    
    //    self.scrollView.maximumZoomScale = 5;
    //    self.scrollView.minimumZoomScale = 0.4;
    
    
    
    
    
    
    
    
    
}
// 处理捏合缩放手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIImageView *view = [self.arrImageView objectAtIndex:self.page];
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
}





- (void)labelClick {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

// 处理旋转手势
- (void) rotateView:(UIRotationGestureRecognizer *)rotationGestureRecognizer
{
    UIImageView *view = [self.arrImageView objectAtIndex:self.page];
    if (rotationGestureRecognizer.state == UIGestureRecognizerStateBegan || rotationGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformRotate(view.transform, rotationGestureRecognizer.rotation);
        [rotationGestureRecognizer setRotation:0];
    }
}

- (IBAction)actionSave:(id)sender {
    [self saveImage:[self.arrImageView objectAtIndex:self.page].image];
}

//image是要保存的图片
- (void) saveImage:(UIImage *)image{
    
    if (image) {
        
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
        
    };
    
}
//保存完成后调用的方法
- (void) savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        NSLog(@"保存图片出错%@", error.localizedDescription);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"保存图片出错%@", error.localizedDescription);
            // [SVProgressHUD showErrorWithStatus:@"保存图片出错"];
            
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:@"保存图片成功"];
        });
        NSLog(@"保存图片成功");
    }
}



- (IBAction)actionType:(id)sender {
    if([[self.arrThumbnailState objectAtIndex:self.page] intValue] == 1){
        
        [self.contentList replaceObjectAtIndex:self.page withObject:[self.arrImage objectAtIndex:self.page] ];
        
        
        [self.arrThumbnailState replaceObjectAtIndex:self.page withObject:@"0"];
        [self.btImageType setTitle:@"查看缩略图" forState:UIControlStateNormal];
    }else{
        [self.contentList replaceObjectAtIndex:self.page withObject:[self.arrThumbnail objectAtIndex:self.page] ];
        [self.arrThumbnailState replaceObjectAtIndex:self.page withObject:@"1"];
        [self.btImageType setTitle:@"查看原图" forState:UIControlStateNormal];
    }
    
    [[self.arrImageView objectAtIndex:self.page] sd_setImageWithURL:[NSURL URLWithString:[self.contentList objectAtIndex:self.page ]] placeholderImage:[UIImage imageNamed:@"000"] options:SDWebImageQueryMemoryData progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        CGFloat progress = ((CGFloat)receivedSize / (CGFloat)expectedSize);
        [SVProgressHUD showProgress:progress status:@"加载中"];
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [SVProgressHUD dismiss];
    }];
    
}


-(CGFloat)getStatusBarHight {
    float statusBarHeight = 0;
    if (@available(iOS 13.0, *)) {
        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager;
        statusBarHeight = statusBarManager.statusBarFrame.size.height;
    }
    else {
        statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    return statusBarHeight;
}


@end
