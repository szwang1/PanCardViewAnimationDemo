//
//  ViewController.m
//  PanCardViewAnimationDemo
//
//  Created by wangshengzhao on 2017/7/20.
//  Copyright © 2017年 UP All rights reserved.
//

#import "ViewController.h"

#define kScreenWidth    self.view.frame.size.width
#define CARDHEIGHT      150
#define CARDWIDTH       250
@interface ViewController ()<UIGestureRecognizerDelegate>{
    UIView          *_commonHeader;
    NSMutableArray  *_cardsArray;
    UIScrollView    *_scroll;
    CGFloat         headPositionY;
}

@end


@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"CARD";
    headPositionY = 150;
    
    //添加卡片
    _cardsArray = [NSMutableArray array];
    UIImage *i1 = [UIImage imageNamed:@"1"];
    UIImage *i2 = [UIImage imageNamed:@"2"];
    UIImage *i3 = [UIImage imageNamed:@"3"];
    UIImage *i4 = [UIImage imageNamed:@"4"];
    UIImage *i5 = [UIImage imageNamed:@"2"];
    UIImage *i6 = [UIImage imageNamed:@"1"];
    [_cardsArray addObjectsFromArray:@[i1,i2,i3,i4,i5,i6]];
    
    //卡片滑动的容器
    _scroll = [[UIScrollView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_scroll];
    _scroll.scrollEnabled = YES;
    _scroll.contentSize = CGSizeMake(kScreenWidth, CARDHEIGHT*_cardsArray.count);
    [self addImages:_cardsArray];
    
    [self commonHeaderWithImg:nil andY:headPositionY];
    [self.view addSubview:_commonHeader];
    UIPanGestureRecognizer* pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    pan.delegate = self;
    [_commonHeader addGestureRecognizer:pan];
    
    //导航栏功能菜单
}

- (UIView*)commonHeaderWithImg:(NSString*)imgName andY:(CGFloat)y{
    _commonHeader = [[UIView alloc]initWithFrame:CGRectMake(0, y, kScreenWidth, 100)];
    UIImageView *head = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth,100)];
    head.image = [UIImage imageNamed:@"5"];
    
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2-40, 25, 80, 80)];
    icon.image = [UIImage imageNamed:imgName];
    
    [_commonHeader addSubview:head];
    [_commonHeader addSubview:icon];
    return _commonHeader;
}

-(void)addImages:(NSArray*)images{
    
    int count=(int)images.count;
    CGFloat gap=10;
    //间隔应该以宽和高进行度量，平分count
    CGFloat normalHeight = 150;
    for (int i=0; i<count; i++) {
        UIImageView *cardView=[[UIImageView alloc]init];
        
        CGFloat dd=(count-i);
        if (i<count) {
            cardView.frame=CGRectMake(gap*dd, 70+gap*i, kScreenWidth-gap*dd*2, normalHeight);
        }
        else
        {
            cardView.frame=CGRectMake((kScreenWidth-CARDWIDTH)/2, gap*count, CARDWIDTH, normalHeight);
        }
        cardView.image=images[i];
        cardView.backgroundColor=[UIColor clearColor];
        cardView.tag=i+1;
        
        [_scroll addSubview:cardView];
    }
}

- (void)pan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translatedPoint = [recognizer translationInView:self.view];//偏移量
    CGFloat x = recognizer.view.center.x ;
    CGFloat y = recognizer.view.center.y + translatedPoint.y;//现在的高度值，用此进行计算。
    recognizer.view.center = CGPointMake(x, y);
    NSInteger count = _cardsArray.count;
    
    CGFloat offsetY = fabs(y-headPositionY);
    CGFloat scale = offsetY/CARDHEIGHT;
    if (scale>=1) {scale = 1;}
    CGFloat xgap = 20*scale;
    CGFloat ygap = 160*scale;
    
    if (translatedPoint.y>0 && offsetY<500) {//向下滑动
        [UIView animateWithDuration:1 animations:^{
            for (int i=1; i<count+1; i++){
                CGFloat dd=(count+1-i);
                //frame重置
                CGFloat width = (kScreenWidth-xgap*dd*2)>=CARDWIDTH?CARDWIDTH:kScreenWidth-xgap*dd*2;
                CGFloat newX = (width=CARDWIDTH)?(kScreenWidth-CARDWIDTH)/2:xgap*dd;
                CGFloat newY = ygap*(i-1)*scale+50;
                [[_scroll viewWithTag:i] setFrame:CGRectMake(newX, newY, width, CARDHEIGHT)];
            }
        } completion:^(BOOL finished) {
            
        }];
        
    }else{//向上滑动
        [UIView animateWithDuration:1 animations:^{
            for (int i=1; i<count+1; i++){
                CGFloat dd=(count+1-i);
                //frame重置
                CGFloat width = (kScreenWidth-xgap*dd*2)<CARDWIDTH?kScreenWidth-xgap*dd*2:CARDWIDTH;
                CGFloat newX = (width=CARDWIDTH)?(kScreenWidth-CARDWIDTH)/2:xgap*dd;
                CGFloat newY = ygap*(i-1)*scale+50;
                [[_scroll viewWithTag:i] setFrame:CGRectMake(newX, newY, width, CARDHEIGHT)];
                
            }
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
    //滑动的上下底线
    if (y<64) {
        y = 64;
        recognizer.view.center = CGPointMake(x, y);
    }
    if (y>CGRectGetHeight(self.view.frame)) {
        y =CGRectGetHeight(self.view.frame);
        recognizer.view.center = CGPointMake(x, y);
        
    }
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
}




@end
