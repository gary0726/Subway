//
//  StationPinyin.m
//  SubWay
//
//  Created by Glex on 14-4-10.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "StationPinyin.h"
#import "InfoViewController.h"
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

@implementation StationPinyin
@synthesize upView,downView;

@synthesize lineImage,imageView1,imageView2,lab1;
@synthesize mark;
@synthesize allPlacesArray;
@synthesize letterView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        upView=[[UIImageView alloc]initWithFrame:CGRectMake(0,235,self.frame.size.width,70)];
        upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_0"];
        [self addSubview:upView];
        
        if(iOS7){
            if(IS_IPHONE5)
                sc=[[UIScrollView alloc] initWithFrame:CGRectMake(0,155, self.frame.size.width, self.frame.size.height-180)];
            else
                sc=[[UIScrollView alloc] initWithFrame:CGRectMake(0,145, self.frame.size.width, self.frame.size.height-170)];
        }
        else
        {
            if(IS_IPHONE5)
                sc=[[UIScrollView alloc] initWithFrame:CGRectMake(0,135, self.frame.size.width, self.frame.size.height-160)];
            else
                sc=[[UIScrollView alloc] initWithFrame:CGRectMake(0,125, self.frame.size.width, self.frame.size.height-150)];
        }
        
        
        sc.showsVerticalScrollIndicator=NO;
        [sc setHidden:YES];
        [self insertSubview:sc belowSubview:upView];
        
        UIView *viewLine=[[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width/2, 0, 1,CGRectGetHeight(sc.frame))];
        viewLine.tag=1;
        [sc addSubview:viewLine];
        
        downView=[[UIImageView alloc]initWithFrame:CGRectMake(0,upView.frame.origin.y+65,self.frame.size.width,70)];
        downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_1"];
        [self addSubview:downView];
        
        [self setUpViewAndDownViewFrame:@"Big"];
        
        _imageArray = [[NSArray alloc] initWithObjects:@"iPhone_bg_4",@"iPhone_bg_5",@"iPhone_bg_6",@"iPhone_bg_6",@"iPhone_bg_7",@"iPhone_bg_8",@"iPhone_bg_9",@"iPhone_bg_11",@"iPhone_bg_10",@"iPhone_bg_12",@"iPhone_bg_4",@"iPhone_bg_5",@"iPhone_bg_6",@"iPhone_bg_6",@"iPhone_bg_7",@"iPhone_bg_8",@"iPhone_bg_9",@"iPhone_bg_11",@"iPhone_bg_10",@"iPhone_bg_12",nil];
        _currentPage = 0;
        
        if(IS_IPHONE5)
            _flowView = [[SBPageFlowView alloc] initWithFrame:CGRectMake(0,70, self.bounds.size.width,200)];
        else
            _flowView = [[SBPageFlowView alloc] initWithFrame:CGRectMake(0,40, self.bounds.size.width,200)];
        
        _flowView.delegate = self;
        _flowView.dataSource = self;
        _flowView.minimumPageAlpha = 0.5f;
        _flowView.minimumPageScale = 0.5f;
        _flowView.defaultImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1.jpg"]];
        [self addSubview:_flowView];
        [_flowView reloadData];
        
        
        lab1=[[UILabel alloc]initWithFrame:CGRectMake(self.center.x-50,50,100,100)];
        lab1.text=@"B";
        lab1.textAlignment=NSTextAlignmentCenter;
        lab1.backgroundColor=[UIColor clearColor];
        lab1.textColor=[UIColor whiteColor];
        lab1.font=[UIFont boldSystemFontOfSize:60];
        [_flowView addSubview:lab1];
        
        letterArray=@[@"B",@"C",@"D",@"F",@"G",@"H",@"J",@"K",@"L",@"M",@"N",@"P",@"Q",@"R",@"S",@"T",@"W",@"X",@"Y",@"Z"];
        
        letterView=[[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width-30,IS_IPHONE5?60:20,20,330)];
        letterView.layer.masksToBounds=YES;
        letterView.layer.cornerRadius=5;
        letterView.userInteractionEnabled=YES;
        letterView.backgroundColor=[UIColor colorWithRed:0.46f green:0.52f blue:0.57f alpha:0.5f];
        [self addSubview:letterView];
        
        CGRect rect=CGRectMake(0,5,20,15);
        for (int i=0; i<letterArray.count; i++) {
            UITapGestureRecognizer *gestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(letterClick:)];
            
            UILabel *la=[[UILabel alloc]initWithFrame:rect];
            la.userInteractionEnabled=YES;
            [la addGestureRecognizer:gestureRecognizer];
            
            la.font=[UIFont systemFontOfSize:10];
            la.textColor=[UIColor whiteColor];
            la.backgroundColor=[UIColor clearColor];
            la.textAlignment=NSTextAlignmentCenter;
            la.text=[letterArray objectAtIndex:i];
            [letterView addSubview:la];
            rect.origin.y+=16;
        }
        
        mark=YES;
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}
-(void)letterClick:(UITapGestureRecognizer *)gesture
{
    NSString *s=((UILabel *)[gesture view]).text;
    _currentPage =[letterArray indexOfObject:s];
    
    [self didScrollToPage:_currentPage inFlowView:_flowView];
    
    UIImageView *image=(UIImageView *)[_flowView cellForItemAtCurrentIndex:_currentPage];
    image.image=[UIImage imageNamed:[_imageArray objectAtIndex:_currentPage]];
}

