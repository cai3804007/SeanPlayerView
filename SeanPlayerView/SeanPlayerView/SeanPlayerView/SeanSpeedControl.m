//
//  SeanSpeedControl.m
//  SeanPlayerView
//
//  Created by yoyochecknow on 2020/5/9.
//  Copyright © 2020 SeanOrganization. All rights reserved.
//

#import "SeanSpeedControl.h"
#import "SeanLandScapeControl.h"

@interface SeanSpeedControl ()

@end



@implementation SeanSpeedControl
@synthesize landScapeControlView = _landScapeControlView;


- (void)setPlayerRate:(CGFloat)rate{
    self.player.currentPlayerManager.rate = rate;
    
}
-(void)setIsShowSpeed:(BOOL)isShowSpeed{
    _isShowSpeed = isShowSpeed;
    SeanLandScapeControl *con = (SeanLandScapeControl *)self.landScapeControlView;
    [con setIsShowRate:isShowSpeed];
    
}

 

- (ZFLandScapeControlView *)landScapeControlView {
    if (!_landScapeControlView) {
        @weakify(self)
        _landScapeControlView = (ZFLandScapeControlView *)[[SeanLandScapeControl alloc] init];
        _landScapeControlView.sliderValueChanging = ^(CGFloat value, BOOL forward) {
            @strongify(self)
            [self cancelAutoFadeOutControlView];
        };
        _landScapeControlView.sliderValueChanged = ^(CGFloat value) {
            @strongify(self)
            [self autoFadeOutControlView];
        };
    }
    return _landScapeControlView;
}
@end
