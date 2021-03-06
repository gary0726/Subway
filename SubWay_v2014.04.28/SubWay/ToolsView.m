//
//  ToolsView.m
//  SubWay
//
//  Created by apple on 14-3-24.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "ToolsView.h"

@implementation ToolsView
@synthesize narrowBtn,wideBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        wideBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        wideBtn.frame=CGRectMake(5,5, 30, 30);
        [wideBtn setBackgroundImage:[UIImage imageNamed:@"iPhone_btn_fangda"] forState:UIControlStateNormal];
        [wideBtn addTarget:self action:@selector(zoomInAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:wideBtn];
        
        narrowBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        narrowBtn.frame=CGRectMake(5,50, 30, 30);
        [narrowBtn setBackgroundImage:[UIImage imageNamed:@"iPhone_btn_suoxiao"] forState:UIControlStateNormal];
        [narrowBtn addTarget:self action:@selector(zoomOutAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:narrowBtn];
        
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"iPhone_btn_fangdakuang"]]];
    }
    return self;
}
-(void)zoomInAction
{
    [self.delegate zoomIn];
}

-(void)zoomOutAction
{
    [self.delegate zoomOut];
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
