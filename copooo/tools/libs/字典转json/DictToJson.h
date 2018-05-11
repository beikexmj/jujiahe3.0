//
//  DictToJson.h
//  copooo
//
//  Created by 夏明江 on 16/9/1.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DictToJson : NSObject
+(NSString *)jsonStringWithDictionary:(NSDictionary *)dictionary;
+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
-(NSString *)jsonStringWithArray:(NSArray *)array;
@end
