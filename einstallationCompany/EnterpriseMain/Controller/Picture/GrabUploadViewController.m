//
//  GrabUploadViewController.m
//  einstallationCompany
//
//  Created by 云位 on 2023/9/10.
//

#import "GrabUploadViewController.h"
#import "TZTestCell.h"
#import "TZImagePickerController.h"
#import "UIView+TZLayout.h"
#import "UIView+Extension.h"
#import "SVProgressHUD.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "AFHTTPSessionManager.h"
#import "PictureModel.h"
#import "PictureCanDeleteCollectionViewCell.h"
#import "PictureCarouselViewController.h"
#import "VideoViewController.h"
#import "APIConst.h"
#import "EnterpriseMainService.h"
#import "NSObject+YYModel.h"
#import "EnterpriseNetwork.h"
#import "DialogOneView.h"
#import "DialogTwoButtonView.h"

@interface GrabUploadViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate>{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
    NSInteger SelectedPostion;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionHaveImage;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionHaveVideo;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (weak, nonatomic) IBOutlet UICollectionView *imagecollectionView;

@property NSMutableArray <NSString*> * arrProgressData;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vSelectImageHeight;

@property NSMutableArray<PictureModel*> * arrImage;
@property NSMutableArray<PictureModel*> * arrVideo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionImageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionVideoHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vConstraintHeight;
@property (weak, nonatomic) IBOutlet UIButton *btUpload;

@property NSInteger uploadCount;
@property NSInteger uploadSuccessCount;
@property NSInteger uploadFailCount;
@property NSInteger uploadHandleCount;
@property NSString * Pid;
@end

@implementation GrabUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackItem];
    self.navigationItem.title = @"上传图片";
    self.uploadCount = 0;
    self.arrImage = [NSMutableArray array];
    self.arrVideo = [NSMutableArray array];
    self.arrProgressData = [NSMutableArray arrayWithCapacity:0];
    [self.arrProgressData addObject:@"0"];
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    [self initPickerCollectionView];
    [self initCollectionView:self.collectionHaveImage];
    [self initCollectionView:self.collectionHaveVideo];
    [self.collectionHaveImage reloadData];
    [self.collectionHaveVideo reloadData];
    [self requstOrderList];
}

- (void) initCollectionView:(UICollectionView *)collectionView
{
    //设置CollectionView的属性
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.scrollEnabled = YES;
    //    [self.view addSubview:self.collectionView];
    //注册Cell
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PictureCanDeleteCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"identifier"];
    
}

