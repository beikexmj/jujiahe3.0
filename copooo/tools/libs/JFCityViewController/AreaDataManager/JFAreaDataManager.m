//
//  JFAreaDataManager.m
//  JFFootball
//
//  Created by 张志峰 on 2016/11/18.
//  Copyright © 2016年 zhifenx. All rights reserved.
//

#import "JFAreaDataManager.h"
#import <CoreLocation/CoreLocation.h>

#import "FMDB.h"

@interface JFAreaDataManager ()

@property (nonatomic, strong) FMDatabase *db;

@end

@implementation JFAreaDataManager

static JFAreaDataManager *manager = nil;
+ (JFAreaDataManager *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)areaSqliteDBData {
    // copy"area.sqlite"到Documents中
    NSFileManager *fileManager =[NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory =[paths objectAtIndex:0];
    NSString *txtPath =[documentsDirectory stringByAppendingPathComponent:@"city.db"];
    if([fileManager fileExistsAtPath:txtPath] == NO){
        NSString *resourcePath =[[NSBundle mainBundle] pathForResource:@"city" ofType:@"db"];
        [fileManager copyItemAtPath:resourcePath toPath:txtPath error:&error];
    }
    // 新建数据库并打开
    NSString *path  = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"city.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    self.db = db;
    BOOL success = [db open];
    if (success) {
        // 数据库创建成功!
        NSLog(@"数据库创建成功!");
        NSString *sqlStr = @"CREATE TABLE IF NOT EXISTS city (city_id INTEGER ,city_oid INTEGER ,city_name TEXT ,city_level INTEGER ,city_short_name TEXT ,city_full_name TEXT ,city_english_name TEXT ,city_pid INTEGER ,city_post_code INTEGER ,city_latitude FLOAT ,city_longitude FLOAT ,city_code_tabtime INTEGER ,city_code integer ,created_at TEXT ,updated_at TEXT ,city_altitude FLOAT);";
        BOOL successT = [self.db executeUpdate:sqlStr];
        if (successT) {
        // 创建表成功!
            
            NSLog(@"创建表成功!");
        }else{
            // 创建表失败!
            NSLog(@"创建表失败!");
            [self.db close];
        }
    }else{
        // 数据库创建失败!
        NSLog(@"数据库创建失败!");
        [self.db close];
    }
}

/// 所有市区的名称
- (void)cityData:(void (^)(NSMutableArray *dataArray))cityData {
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    FMResultSet *result = [self.db executeQuery:@"SELECT DISTINCT city_name FROM city WHERE city_level ='2';"];
    while ([result next]) {
        NSString *cityName = [result stringForColumn:@"city_name"];
        [resultArray addObject:cityName];
    }
    cityData(resultArray);
}

/// 获取当前市的city_oid
- (void)cityNumberWithCity:(NSString *)city cityNumber:(void (^)(NSString *cityNumber))cityNumber {
    FMResultSet *result = [self.db executeQuery:[NSString stringWithFormat:@"SELECT * FROM city WHERE city_name = '%@';",city]];
    while ([result next]) {
        NSString *number = [result stringForColumn:@"city_oid"];
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[result doubleForColumn:@"city_latitude"] longitude:[result doubleForColumn:@"city_longitude"]];
        [[NSUserDefaults standardUserDefaults] setObject: [NSKeyedArchiver archivedDataWithRootObject:location] forKey:@"cityLocations"];
        
        cityNumber(number);
    }
}
/// 所有区县的名称
- (void)areaData:(NSString *)cityNumber areaData:(void (^)(NSMutableArray *areaData))areaData {
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    NSString *sqlString = [NSString stringWithFormat:@"SELECT area_name FROM shop_area WHERE city_number ='%@';",cityNumber];
    FMResultSet *result = [self.db executeQuery:sqlString];
    while ([result next]) {
        NSString *areaName = [result stringForColumn:@"area_name"];
        [resultArray addObject:areaName];
    }
    areaData(resultArray);
}

/// 根据city_number获取当前城市
- (void)currentCity:(NSString *)cityNumber currentCityName:(void (^)(NSString *name))currentCityName {
    FMResultSet *result = [self.db executeQuery:[NSString stringWithFormat:@"SELECT DISTINCT city_name FROM city WHERE city_oid = '%@';",cityNumber]];
    while ([result next]) {
        NSString *name = [result stringForColumn:@"city_name"];
        currentCityName(name);
    }
}

- (void)searchCityData:(NSString *)searchObject result:(void (^)(NSMutableArray *result))result {
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    FMResultSet *areaResult = [self.db executeQuery:[NSString stringWithFormat:@"SELECT DISTINCT area_name,city_name,city_number FROM shop_area WHERE area_name LIKE '%@%%';",searchObject]];
    while ([areaResult next]) {
        NSString *area = [areaResult stringForColumn:@"area_name"];
        NSString *city = [areaResult stringForColumn:@"city_name"];
        NSString *cityNumber = [areaResult stringForColumn:@"city_number"];
        NSDictionary *dataDic = @{@"super":city,@"city":area,@"city_number":cityNumber};
        [resultArray addObject:dataDic];
    }
    
    if (resultArray.count == 0) {
        FMResultSet *cityResult = [self.db executeQuery:[NSString stringWithFormat:@"SELECT DISTINCT city_name,city_oid FROM city WHERE city_name LIKE '%@%%' AND city_level ='2';",searchObject]];
            while ([cityResult next]) {
                NSString *city = [cityResult stringForColumn:@"city_name"];
                NSString *cityNumber = [cityResult stringForColumn:@"city_oid"];
                NSString *province = @"";
                NSDictionary *dataDic = @{@"super":province,@"city":city,@"city_number":cityNumber};
                [resultArray addObject:dataDic];
            }
        
        if (resultArray.count == 0) {
            FMResultSet *provinceResult = [self.db executeQuery:[NSString stringWithFormat:@"SELECT DISTINCT province_name,city_name,city_number FROM shop_area WHERE province_name LIKE '%@%%';",searchObject]];
            
            while ([provinceResult next]) {
                NSString *province = [provinceResult stringForColumn:@"province_name"];
                NSString *city = [provinceResult stringForColumn:@"city_name"];
                NSString *cityNumber = [provinceResult stringForColumn:@"city_number"];
                NSDictionary *dataDic = @{@"super":province,@"city":city,@"city_number":cityNumber};
                [resultArray addObject:dataDic];
            }
            
            //统一在数组中传字典是为了JFSearchView解析数据时方便
            if (resultArray.count == 0) {
                [resultArray addObject:@{@"city":@"抱歉,未找到相关位置，可尝试修改后重试!",@"super":@""}];
            }
        }
    }
    //返回结果
    result(resultArray);
}

@end
