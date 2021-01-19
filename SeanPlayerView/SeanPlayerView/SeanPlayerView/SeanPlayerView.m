//
//  SeanPlayerView.m
//  SeanPlayerView
//
//  Created by yoyochecknow on 2019/9/6.
//  Copyright © 2019 SeanOrganization. All rights reserved.
//

#import "SeanPlayerView.h"
#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFPlayerControlView.h>
#import <ZFUtilities.h>
#import <ZFAVPlayerManager.h>
#import "SeanSpeedView.h"
#import "SeanPlayerControlView.h"
@interface SeanPlayerView ()
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic,strong) SeanPlayerControlView *seanControlView;


@property (nonatomic,strong) SeanSpeedView *speedView;

@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) UIImageView *containerView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic,strong) ZFAVPlayerManager *playerManager;

@property (nonatomic,assign) ZFPlayerPlaybackState playerState;
@property (nonatomic,assign) BOOL isNeedSpeed;
@end



@implementation SeanPlayerView

-(instancetype)initWithFrame:(CGRect)frame needSpeed:(BOOL)speed{
    self = [super initWithFrame:frame];
      if (self) {
          _isNeedSpeed = speed;
          [self configUI];
          self.layer.cornerRadius = 5;
      }
      return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
        self.layer.cornerRadius = 5;
    }
    return self;
}


- (void)configUI{
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    /// 播放器相关
    _playerManager = playerManager;

    
    
    
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
    if (self.isNeedSpeed) {
        self.player.controlView = self.seanControlView;
//        self.seanControlView.
        
        
    }else{
        self.player.controlView = self.controlView;
    }
    
    
    
    
    /// 设置退到后台继续播放
    self.player.pauseWhenAppResignActive = YES;
    @weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self.presentVC setNeedsStatusBarAppearanceUpdate];
    };
    
    /// 播放完成
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        self.playBtn.selected = NO;
        self.playBtn.hidden = NO;
        [self.playerManager stop];
     };
    self.playerState = ZFPlayerPlayStatePlayStopped;
    self.player.playerPlayStateChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, ZFPlayerPlaybackState playState) {
        @strongify(self)
        if ([asset.assetURL isEqual:self.url]) {
            self.playerState = playState;
        }
        if (playState == ZFPlayerPlayStatePaused) {
            self.playBtn.selected = YES;
            self.playBtn.hidden = NO;
        }else if(playState == ZFPlayerPlayStatePlaying) {
            self.playBtn.selected = NO;
            self.playBtn.hidden = YES;
        }
    };
    
    
    [self addSubview:self.containerView];
    
    
    
   self.containerView.frame = self.bounds;
   CGFloat w = 44;
   CGFloat h = w;
   CGFloat x = (CGRectGetWidth(self.containerView.frame)-w)/2;
   CGFloat y = (CGRectGetHeight(self.containerView.frame)-h)/2;
   self.playBtn.frame = CGRectMake(x, y, w, h);
   [self addSubview:self.playBtn];

}






-(void)setCoverImage:(NSString *)coverImage{
    _coverImage = coverImage;
    //设置展占
//    [self.containerView sd_setImageWithURL:[NSURL URLWithString:coverImage] placeholderImage:[UIImage rectangleDefault]];
    
}
- (void)setRate:(CGFloat)rate{
    
    
    
}



- (void)play{
    self.player.assetURL = self.url;
    [self.controlView showTitle:@"" coverURLString:self.coverImage fullScreenMode:ZFFullScreenModeAutomatic];
    self.playBtn.hidden = YES;
    [self.player playTheIndex:0];
}
- (void)pause{
    if ([self.playerManager isPlaying]) {
        [self.playerManager pause];
    }
    
}
- (void)stop{
    [self.player stop];
}

- (void)comePlay{
    if (self.playerState == ZFPlayerPlayStatePaused) {
        [self.playerManager play];
    }else{
        self.player.assetURL = self.url;
        [self.controlView showTitle:@"" coverURLString:self.coverImage fullScreenMode:ZFFullScreenModeAutomatic];
        self.playBtn.hidden = YES;
        [self.player playTheIndex:0];
    }
}

- (UIImageView *)containerView {
    if (!_containerView) {
        _containerView = [UIImageView new];
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.coverImage]];
        UIImage *image = [UIImage imageWithData:data];
//        [_containerView setImageWithURLString:kVideoCover placeholder:[ZFUtilities imageWithColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1] size:CGSizeMake(1, 1)]];
        _containerView.contentMode = UIViewContentModeScaleAspectFill;
        _containerView.image = image;
//        _containerView.backgroundColor = [UIColor blueColor];
    }
    return _containerView;
}
- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
        _controlView.autoHiddenTimeInterval = 3;
        _controlView.autoFadeTimeInterval = 0.5;
        _controlView.prepareShowLoading = YES;
        _controlView.prepareShowControlView = YES;
    }
    return _controlView;
}

-(SeanPlayerControlView *)seanControlView{
    if (!_seanControlView) {
        _seanControlView = [[SeanPlayerControlView alloc] init];
//        _seanControlView.fastViewAnimated = YES;
        _seanControlView.autoHiddenTimeInterval = 3;
        _seanControlView.autoFadeTimeInterval = 0.5;
//        _seanControlView.prepareShowLoading = YES;
//        _seanControlView.prepareShowControlView = YES;
    }
    return _seanControlView;
}







- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"class_play_button"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"class_play_button"] forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(comePlay) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.containerView.frame = self.bounds;
    CGFloat w = 44;
    CGFloat h = w;
    CGFloat x = (CGRectGetWidth(self.containerView.frame)-w)/2;
    CGFloat y = (CGRectGetHeight(self.containerView.frame)-h)/2;
    self.playBtn.frame = CGRectMake(x, y, w, h);
}

-(BOOL)isFullScreen{
    return self.player.isFullScreen;
}

-(BOOL)shouldAutorotate{
    return self.player.shouldAutorotate;
}

-(SeanSpeedView *)speedView{
    if (!_speedView) {
        _speedView = [[SeanSpeedView alloc] initWithFrame:self.controlView.bounds];
        [self.seanControlView addSubview:_speedView];
    }
    return _speedView;
}




-(void)dealloc{
      [self.player stop];
    NSLog(@"%@=====%@",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
}
@end
