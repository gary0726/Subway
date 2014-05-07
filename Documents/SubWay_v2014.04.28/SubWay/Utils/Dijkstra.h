//
//  Dijkstra.h
//  SubWay
//
//  Created by Glex on 14-4-21.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "SqliteDao.h"

#define M 148

@interface Dijkstra : NSObject
{
@public
    bool s[M];
    int dist[M];
    int path[M];
    
    int length;
    
    int matrix[M][M];
    NSString *StrBegin,*StrEnd;
}
@property(nonatomic,retain)NSMutableArray *passStationArray;
-(void) BuildGraph;

+(NSMutableArray *)transLine:(NSMutableArray *)palcesLineArray s:(NSString *)start s1:(NSString *)end;

////计算含有APM线的价格
+(NSString *)price:(NSString *)start end:(NSString *)end array:(NSMutableArray *)palcesLineArray;

//startView、endView 的颜色
+(void)getLineAndColor:(NSString *)start str:(NSString *)end startV:(UIView *)startView endV:(UIView *)endView imageV:(UIImageView *)startKuangImage1 imageV1:(UIImageView *)startKuangImage2;


//换线方向
+(NSMutableArray *)changeLineDirection:(NSMutableArray *)changeLineArray passStation:(NSMutableArray *)passStationArray str:(NSString *)labelText;
//开始方向
+(NSString *)direction:(NSMutableArray *)palcesLine str:(NSString *)str str1:(NSString *)str1;
@end