- (void)initPickerCollectionView {
    _imagecollectionView.alwaysBounceVertical = YES;
    _imagecollectionView.backgroundColor = [UIColor whiteColor];
    _imagecollectionView.dataSource = self;
    _imagecollectionView.delegate = self;
    _imagecollectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [_imagecollectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
}

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (@available(iOS 9, *)) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
        
    }
    return _imagePickerVc;
}

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        // 无相机权限 做一个友好的提示
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self takePhoto];
                });
            }
        }];
        // 拍照之前还需要检查相册权限
    } else if ([PHPhotoLibrary authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if ([PHPhotoLibrary authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

- (void)pushTZImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:3 delegate:self pushPhotoPickerVc:YES];
    
    
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = YES;
    
    
    // 1.设置目前已经选中的图片数组
    imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    imagePickerVc.allowTakeVideo = YES;   // 在内部显示拍视频按
    imagePickerVc.videoMaximumDuration = 30; // 视频最大拍摄时间
    [imagePickerVc setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    }];
    imagePickerVc.autoSelectCurrentWhenDone = NO;
    
    // imagePickerVc.photoWidth = 1600;
    // imagePickerVc.photoPreviewMaxWidth = 1600;
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    //     imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    //     imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    //     imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    imagePickerVc.navigationBar.translucent = NO;
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *barAppearance = [[UINavigationBarAppearance alloc] init];
        barAppearance.backgroundColor = imagePickerVc.navigationBar.barTintColor;
        barAppearance.titleTextAttributes = imagePickerVc.navigationBar.titleTextAttributes;
        imagePickerVc.navigationBar.standardAppearance = barAppearance;
        imagePickerVc.navigationBar.scrollEdgeAppearance = barAppearance;
    }
    
    
    imagePickerVc.iconThemeColor = [UIColor colorWithRed:31 / 255.0 green:185 / 255.0 blue:34 / 255.0 alpha:1.0];
    imagePickerVc.showPhotoCannotSelectLayer = YES;
    imagePickerVc.cannotSelectLayerColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    /*
     [imagePickerVc setPhotoPickerPageUIConfigBlock:^(UICollectionView *collectionView, UIView *bottomToolBar, UIButton *previewButton, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel, UIView *divideLine) {
     [doneButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
     }];
     */
    /*
     [imagePickerVc setAssetCellDidSetModelBlock:^(TZAssetCell *cell, UIImageView *imageView, UIImageView *selectImageView, UILabel *indexLabel, UIView *bottomView, UILabel *timeLength, UIImageView *videoImgView) {
     cell.contentView.clipsToBounds = YES;
     cell.contentView.layer.cornerRadius = cell.contentView.tz_width * 0.5;
     }];
     */
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = YES;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = YES; // 是否可以多选视频
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = YES;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    // 设置竖屏下的裁剪尺寸
    //    NSInteger left = 30;
    //    NSInteger widthHeight = self.view.tz_width - 2 * left;
    //    NSInteger top = (self.view.tz_height - widthHeight) / 2;
    //    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    //    imagePickerVc.scaleAspectFillCrop = YES;
    // 设置横屏下的裁剪尺寸
    // imagePickerVc.cropRectLandscape = CGRectMake((self.view.tz_height - widthHeight) / 2, left, widthHeight, widthHeight);
    /*
     [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
     cropView.layer.borderColor = [UIColor redColor].CGColor;
     cropView.layer.borderWidth = 2.0;
     }];*/
    
    // imagePickerVc.allowPreview = NO;
    // 自定义导航栏上的返回按钮
    /*
     [imagePickerVc setNavLeftBarButtonSettingBlock:^(UIButton *leftButton){
     [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
     [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 20)];
     }];
     imagePickerVc.delegate = self;
     */
    
    // Deprecated, Use statusBarStyle
    // imagePickerVc.isStatusBarDefault = NO;
    //    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
    
    // 设置是否显示图片序号
    imagePickerVc.showSelectedIndex = YES;
    
    // 设置拍照时是否需要定位，仅对选择器内部拍照有效，外部拍照的，请拷贝demo时手动把pushImagePickerController里定位方法的调用删掉
    // imagePickerVc.allowCameraLocation = NO;
    
    // 自定义gif播放方案
    //    [[TZImagePickerConfig sharedInstance] setGifImagePlayBlock:^(TZPhotoPreviewView *view, UIImageView *imageView, NSData *gifData, NSDictionary *info) {
    //        FLAnimatedImage *animatedImage = [FLAnimatedImage animatedImageWithGIFData:gifData];
    //        FLAnimatedImageView *animatedImageView;
    //        for (UIView *subview in imageView.subviews) {
    //            if ([subview isKindOfClass:[FLAnimatedImageView class]]) {
    //                animatedImageView = (FLAnimatedImageView *)subview;
    //                animatedImageView.frame = imageView.bounds;
    //                animatedImageView.animatedImage = nil;
    //            }
    //        }
    //        if (!animatedImageView) {
    //            animatedImageView = [[FLAnimatedImageView alloc] initWithFrame:imageView.bounds];
    //            animatedImageView.runLoopMode = NSDefaultRunLoopMode;
    //            [imageView addSubview:animatedImageView];
    //        }
    //        animatedImageView.animatedImage = animatedImage;
    //    }];
    
    // 设置首选语言 / Set preferred language
    // imagePickerVc.preferredLanguage = @"zh-Hans";
    
    // 设置languageBundle以使用其它语言 / Set languageBundle to use other language
    // imagePickerVc.languageBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"tz-ru" ofType:@"lproj"]];
    
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

// 调用相机
- (void)pushImagePickerController {
    // 提前定位
    __weak typeof(self) weakSelf = self;
    
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        NSMutableArray *mediaTypes = [NSMutableArray array];
        [mediaTypes addObject:(NSString *)kUTTypeMovie];
        [mediaTypes addObject:(NSString *)kUTTypeImage];
        if (mediaTypes.count) {
            _imagePickerVc.mediaTypes = mediaTypes;
        }
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}


- (void)deleteBtnClik:(UIButton *)sender {
    if ([self collectionView:self.imagecollectionView numberOfItemsInSection:0] <= _selectedPhotos.count) {
        self.arrProgressData = [NSMutableArray array];
        for(int i =0;i<=self->_selectedAssets.count;i++){
            [self.arrProgressData addObject:@"0"];
            
        }
        [_selectedPhotos removeObjectAtIndex:sender.tag];
        [_selectedAssets removeObjectAtIndex:sender.tag];
        [self.imagecollectionView reloadData];
        return;
    }
    
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    [_imagecollectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [self->_imagecollectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self->_imagecollectionView reloadData];
    }];
}

