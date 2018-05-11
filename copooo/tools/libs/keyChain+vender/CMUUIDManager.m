//
//  CMUUIDManager.m
//  copooo
//
//  Created by XiaMingjiang on 2018/3/12.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "CMUUIDManager.h"
#import "CMKeyChain.h"

@implementation CMUUIDManager

static NSString * const KEY_IN_KEYCHAIN = @"com.copticomm.jjh";
static NSString * const KEY_UUID = @"com.copticomm.jjh";

+(void)saveUUID:(NSString *)uuid
{
    NSMutableDictionary *usernameUuidPairs = [NSMutableDictionary dictionary];
    [usernameUuidPairs setObject:uuid forKey:KEY_UUID];
    [CMKeyChain save:KEY_IN_KEYCHAIN data:usernameUuidPairs];
}

+(id)readUUID
{
    NSMutableDictionary *usernameUuidPairs = (NSMutableDictionary *)[CMKeyChain load:KEY_IN_KEYCHAIN];
    return [usernameUuidPairs objectForKey:KEY_UUID];
}

+(void)deleteUUID
{
    [CMKeyChain delete:KEY_IN_KEYCHAIN];
}
@end
