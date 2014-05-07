//
//  Dijkstra.m
//  SubWay
//
//  Created by Glex on 14-4-21.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "Dijkstra.h"
#define SIZE_ONE 16
#define SIZE_TWO 24
#define SIZE_THIRDA 14
#define SIZE_THIRDB 16
#define SIZE_FOUR 18
#define SIZE_FIVE 24
#define SIZE_SIX 22
#define SIZE_EIGHT 13
#define SIZE_APM 9
#define SIZE_GF 14

extern NSMutableArray *arrLinePub;
extern NSArray *line1;
extern NSArray *line2;
extern NSArray *line3A;
extern NSArray *line3B;
extern NSArray *line4;
extern NSArray *line5;
extern NSArray *line6;
extern NSArray *line8;
extern NSArray *lineAPM;
extern NSArray *lineGF;
extern NSArray *node;

@implementation Dijkstra
@synthesize passStationArray;

-(int)GetPos:(NSArray *)array s:(NSString *)str
{
    int k=0;
    int j=0;
    
    for (NSString *ss in array)
    {
        if([ss isEqualToString:str])
        {
            k+=j;
        }
        j++;
    }
    return k;
}
-(void) BuildGraph
{
    // 初始化matrix
    for (int i=0; i<M; i++)
    {
        for (int j=0; j<M; j++)
        {
            matrix[i][j]=0;
        }
    }
    // 根据A建立边信息
    for (int i=0; i<(SIZE_ONE-1); i++)
    {
        int u =[self GetPos:node s:line1[i]];
        int v =[self GetPos:node s:line1[i+1]];
        
        matrix[u][v]=1;
        matrix[v][u]=1;
    }
    // 根据B建立边信息
    for (int i=0; i<(SIZE_TWO-1); i++)
    {
        int u =[self GetPos:node s:line2[i]];
        int v =[self GetPos:node s:line2[i+1]];
        
        matrix[u][v]=1;
        matrix[v][u]=1;
    }
    for (int i=0; i<(SIZE_THIRDA-1); i++)
    {
        int u =[self GetPos:node s:line3A[i]];
        int v =[self GetPos:node s:line3A[i+1]];
        
        matrix[u][v]=1;
        matrix[v][u]=1;
    }
    for (int i=0; i<(SIZE_THIRDB-1); i++)
    {
        int u =[self GetPos:node s:line3B[i]];
        int v =[self GetPos:node s:line3B[i+1]];
        
        matrix[u][v]=1;
        matrix[v][u]=1;
    }
    for (int i=0; i<(SIZE_FOUR-1); i++)
    {
        int u =[self GetPos:node s:line4[i]];
        int v =[self GetPos:node s:line4[i+1]];
        
        matrix[u][v]=1;
        matrix[v][u]=1;
    }
    for (int i=0; i<(SIZE_FIVE-1); i++)
    {
        int u =[self GetPos:node s:line5[i]];
        int v =[self GetPos:node s:line5[i+1]];
        
        matrix[u][v]=1;
        matrix[v][u]=1;
    }
    for (int i=0; i<(SIZE_SIX-1); i++)
    {
        int u =[self GetPos:node s:line6[i]];
        int v =[self GetPos:node s:line6[i+1]];
        
        matrix[u][v]=1;
        matrix[v][u]=1;
    }
    for (int i=0; i<(SIZE_EIGHT-1); i++)
    {
        int u =[self GetPos:node s:line8[i]];
        int v =[self GetPos:node s:line8[i+1]];
        
        matrix[u][v]=1;
        matrix[v][u]=1;
    }
    for (int i=0; i<(SIZE_APM-1); i++)
    {
        int u =[self GetPos:node s:lineAPM[i]];
        int v =[self GetPos:node s:lineAPM[i+1]];
        
        matrix[u][v]=1;
        matrix[v][u]=1;
    }
    for (int i=0; i<(SIZE_GF-1); i++)
    {
        int u =[self GetPos:node s:lineGF[i]];
        int v =[self GetPos:node s:lineGF[i+1]];
        
        matrix[u][v]=1;
        matrix[v][u]=1;
    }
    
    int u = [self GetPos:node s:StrBegin];
    int v = [self GetPos:node s:StrEnd];
    
    [self Dijkstra:u v:v];
}
-(void)Dijkstra:(int) v0 v:(int) v1
{
    // 1、初始化
    for (int i=0; i<M; i++)
    {
        s[i] = false;
        if (matrix[v0][i] != 0)
        {
            dist[i] = matrix[v0][i];
            path[i] = v0;
        }
        else
        {
            dist[i] = INT_MAX;
            path[i] = -1;
        }
    }
    s[v0]=true;
    dist[v0]=0;
    path[v0]=v0;
    
    // 2、循环n-1次
    for (int i=0; i<(M-1); i++)
    {
        // 2.1、取dist[u]最小的u
        int min=INT_MAX;
        int u;
        for (int j=0; j<M; j++)
        {
            if (s[j] == false && dist[j] < min)
            {
                min = dist[j];
                u = j;
            }
        }
        s[u] = true;
        // 2.2、更新u邻接的所有w
        for (int w=0; w<M; w++)
        {
            if (s[w] == false &&matrix[u][w] != 0)
            {
                if (dist[u] + matrix[u][w] < dist[w])
                {
                    dist[w] = dist[u] + matrix[u][w];
                    path[w] = u;
                }
            }
        }
    }
    
    passStationArray=[[NSMutableArray alloc]init];
    // 3、获取结果
    length=0;
    while (v1 != v0)
    {
        v1 = path[v1];
        [passStationArray addObject:[node objectAtIndex:v1]];
        //NSLog(@"-dijistra-----:%@",[node objectAtIndex:v1]);
        length++;
    }
    length ++;
    //NSLog(@"length:%i",length);
}
#pragma mar -找出是否换乘站
+(NSMutableArray *)transLine:(NSMutableArray *)palcesLineArray s:(NSString *)start s1:(NSString *)end
{
    NSMutableArray *arrArrXiangLingZhan = [NSMutableArray array];
    /**
     *  两个站点确定的 地铁线ID
     */
    [arrLinePub removeAllObjects];
    // 计算得到相邻站的公共 地铁线
    
//    for (NSString *s in palcesLineArray) {
//        NSLog(@"all-%@",s);
//    }
//
//    [palcesLineArray insertObject:start atIndex:0];
//    [palcesLineArray insertObject:end atIndex:palcesLineArray.count];
    
    for (NSInteger i=0; i<palcesLineArray.count-1; i++) {
        NSString *zhanCurr = palcesLineArray[i];
        NSString *zhanNext = palcesLineArray[i+1];
        
        NSArray *arrayCurr;
        NSArray *arrayNext;
        if([zhanCurr hasSuffix:@"（未开通）"]&&![zhanNext hasSuffix:@"（未开通）"])
        {
            NSRange range=[zhanCurr rangeOfString:@"（"];
            NSString *str=[zhanCurr substringWithRange:NSMakeRange(0, range.location)];
            
            arrayCurr= [SqliteDao findLineByStationId:str];
            arrayNext= [SqliteDao findLineByStationId:zhanNext];
        }
        else if([zhanNext hasSuffix:@"（未开通）"]&&![zhanCurr hasSuffix:@"（未开通）"])
        {
            NSRange range=[zhanNext rangeOfString:@"（"];
            NSString *str=[zhanNext substringWithRange:NSMakeRange(0, range.location)];
            
            arrayCurr= [SqliteDao findLineByStationId:zhanCurr];
            arrayNext= [SqliteDao findLineByStationId:str];
        }
        else if ([zhanNext hasSuffix:@"（未开通）"]&&[zhanCurr hasSuffix:@"（未开通）"])
        {
            NSRange range=[zhanNext rangeOfString:@"（"];
            NSString *str=[zhanNext substringWithRange:NSMakeRange(0, range.location)];
            arrayNext= [SqliteDao findLineByStationId:str];
            
            NSRange range1=[zhanCurr rangeOfString:@"（"];
            NSString *str1=[zhanCurr substringWithRange:NSMakeRange(0, range1.location)];
            arrayCurr= [SqliteDao findLineByStationId:str1];
        }
        else
        {
            arrayCurr= [SqliteDao findLineByStationId:zhanCurr];
            arrayNext= [SqliteDao findLineByStationId:zhanNext];
        }
        
//        NSLog(@"-curr-%@",arrayCurr);
//        NSLog(@"-next-%@",arrayNext);
        
        
        NSMutableSet *lineCurr=[[NSMutableSet alloc]initWithArray:arrayCurr];
        NSMutableSet *lineNext=[[NSMutableSet alloc]initWithArray:arrayNext];
        
        [lineCurr intersectSet:lineNext];
        
        // TODO:计算当前站和下一个站的公共 地铁线，得到两个字站共同的地铁线
        NSObject *linePub = [lineCurr anyObject];
        
        if(linePub!=nil)
            [arrLinePub addObject:linePub];
        
        [arrArrXiangLingZhan addObject:@{zhanCurr:zhanNext}];
    }
    
    NSMutableArray *changeArray1=[[NSMutableArray alloc]init];
    
   if(arrLinePub.count>0)
   {
       for (NSInteger i=0; i<arrLinePub.count-1; i++) {
           NSNumber *lineCurr = [arrLinePub[i] objectForKey:@"ZLINEID"];
           NSNumber *lineNext = [arrLinePub[i+1] objectForKey:@"ZLINEID"];
           
           
           if ([lineCurr integerValue]!=[lineNext integerValue]) {
               // 线路改变了，表示换乘点
               NSMutableDictionary *dictCurrXiangLianZhan = arrArrXiangLingZhan[i];
               
               NSNumber *transZhan = [[dictCurrXiangLianZhan allValues] objectAtIndex:0];
               [changeArray1 addObject:transZhan];
           }
       }

   }
//    for (NSString *ss in changeArray1) {
//        NSLog(@"-Dijkstra换乘站点-%@",ss);
//    }
//    
//    for (NSString *s in arrLinePub) {
//        NSLog(@"交集站：%@",s);
//    }
    return changeArray1;
}

