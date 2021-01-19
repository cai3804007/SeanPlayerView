//
//  SeanLandScapeControl.h
//  SeanPlayerView
//
//  Created by yoyochecknow on 2020/5/11.
//  Copyright © 2020 SeanOrganization. All rights reserved.
//

#import <ZFPlayer/ZFPlayer.h>
#import <ZFLandScapeControlView.h>
NS_ASSUME_NONNULL_BEGIN

@interface SeanLandScapeControl : ZFLandScapeControlView
@property (nonatomic,strong) UIButton *speedButton;
@property (nonatomic,assign) BOOL isShowRate;
@end

NS_ASSUME_NONNULL_END