- (void)animateLayerAtIndex:(NSInteger)index{
    if ([self.layer.sublayers count] - 1 > index){
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        animation.toValue = (id)[RGB(180, 180, 180, 1) CGColor];
        animation.duration = 0.5f;
        animation.autoreverses = YES;
        animation.repeatCount = 1;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [self.layer.sublayers[index] addAnimation:animation forKey:@"myAnimation"];
    }
}

#pragma mark -设置上下imageview的背景
-(void)setUpViewAndDownViewFrame:(NSString *)str
{
    if([str isEqualToString:@"Big"])
    {
        if(iOS7){
            if(IS_IPHONE5){
                upView.frame=CGRectMake(0,248,self.frame.size.width,110);
                downView.frame=CGRectMake(0,348,self.frame.size.width,110);
            }
            else
            {
                upView.frame=CGRectMake(0,218,self.frame.size.width,80);
                downView.frame=CGRectMake(0,290,self.frame.size.width,80);
            }
        }
        else
        {
            if(IS_IPHONE5){
                upView.frame=CGRectMake(0,228,self.frame.size.width,110);
                downView.frame=CGRectMake(0,328,self.frame.size.width,110);
            }
            else
            {
                upView.frame=CGRectMake(0,198,self.frame.size.width,80);
                downView.frame=CGRectMake(0,270,self.frame.size.width,80);
            }
        }
    }
    else
    {
        if(iOS7){
            if(IS_IPHONE5){
                upView.frame=CGRectMake(0,130,self.frame.size.width,40);
                downView.frame=CGRectMake(0,418,self.frame.size.width,40);
            }
            else
            {
                upView.frame=CGRectMake(0,130,self.frame.size.width,30);
                downView.frame=CGRectMake(0,340,self.frame.size.width,30);
            }
        }
        else
        {
            if(IS_IPHONE5){
                upView.frame=CGRectMake(0,110,self.frame.size.width,40);
                downView.frame=CGRectMake(0,398,self.frame.size.width,40);
            }
            else
            {
                upView.frame=CGRectMake(0,110,self.frame.size.width,30);
                downView.frame=CGRectMake(0,320,self.frame.size.width,30);
            }
        }
    }
}
-(void)homeBtnAction
{
    CATransition * animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.3;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"rippleEffect";
    animation.subtype = kCATransitionFromLeft;
    [self.layer addAnimation:animation forKey:@"animation"];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"FINDSUBWAY" object:nil];
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
        imageView.tag=index;
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
    [self setDaXiaoKuang:pageNumber fl:@"Big" str:mark];
    _currentPage=pageNumber;
    
    switch (pageNumber) {
        case 0:
            lab1.text=@"B";
            lab1.font=[UIFont boldSystemFontOfSize:60];
            
            [self viewWithTag:1].backgroundColor=[UIColor colorWithRed:0.98 green:0.86 blue:0.29 alpha:1];
            [self query:lab1.text imageStr:@"iPhone_btn_4"];
            break;
        case 1:
            lab1.text=@"C";
            lab1.font=[UIFont boldSystemFontOfSize:60];
            
            [self viewWithTag:1].backgroundColor=[UIColor colorWithRed:0.15 green:0.37 blue:0.56 alpha:1];
            [self query:lab1.text imageStr:@"iPhone_btn_5"];
            break;
        case 2:
            lab1.text=@"D";
            lab1.font=[UIFont boldSystemFontOfSize:60];
            
            [self viewWithTag:1].backgroundColor=[UIColor colorWithRed:0.96 green:0.55 blue:0.12 alpha:1];
            [self query:lab1.text imageStr:@"iPhone_btn_6"];
            break;
        case 3:
            lab1.text=@"F";
            lab1.font=[UIFont boldSystemFontOfSize:60];
            
            [self viewWithTag:1].backgroundColor=[UIColor colorWithRed:0.96 green:0.55 blue:0.12 alpha:1];
            [self query:lab1.text imageStr:@"iPhone_btn_6"];
            break;
        case 4:
            lab1.text=@"G";
            lab1.font=[UIFont boldSystemFontOfSize:60];
            
            [self viewWithTag:1].backgroundColor=[UIColor colorWithRed:0.16 green:0.47 blue:0.23 alpha:1];
            [self query:lab1.text imageStr:@"iPhone_btn_7"];
            break;
        case 5:

            lab1.text=@"H";
            lab1.font=[UIFont boldSystemFontOfSize:60];
            
            [self viewWithTag:1].backgroundColor=[UIColor colorWithRed:0.72 green:0.11 blue:0.12 alpha:1];
            [self query:lab1.text imageStr:@"iPhone_btn_8"];
            break;
        case 6:
            lab1.text=@"J";
            lab1.font=[UIFont boldSystemFontOfSize:60];
            
            [self viewWithTag:1].backgroundColor=[UIColor colorWithRed:0.08 green:0.55 blue:0.5 alpha:1];
            [self query:lab1.text imageStr:@"iPhone_btn_9"];
            
            break;
        case 7:
            lab1.font=[UIFont boldSystemFontOfSize:60];
            lab1.text=@"K";
            
            [self viewWithTag:1].backgroundColor=[UIColor colorWithRed:0.31 green:0.79 blue:0.95 alpha:1];
            [self query:lab1.text imageStr:@"iPhone_btn_11"];
            
            break;
        case 8:
            lab1.font=[UIFont boldSystemFontOfSize:60];
            lab1.text=@"L";
            
            [self viewWithTag:1].backgroundColor=[UIColor colorWithRed:0.66 green:0.81 blue:0.25 alpha:1];
            [self query:lab1.text imageStr:@"iPhone_btn_10"];
            break;
        case 9:
            lab1.text=@"M";
            lab1.font=[UIFont boldSystemFontOfSize:60];
            
            [self viewWithTag:1].backgroundColor=[UIColor colorWithRed:0.50 green:0.15 blue:0.56 alpha:1];
            [self query:lab1.text imageStr:@"iPhone_btn_12"];
            break;
        case 10:
            lab1.text=@"N";
            lab1.font=[UIFont boldSystemFontOfSize:60];
            
            [self viewWithTag:1].backgroundColor=[UIColor colorWithRed:0.98 green:0.86 blue:0.29 alpha:1];
            [self query:lab1.text imageStr:@"iPhone_btn_4"];
            
            break;
        case 11:
            lab1.text=@"P";
            lab1.font=[UIFont boldSystemFontOfSize:60];
            
            [self viewWithTag:1].backgroundColor=[UIColor colorWithRed:0.15 green:0.37 blue:0.56 alpha:1];
            [self query:lab1.text imageStr:@"iPhone_btn_5"];
            break;
        case 12:
            lab1.text=@"Q";
            lab1.font=[UIFont boldSystemFontOfSize:60];
            
            [self viewWithTag:1].backgroundColor=[UIColor colorWithRed:0.96 green:0.55 blue:0.12 alpha:1];
            [self query:lab1.text imageStr:@"iPhone_btn_6"];
            break;
        case 13:
 
            lab1.text=@"R";
            lab1.font=[UIFont boldSystemFontOfSize:60];
            
            [self viewWithTag:1].backgroundColor=[UIColor colorWithRed:0.96 green:0.55 blue:0.12 alpha:1];
            [self query:lab1.text imageStr:@"iPhone_btn_6"];
            break;
        case 14:
 
            lab1.text=@"S";
            lab1.font=[UIFont boldSystemFontOfSize:60];
            
            [self viewWithTag:1].backgroundColor=[UIColor colorWithRed:0.16 green:0.47 blue:0.23 alpha:1];
            [self query:lab1.text imageStr:@"iPhone_btn_7"];
            
            break;
        case 15:

            lab1.text=@"T";
            lab1.font=[UIFont boldSystemFontOfSize:60];
            
            [self viewWithTag:1].backgroundColor=[UIColor colorWithRed:0.72 green:0.11 blue:0.12 alpha:1];
            [self query:lab1.text imageStr:@"iPhone_btn_8"];
            break;
        case 16:

            lab1.text=@"W";
            lab1.font=[UIFont boldSystemFontOfSize:60];
            
            [self viewWithTag:1].backgroundColor=[UIColor colorWithRed:0.08 green:0.55 blue:0.5 alpha:1];
            [self query:lab1.text imageStr:@"iPhone_btn_9"];
            break;
        case 17:

            lab1.font=[UIFont boldSystemFontOfSize:60];
            lab1.text=@"X";
            
            [self viewWithTag:1].backgroundColor=[UIColor colorWithRed:0.31 green:0.79 blue:0.95 alpha:1];
            [self query:lab1.text imageStr:@"iPhone_btn_11"];
            break;
        case 18:

            lab1.font=[UIFont boldSystemFontOfSize:60];
            lab1.text=@"Y";
            
            [self viewWithTag:1].backgroundColor=[UIColor colorWithRed:0.66 green:0.81 blue:0.25 alpha:1];
            [self query:lab1.text imageStr:@"iPhone_btn_10"];
            break;
        case 19:
            lab1.text=@"Z";
            lab1.font=[UIFont boldSystemFontOfSize:60];
            
            [self viewWithTag:1].backgroundColor=[UIColor colorWithRed:0.50 green:0.15 blue:0.56 alpha:1];
            [self query:lab1.text imageStr:@"iPhone_btn_12"];
            break;
    }
}
#pragma mark-设置up和down的背景
-(void)setDaXiaoKuang:(NSInteger)index fl:(NSString *)s str:(BOOL) s1
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
            case 10:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_0"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_1"];
                break;
            case 11:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_2"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_3"];
                
                break;
            case 12:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_4"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_5"];
                
                break;
            case 13:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_4"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_5"];
                
                break;
            case 14:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_6"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_7"];
                
                break;
            case 15:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_8"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_9"];
                
                break;
            case 16:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_10"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_11"];
                break;
            case 17:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_14"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_15"];
                break;
            case 18:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_12"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_da_13"];
                break;
            case 19:
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
            case 10:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_0"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_1"];
                break;
            case 11:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_2"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_3"];
                
                break;
            case 12:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_4"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_5"];
                
                break;
            case 13:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_4"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_5"];
                
                break;
            case 14:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_6"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_7"];
                
                break;
            case 15:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_8"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_9"];
                
                break;
            case 16:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_10"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_11"];
                break;
            case 17:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_14"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_15"];
                break;
            case 18:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_12"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_13"];
                
                break;
            case 19:
                upView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_16"];
                downView.image=[UIImage imageNamed:@"iPhone_bg_kuang_xiao_17"];
                break;

        }
        
    }
}
-(void)query:(NSString *)str imageStr:(NSString *)imageStr
{
    allPlacesArray=[SqliteDao findPlaceByPinyin:str];
    
    NSLog(@"地点个数：%i",allPlacesArray.count);
    UIImageView *image;
    
    for (UIView *s in sc.subviews) {
        if([s isKindOfClass:[UIImageView class]])
            [s removeFromSuperview];
    }
    
    for (int i=0; i<[allPlacesArray count]; i++)
    {
        image=[[UIImageView alloc]initWithFrame:CGRectMake(60,35*i+20, 100,30)];
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
        [image addSubview:la];
        
        la.userInteractionEnabled=YES;
        [la addGestureRecognizer:tapGestureRecognizer];
        image.userInteractionEnabled=YES;
    }
    [self viewWithTag:1].frame=CGRectMake(self.frame.size.width/2, 0, 1,40*[allPlacesArray count]);
    [sc setContentSize:CGSizeMake(CGRectGetWidth(sc.frame),35*[allPlacesArray count]+30)];
    
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
                             if(iOS7)
                                 _flowView.frame=CGRectMake(20,0, self.bounds.size.width-40,200);
                             else
                                 _flowView.frame=CGRectMake(20,-20, self.bounds.size.width-40,200);
                             
                             CGAffineTransform transform = _flowView.transform;
                             transform = CGAffineTransformScale(transform,0.5,0.5);
                             _flowView.transform = transform;
                             
                             lab1.frame=CGRectMake(self.center.x-68,50,100,100);
                             
                             [self setUpViewAndDownViewFrame:@"Small"];
                             [self setDaXiaoKuang:index fl:@"Small" str:NO];
                             
                             if (index==0)
                             {
                                 [self viewWithTag:1].backgroundColor=[UIColor colorWithRed:0.98 green:0.86 blue:0.29 alpha:1];
                                 [self query:lab1.text imageStr:@"iPhone_btn_4"];
                             }
                             letterView.hidden=YES;
                             [self didScrollToPage:_currentPage inFlowView:_flowView];
                        }
                         completion:^(BOOL finished)
         {
             mark=NO;
             [sc setHidden:NO];
             
             UIImageView *image=(UIImageView *)[_flowView cellForItemAtCurrentIndex:_currentPage];
             image.image=[UIImage imageNamed:[_imageArray objectAtIndex:_currentPage]];
         }];
    }
    else
    {
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             _flowView.minimumPageAlpha = 0.5f;
                             _flowView.minimumPageScale = 0.5f;
                             if(IS_IPHONE5)
                                 _flowView.frame=CGRectMake(0,120, self.bounds.size.width,100);
                             else
                                 _flowView.frame=CGRectMake(0,90, self.bounds.size.width,100);
                             
                             CGAffineTransform transform = _flowView.transform;
                             transform = CGAffineTransformScale(transform,2,2);
                             _flowView.transform = transform;
                             
                             
                             lab1.frame=CGRectMake(self.center.x+110,50,100,100);
                             
                            [self setUpViewAndDownViewFrame:@"Big"];
                             [self setDaXiaoKuang:index fl:@"Big" str:YES];
                             [sc setHidden:YES];
                         }
                         completion:^(BOOL finished)
         {
             letterView.hidden=NO;
             mark=YES;
             
             [self didScrollToPage:_currentPage inFlowView:_flowView];
             UIImageView *image=(UIImageView *)[_flowView cellForItemAtCurrentIndex:_currentPage];
             image.image=[UIImage imageNamed:[_imageArray objectAtIndex:_currentPage]];
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