- (void)deleteUploadClik:(UIButton *)sender {
    [self showTwoDialogView:@"是否确认删除图片" withRightButtonTitle:@"是" withLeftButtonTitle:@"否" withPid: [NSString stringWithFormat:@"%ld", sender.tag]];
}


// The picker should dismiss itself; when it dismissed these handle will be called.
// You can also set autoDismiss to NO, then the picker don't dismiss itself.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 你也可以设置autoDismiss属性为NO，选择器就不会自己dismis了
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    
    
    
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    
    
    
    _isSelectOriginalPhoto = YES;
    self.arrProgressData = [NSMutableArray array];
    for(int i =0;i<=self->_selectedAssets.count;i++){
        [self.arrProgressData addObject:@"0"];
        
    }
    
    [_imagecollectionView reloadData];
    // _imagecollectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
    // 1.打印图片名字
    [self printAssetsName:assets];
    // 2.图片位置信息
    
    // 3. 获取原图的示例，用队列限制最大并发为1，避免内存暴增
    self.operationQueue = [[NSOperationQueue alloc] init];
    self.operationQueue.maxConcurrentOperationCount = 1;
    //    for (NSInteger i = 0; i < assets.count; i++) {
    //        PHAsset *asset = assets[i];
    //        // 图片上传operation，上传代码请写到operation内的start方法里，内有注释
    //        TZImageUploadOperation *operation = [[TZImageUploadOperation alloc] initWithAsset:asset completion:^(UIImage * photo, NSDictionary *info, BOOL isDegraded) {
    //            if (isDegraded) return;
    //            NSLog(@"图片获取&上传完成");
    //        } progressHandler:^(double progress, NSError * _Nonnull error, BOOL * _Nonnull stop, NSDictionary * _Nonnull info) {
    //            NSLog(@"获取原图进度 %f", progress);
    //        }];
    //        [self.operationQueue addOperation:operation];
    //    }
    for (PHAsset *asset in assets) {
        NSLog(@"location:%@",asset.location);
        if (asset.mediaType == PHAssetMediaTypeVideo) {
            // 这是一个视频，可以处理它
            if(asset.duration>30){
                [SVProgressHUD showErrorWithStatus:@"视频超过30秒无法上传，请删除！"];
                return;
            }
        }
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    tzImagePickerVc.sortAscendingByModificationDate = YES;
    [tzImagePickerVc showProgressHUD];
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSDictionary *meta = [info objectForKey:UIImagePickerControllerMediaMetadata];
        [[TZImageManager manager] savePhotoWithImage:image meta:meta location:nil completion:^(PHAsset *asset, NSError *error){
            [tzImagePickerVc hideProgressHUD];
            if (error) {
                NSLog(@"图片保存失败 %@",error);
            } else {
                TZAssetModel *assetModel = [[TZImageManager manager] createModelWithAsset:asset];
                //                if (NO) { // 允许裁剪,去裁剪
                //                    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
                //                        [self refreshCollectionViewWithAddedAsset:asset image:cropImage];
                //                    }];
                //                    imagePicker.allowPickingImage = YES;
                //                    imagePicker.needCircleCrop = NO;
                //                    imagePicker.circleCropRadius = 100;
                //                    [self presentViewController:imagePicker animated:YES completion:nil];
                //                } else {
                [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                //                }
            }
        }];
    } else if ([type isEqualToString:@"public.movie"]) {
        NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        if (videoUrl) {
            [[TZImageManager manager] saveVideoWithUrl:videoUrl location:nil completion:^(PHAsset *asset, NSError *error) {
                [tzImagePickerVc hideProgressHUD];
                if (!error) {
                    TZAssetModel *assetModel = [[TZImageManager manager] createModelWithAsset:asset];
                    [[TZImageManager manager] getPhotoWithAsset:assetModel.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
                        if (!isDegraded && photo) {
                            [self refreshCollectionViewWithAddedAsset:assetModel.asset image:photo];
                        }
                    }];
                }
            }];
        }
    }
}

