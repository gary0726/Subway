//
//  DisplayView.h
//  SubWay
//
//  Created by apple on 14-3-24.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StartEndView.h"
#import "Constants.h"
#import "InfoViewController.h"
#import <MapKit/MapKit.h>
#import "TopView.h"

@protocol StartAndEndTextValueDelegate <NSObject>

@optional
-(void)startFieldText:(NSString *)s;
-(void)endFieldText:(NSString *)e;
-(void)passScaleValue:(float)scaleV;

@end

@interface DisplayView : UIView
<UIScrollViewDelegate,StartEndInfoDelegate>
{
    CGPoint pt;
    CGPoint pt1;
    NSString *mapx;
    NSString *mapy;
    NSString *mapx1;
    NSString *mapy1;
    
    BOOL startMark;
    BOOL endMark;
    NSString *place;
    NSString *englishName;
    NSMutableArray *infoArray;
    NSMutableArray *arrayLine;
    NSMutableArray *arrayStartAndEndTime;
    NSDictionary *dictLocation;
    
    NSDictionary *minDistanceDic;
}

@property(nonatomic,retain)UIScrollView *scrollView;
@property(nonatomic,retain)UIImageView *imageView;

@property(nonatomic,assign)id<StartAndEndTextValueDelegate>delegate;
@end
