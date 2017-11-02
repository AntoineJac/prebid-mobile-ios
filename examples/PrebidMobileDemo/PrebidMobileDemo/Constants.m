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

#import "Constants.h"

@implementation Constants

NSString *const kAdServer = @"Ad Server";
NSString *const kDemandSource = @"Demand Source";
NSString *const kAdType = @"Ad Type";
NSString *const kPlacementId = @"Placement ID";
NSString *const kSize = @"Size";

NSString *const kDefaultPlacementId = @"9373413";
NSString *const kDefaultSize = @"300x250";

NSString *const kBanner = @"Banner";
NSString *const kInterstitial = @"Interstitial";
NSString *const kNative = @"Native";
NSString *const kVideo = @"Video";

#pragma mark - MoPub constants
NSString *const kMoPubAdServer = @"MoPub";
NSString *const kMoPubBannerAdUnitIdDemandSDK = @"5d748364ee9c46a2b112892fc3551b6f";
NSString *const kMoPubInterstitialAdUnitIdDemandSDK = @"739d7e40ee2e4767baff63fab4e4b9c4";
NSString *const kMoPubBannerAdUnitId = @"a9cb8ff85fef4b50b457e3b11119aabf";
NSString *const kMoPubInterstitialAdUnitId = @"fc82df5c964945c79cceef4c5666e1e2";


#pragma mark - DFP constants
NSString *const kDFPAdServer = @"DFP";
NSString *const kDFPBannerAdUnitIdDemandSDK = @"/19968336/test_network_mediation";
NSString *const kDFPInterstitialAdUnitIdDemandSDK = @"/19968336/test_network_mediation";
NSString *const kDFPBannerAdUnitId = @"/19968336/PriceCheck_300x250";
NSString *const kDFPInterstitialAdUnitId = @"/19968336/PriceCheck_Interstitial";

#pragma mark - Prebid Mobile constants
NSString *const kAccountId = @"aecd6ef7-b992-4e99-9bb8-65e2d984e1dd";
NSString *const kAdUnit1ConfigId = @"005bf148-d964-441a-a91f-e6f09a05d1c9";
NSString *const kAdUnit2ConfigId = @"005bf148-d964-441a-a91f-e6f09a05d1c9";

NSString *const kAdUnit1Id = @"HomeScreen";
NSString *const kAdUnit2Id = @"NavScreen";

NSString *const kFBAudienceNetwork = @"audienceNetwork";
NSString *const kFBBannerAdUnit = @"fbBannerAdUnit";
NSString *const kFBIntAdUnit = @"fbIntAdUnit";
NSString *const kFBBannerAdUnitConfigId = @"7767e961-6ead-45e0-856e-d82c75010dd7";

@end
