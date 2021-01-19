//
//  SeanSpeedView.m
//  SeanPlayerView
//
//  Created by yoyochecknow on 2019/11/1.
//  Copyright © 2019 SeanOrganization. All rights reserved.
//

#import "SeanSpeedView.h"


@interface SeanSpeedViewCell : UITableViewCell
@property (nonatomic,strong) UILabel *speedLabel;

@end
@implementation SeanSpeedViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _speedLabel = [[UILabel alloc]init];
        _speedLabel.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_speedLabel];
//        self.backgroundView = [[UIView alloc]initWithFrame:self.contentView.bounds];
//        self.backgroundView.backgroundColor = [UIColor colorWithRed:47/255.0 green:47/255.0 blue:47/255.0 alpha:1];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.speedLabel.frame = self.contentView.bounds;
    self.speedLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end


@interface SeanSpeedView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *contentView;
@end




@implementation SeanSpeedView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
//        self.alpha = 0.3;
        self.contentView = [[UIView alloc]initWithFrame:self.bounds];
        [self addSubview:self.contentView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenMe)];
        [self.contentView addGestureRecognizer:tap];
        [self configUI];
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hiddenMe];
}


- (void)showMe{
    self.isShow = YES;
    self.hidden = NO;
    self.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }];
}

- (void)hiddenMe{
    self.isShow = NO;
    [UIView animateWithDuration:1.0 animations:^{
        self.frame = CGRectMake(self.frame.size.width, 0, self .frame.size.width, self.frame.size.height);
    }];
}


- (void)configUI{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width * 0.7, 0, self.frame.size.width * 0.3, self.frame.size.height)];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.8;
    view.userInteractionEnabled = YES;
    [self addSubview:view];
    
    UITableView *table = [[UITableView alloc]initWithFrame:view.frame];
    [self addSubview:table];
    
//    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(self.frame.size.width * 0.7, 0, self.frame.size.width * 0.3, self.frame.size.height)];
//    [self addSubview:table];
    if (@available(iOS 11.0, *)) {
        table.contentInsetAdjustmentBehavior  = UIScrollViewContentInsetAdjustmentNever;
    }
    table.delegate = self;
    table.dataSource = self;
    _tableView = table;
    table.bounces = NO;
    table.backgroundColor = [UIColor clearColor];
//    table.separatorColor = [UIColor whiteColor];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table registerClass:[SeanSpeedViewCell class] forCellReuseIdentifier:@"cell"];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = self.frame.size.height/self.speeds.count;
    return  height;
    
}

-(void)setSpeeds:(NSArray *)speeds{
    _speeds = speeds;
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.speeds.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SeanSpeedViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    CGFloat rate = [self.speeds[indexPath.row] floatValue];
    cell.speedLabel.text = [NSString stringWithFormat:@"%.2fx",rate];
    cell.speedLabel.textAlignment = NSTextAlignmentCenter;
    cell.speedLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self hiddenMe];
    if (self.seletedRate) {
        CGFloat rate = [self.speeds[indexPath.row] floatValue];
        NSLog(@"%@",[NSString stringWithFormat:@"%.2f倍速",rate]);
        self.seletedRate(rate);
    }
}




@end