- (void)refreshCollectionViewWithAddedAsset:(PHAsset *)asset image:(UIImage *)image {
    
    [_selectedAssets addObject:asset];
    [_selectedPhotos addObject:image];
    self.arrProgressData = [NSMutableArray array];
    for(int i =0;i<=self->_selectedAssets.count;i++){
        [self.arrProgressData addObject:@"0"];
        
    }
    [_imagecollectionView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

/// 打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    for (PHAsset *asset in assets) {
        fileName = [asset valueForKey:@"filename"];
        // NSLog(@"图片名字:%@",fileName);
    }
}

#pragma mark  设置CollectionView的组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
        return 1;
}

#pragma mark  设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView == self.imagecollectionView){
        self.height.constant = ceil((_selectedPhotos.count + 1)/3.0f)*((SCREENWIDTH-90)/3.0f);
        self.vSelectImageHeight.constant =  self.height.constant +140;
        return _selectedPhotos.count + 1;
    }else if(collectionView == self.collectionHaveImage){
        return self.arrImage.count;
    }else{
        return self.arrVideo.count;
    }
    return 0;
}

#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"identifier";
    if(collectionView == self.imagecollectionView){
        TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
        cell.videoImageView.hidden = YES;
        if (indexPath.item == _selectedPhotos.count) {
            cell.imageView.image = [UIImage imageNamed:@"Image_add.png"];
            cell.deleteBtn.hidden = YES;
            cell.gifLable.hidden = YES;
            cell.progressView.hidden = YES;
        } else {
            cell.progressView.hidden = NO;
            cell.imageView.image = _selectedPhotos[indexPath.item];
            cell.asset = _selectedAssets[indexPath.item];
            cell.deleteBtn.hidden = NO;
        }
        [cell.progressView setProgress:[[self.arrProgressData objectAtIndex:indexPath.row] floatValue]];
        
        
        cell.gifLable.hidden = YES;
        cell.deleteBtn.tag = indexPath.item;
        [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else if(collectionView == self.collectionHaveImage){
        PictureModel *itemModelList = [self.arrImage objectAtIndex:indexPath.row+indexPath.section*3];
        PictureCanDeleteCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        cell.pictureModel = itemModelList;
        [cell setPicture];
        cell.deleteBtn.tag = [itemModelList.pid intValue];
        [cell.deleteBtn addTarget:self action:@selector(deleteUploadClik:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        PictureModel *itemModelList = [self.arrVideo objectAtIndex:indexPath.row+indexPath.section*3];
        PictureCanDeleteCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        
        cell.pictureModel = itemModelList;
        [cell setVideo];
        cell.deleteBtn.tag = [itemModelList.pid intValue];
        [cell.deleteBtn addTarget:self action:@selector(deleteUploadClik:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    return nil;
    
    
    
}

#pragma mark  定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if(collectionView == self.imagecollectionView){
        return UIEdgeInsetsMake(5, 5, 5, 5);//（上、左、下、右）
    }else{
        return UIEdgeInsetsMake(0, 0, 10, 0);//（上、左、下、右）
    }
    
    
}


-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath
{
    if(collectionView == self.imagecollectionView){
        return CGSizeMake((SCREENWIDTH-120)/3, (SCREENWIDTH-120)/3);
    }else{
        return CGSizeMake((SCREENWIDTH-100)/3-1, (SCREENWIDTH-100)/3*0.81);
    }
    
}


#pragma mark  点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == self.imagecollectionView){
        if (indexPath.item == _selectedPhotos.count) {
            NSString *takePhotoTitle = @"相机";
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:takePhotoTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self takePhoto];
            }];
            [alertVc addAction:takePhotoAction];
            UIAlertAction *imagePickerAction = [UIAlertAction actionWithTitle:@"去相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self pushTZImagePickerController];
            }];
            [alertVc addAction:imagePickerAction];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertVc addAction:cancelAction];
            UIPopoverPresentationController *popover = alertVc.popoverPresentationController;
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            if (popover) {
                popover.sourceView = cell;
                popover.sourceRect = cell.bounds;
                popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
            }
            [self presentViewController:alertVc animated:YES completion:nil];
            
        }else { // preview photos or video / 预览照片或者视频
            PHAsset *asset = _selectedAssets[indexPath.item];
            BOOL isVideo = NO;
            isVideo = asset.mediaType == PHAssetMediaTypeVideo;
            if ([[asset valueForKey:@"filename"] containsString:@"GIF"] && YES) {
                TZGifPhotoPreviewController *vc = [[TZGifPhotoPreviewController alloc] init];
                TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypePhotoGif timeLength:@""];
                vc.model = model;
                vc.modalPresentationStyle = UIModalPresentationFullScreen;
                [self presentViewController:vc animated:YES completion:nil];
            } else { // preview photos / 预览照片
                TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.item];
                imagePickerVc.maxImagesCount = 9;
                imagePickerVc.allowPickingGif = NO;
                imagePickerVc.autoSelectCurrentWhenDone = NO;
                imagePickerVc.allowPickingOriginalPhoto = YES;
                imagePickerVc.allowPickingMultipleVideo = YES;
                imagePickerVc.showSelectedIndex = NO;
                imagePickerVc.isSelectOriginalPhoto = YES;
                imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
                [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                    
                    self->_selectedPhotos = [NSMutableArray arrayWithArray:photos];
                    self->_selectedAssets = [NSMutableArray arrayWithArray:assets];
                    self->_isSelectOriginalPhoto = YES;
                    self.arrProgressData = [NSMutableArray array];
                    for(int i =0;i<=self->_selectedAssets.count;i++){
                        [self.arrProgressData addObject:@"0"];
                        
                    }
                    [self->_imagecollectionView reloadData];
                    self->_imagecollectionView.contentSize = CGSizeMake(0, ((self->_selectedPhotos.count + 2) / 3 ) * (self->_margin + self->_itemWH));
                }];
                [self presentViewController:imagePickerVc animated:YES completion:nil];
            }
        }
    }else if(collectionView == self.collectionHaveImage){
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


-(void)requstOrderList{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];
    
    NSDictionary *dic = @{@"AnnexNo":self.annexNo};
    [EnterpriseMainService requestGrabUpload:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
        if (data) {
            
            self.arrImage = [NSMutableArray new];
            for (NSDictionary *dic in data[@"data"][@"imagsarr"]) {
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
            [self.collectionHaveImage reloadData];
            
            
            self.arrVideo = [NSMutableArray new];
            for (NSDictionary *dic in data[@"data"][@"videoarr"]) {
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
            [self.collectionHaveVideo reloadData];
            
            
            
            self.collectionImageHeight.constant = ((SCREENWIDTH-100)/3*0.81+10)*ceil(self.arrImage.count/3.0);
            self.collectionVideoHeight.constant = ((SCREENWIDTH-100)/3*0.81+10)*ceil(self.arrVideo.count/3.0);
            
            
            self.vConstraintHeight.constant = ((SCREENWIDTH-100)/3*0.81+10)*ceil(self.arrImage.count/3.0)+135+((SCREENWIDTH-100)/3*0.81+10)*ceil(self.arrVideo.count/3.0);
            
            
        }
    }];
    
}


-(void)requstDeleteUpload:(NSString*)Pid{
    
    [SVProgressHUD show];
    
    NSDictionary *dic = @{@"p_id":Pid};
    [EnterpriseMainService requestDeleteUpload:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
        if (data) {
            [SVProgressHUD dismiss];
            if ([data[@"code"]integerValue] == 1) {
                [self requstOrderList];
            }
            
            
            
            
        }
    }];
    
}

