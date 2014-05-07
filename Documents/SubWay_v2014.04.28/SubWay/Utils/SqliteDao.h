//
//  SqliteDao.h
//  SubWay
//
//  Created by apple on 14-3-27.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMResultSet.h"
#import "FMDatabase.h"

@interface SqliteDao : NSObject

+(NSMutableArray *)queryStation;
+(NSMutableArray *)findLineByStationId:(NSString *)name;

+(NSMutableArray *)findDeviceByStationId:(NSString *)englishName;
+(NSMutableDictionary *)findCategoryByCategoryId:(NSString *)categoryId;

+(NSMutableArray *)findEntranceByStationId:(NSString *)englishName;

+(NSMutableArray *)findStartAndEndTime:(NSString *)englishName;
+(NSMutableDictionary *)findStartAndEndTime1:(NSString *)name str:(NSString *)endStation;
+(NSMutableDictionary *)findPlaceByEndStation:(NSString *)endStationId;

+(NSMutableArray *)findAllPlacesByLineId:(NSString *)lineId;
+(NSMutableDictionary *)findTicketPriceByStationId:(NSString *)startStationId str:(NSString *)endStationId;
+(NSMutableDictionary *)findTimeStartAndEnd:(NSString *)startStationId str:(NSString *)endStationId;
+(NSMutableArray *)findPlaceByPinyin:(NSString *)Pinyin;

+(NSMutableDictionary *)findStationDetailInfo:(NSString *)zname;
+(NSMutableDictionary *)findColor:(NSString *)zlineId;

+(UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;
@end
