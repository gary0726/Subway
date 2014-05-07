//
//  SelectCompanyViewController.m
//  SubWay
//
//  Created by Gary on 14-4-25.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "SelectCompanyViewController.h"

extern NSMutableArray *allStationArray;

@interface SelectCompanyViewController ()

@end

@implementation SelectCompanyViewController
@synthesize searchAPI;
@synthesize flag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dict=[[NSMutableDictionary alloc]init];
    
    self.searchAPI = [[AMapSearchAPI alloc] initWithSearchKey:[APIKey gaoDeAPIKey] Delegate:self];
    
    if(iOS7){
        [_topView setBackgroundColor:[UIColor colorWithRed:0.22 green:0.7 blue:0.76 alpha:0.9]];
        //_topView.frame=CGRectMake(0,0,320,160);
    }
    else{
        [_topView setBackgroundColor:[UIColor colorWithRed:0.22 green:0.7 blue:0.76 alpha:0.9]];
        _topView.frame=CGRectMake(0,0,320,60);
    }
    
    [self initMap];
    [self addBtnToMapView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) initMap{
    maMapView = [[MAMapView alloc] initWithFrame:CGRectMake(0,60,320,CGRectGetHeight(self.view.frame)-60)];
    maMapView.showsUserLocation = YES;
    maMapView.userTrackingMode = MAUserTrackingModeFollow;
    maMapView.delegate = self;
    [maMapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES];
    [self.view addSubview:maMapView];
    maMapView.showsScale  = NO;
    maMapView.showsCompass = NO;
    maMapView.zoomLevel = 15;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    label.backgroundColor = [UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:0.8];
    label.text = @"长按图标来选定地点";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    [maMapView addSubview:label];
    
    //创建长按事件
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.delegate = self;
    longPress.minimumPressDuration = 0.5;
    [maMapView addGestureRecognizer:longPress];
}
-(void) addBtnToMapView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 65.0f, 100, 60, 160)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 160)];
    imageView.image = [UIImage imageNamed:@"iPhone_bg_kuang_3"];
    
    UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 43)];
    selectBtn.tag = 0;
    UIButton *locationBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 43, 60, 43)];
    locationBtn.tag = 1;
    UIButton *myHomeOrWork = [[UIButton alloc] initWithFrame:CGRectMake(0, 86, 60, 44)];
    myHomeOrWork.tag = 2;
    
    [selectBtn addTarget:self action:@selector(setMapCenterCoordinateFromBtn:) forControlEvents:UIControlEventTouchUpInside];
    [locationBtn addTarget:self action:@selector(setMapCenterCoordinateFromBtn:) forControlEvents:UIControlEventTouchUpInside];
    [myHomeOrWork addTarget:self action:@selector(setMapCenterCoordinateFromBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:selectBtn];
    [view addSubview:locationBtn];
    [view addSubview:myHomeOrWork];
    
    [view setAlpha:0.8];
    [view addSubview:imageView];
    [maMapView addSubview:view];
}