#pragma mark- //计算含有APM线的价格
+(NSString *)price:(NSString *)start end:(NSString *)end array:(NSMutableArray *)palcesLineArray
{
    NSMutableArray *arrayApm=[lineAPM mutableCopy];
    [arrayApm removeObjectAtIndex:0];
    [arrayApm removeLastObject];
    
    
    NSMutableArray *arrayNotAPM=[NSMutableArray array];
    NSMutableArray *arrayContainAPM=[NSMutableArray array];
    
    [palcesLineArray insertObject:start atIndex:0];
    [palcesLineArray insertObject:end atIndex:palcesLineArray.count];
    
    for (NSString *s in palcesLineArray) {
        for (NSString *s1 in arrayApm)
        {
            if([s isEqualToString:s1])
            {
                [arrayContainAPM addObject:s];
            }
        }
    }
    
    NSMutableArray *p= [palcesLineArray mutableCopy];
    for (NSString *s in arrayContainAPM) {
        [p removeObject:s];
    }
    arrayNotAPM=p;
    
    for (NSString *s1 in arrayApm)
    {
        if([start isEqualToString:s1])
        {
            if([end isEqualToString:[lineAPM objectAtIndex:0]]||[end isEqualToString:[lineAPM objectAtIndex:lineAPM.count-1]])
            {
                return @"2";
            }
            else
            {
                NSMutableDictionary *ticketPriceDic=[SqliteDao findTicketPriceByStationId:[arrayNotAPM objectAtIndex:0] str:[arrayNotAPM objectAtIndex:arrayNotAPM.count-1]];
                return [NSString stringWithFormat:@"%i",[[ticketPriceDic objectForKey:@"ZPRICE"] integerValue]+2];
            }
        }
        if([end isEqualToString:s1])
        {
            if([start isEqualToString:[lineAPM objectAtIndex:0]]||[start isEqualToString:[lineAPM objectAtIndex:lineAPM.count-1]])
            {
                return @"2";
            }
            else
            {
                NSMutableDictionary *ticketPriceDic=[SqliteDao findTicketPriceByStationId:[arrayNotAPM objectAtIndex:0] str:[arrayNotAPM objectAtIndex:arrayNotAPM.count-1]];
                return [NSString stringWithFormat:@"%i",[[ticketPriceDic objectForKey:@"ZPRICE"] integerValue]+2];
            }
        }
    }
    
    NSMutableDictionary *ticketPriceDic=[SqliteDao findTicketPriceByStationId:start str:end];
    return [ticketPriceDic objectForKey:@"ZPRICE"];
}
#pragma mark -设置颜色
+(void)getLineAndColor:(NSString *)start str:(NSString *)end startV:(UIView *)startView endV:(UIView *)endView imageV:(UIImageView *)startKuangImage1 imageV1:(UIImageView *)startKuangImage2
{
    NSMutableArray *startArray=[SqliteDao findLineByStationId:start];
    NSMutableArray *endArray=[SqliteDao findLineByStationId:end];
    
    NSString *color=[[startArray objectAtIndex:0]objectForKey:@"ZCOLOR"];
    color=[color substringWithRange:NSMakeRange(5, color.length-6)];
    NSArray *colorArray=[color componentsSeparatedByString:@","];
    
    float red= ([colorArray[0] floatValue])/255;
    float green= ([colorArray[1] floatValue])/255;
    float blue= ([colorArray[2] floatValue])/255;
    float alpha= ([colorArray[3] floatValue]);
    startView.backgroundColor=[UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
    
    NSString *color1=[[endArray objectAtIndex:0]objectForKey:@"ZCOLOR"];
    color1=[color1 substringWithRange:NSMakeRange(5,color1.length-6)];
    NSArray *colorArray1=[color1 componentsSeparatedByString:@","];
    
    float red1= ([colorArray1[0] floatValue])/255;
    float green1= ([colorArray1[1] floatValue])/255;
    float blue1= ([colorArray1[2] floatValue])/255;
    float alpha1= ([colorArray1[3] floatValue]);
    endView.backgroundColor=[UIColor colorWithRed:red1 green:green1 blue:blue1 alpha:alpha1];
    
    
    NSString *startFlag=[[startArray objectAtIndex:0]objectForKey:@"ZLINENUMBER"];
    if([startFlag isEqualToString:@"1"])
        startKuangImage1.image=[UIImage imageNamed:@"iPhone_kuang_0"];
    if([startFlag isEqualToString:@"2"])
        startKuangImage1.image=[UIImage imageNamed:@"iPhone_kuang_1"];
    if([startFlag isEqualToString:@"3"])
        startKuangImage1.image=[UIImage imageNamed:@"iPhone_kuang_2"];
    if([startFlag isEqualToString:@"4"])
        startKuangImage1.image=[UIImage imageNamed:@"iPhone_kuang_3"];
    if([startFlag isEqualToString:@"5"])
        startKuangImage1.image=[UIImage imageNamed:@"iPhone_kuang_4"];
    if([startFlag isEqualToString:@"6"])
        startKuangImage1.image=[UIImage imageNamed:@"iPhone_kuang_9"];
    if([startFlag isEqualToString:@"8"])
        startKuangImage1.image=[UIImage imageNamed:@"iPhone_kuang_6"];
    if([startFlag isEqualToString:@"APM"])
        startKuangImage1.image=[UIImage imageNamed:@"iPhone_kuang_8"];
    if([startFlag isEqualToString:@"GF"])
        startKuangImage1.image=[UIImage imageNamed:@"iPhone_kuang_7"];
    
    
    NSString *endFlag=[[endArray objectAtIndex:0]objectForKey:@"ZLINENUMBER"];
    if([endFlag isEqualToString:@"1"])
        startKuangImage2.image=[UIImage imageNamed:@"iPhone_kuang_0"];
    if([endFlag isEqualToString:@"2"])
        startKuangImage2.image=[UIImage imageNamed:@"iPhone_kuang_1"];
    if([endFlag isEqualToString:@"3"])
        startKuangImage2.image=[UIImage imageNamed:@"iPhone_kuang_2"];
    if([endFlag isEqualToString:@"4"])
        startKuangImage2.image=[UIImage imageNamed:@"iPhone_kuang_3"];
    if([endFlag isEqualToString:@"5"])
        startKuangImage2.image=[UIImage imageNamed:@"iPhone_kuang_4"];
    if([endFlag isEqualToString:@"6"])
        startKuangImage2.image=[UIImage imageNamed:@"iPhone_kuang_9"];
    if([endFlag isEqualToString:@"8"])
        startKuangImage2.image=[UIImage imageNamed:@"iPhone_kuang_6"];
    if([endFlag isEqualToString:@"APM"])
        startKuangImage2.image=[UIImage imageNamed:@"iPhone_kuang_8"];
    if([endFlag isEqualToString:@"GF"])
        startKuangImage2.image=[UIImage imageNamed:@"iPhone_kuang_7"];
    
}
+(NSMutableArray *)changeLineDirection:(NSMutableArray *)changeLineArray passStation:(NSMutableArray *)passStationArray str:(NSString *)labelText
{
    
    [arrayPublicLine removeAllObjects];
    
    for (int j=0; j<passStationArray.count; j++)
    {
        for (int i=0; i<changeLineArray.count; i++)
        {
            if([changeLineArray[i] isEqualToString:passStationArray[j]])
            {
                NSString *zhanCurr = passStationArray[j];
                NSString *zhanNext = passStationArray[j+1];
                
                NSArray *arrayCurr;
                NSArray *arrayNext;
                arrayCurr= [SqliteDao findLineByStationId:zhanCurr];
                arrayNext= [SqliteDao findLineByStationId:zhanNext];
                
                NSMutableSet *lineCurr=[[NSMutableSet alloc]initWithArray:arrayCurr];
                NSMutableSet *lineNext=[[NSMutableSet alloc]initWithArray:arrayNext];
                
                [lineCurr intersectSet:lineNext];
                
                // TODO:计算当前站和下一个站的公共 地铁线，得到两个字站共同的地铁线
                NSObject *linePub = [lineCurr anyObject];
                
                if(linePub!=nil)
                    [arrayPublicLine addObject:linePub];
            }
        }
    }
    
    NSMutableArray *changeLineDirection=[NSMutableArray array];
    
    if(changeLineArray.count>0)
    {
        if(passStationArray.count==3)
        {
            NSString *dir=@"机场南";//存放转线方向
            NSString *changeLine=@"3";//存放转线站点的哪条线
            
            
            if([[[arrLinePub objectAtIndex:1]objectForKey:@"ZLINEID"] integerValue]==1)
            {
                changeLine=@"1";
                
                NSInteger a=[line1 indexOfObject:changeLineArray[0]];
                NSInteger b=[line1 indexOfObject:labelText];
                
                if (a<b) {
                    dir=[line1 lastObject];
                }
                else
                {
                    dir=[line1 firstObject];
                }
            }
            if([[[arrLinePub objectAtIndex:1]objectForKey:@"ZLINEID"] integerValue]==2)
            {
                changeLine=@"2";
                
                NSInteger a=[line2 indexOfObject:changeLineArray[0]];
                NSInteger b=[line2 indexOfObject:labelText];
                
                if (a<b) {
                    dir=[line2 lastObject];
                }
                else
                {
                    dir=[line2 firstObject];
                }
            }
            if([[[arrLinePub objectAtIndex:1]objectForKey:@"ZLINEID"] integerValue]==3)
            {
                changeLine=@"3";
                NSInteger a=[line3A indexOfObject:changeLineArray[0]];
                NSInteger b=[line3A indexOfObject:labelText];
                
                if (a<b) {
                    dir=[line3A lastObject];
                }
                else
                {
                    dir=[line3A firstObject];
                }
            }
            if([[[arrLinePub objectAtIndex:1]objectForKey:@"ZLINEID"] integerValue]==4)
            {
                changeLine=@"3";
                
                NSInteger a=[line3B indexOfObject:changeLineArray[0]];
                NSInteger b=[line3B indexOfObject:labelText];
                
                if (a<b) {
                    dir=[line3B lastObject];
                }
                else
                {
                    dir=[line3B firstObject];
                }
            }
            if([[[arrLinePub objectAtIndex:1]objectForKey:@"ZLINEID"] integerValue]==5)
            {
                changeLine=@"4";
                
                NSInteger a=[line4 indexOfObject:changeLineArray[0]];
                NSInteger b=[line4 indexOfObject:labelText];
                
                if (a<b) {
                    dir=[line4 lastObject];
                }
                else
                {
                    dir=[line4 firstObject];
                }
            }
            if([[[arrLinePub objectAtIndex:1]objectForKey:@"ZLINEID"] integerValue]==6)
            {
                changeLine=@"5";
                
                NSInteger a=[line5 indexOfObject:changeLineArray[0]];
                NSInteger b=[line5 indexOfObject:labelText];
                
                if (a<b) {
                    dir=[line5 lastObject];
                }
                else
                {
                    dir=[line5 firstObject];
                }
            }
            if([[[arrLinePub objectAtIndex:1]objectForKey:@"ZLINEID"] integerValue]==10)
            {
                changeLine=@"6";
                
                NSInteger a=[line6 indexOfObject:changeLineArray[0]];
                NSInteger b=[line6 indexOfObject:labelText];
                
                if (a<b) {
                    dir=[line6 lastObject];
                }
                else
                {
                    dir=[line6 firstObject];
                }
            }
            if([[[arrLinePub objectAtIndex:1]objectForKey:@"ZLINEID"] integerValue]==7)
            {
                changeLine=@"8";
                
                NSInteger a=[line8 indexOfObject:changeLineArray[0]];
                NSInteger b=[line8 indexOfObject:labelText];
                
                if (a<b) {
                    dir=[line8 lastObject];
                }
                else
                {
                    dir=[line8 firstObject];
                }
            }
            if([[[arrLinePub objectAtIndex:1]objectForKey:@"ZLINEID"] integerValue]==8)
            {
                changeLine=@"GF";
                
                NSInteger a=[lineGF indexOfObject:changeLineArray[0]];
                NSInteger b=[lineGF indexOfObject:labelText];
                
                if (a<b) {
                    dir=[lineGF lastObject];
                }
                else
                {
                    dir=[lineGF firstObject];
                }
            }
            
            
            if([[[arrLinePub objectAtIndex:1]objectForKey:@"ZLINEID"] integerValue]==9)
            {
                changeLine=@"APM";
                
                NSInteger a=[lineAPM indexOfObject:changeLineArray[0]];
                NSInteger b=[lineAPM indexOfObject:labelText];
                
                if (a<b) {
                    dir=[lineAPM lastObject];
                }
                else
                {
                    dir=[lineAPM firstObject];
                }
            }
            
            [changeLineDirection addObject:@[changeLine,dir]];
        }
        else
        {
            NSMutableArray *arrayIndex=[NSMutableArray array];
            for (int i=0; i<changeLineArray.count; i++) {
                [arrayIndex addObject:[NSNumber numberWithInteger:[passStationArray indexOfObject:changeLineArray[i]]]];
            }
            
            for (int i=0;i<arrayIndex.count;i++) {
                
                NSString *dir=@"机场南";//存放转线方向
                NSString *changeLine=@"3";//存放转线站点的哪条线
                
                NSString *s=arrayIndex[i];
                
                NSString *zhanNext=[passStationArray objectAtIndex:[s integerValue]+1];//转线的下一个站点
                //NSLog(@"--超过3个站点换乘站的下一站--%@",zhanNext);
                
                
                if([[[arrayPublicLine objectAtIndex:i]objectForKey:@"ZLINEID"] integerValue]==1)
                {
                    changeLine=@"1";
                    
                    NSInteger a=[line1 indexOfObject:[passStationArray objectAtIndex:[s integerValue]]];
                    NSInteger b=[line1 indexOfObject:zhanNext];
                    
                    if (a<b) {
                        dir=[line1 lastObject];
                    }
                    else
                    {
                        dir=[line1 firstObject];
                    }
                }
                if([[[arrayPublicLine objectAtIndex:i]objectForKey:@"ZLINEID"] integerValue]==2)
                {
                    changeLine=@"2";
                    
                    NSInteger a=[line2 indexOfObject:[passStationArray objectAtIndex:[s integerValue]]];
                    NSInteger b=[line2 indexOfObject:zhanNext];
                    
                    if (a<b) {
                        dir=[line2 lastObject];
                    }
                    else
                    {
                        dir=[line2 firstObject];
                    }
                }
                if([[[arrayPublicLine objectAtIndex:i]objectForKey:@"ZLINEID"] integerValue]==3)
                {
                    changeLine=@"3";
                    NSInteger a=[line3A indexOfObject:[passStationArray objectAtIndex:[s integerValue]]];
                    NSInteger b=[line3A indexOfObject:zhanNext];
                    
                    if (a<b) {
                        dir=[line3A lastObject];
                    }
                    else
                    {
                        dir=[line3A firstObject];
                    }
                }
                if([[[arrayPublicLine objectAtIndex:i]objectForKey:@"ZLINEID"] integerValue]==4)
                {
                    changeLine=@"3";
                    NSInteger a=[line3B indexOfObject:[passStationArray objectAtIndex:[s integerValue]]];
                    NSInteger b=[line3B indexOfObject:zhanNext];
                    
                    if (a<b) {
                        dir=[line3B lastObject];
                    }
                    else
                    {
                        dir=[line3B firstObject];
                    }
                }
                if([[[arrayPublicLine objectAtIndex:i]objectForKey:@"ZLINEID"] integerValue]==5)
                {
                    changeLine=@"4";
                    NSInteger a=[line4 indexOfObject:[passStationArray objectAtIndex:[s integerValue]]];
                    NSInteger b=[line4 indexOfObject:zhanNext];
                    
                    if (a<b) {
                        dir=[line4 lastObject];
                    }
                    else
                    {
                        dir=[line4 firstObject];
                    }
                }
                if([[[arrayPublicLine objectAtIndex:i]objectForKey:@"ZLINEID"] integerValue]==6)
                {
                    changeLine=@"5";
                    NSInteger a=[line5 indexOfObject:[passStationArray objectAtIndex:[s integerValue]]];
                    NSInteger b=[line5 indexOfObject:zhanNext];
                    
                    if (a<b) {
                        dir=[line5 lastObject];
                    }
                    else
                    {
                        dir=[line5 firstObject];
                    }
                }
                if([[[arrayPublicLine objectAtIndex:i]objectForKey:@"ZLINEID"] integerValue]==10)
                {
                    changeLine=@"6";
                    NSInteger a=[line6 indexOfObject:[passStationArray objectAtIndex:[s integerValue]]];
                    NSInteger b=[line6 indexOfObject:zhanNext];
                    
                    if (a<b) {
                        dir=[line6 lastObject];
                    }
                    else
                    {
                        dir=[line6 firstObject];
                    }
                }
                if([[[arrayPublicLine objectAtIndex:i]objectForKey:@"ZLINEID"] integerValue]==7)
                {
                    changeLine=@"8";
                    NSInteger a=[line8 indexOfObject:[passStationArray objectAtIndex:[s integerValue]]];
                    NSInteger b=[line8 indexOfObject:zhanNext];
                    
                    if (a<b) {
                        dir=[line8 lastObject];
                    }
                    else
                    {
                        dir=[line8 firstObject];
                    }
                }
                if([[[arrayPublicLine objectAtIndex:i]objectForKey:@"ZLINEID"] integerValue]==8)
                {
                    changeLine=@"GF";
                    NSInteger a=[lineGF indexOfObject:[passStationArray objectAtIndex:[s integerValue]]];
                    NSInteger b=[lineGF indexOfObject:zhanNext];
                    
                    if (a<b) {
                        dir=[lineGF lastObject];
                    }
                    else
                    {
                        dir=[lineGF firstObject];
                    }
                }
                
                
                if([[[arrayPublicLine objectAtIndex:i]objectForKey:@"ZLINEID"] integerValue]==9)
                {
                    changeLine=@"APM";
                    NSInteger a=[lineAPM indexOfObject:[passStationArray objectAtIndex:[s integerValue]]];
                    NSInteger b=[lineAPM indexOfObject:zhanNext];
                    
                    if (a<b) {
                        dir=[lineAPM lastObject];
                    }
                    else
                    {
                        dir=[lineAPM firstObject];
                    }
                }
                [changeLineDirection addObject:@[changeLine,dir]];
            }
        }
    }
//    for (NSString *  s in changeLineDirection) {
//        NSLog(@"change line and direction:%@",s);
//    }
    
    return changeLineDirection;
}

+(NSString *)direction:(NSMutableArray *)palcesLine str:(NSString *)str str1:(NSString *)str1
{
    NSString *direction;
    
    NSMutableArray *palcesLineArray=[[NSMutableArray alloc]initWithArray:palcesLine];
    [palcesLineArray insertObject:str atIndex:0];
    [palcesLineArray insertObject:str1 atIndex:palcesLineArray.count];
    
    
    if(arrLinePub.count>0)
    {
        if([[[arrLinePub objectAtIndex:0]objectForKey:@"ZLINEID"] integerValue]==1)
        {
            NSInteger a=[line1 indexOfObject:[palcesLineArray objectAtIndex:0]];
            NSInteger b=[line1 indexOfObject:[palcesLineArray objectAtIndex:1]];
            
            if (a<b) {
                direction=[line1 lastObject];
            }
            else
            {
                direction=[line1 firstObject];
            }
        }
        if([[[arrLinePub objectAtIndex:0]objectForKey:@"ZLINEID"] integerValue]==2)
        {
            NSInteger a=[line2 indexOfObject:[palcesLineArray objectAtIndex:0]];
            NSInteger b=[line2 indexOfObject:[palcesLineArray objectAtIndex:1]];
            
            if (a<b) {
                direction=[line2 lastObject];
            }
            else
            {
                direction=[line2 firstObject];
            }
        }
        if([[[arrLinePub objectAtIndex:0]objectForKey:@"ZLINEID"] integerValue]==3)
        {
            NSInteger a=[line3A indexOfObject:[palcesLineArray objectAtIndex:0]];
            NSInteger b=[line3A indexOfObject:[palcesLineArray objectAtIndex:1]];
            
            if (a<b) {
                direction=[line3A lastObject];
            }
            else
            {
                direction=[line3A firstObject];
            }
        }
        if([[[arrLinePub objectAtIndex:0]objectForKey:@"ZLINEID"] integerValue]==4)
        {
            NSInteger a=[line3B indexOfObject:[palcesLineArray objectAtIndex:0]];
            NSInteger b=[line3B indexOfObject:[palcesLineArray objectAtIndex:1]];
            
            if (a<b) {
                direction=[line3B lastObject];
            }
            else
            {
                direction=[line3B firstObject];
            }
        }
        if([[[arrLinePub objectAtIndex:0]objectForKey:@"ZLINEID"] integerValue]==5)
        {
            NSInteger a=[line4 indexOfObject:[palcesLineArray objectAtIndex:0]];
            NSInteger b=[line4 indexOfObject:[palcesLineArray objectAtIndex:1]];
            
            if (a<b) {
                direction=[line4 lastObject];
            }
            else
            {
                direction=[line4 firstObject];
            }
        }
        if([[[arrLinePub objectAtIndex:0]objectForKey:@"ZLINEID"] integerValue]==6)
        {
            NSInteger a=[line5 indexOfObject:[palcesLineArray objectAtIndex:0]];
            NSInteger b=[line5 indexOfObject:[palcesLineArray objectAtIndex:1]];
            
            if (a<b) {
                direction=[line5 lastObject];
            }
            else
            {
                direction=[line5 firstObject];
            }
        }
        if([[[arrLinePub objectAtIndex:0]objectForKey:@"ZLINEID"] integerValue]==10)
        {
            NSInteger a=[line6 indexOfObject:[palcesLineArray objectAtIndex:0]];
            NSInteger b=[line6 indexOfObject:[palcesLineArray objectAtIndex:1]];
            
            if (a<b) {
                direction=[line6 lastObject];
            }
            else
            {
                direction=[line6 firstObject];
            }
        }
        if([[[arrLinePub objectAtIndex:0]objectForKey:@"ZLINEID"] integerValue]==7)
        {
            NSInteger a=[line8 indexOfObject:[palcesLineArray objectAtIndex:0]];
            NSInteger b=[line8 indexOfObject:[palcesLineArray objectAtIndex:1]];
            
            if (a<b) {
                direction=[line8 lastObject];
            }
            else
            {
                direction=[line8 firstObject];
            }
        }
        if([[[arrLinePub objectAtIndex:0]objectForKey:@"ZLINEID"] integerValue]==8)
        {
            NSInteger a=[lineGF indexOfObject:[palcesLineArray objectAtIndex:0]];
            NSInteger b=[lineGF indexOfObject:[palcesLineArray objectAtIndex:1]];
            
            if (a<b) {
                direction=[lineGF lastObject];
            }
            else
            {
                direction=[lineGF firstObject];
            }
        }
        
        
        if([[[arrLinePub objectAtIndex:0]objectForKey:@"ZLINEID"] integerValue]==9)
        {
            NSInteger a=[lineAPM indexOfObject:[palcesLineArray objectAtIndex:0]];
            NSInteger b=[lineAPM indexOfObject:[palcesLineArray objectAtIndex:1]];
            
            if (a<b) {
                direction=[lineAPM lastObject];
            }
            else
            {
                direction=[lineAPM firstObject];
            }
        }
    }
    return direction;
}
@end
