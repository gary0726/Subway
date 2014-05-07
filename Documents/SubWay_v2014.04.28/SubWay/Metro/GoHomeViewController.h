//
//  GoHomeViewController.h
//  SubWay
//
//  Created by Gary on 14-4-25.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Dijkstra.h"
#import "MBProgressHUD.h"
#import "SelectHomeViewController.h"

#import "LineStationView.h"
#import <math.h>
#import "Constants.h"
#import "SqliteDao.h"
#import "InfoViewController.h"


@interface GoHomeViewController : UIViewController
<CLLocationManagerDelegate,UIActionSheetDelegate,
UIAlertViewDelegate>
{
    CLLocationManager *locationManager;
    NSString *homeFlag;
    
    LineStationView *stationView;
    NSMutableArray *changeArray1;
    
    Dijkstra *d;
    
    NSMutableArray *sortPassStationArray;
     NSString *direction;
}
@property(nonatomic,retain)UILabel *detailLabel;
@property(nonatomic,retain)UILabel *startTimeLabel;
@property(nonatomic,retain)UILabel *endTimeLabel;

@property(nonatomic,retain)UIScrollView *sc;
@property(nonatomic,retain)UIView *startView;
@property(nonatomic,retain)UIView *endView;

@property(nonatomic,retain)UIImageView *startKuangImage1;
@property(nonatomic,retain)UILabel *startPlace1;

@property(nonatomic,retain)UIImageView *startKuangImage2;
@property(nonatomic,retain)UILabel *endPlace2;
@property(nonatomic,retain)NSMutableArray *array;
@property(nonatomic,retain)NSString *price;//票价



@property (weak, nonatomic) IBOutlet UIView *titleView;
- (IBAction)backAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *StartEndVuew;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
- (IBAction)settingAction:(id)sender;
- (IBAction)moveAction:(id)sender;



@end
