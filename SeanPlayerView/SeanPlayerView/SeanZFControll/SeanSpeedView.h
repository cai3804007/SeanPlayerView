//
//  SeanSpeedView.h
//  SeanPlayerView
//
//  Created by yoyochecknow on 2019/11/1.
//  Copyright © 2019 SeanOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SeanSpeedView : UIView
//是否在显示状态
@property (nonatomic,assign) BOOL isShow;

@property (nonatomic,strong) NSArray *speeds;

@property (nonatomic,copy) void (^hiddenSpeedView)(void);

- (void)showMe;
- (void)hiddenMe;

@property (nonatomic,copy) void (^seletedRate)(CGFloat rate);


@end

NS_ASSUME_NONNULL_END