#pragma mark - Gesture
- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress{
    if ([longPress state] == UIGestureRecognizerStateBegan) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"查询中请稍后...";
        hud.mode = MBProgressHUDModeCustomView;
        
        CGPoint point = [longPress locationInView:maMapView];
        CLLocationCoordinate2D coordinate = [maMapView convertPoint:point toCoordinateFromView:maMapView];
        [self searchReGeocodeWithCoordinate:coordinate];
    }
}
-(void) searchReGeocodeWithCoordinate:(CLLocationCoordinate2D) coordinate{
    AMapReGeocodeSearchRequest *reGeocodeSearchRequest = [[AMapReGeocodeSearchRequest alloc] init];
    reGeocodeSearchRequest.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    reGeocodeSearchRequest.requireExtension = YES;
    reGeocodeSearchRequest.searchType = AMapSearchType_ReGeocode;
    
    [searchAPI AMapReGoecodeSearch:reGeocodeSearchRequest];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
-(void) setMapCenterCoordinateFromBtn:(id) sender{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    UIButton *btn = (UIButton *) sender;
    if (btn.tag == 0 && userLongPressAnnotation != nil) {
        maMapView.centerCoordinate = userLongPressAnnotation.coordinate;
        [maMapView selectAnnotation:userLongPressAnnotation animated:YES];
    }
    if (btn.tag == 1) {
        maMapView.centerCoordinate = maMapView.userLocation.coordinate;
    }
    if (btn.tag == 2 && homeOrWorkAnnotation != nil) {
        maMapView.centerCoordinate = homeOrWorkAnnotation.coordinate;
        [maMapView selectAnnotation:homeOrWorkAnnotation animated:YES];
    }
    [UIView commitAnimations];
}

//查询结果 回调
-(void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (response.regeocode != nil) {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(request.location.latitude, request.location.longitude);
        
        [dict setObject:[NSNumber numberWithFloat:request.location.latitude] forKey:[NSString stringWithFormat:@"%f",request.location.longitude]];
        
        if (userLongPressAnnotation != nil) {
            [maMapView removeAnnotation:userLongPressAnnotation];
        }
        
        userLongPressAnnotation = [[MAPointAnnotation alloc] init];
        userLongPressAnnotation.coordinate = coordinate;
        
        
        userLongPressAnnotation.title = @"选此处为我的公司";
        
        userLongPressAnnotation.subtitle = [NSString stringWithFormat:@"%@%@%@%@%@",response.regeocode.addressComponent.city,
                                            response.regeocode.addressComponent.district,
                                            response.regeocode.addressComponent.township,
                                            response.regeocode.addressComponent.neighborhood,
                                            response.regeocode.addressComponent.building
                                            ];
        [maMapView addAnnotation:userLongPressAnnotation];
    }
}

-(void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    MAAnnotationView *view = views[0];
    [maMapView selectAnnotation:view.annotation animated:YES];
}

-(void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    if ([view.annotation isKindOfClass:[MAPointAnnotation class]]) {
        _companyText.text =userLongPressAnnotation.subtitle;
    }
}

-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        //MAPointAnnotation *poinAnnotation  = (MAPointAnnotation *) annotation;
        
        static NSString *geoIdentifier = @"geoIdentifier";
        
        MAPinAnnotationView *pinAnnotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:geoIdentifier];
        
        if (pinAnnotationView == nil) {
            pinAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:geoIdentifier];
        }
        pinAnnotationView.canShowCallout = YES;
        pinAnnotationView.animatesDrop =YES;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [btn setImage:[UIImage imageNamed:@"iPhone_btn_queren_1_0"] forState:UIControlStateNormal];
        
        pinAnnotationView.rightCalloutAccessoryView = btn;
        
        UIView *homeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,30, 30)];
        UIImageView *homeImageView = [[UIImageView alloc] initWithFrame:homeView.frame];
        homeImageView.image = [UIImage imageNamed:@"iPhone_btn_shangban_0_1"];
        [homeView addSubview:homeImageView];
        pinAnnotationView.leftCalloutAccessoryView = homeView;
        
        pinAnnotationView.pinColor = MAPinAnnotationColorPurple;
        return pinAnnotationView;
    }
    return nil;
}

//-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
//    if (updatingLocation)
//    {
//        NSLog(@"用户：%f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
//    }
//}
-(void)search:(id)searchRequest error:(NSString *)errInfo{
    //已断开与互联网的链接
    if ([errInfo rangeOfString:@"NSURLErrorDomain"].location != NSNotFound) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"似乎没有网络";
        HUD.mode = MBProgressHUDModeText;
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(1.5);
        } completionBlock:^{
            [HUD removeFromSuperview];
        }];
    }
    if ([searchRequest isKindOfClass:[AMapReGeocodeSearchRequest class]]) {
        NSLog(@"定位错误。%@",errInfo);
        AMapReGeocodeSearchRequest *request = (AMapReGeocodeSearchRequest *) searchRequest;
        if ([errInfo isEqualToString:@"INVALID_USER_KEY"] || [errInfo isEqualToString:@"INVALID_PARAMS"] || [errInfo isEqualToString:@"UNKNOWN_ERROR"]) {
            //网络延迟 或者 信号不好 出现的问题，重新去查询
            AMapReGeocodeSearchRequest *newRequest  = [[AMapReGeocodeSearchRequest alloc] init];
            newRequest.searchType = AMapSearchType_ReGeocode;
            newRequest.location = request.location;
            [self.searchAPI AMapReGoecodeSearch:newRequest];
            return;
        }
    }
}

