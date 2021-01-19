//
//  ViewController.m
//  SeanPlayerView
//
//  Created by yoyochecknow on 2019/10/31.
//  Copyright © 2019 SeanOrganization. All rights reserved.
//

#import "ViewController.h"
#import "SeanPlayerControlView.h"
#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <UIImageView+ZFCache.h>
#import <ZFUtilities.h>
#import "SeanSpeedView.h"
static NSString *kVideoCover = @"https://upload-images.jianshu.io/upload_images/635942-14593722fe3f0695.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240";
@interface ViewController ()
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UIImageView *containerView;
@property (nonatomic, strong) SeanPlayerControlView *controlView;
@property (nonatomic,strong) SeanSpeedView *speedView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
 
  //  self.controlView.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.width*9.0/16.0);
    self.controlView.isShowRate = YES;
    self.speedView.speeds = @[@(1.2),@(1.5),@(1.8),@(2.0)];
    @weakify(self);
    self.controlView.speedButtonBlock = ^{
        @strongify(self);
        [self.speedView showMe];
    };
    self.speedView.seletedRate = ^(CGFloat rate) {
         @strongify(self);
        [self.controlView setPlayerRate:rate];
    };
    
    [self configUIP];

    [self.view addSubview:self.controlView];
}






- (void)configUIP{
    
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    /// 播放器相关
     self.controlView.isShowRate = YES;
    self.controlView.speedButtonBlock = ^{
        
    };
    
    self.containerView.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.width*9.0/16.0);
    
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
    self.player.controlView = self.controlView;
    /// 设置退到后台继续播放
    self.player.pauseWhenAppResignActive = NO;
   
 
    
    @weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
    };
    
    
    
    /// 播放完成
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        [self.player.currentPlayerManager replay];
        [self.player playTheNext];
        if (!self.player.isLastAssetURL) {
            NSString *title = [NSString stringWithFormat:@"视频标题%zd",self.player.currentPlayIndex];
            [self.controlView showTitle:title coverURLString:kVideoCover fullScreenMode:ZFFullScreenModeLandscape];
        } else {
            [self.player stop];
        }
    };
    
    NSString *URLString = [@"http://flv3.bn.netease.com/tvmrepo/2018/6/H/9/EDJTRBEH9/SD/EDJTRBEH9-mobile.mp4" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    playerManager.assetURL = [NSURL URLWithString:URLString];
    [self.controlView showTitle:@"" coverURLString:kVideoCover fullScreenMode:ZFFullScreenModeAutomatic];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.player.viewControllerDisappear = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.player.viewControllerDisappear = YES;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat x = 0;
    CGFloat y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    CGFloat w = CGRectGetWidth(self.view.frame);
    CGFloat h = w*9/16;
    self.containerView.frame = CGRectMake(x, y, w, h);
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    /// 如果只是支持iOS9+ 那直接return NO即可，这里为了适配iOS8
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (BOOL)shouldAutorotate {
    return self.player.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.player.isFullScreen) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (SeanPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [SeanPlayerControlView new];
    }
    return _controlView;
}

- (UIImageView *)containerView {
    if (!_containerView) {
        _containerView = [UIImageView new];
        [_containerView setImageWithURLString:kVideoCover placeholder:[ZFUtilities imageWithColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1] size:CGSizeMake(1, 1)]];
    }
    return _containerView;
}

-(SeanSpeedView *)speedView{
    if (!_speedView) {
        _speedView = [[SeanSpeedView alloc] initWithFrame:self.controlView.bounds];
        [self.controlView addSubview:_speedView];
    }
    return _speedView;
}
@end

