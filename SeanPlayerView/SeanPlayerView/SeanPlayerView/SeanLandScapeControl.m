//
//  SeanLandScapeControl.m
//  SeanPlayerView
//
//  Created by yoyochecknow on 2020/5/11.
//  Copyright © 2020 SeanOrganization. All rights reserved.
//

#import "SeanLandScapeControl.h"
#import "ZFUtilities.h"
#import "UIView+ZFFrame.h"
#import "SeanSpeedView.h"
@interface SeanLandScapeControl ()
@property (nonatomic,strong) SeanSpeedView *speedView;

@property (nonatomic,assign) CGFloat silderW;
@property (nonatomic,assign) BOOL first;
@end


@implementation SeanLandScapeControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.speedView.seletedRate = ^(CGFloat rate) {
            NSLog(@"%f倍速",rate);
        };
    }
    return self;
}


-(void)setIsShowRate:(BOOL)isShowRate{
    _isShowRate = isShowRate;
    if (isShowRate) {
        [self.bottomToolView addSubview:self.speedButton];
    }else{
        [self.speedButton removeFromSuperview];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat min_margin = 9;
    CGFloat  min_w = 62;
    CGFloat rateW = self.isShowRate ? 50 : 0;
    CGFloat  min_x = self.bottomToolView.zf_width - min_w - ((iPhoneX && self.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape) ? 44: min_margin) - rateW;
    CGFloat min_y = 0;
    CGFloat  min_h = 30;
    self.totalTimeLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.totalTimeLabel.zf_centerY = self.playOrPauseBtn.zf_centerY;
    
    min_x = self.currentTimeLabel.zf_right + 4;
    min_y = 0;
    min_w = self.totalTimeLabel.zf_left - min_x - 4;
    min_h = 30;
    self.slider.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.slider.zf_centerY = self.playOrPauseBtn.zf_centerY;
    self.speedButton.frame = CGRectMake(CGRectGetMaxX( self.totalTimeLabel.frame), 0, 50, 30);
    self.speedButton.zf_centerY = self.playOrPauseBtn.zf_centerY;
}


- (void)speedButtonClick:(UIButton *)sender{
    
     [self addSubview:self.speedView];
     [self.speedView showMe];
}


- (BOOL)shouldResponseGestureWithPoint:(CGPoint)point withGestureType:(ZFPlayerGestureType)type touch:(nonnull UITouch *)touch {
    if (self.speedView.isShow) {
        return NO;
    }

    CGRect sliderRect = [self.bottomToolView convertRect:self.slider.frame toView:self];
    if (CGRectContainsPoint(sliderRect, point)) {
        return NO;
    }
    if (self.player.isLockedScreen && type != ZFPlayerGestureTypeSingleTap) { // 锁定屏幕方向后只相应tap手势
        return NO;
    }
    return YES;
}




-(UIButton *)speedButton{
    if (!_speedButton) {
        _speedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_speedButton setTitle:@"倍速" forState:UIControlStateNormal];
        _speedButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_speedButton addTarget:self action:@selector(speedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _speedButton;
}


-(SeanSpeedView *)speedView{
    if (!_speedView) {
        _speedView = [[SeanSpeedView alloc] initWithFrame:CGRectMake(0, 0, ZFPlayer_ScreenHeight,ZFPlayer_ScreenWidth)];
        _speedView.speeds = @[@(0.5),@(1),@(1.25),@(1.5),@(2)];
      
    }
    return _speedView;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