- (void)uploadImages{
    
    
    for (PHAsset *asset in _selectedAssets) {
        if (asset.mediaType == PHAssetMediaTypeVideo) {
            // 这是一个视频，可以处理它
            if(asset.duration>30){
                [SVProgressHUD showErrorWithStatus:@"视频超过30秒无法上传，请删除！"];
                return;
            }
        }
    }
    [self.btUpload setEnabled:NO];
    
    @try {
        
        self.arrProgressData = [NSMutableArray arrayWithCapacity:0];
        self.uploadHandleCount = 0;
        self.uploadSuccessCount = 0;
        self.uploadFailCount = 0;
        self.uploadCount = _selectedPhotos.count;
        [self updatePhoto];
    }
    @catch (NSException *exception) {
        [SVProgressHUD showErrorWithStatus:@"请重试！"];
    }
    @finally {
    
    }
    
}


-(void)updatePhoto{
    @try {
        if(self.uploadHandleCount<self.uploadCount){
            [SVProgressHUD show];
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html",@"application/text",@"multipart/form-data", nil];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            
            NSDictionary *dict = @{@"AnnexNo":self.annexNo};
            NSString *url;
            
            self.arrProgressData = [NSMutableArray array];
            for(int i =0;i<=self->_selectedAssets.count;i++){
                [self.arrProgressData addObject:@"0"];
                
            }
            
            
            __block PHAsset *asset = nil;
            
            
            asset = [self->_selectedAssets objectAtIndex:self.uploadFailCount];
            
            if( asset.mediaType == PHAssetMediaTypeVideo){
                url = [NSString stringWithFormat:@"%@%@?AnnexNo=%@",ENTERPRISE_SERVER_HOST,UPLOAD_VIDEO_URL,self.annexNo];
                [[TZImageManager manager] getVideoOutputPathWithAsset:asset presetName:AVAssetExportPresetPassthrough success:^(NSString *outputPath) {
                    NSData *data = [NSData dataWithContentsOfFile:outputPath];
                    [manager POST:url parameters:dict headers:NULL constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                        @try {
                            
                            // 创建 AVURLAsset 以获取视频文件的属性
                            AVURLAsset *videoAsset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:outputPath]];
                            NSString *fileName = [videoAsset.URL lastPathComponent];
                            
                            
                            CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[outputPath pathExtension], NULL);
                            CFStringRef mimeType = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType);
                            if (mimeType) {
                                NSString *mimeTypeString = (__bridge_transfer NSString *)mimeType;
                                NSLog(@"媒体资源的 MIME 类型：%@", mimeTypeString);
                                [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:mimeTypeString];
                            } else {
                                NSLog(@"未能确定媒体资源的 MIME 类型");
                            }
                        }
                        @catch (NSException *exception) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [SVProgressHUD showErrorWithStatus:@"媒体资源处理错误，请重试！"];
                                [self.btUpload setEnabled:YES];});
                        }
                        @finally {
                            
                        }
                        
                        
                        
                    } progress:^(NSProgress * _Nonnull uploadProgress) {
                        NSLog(@"------%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            
                            [self.arrProgressData replaceObjectAtIndex:self.uploadFailCount withObject:[NSString stringWithFormat:@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount]];
                            //                        //刷新的位置，第一个参数代表刷新的第几个cell，第二个参数代表的刷新的第几组（一般我们用到一组的情况比较多，所以这里直接我就默认写的0）
                            //                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                            //                        //开始执行刷新的方法，刷新位置是数组，
                            //                        [self.imagecollectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects: indexPath, nil]];
                            [self.imagecollectionView reloadData];
                            
                            
                            
                        });
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                        NSString* str = [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:gbkEncoding];
                        
                        NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
                        temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                        temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                        NSDictionary *responseData = [EnterpriseNetwork dictionaryWithJsonString:temp];
                        
                        self.uploadHandleCount = self.uploadHandleCount+1;
                        self.uploadSuccessCount = self.uploadSuccessCount+1;
                        
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self->_selectedAssets removeObjectAtIndex:self.uploadFailCount];
                            [self->_selectedPhotos removeObjectAtIndex:self.uploadFailCount];
                            [self->_imagecollectionView reloadData];
                            [self requstOrderList];
                            if(self.uploadCount == self.uploadHandleCount){
                                [SVProgressHUD dismiss];
                                
                                [self.btUpload setEnabled:YES];
                                
                                [self showOneDialogView: [NSString stringWithFormat:@"总计%ld个，%ld个上传成功，%ld个上传失败！",(long)self.uploadCount,(long)self.uploadSuccessCount,(long)self.uploadFailCount]
                                   withRightButtonTitle:@"确定"];
                                return;
                            }
                            
                            [self updatePhoto];
                        });
                        
                        
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"-----error-%@",error);
                        self.uploadHandleCount = self.uploadHandleCount+1;
                        self.uploadFailCount = self.uploadFailCount+1;
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"视频上传失败！%@",error]];
                            if(self.uploadCount == self.uploadHandleCount){
                                [SVProgressHUD dismiss];
                                [self.btUpload setEnabled:YES];
                                [self showOneDialogView:[NSString stringWithFormat:@"总计%ld个，%ld个上传成功，%ld个上传失败！",(long)self.uploadCount,(long)self.uploadSuccessCount,(long)self.uploadFailCount]
                                   withRightButtonTitle:@"确定"];
                                return;
                            }
                            [self updatePhoto];
                            
                            
                            
                        });
                    }];
                    
                } failure:^(NSString *errorMessage, NSError *error) {
                    NSLog(@"视频导出失败:%@,error:%@",errorMessage, error);
                }];
            }else{
                url = [NSString stringWithFormat:@"%@%@?AnnexNo=%@",ENTERPRISE_SERVER_HOST,UPLOAD_IMAGE_URL,self.annexNo];
                
                [[TZImageManager manager] getOriginalPhotoWithAsset:asset completion:^(UIImage *image, NSDictionary *info) {
                    
                    [manager POST:url parameters:dict headers:NULL constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                        @try {
                            PHAssetResource * resource = [[PHAssetResource assetResourcesForAsset: asset] firstObject];
                            NSString *tempPrivateFileURL = [resource valueForKey:@"privateFileURL"];
                            NSString * tempFilename = resource.originalFilename;
                            NSString *suffix = [[tempFilename pathExtension] lowercaseString];
                            NSData *data = [NSData dataWithContentsOfFile:tempPrivateFileURL];
                            
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            formatter.dateFormat = [NSString stringWithFormat: @"yyyyMMddHHmmss%ld",(long)self.uploadHandleCount];
                            NSString * mimeType = @"";
                            NSString *fileName =@"";
                            if([suffix isEqualToString: @"jpg"]||[suffix isEqualToString: @"jpeg"]){
                                mimeType = @"image/jpg";
                                fileName = [NSString stringWithFormat:@"%@.jpg",[formatter stringFromDate:[NSDate date]]];
                                [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:mimeType];
                            }else{
                                mimeType = @"image/png";
                                fileName = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];
                                NSData *data = UIImagePNGRepresentation(image);
                                [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:mimeType];
                            }
                        }
                        @catch (NSException *exception) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [SVProgressHUD showErrorWithStatus:@"图片格式处理错误，请重试！"];
                                [self.btUpload setEnabled:YES];});
                        }
                        @finally {
                            
                            
                        }
                    } progress:^(NSProgress * _Nonnull uploadProgress) {
                        NSLog(@"------%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            @try {
                                //
                                [self.arrProgressData replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount]];
                                //                        //刷新的位置，第一个参数代表刷新的第几个cell，第二个参数代表的刷新的第几组（一般我们用到一组的情况比较多，所以这里直接我就默认写的0）
                                //                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                                //                        //开始执行刷新的方法，刷新位置是数组，
                                //                        [self.imagecollectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects: indexPath, nil]];
                                [self.imagecollectionView reloadData];
                                
                            }
                            @catch (NSException *exception) {
                               
                            }
                            @finally {
                                
                                
                            }
                            
                        });
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                        NSString* str = [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:gbkEncoding];
                        
                        NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
                        temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                        temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                        NSDictionary *responseData = [EnterpriseNetwork dictionaryWithJsonString:temp];
                        
                        self.uploadHandleCount = self.uploadHandleCount+1;
                        self.uploadSuccessCount = self.uploadSuccessCount+1;
                        
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            @try {
                                [self->_selectedAssets removeObjectAtIndex:self.uploadFailCount];
                                [self->_selectedPhotos removeObjectAtIndex:self.uploadFailCount];
                                [self->_imagecollectionView reloadData];
                                [self requstOrderList];
                                
                                if(self.uploadCount == self.uploadHandleCount){
                                    [SVProgressHUD dismiss];
                                    [self.btUpload setEnabled:YES];
                        
                                    [self showOneDialogView: [NSString stringWithFormat:@"总计%ld个，%ld个上传成功，%ld个上传失败！",(long)self.uploadCount,(long)self.uploadSuccessCount,(long)self.uploadFailCount]
                                       withRightButtonTitle:@"确定"];
                                    return;
                                }
                                [self updatePhoto];
                            }
                            @catch (NSException *exception) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [SVProgressHUD showErrorWithStatus:@"视频上传成功时，页面处理错误！"];
                                    [self.btUpload setEnabled:YES];});
                            }
                            @finally {
                                
                                
                            }
                        });
                        
                        
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"-----error-%@",error);
                        self.uploadHandleCount = self.uploadHandleCount+1;
                        self.uploadFailCount = self.uploadFailCount+1;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            @try {
                                if(self.uploadCount == self.uploadHandleCount){
                                    [SVProgressHUD dismiss];
                                    
                                    [self.btUpload setEnabled:YES];
                                    
                                    [self showOneDialogView:[NSString stringWithFormat:@"总计%ld个，%ld个上传成功，%ld个上传失败！",(long)self.uploadCount,(long)self.uploadSuccessCount,(long)self.uploadFailCount]
                                       withRightButtonTitle:@"确定"];
                                    return;
                                }
                                [self updatePhoto];
                            }
                            @catch (NSException *exception) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"图片上传失败！%@",error]];
                                    [self.btUpload setEnabled:YES];});
                            }
                            @finally {
                                
                                
                            }
                            
                        });
                    }];
                }];}
            
            
            
            
            
        }
    }
    @catch (NSException *exception) {
        [SVProgressHUD showErrorWithStatus:@"请重试！"];
    }
    @finally {
        
        
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
        [weakView removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
        
    };
    
    [window addSubview:view];
}



- (void)showTwoDialogView:(NSString *) strContent withRightButtonTitle:(NSString *) strRightButtonName
      withLeftButtonTitle:(NSString *) strLeftButtonName withPid:(NSString *) Pid{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    DialogTwoButtonView *view = [DialogTwoButtonView LoadView_FromXib];
    view.frame = window.frame;
    view.laContent.text = strContent;
    [view.btLeft setTitle:strLeftButtonName forState:UIControlStateNormal];
    [view.btRight setTitle:strRightButtonName forState:UIControlStateNormal];
    CGFloat itemHeight = [(NSString *)strContent boundingRectWithSize:CGSizeMake((SCREENWIDTH-80), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    view.constraintViewHeight.constant = 220+itemHeight;
    __weak typeof(view) weakView = view;
    view.confirmBlock  = ^{
        [weakView removeFromSuperview];
        [self requstDeleteUpload:Pid];
    };
    view.cancelBlock = ^{
        [weakView removeFromSuperview];
    };
    [window addSubview:view];
}




- (IBAction)actionUpload:(id)sender {
    if(_selectedAssets.count==0){
        [SVProgressHUD showErrorWithStatus:@"请选择图片或视频！"];
    }else{
        [self uploadImages];
    }
}


@end
