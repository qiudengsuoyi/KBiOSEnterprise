//
//  PictureCanDeleteCollectionViewCell.m
//  einstallationCompany
//
//  Created by 云位 on 2023/9/17.
//

#import "PictureCanDeleteCollectionViewCell.h"
#import <SDWebImage/SDWebImage.h>
#import <AVFoundation/AVFoundation.h>

@implementation PictureCanDeleteCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setPicture{
    if([self.pictureModel.thumbnail isEqualToString:@""]){
        self.deleteBtn.hidden = YES;
    }else{
        self.deleteBtn.hidden = NO;
    }
    [self.iv sd_setImageWithURL:[NSURL URLWithString:self.pictureModel.thumbnail]
                 placeholderImage:[UIImage imageNamed:@"picture_occupy.png"]];
    
    
 
}


-(void)setVideo{
    if([self.pictureModel.images isEqualToString:@""]){
        self.deleteBtn.hidden = YES;
    }else{
        self.deleteBtn.hidden = NO;
    }
    NSURL *videoURL = [NSURL URLWithString:self.pictureModel.images];

    if(![self.pictureModel.images isEqualToString:@""]){
        // 初始化AVAsset对象
        AVAsset *asset = [AVAsset assetWithURL:videoURL];
        
        // 初始化AVAssetImageGenerator对象
        AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
        
        // 设置时间点，获取第一帧图像
        CMTime time = kCMTimeZero;
        NSError *error = nil;
        CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:&error];
        
        if (imageRef != NULL) {
            // 将图像转换为UIImage
            UIImage *firstFrameImage = [UIImage imageWithCGImage:imageRef];
            [self.iv setImage:firstFrameImage];
            // 释放CGImageRef
            CGImageRelease(imageRef);
            
            // 现在，firstFrameImage包含了视频的第一帧图像
            // 您可以在需要的地方使用这个UIImage对象
        } else {
            NSLog(@"获取视频第一帧图像失败，错误：%@", [error localizedDescription]);
        }
    }else{
        [self.iv sd_setImageWithURL:[NSURL URLWithString:self.pictureModel.thumbnail]
                     placeholderImage:[UIImage imageNamed:@"picture_occupy.png"]];
    }
 
}

@end
