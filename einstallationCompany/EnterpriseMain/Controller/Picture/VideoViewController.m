//
//  VideoViewController.m
//  einstallationCompany
//
//  Created by 云位 on 2023/9/10.
//

#import "VideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface VideoViewController ()
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@end

@implementation VideoViewController

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    // 设置playerLayer的frame属性以充满整个视图
    self.playerLayer.frame = self.view.bounds;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackItem];
    self.navigationItem.title = @"视频";
    // 指定远程视频文件的URL
    NSURL *videoURL = [NSURL URLWithString:self.videoURL];
 
    // 初始化AVPlayer对象
    self.player = [AVPlayer playerWithURL:videoURL];

    // 创建AVPlayerLayer并将其添加到视图中
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.playerLayer];
    
    // 开始播放视频
    [self.player play];
}


@end
