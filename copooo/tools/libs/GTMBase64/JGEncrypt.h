//
//  JGEncrypt.h
//  NDP_eHome
//
//  Created by 冠美 on 16/1/27.
//  Copyright © 2016年 JGeHome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"
@interface JGEncrypt : NSObject
+(NSString*)encryptWithContent:(NSString*)content type:(CCOperation)type key:(NSString*)aKey;
@end
