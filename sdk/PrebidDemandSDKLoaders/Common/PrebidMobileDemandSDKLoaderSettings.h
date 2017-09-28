/*   Copyright 2017 APPNEXUS INC
 
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

@interface PrebidMobileDemandSDKLoaderSettings : NSObject

+ (nonnull instancetype)sharedInstance;

#ifdef DEBUG
+ (void)resetSharedInstance;
#endif

/**
  * An enumeration object that holds different types of sdk demand sources available to be configured
  */
typedef NS_ENUM(NSInteger, PBDemandSourceType) {
    PBDemandSourceFacebook
};

- (void)enableDemandSources:(nonnull NSArray<NSNumber *> *)demandSources;
- (BOOL)isDemandEnabled:(nonnull NSString *)demand;

@end