- (IBAction)backAction:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)sureAction:(id)sender {
    if([flag isEqualToString:@"1"])//二级界面进来的
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否更改公司的设置" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else
    {
        if(_companyText.text.length>0)
        {
            NSMutableDictionary *minDistanceDic=[[NSMutableDictionary alloc]init];
            
            for (int i=0; i<[allStationArray count]; i++)
            {
                if([[[allStationArray objectAtIndex:i] objectForKey:@"ZOPEN"]floatValue]==1)
                {
                    //查询数据库得到
                    float a= [[[allStationArray objectAtIndex:i] objectForKey:@"ZLATITUDE"] floatValue];
                    float b= [[[allStationArray objectAtIndex:i] objectForKey:@"ZLONGITUDE"] floatValue];
                    //定位得出的
                    float c=[[[dict allValues] objectAtIndex:0] floatValue];
                    float d=[[[dict allKeys] objectAtIndex:0] floatValue];
                    
                    CLLocation *location=[[CLLocation alloc] initWithLatitude:a longitude:b];
                    CLLocationDistance distance=[location distanceFromLocation:[[CLLocation alloc] initWithLatitude:c longitude:d]];
                    
                    [minDistanceDic setValue:[NSNumber numberWithFloat:distance] forKey:[[allStationArray objectAtIndex:i]objectForKey:@"ZNAME"]];
                }
            }
            NSArray *ar=[minDistanceDic allValues];
            ar=[ar sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                NSComparisonResult result = [obj1 compare:obj2];
                return result==NSOrderedDescending;
            }];
            [minDistanceDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                float a=[obj floatValue];
                float b=[[ar objectAtIndex:0] floatValue];
                if(a==b)
                {
                    [[NSUserDefaults standardUserDefaults] setObject:key forKey:@"company"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    NSLog(@"自定义离公司最近的地铁站：%@",key);
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"companyText" object:key];//home的位置变化
                }
            }];
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view.superview addSubview:HUD];
            HUD.labelText = @"设置成功，欢迎体验一键上班";
            HUD.mode = MBProgressHUDModeText;
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(1.5);
            } completionBlock:^{
                [HUD removeFromSuperview];
            }];
        }
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}
#pragma mark -alert delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        if(_companyText.text.length>0)
        {
            NSMutableDictionary *minDistanceDic=[[NSMutableDictionary alloc]init];
            
            for (int i=0; i<[allStationArray count]; i++)
            {
                if([[[allStationArray objectAtIndex:i] objectForKey:@"ZOPEN"]floatValue]==1)
                {
                    //查询数据库得到
                    float a= [[[allStationArray objectAtIndex:i] objectForKey:@"ZLATITUDE"] floatValue];
                    float b= [[[allStationArray objectAtIndex:i] objectForKey:@"ZLONGITUDE"] floatValue];
                    //定位得出的
                    float c=[[[dict allValues] objectAtIndex:0] floatValue];
                    float d=[[[dict allKeys] objectAtIndex:0] floatValue];
                    
                    CLLocation *location=[[CLLocation alloc] initWithLatitude:a longitude:b];
                    CLLocationDistance distance=[location distanceFromLocation:[[CLLocation alloc] initWithLatitude:c longitude:d]];
                    
                    [minDistanceDic setValue:[NSNumber numberWithFloat:distance] forKey:[[allStationArray objectAtIndex:i]objectForKey:@"ZNAME"]];
                }
            }
            NSArray *ar=[minDistanceDic allValues];
            ar=[ar sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                NSComparisonResult result = [obj1 compare:obj2];
                return result==NSOrderedDescending;
            }];
            [minDistanceDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                float a=[obj floatValue];
                float b=[[ar objectAtIndex:0] floatValue];
                if(a==b)
                {
                    [[NSUserDefaults standardUserDefaults] setObject:key forKey:@"company"];
                    NSLog(@"自定义离公司最近的地铁站：%@",key);
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"companyText" object:key];//公司的位置变化
                }
            }];
        }
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}
@end
