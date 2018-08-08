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

typedef NS_ENUM(NSInteger, PBPriceGranularity) {
    PBPriceGranularityLow,
    PBPriceGranularityMedium,
    PBPriceGranularityDense,
    PBPriceGranularityAuto,
    PBPriceGranularityHigh
};

-(void) setPriceGranularity:(PBPriceGranularity2)PBPriceGranularity;

@property (nonatomic, readwrite) NSString *__nullable priceGranularity;


@property (nonatomic, assign, readwrite) NSString* _Nonnull storeRequestId;

@end
