//
//  NXSig.h
//  cybex_ios_core_cpp
//
//  Created by koofrank on 2019/7/1.
//  Copyright © 2019 com.nbltrustdev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NXSig : NSObject

+ (NSString *)amendOrderWith:(NSString *)refId
                  cutLossPx:(NSString *)cutLossPx
               takeProfitPx:(NSString *)takeProfit
                  execNowPx:(NSString *)execNowPx
                 expiration:(NSString *)expiration
                     seller:(NSString *)seller;
@end

NS_ASSUME_NONNULL_END
