//
//  SeanSpeedControl.h
//  SeanPlayerView
//
//  Created by yoyochecknow on 2020/5/9.
//  Copyright © 2020 SeanOrganization. All rights reserved.
//

#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayerControlView.h>
NS_ASSUME_NONNULL_BEGIN

@interface SeanSpeedControl : ZFPlayerControlView

@property (nonatomic,assign) BOOL isShowSpeed;

- (void)setPlayerRate:(CGFloat)rate;
@end

NS_ASSUME_NONNULL_END
