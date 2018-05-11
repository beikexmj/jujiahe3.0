//
//  CMUUIDManager.h
//  copooo
//
//  Created by XiaMingjiang on 2018/3/12.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMUUIDManager : NSObject

+(void)saveUUID:(NSString *)uuid;

+(id)readUUID;

+(void)deleteUUID;

@end
