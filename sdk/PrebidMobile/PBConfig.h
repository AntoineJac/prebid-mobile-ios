/*   Copyright 2017 Prebid.org, Inc.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <Foundation/Foundation.h>


@interface PBConfig : NSObject

+ (nonnull instancetype)sharedInstance;

#ifdef DEBUG
+ (void)resetSharedInstance;
#endif

typedef NS_ENUM(NSInteger, PBPriceGranularity2) {
    PBPriceGranularityUnknown2,
    PBPriceGranularityMedium2,
    PBPriceGranularityDense2,
};

-(void) setPriceGranularity:(PBPriceGranularity2)priceGranularity;

@property (nonatomic, readwrite) NSString *__nullable priceGranularityF;


@property (nonatomic, assign, readwrite) NSString* _Nonnull storeRequestID;

@end