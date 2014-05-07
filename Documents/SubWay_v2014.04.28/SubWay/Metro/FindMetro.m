//
//  FindMetro.m
//  SubWay
//
//  Created by apple on 14-3-25.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "FindMetro.h"
#import "InfoViewController.h"

@implementation FindMetro
@synthesize homeBtn;
@synthesize topView;
@synthesize stationBtn,lineBtn;
@synthesize upView,downView;

@synthesize lineImage,imageView1,imageView2,lab1;
@synthesize mark;
@synthesize allPlacesArray;
@synthesize sc;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        topView=[[UIView alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,60)];
        [topView setBackgroundColor:[UIColor colorWithRed:0.22 green:0.7 blue:0.76 alpha:0.9]];
        [self addSubview:topView];
        
        homeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        homeBtn.frame=CGRectMake(10,20,30,30);
        [homeBtn setBackgroundImage:[UIImage imageNamed:@"iPhone_btn_home_0_0"] forState:UIControlStateNormal];
        [homeBtn addTarget:self action:@selector(homeBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:homeBtn];
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,0,80,topView.frame.size.height)];
        view.backgroundColor=[UIColor clearColor];
        view.userInteractionEnabled=YES;
        [topView addSubview:view];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [view addGestureRecognizer:tap];
        
        
        
        CGFloat top = 15; // 顶端盖高度
        CGFloat bottom = 0 ; // 底端盖高度
        CGFloat left = 15; // 左端盖宽度
        CGFloat right = 0; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        UIImage *image1=[UIImage imageNamed:@"iPhone_btn_15"];
        image1 = [image1 resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeTile];
        
        stationBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        stationBtn.frame=CGRectMake(homeBtn.frame.origin.x+75,20,80,30);
        [stationBtn setBackgroundImage:image1 forState:UIControlStateNormal];
        [stationBtn setTitle:@"站点" forState:UIControlStateNormal];
        [stationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [stationBtn addTarget:self action:@selector(stationBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:stationBtn];
        
        CGFloat top1 = 15; // 顶端盖高度
        CGFloat bottom1 =0; // 底端盖高度
        CGFloat left1 = 0; // 左端盖宽度
        CGFloat right1 = 15; // 右端盖宽度
        UIEdgeInsets insets1 = UIEdgeInsetsMake(top1, left1, bottom1, right1);
        UIImage *image2=[UIImage imageNamed:@"iPhone_btn_16"];
        image2 = [image2 resizableImageWithCapInsets:insets1 resizingMode:UIImageResizingModeTile];
        
        lineBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        lineBtn.frame=CGRectMake(stationBtn.frame.origin.x+80,20,80,30);
        [lineBtn setBackgroundImage:image2 forState:UIControlStateNormal];
        [lineBtn setTitleColor:[UIColor colorWithRed:0.15f green:0.69f blue:0.77f alpha:1.0f] forState:UIControlStateNormal];
        [lineBtn setTitle:@"线路" forState:UIControlStateNormal];
        [lineBtn addTarget:self action:@selector(lineBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:lineBtn];
        [self lineBtnAction];

        
        upView=[[UIImageView alloc]initWithFrame:CGRectMake(0,300,self.frame.size.width,(self.frame.size.height-295)/2)];
        upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_0"];
        [self addSubview:upView];
        
        if(iOS7){
            if(IS_IPHONE5){
                sc=[[UIScrollView alloc] initWithFrame:CGRectMake(0,220, self.frame.size.width, self.frame.size.height-250)];
            }
            else{
                sc=[[UIScrollView alloc] initWithFrame:CGRectMake(0,210, self.frame.size.width,200)];
            }
        }
        else
        {
            if(IS_IPHONE5){
                sc=[[UIScrollView alloc] initWithFrame:CGRectMake(0,200, self.frame.size.width, self.frame.size.height-230)];
            }
            else{
                sc=[[UIScrollView alloc] initWithFrame:CGRectMake(0,190, self.frame.size.width,200)];
            }
        }
        sc.showsVerticalScrollIndicator=NO;
        [sc setHidden:YES];
        [self insertSubview:sc belowSubview:upView];

        
        UIView *viewLine=[[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width/2, 0, 1,CGRectGetHeight(sc.frame))];
        viewLine.tag=1;
        [sc addSubview:viewLine];
        
        
        downView=[[UIImageView alloc]initWithFrame:CGRectMake(0,upView.frame.origin.y+(self.frame.size.height-295)/2-5,self.frame.size.width,(self.frame.size.height-295)/2)];
        downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_1"];
        [self addSubview:downView];
        
        [self setUpViewAndDownViewFrame:@"Big"];
        
        _imageArray = [[NSArray alloc] initWithObjects:@"iPhone_bg_4",@"iPhone_bg_5",@"iPhone_bg_6",@"iPhone_bg_6",@"iPhone_bg_7",@"iPhone_bg_8",@"iPhone_bg_9",@"iPhone_bg_11",@"iPhone_bg_10",@"iPhone_bg_12",nil];
        _currentPage = 0;
        
        if(IS_IPHONE5)
        {
            _flowView = [[SBPageFlowView alloc] initWithFrame:CGRectMake(0,130, self.bounds.size.width,200)];
        }
        else
        {
            _flowView = [[SBPageFlowView alloc] initWithFrame:CGRectMake(0,100, self.bounds.size.width,200)];
        }
        _flowView.delegate = self;
        _flowView.dataSource = self;
        _flowView.minimumPageAlpha = 0.5f;
        _flowView.minimumPageScale = 0.5f;
        _flowView.defaultImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1.jpg"]];
        [self addSubview:_flowView];
        [_flowView reloadData];

        
        lab1=[[UILabel alloc]initWithFrame:CGRectMake(self.center.x-50,50,100,100)];
        lab1.text=@"1";
        lab1.textAlignment=NSTextAlignmentCenter;
        lab1.backgroundColor=[UIColor clearColor];
        lab1.textColor=[UIColor whiteColor];
        lab1.font=[UIFont boldSystemFontOfSize:60];
        [_flowView addSubview:lab1];

        
        stationV=[[StationPinyin alloc]initWithFrame:CGRectMake(0,60,self.frame.size.width,self.frame.size.height-60)];
        [stationV setHidden:YES];
        [self addSubview:stationV];
        
        
        mark=YES;
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}
#pragma mark -设置上下imageview的背景
-(void)setUpViewAndDownViewFrame:(NSString *)str
{
    if([str isEqualToString:@"Big"])
    {
        if(iOS7){
            if(IS_IPHONE5){
                upView.frame=CGRectMake(0,308,self.frame.size.width,110);
                downView.frame=CGRectMake(0,408,self.frame.size.width,110);
            }
            else
            {
                upView.frame=CGRectMake(0,278,self.frame.size.width,80);
                downView.frame=CGRectMake(0,350,self.frame.size.width,80);
            }
        }
        else
        {
            if(IS_IPHONE5){
                upView.frame=CGRectMake(0,288,self.frame.size.width,110);
                downView.frame=CGRectMake(0,388,self.frame.size.width,110);
            }
            else
            {
                upView.frame=CGRectMake(0,258,self.frame.size.width,80);
                downView.frame=CGRectMake(0,330,self.frame.size.width,80);
            }
        }
    }
    else
    {
        if(iOS7)
        {
            if(IS_IPHONE5){
                upView.frame=CGRectMake(0,190,self.frame.size.width,40);
                downView.frame=CGRectMake(0,478,self.frame.size.width,40);
            }
            else
            {
                upView.frame=CGRectMake(0,190,self.frame.size.width,30);
                downView.frame=CGRectMake(0,400,self.frame.size.width,30);
            }
        }
        else
        {
            if(IS_IPHONE5){
                upView.frame=CGRectMake(0,170,self.frame.size.width,40);
                downView.frame=CGRectMake(0,458,self.frame.size.width,40);
            }
            else
            {
                upView.frame=CGRectMake(0,170,self.frame.size.width,30);
                downView.frame=CGRectMake(0,380,self.frame.size.width,30);
            }
        }
    }
}
-(void)tap:(UITapGestureRecognizer *)tap
{
    [self homeBtnAction];
}
#pragma mark -查找地铁返回主页
-(void)homeBtnAction
{
    CATransition * animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.3;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type =kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0];
    [self.layer addAnimation:animation forKey:@"animation"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"FINDSUBWAY" object:nil];
}
-(void)stationBtnAction
{
    [_flowView setHidden:YES];
    [upView setHidden:YES];
    [downView setHidden:YES];
    [stationV setHidden:NO];
    [sc setHidden:YES];
    
    [lineBtn setTitleColor:[UIColor colorWithRed:0.15f green:0.69f blue:0.77f alpha:1.0f] forState:UIControlStateNormal];
    [stationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    CGFloat top = 15; // 顶端盖高度
    CGFloat bottom = 0 ; // 底端盖高度
    CGFloat left = 15; // 左端盖宽度
    CGFloat right = 0; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    UIImage *image1=[UIImage imageNamed:@"iPhone_btn_15"];
    image1 = [image1 resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeTile];
    
    CGFloat top1 = 15; // 顶端盖高度
    CGFloat bottom1 =0; // 底端盖高度
    CGFloat left1 = 0; // 左端盖宽度
    CGFloat right1 = 15; // 右端盖宽度
    UIEdgeInsets insets1 = UIEdgeInsetsMake(top1, left1, bottom1, right1);
    UIImage *image2=[UIImage imageNamed:@"iPhone_btn_16"];
    image2 = [image2 resizableImageWithCapInsets:insets1 resizingMode:UIImageResizingModeTile];
    
    [stationBtn setBackgroundImage:image1 forState:UIControlStateNormal];
    [lineBtn setBackgroundImage:image2 forState:UIControlStateNormal];
}
-(void)lineBtnAction
{
    [_flowView setHidden:NO];
    [upView setHidden:NO];
    [downView setHidden:NO];
    [stationV setHidden:YES];
    if (mark==NO) {
        [sc setHidden:NO];
    }
    
    [stationBtn setTitleColor:[UIColor colorWithRed:0.15f green:0.69f blue:0.77f alpha:1.0f] forState:UIControlStateNormal];
    [lineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    CGFloat top = 15; // 顶端盖高度
    CGFloat bottom = 0 ; // 底端盖高度
    CGFloat left = 15; // 左端盖宽度
    CGFloat right = 0; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    UIImage *image1=[UIImage imageNamed:@"iPhone_btn_13"];
    image1 = [image1 resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeTile];
    
    CGFloat top1 = 15; // 顶端盖高度
    CGFloat bottom1 =0; // 底端盖高度
    CGFloat left1 = 0; // 左端盖宽度
    CGFloat right1 = 15; // 右端盖宽度
    UIEdgeInsets insets1 = UIEdgeInsetsMake(top1, left1, bottom1, right1);
    UIImage *image2=[UIImage imageNamed:@"iPhone_btn_14"];
    image2 = [image2 resizableImageWithCapInsets:insets1 resizingMode:UIImageResizingModeTile];
    
    [stationBtn setBackgroundImage:image1 forState:UIControlStateNormal];
    [lineBtn setBackgroundImage:image2 forState:UIControlStateNormal];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(flag)
        [self removeFromSuperview];
}


#pragma mark - PagedFlowView Datasource
//返回显示View的个数
- (NSInteger)numberOfPagesInFlowView:(SBPageFlowView *)flowView{
    return [_imageArray count];
}

- (CGSize)sizeForPageInFlowView:(SBPageFlowView *)flowView
{
    return CGSizeMake(200,200);
}

//返回给某列使用的View
- (UIView *)flowView:(SBPageFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    UIImageView *imageView = (UIImageView *)[flowView dequeueReusableCell];
    if (!imageView) {
        imageView = [[UIImageView alloc] init];
        imageView.layer.masksToBounds = YES;
    }
    
    imageView.image = [UIImage imageNamed:[_imageArray objectAtIndex:index]];
    return imageView;
}

#pragma mark - PagedFlowView Delegate
- (void)didReloadData:(UIView *)cell cellForPageAtIndex:(NSInteger)index
{
    UIImageView *imageView = (UIImageView *)cell;
    imageView.image = [UIImage imageNamed:[_imageArray objectAtIndex:index]];
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(SBPageFlowView *)flowView {
    NSLog(@"Scrolled to page # %ld", (long)pageNumber);
    _currentPage = pageNumber;
    [self setDaXiaoKuang:pageNumber fl:@"Big" str:mark];
    
    switch (pageNumber) {
        case 0:
            lab1.text=@"1";
            lab1.font=[UIFont boldSystemFontOfSize:60];
            
            [self viewWithTag:1].backgroundColor=[UIColor colorWithRed:0.98 green:0.86 blue:0.29 alpha:1];
            [self query:pageNumber imageStr:@"iPhone_btn_4"];
            
            break;
        case 1:

            lab1.text=@"2";
            lab1.font=[UIFont boldSystemFontOfSize:60];
            
            [self viewWithTag:1].backgroundColor=[UIColor colorWithRed:0.15 green:0.37 blue:0.56 alpha:1];
            [self query:pageNumber imageStr:@"iPhone_btn_5"];
            break;
        case 2:
            lab1.text=@"3";
            lab1.font=[UIFont boldSystemFontOfSize:60];
            
            [self viewWithTag:1].backgroundColor=[UIColor colorWithRed:0.96 green:0.55 blue:0.12 alpha:1];
            [self query:pageNumber imageStr:@"iPhone_btn_6"];
            break;
        case 3:
            lab1.text=@"3";
            lab1.font=[UIFont boldSystemFontOfSize:60];
            
            [self viewWithTag:1].backgroundColor=[UIColor colorWithRed:0.96 green:0.55 blue:0.12 alpha:1];
            [self query:pageNumber imageStr:@"iPhone_btn_6"];
            break;
        case 4:
            lab1.text=@"4";
            lab1.font=[UIFont boldSystemFontOfSize:60];
            
            [self viewWithTag:1].backgroundColor=[UIColor colorWithRed:0.16 green:0.47 blue:0.23 alpha:1];
            [self query:pageNumber imageStr:@"iPhone_btn_7"];
            break;
        case 5:
            lab1.text=@"5";
            lab1.font=[UIFont boldSystemFontOfSize:60];
            
            [self viewWithTag:1].backgroundColor=[UIColor colorWithRed:0.72 green:0.11 blue:0.12 alpha:1];
            [self query:pageNumber imageStr:@"iPhone_btn_8"];
            break;
        case 6:
            lab1.text=@"8";
            lab1.font=[UIFont boldSystemFontOfSize:60];
            
            [self viewWithTag:1].backgroundColor=[UIColor colorWithRed:0.08 green:0.55 blue:0.5 alpha:1];
            [self query:pageNumber imageStr:@"iPhone_btn_9"];
            break;
        case 7:
            lab1.font=[UIFont boldSystemFontOfSize:29];
            lab1.text=@"APM";
            
            [self viewWithTag:1].backgroundColor=[UIColor colorWithRed:0.31 green:0.79 blue:0.95 alpha:1];
            [self query:pageNumber imageStr:@"iPhone_btn_11"];
            break;
        case 8:
            lab1.font=[UIFont boldSystemFontOfSize:29];
            lab1.text=@"GF";
            
            [self viewWithTag:1].backgroundColor=[UIColor colorWithRed:0.66 green:0.81 blue:0.25 alpha:1];
            [self query:pageNumber imageStr:@"iPhone_btn_10"];
            break;
        case 9:
            lab1.text=@"6";
            lab1.font=[UIFont boldSystemFontOfSize:60];
            
            [self viewWithTag:1].backgroundColor=[UIColor colorWithRed:0.50 green:0.15 blue:0.56 alpha:1];
            [self query:pageNumber imageStr:@"iPhone_btn_12"];
            break;
    }
}
#pragma mark-设置up和down的背景
-(void)setDaXiaoKuang:(NSInteger)index fl:(NSString *)s str:(BOOL)s1
{
    if([s isEqualToString:@"Big"]&&s1)
    {
        switch (index) {
            case 0:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_0"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_1"];
                break;
            case 1:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_2"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_3"];

                break;
            case 2:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_4"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_5"];

                break;
            case 3:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_4"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_5"];
        
                break;
            case 4:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_6"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_7"];
     
                break;
            case 5:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_8"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_9"];
      
                break;
            case 6:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_10"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_11"];
                break;
            case 7:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_14"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_15"];
                break;
            case 8:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_12"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_13"];

                break;
            case 9:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_16"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_17"];
                break;
        }
    }
    else
    {
        switch (index) {
            case 0:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_0"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_1"];
                break;
            case 1:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_2"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_3"];
                
                break;
            case 2:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_4"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_5"];
                
                break;
            case 3:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_4"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_5"];
                
                break;
            case 4:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_6"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_7"];
                
                break;
            case 5:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_8"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_9"];
                
                break;
            case 6:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_10"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_11"];
                break;
            case 7:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_14"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_15"];
                break;
            case 8:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_12"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_13"];
                
                break;
            case 9:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_16"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_17"];
                break;
        }

    }
}
-(void)query:(NSInteger)index imageStr:(NSString *)imageStr
{
    if(index>=6&&index<=8)
    {
        allPlacesArray=[SqliteDao findAllPlacesByLineId:[NSString stringWithFormat:@"%i",index+2]];
    }
    else if (index==9)
    {
        allPlacesArray=[SqliteDao findAllPlacesByLineId:@"7"];
    }
    else
    {
        allPlacesArray=[SqliteDao findAllPlacesByLineId:[NSString stringWithFormat:@"%i",index+1]];
    }
    
    NSLog(@"地点个数：%i",allPlacesArray.count);
    UIImageView *image;
    
    for (UIView *s in sc.subviews) {
        if([s isKindOfClass:[UIImageView class]])
            [s removeFromSuperview];
    }
    
    for (int i=0; i<[allPlacesArray count]; i++)
    {
        image=[[UIImageView alloc]initWithFrame:CGRectMake(60,35*i+15, 100,30)];
        if (i%2==0) {
            image.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageStr]];
        }
        else
        {
            //image.image=[SqliteDao image:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageStr]] rotation:UIImageOrientationDown];
            [image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_1",imageStr]]];
            image.frame=CGRectMake(160, 35*i+10, 100,30);
        }
        [sc addSubview:image];
        
        UITapGestureRecognizer *tapGestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(findStationInfo:)];
        
        UILabel *la=[[UILabel alloc]initWithFrame:CGRectMake(0, 0,100, 30)];
        la.text=[[allPlacesArray objectAtIndex:i] objectForKey:@"ZNAME"];
        la.backgroundColor=[UIColor clearColor];
        la.font=[UIFont boldSystemFontOfSize:13];
        la.textAlignment=NSTextAlignmentCenter;
        la.userInteractionEnabled=YES;
        [la addGestureRecognizer:tapGestureRecognizer];
        [image addSubview:la];
        image.userInteractionEnabled=YES;
    }
    [self viewWithTag:1].frame=CGRectMake(self.frame.size.width/2, 0, 1,40*[allPlacesArray count]);
    [sc setContentSize:CGSizeMake(CGRectGetWidth(sc.frame),40*[allPlacesArray count]+10)];
    
}
-(void)findStationInfo:(UITapGestureRecognizer *)tapGestureRecognizer
{
    NSString *place=((UILabel *)[tapGestureRecognizer view]).text;
    
    InfoViewController *info=[[InfoViewController alloc]init];
    info.place=((UILabel *)[tapGestureRecognizer view]).text;
    info.arrayLine=[SqliteDao findLineByStationId:place];
    
    info.infoArray=[SqliteDao findEntranceByStationId:place];
    
    info.arrayStartAndEndTime=[SqliteDao findStartAndEndTime:place];
    
    [[self viewController] presentViewController:info animated:YES completion:^{
        
    }];
}
#pragma mark 获得view的viewcontroller
- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)didSelectItemAtIndex:(NSInteger)index inFlowView:(SBPageFlowView *)flowView
{
    NSLog(@"didSelectItemAtIndex: %i", index);
    if(mark)
    {
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             _flowView.minimumPageAlpha=0.0f;
                             _flowView.minimumPageScale=0.0f;
                             if(iOS7){
                                 _flowView.frame=CGRectMake(20,60, self.bounds.size.width-40,200);
                             }
                             else
                             {
                                 _flowView.frame=CGRectMake(20,40, self.bounds.size.width-40,200);
                             }
                             
                             CGAffineTransform transform = _flowView.transform;
                             transform = CGAffineTransformScale(transform,0.5,0.5);
                             _flowView.transform = transform;
                             
                             lab1.frame=CGRectMake(self.center.x-68,50,100,100);
                             if (index==7||index==8)
                             {
                                    lab1.font=[UIFont boldSystemFontOfSize:29];
                             }
                             else
                             {
                                 lab1.font=[UIFont boldSystemFontOfSize:60];
                             }
                             
                             
                             [self setDaXiaoKuang:index fl:@"Small" str:NO];
                             [self setUpViewAndDownViewFrame:@"Small"];
                             if (index==0) {
                                 [self viewWithTag:1].backgroundColor=[UIColor colorWithRed:0.98 green:0.86 blue:0.29 alpha:1];
                                 [self query:index imageStr:@"iPhone_btn_4"];
                             }
                             
                         }
                         completion:^(BOOL finished)
         {
             mark=NO;
            [sc setHidden:NO];
         }];
    }
    else
    {
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             _flowView.minimumPageAlpha = 0.5f;
                             _flowView.minimumPageScale = 0.5f;
                             if(IS_IPHONE5)
                                 _flowView.frame=CGRectMake(0,180, self.bounds.size.width,100);
                             else
                                 _flowView.frame=CGRectMake(0,150, self.bounds.size.width,100);
                             
                             CGAffineTransform transform = _flowView.transform;
                             transform = CGAffineTransformScale(transform,2,2);
                             _flowView.transform = transform;
                             
                             lab1.frame=CGRectMake(self.center.x+110,50,100,100);
                             if (index==7||index==8)
                             {
                                 lab1.font=[UIFont boldSystemFontOfSize:29];
                             }
                             else
                             {
                                 lab1.font=[UIFont boldSystemFontOfSize:60];
                             }
                             
                             [self setUpViewAndDownViewFrame:@"Big"];
                             [self setDaXiaoKuang:index fl:@"Big" str:YES];
                             [sc setHidden:YES];
                         }
                         completion:^(BOOL finished)
         {
             mark=YES;
         }];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
