//
//  SeanPlayerView.h
//  SeanPlayerView
//
//  Created by yoyochecknow on 2019/9/6.
//  Copyright © 2019 SeanOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SeanPlayerView : UIView

-(instancetype)initWithFrame:(CGRect)frame needSpeed:(BOOL)speed;


@property (nonatomic,weak)  UIViewController *presentVC;
@property (nonatomic,strong) NSURL *url;
@property (nonatomic,assign) BOOL isFullScreen;
@property (nonatomic,assign) BOOL shouldAutorotate;
@property (nonatomic,copy) NSString *coverImage;


- (void)setRate:(CGFloat)rate;

- (void)setSpeeds:(NSArray *)array;


- (void)play;
- (void)pause;
- (void)stop;
@end

NS_ASSUME_NONNULL_END
