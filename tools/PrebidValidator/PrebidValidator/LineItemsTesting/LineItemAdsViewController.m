//
//  LineItemAdsViewController.m
//  PriceCheckTestApp
//
//  Created by Nicole Hedley on 24/08/2016.
//  Copyright © 2016 Nicole Hedley. All rights reserved.
//

@import GoogleMobileAds;

#import "LineItemAdsViewController.h"
#import "PBVSharedConstants.h"
#import "MPAdView.h"
#import "MPInterstitialAdController.h"
#import "LineItemKeywordsManager.h"

@interface LineItemAdsViewController () <MPInterstitialAdControllerDelegate,
                                         GADInterstitialDelegate,
                                         UITableViewDataSource,
                                         UITableViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *bidPriceToCell;
@property (nonatomic, strong) NSArray *bidPrices;


@property (nonatomic, strong) UITableView *interstitialTableView;
@property (nonatomic, strong) UITableView *bannerTableView;

@property (nonatomic, assign) BOOL isBanner;
@property (nonatomic, assign) BOOL isInterstitial;

@property (nonatomic, assign) CGSize adSize;

@property (nonatomic, strong) UIScrollView *scrollView;

@property PBVLineItemsSetupValidator * validator;
@end

@implementation LineItemAdsViewController

- (instancetype)initWithValidator:(PBVLineItemsSetupValidator *)validator
{
      self = [super init];
    if(self){
        _validator = validator;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Line items";
    
    // Retrieve saved values from NSUserDefaults and setup instance variables
    NSString *adServerName = [[NSUserDefaults standardUserDefaults] stringForKey:kAdServerNameKey];
    NSString *adFormatName = [[NSUserDefaults standardUserDefaults] stringForKey:kAdFormatNameKey];
    NSString *adUnitID = [[NSUserDefaults standardUserDefaults] stringForKey:kAdUnitIdKey];
    NSString *adSizeString = [[NSUserDefaults standardUserDefaults] stringForKey:kAdSizeKey];
    _bidPrices = [[NSUserDefaults standardUserDefaults] arrayForKey:kBidPriceKey];
    
    _isBanner = [adFormatName isEqualToString:kBannerString];
    _isInterstitial = [adFormatName isEqualToString:kInterstitialString];
    
    _adSize = CGSizeZero;
    if ([adSizeString isEqualToString:kBannerSizeString]) {
        _adSize = CGSizeMake(kBannerSizeWidth, kBannerSizeHeight);
    } else if ([adSizeString isEqualToString:kMediumRectangleSizeString]) {
        _adSize = CGSizeMake(kMediumRectangleSizeWidth, kMediumRectangleSizeHeight);
    } else if ([adSizeString isEqualToString:kInterstitialSizeString]) {
        _adSize = CGSizeMake(kInterstitialSizeWidth, kInterstitialSizeHeight);
    }
    
    // Setup banner or interstital table view depending on format chosen
    if (self.isBanner) {
        _bannerTableView = [[UITableView alloc] init];
        _bannerTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self setupTableView:_bannerTableView];
    } else if (self.isInterstitial) {
        _interstitialTableView = [[UITableView alloc] init];
        _interstitialTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self setupTableView:_interstitialTableView];
        self.bidPriceToCell = [[NSMutableDictionary alloc] init];
    }
}

// Table initializer method, properties are the same for banner and interstitial
- (void)setupTableView:(UITableView *)tableView {
    tableView.frame = self.view.frame;
    tableView.dataSource = self;
    tableView.delegate = self;
    
    tableView.backgroundColor = [UIColor whiteColor];
    [tableView setSeparatorColor:[UIColor darkGrayColor]];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    if ([tableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        tableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
    self.view = tableView;
}

#pragma mark - UITableViewDataSource methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    if (tableView == self.bannerTableView) {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(kAdLabelLocationX, kAdLabelLocationY, self.view.frame.size.width, kAdTitleLabelHeight)];
        title.font = [UIFont boldSystemFontOfSize:16];
        title.textColor = [UIColor blackColor];
        [title setText:[@"$" stringByAppendingString:[self.bidPrices objectAtIndex:indexPath.row]]];
        [cell.contentView addSubview:title];

        // Show ad view if it loaded, otherwise show the ad failed label in its place
        UIView *adView = [_validator.getDisplayables valueForKey:[self.bidPrices objectAtIndex:indexPath.row]];
        CGFloat x = ([UIScreen mainScreen].bounds.size.width - _adSize.width) / 2.0;
        adView.frame = CGRectMake(x, kAdLocationY, _adSize.width, _adSize.height);
        [cell.contentView addSubview:adView];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    } else if (tableView == self.interstitialTableView) {
        NSString *bidPrice = [self.bidPrices objectAtIndex:indexPath.row];
        cell.textLabel.text = [@"Click here to test interstitial for $" stringByAppendingString: bidPrice];
        [self.bidPriceToCell setObject:cell forKey:bidPrice];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.bidPrices count];
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isBanner) {
        return self.adSize.height + kAdLocationY + kAdMargin;
    }
    return kAdLocationY + kAdMargin;
}

// This ensures the separators do not have any inset
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Only the interstitial rows are selectable, the banner rows are just for display
    if (tableView == self.bannerTableView) {
        return;
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = cell.textLabel.text;
    NSRange range = [cellText rangeOfString:@"$"];
    NSString *bidPrice = [cellText substringFromIndex:range.location + 1];
    id adObject = _validator.getDisplayables[bidPrice];
    if (adObject) {
        if ([adObject isKindOfClass:[MPInterstitialAdController class]]) {
            MPInterstitialAdController *interstitial = (MPInterstitialAdController *) adObject;
            NSLog(@"price %@ for interstitial %@", bidPrice, interstitial);
            interstitial.delegate = self;
            if (interstitial.ready) {
                [interstitial showFromViewController:self];
            } else {
                [cell setSelected:NO];
            }
        } else if([adObject isKindOfClass:[DFPInterstitial class]] ) {
            DFPInterstitial *interstitial = (DFPInterstitial *)adObject;
            interstitial.delegate = self;
            if (interstitial.isReady) {
                [interstitial presentFromRootViewController:self];
            } else {
                [cell setSelected:NO];
            }
        } else if([adObject isKindOfClass:[DFPInterstitial class]] ){
            DFPInterstitial *interstitial = (DFPInterstitial *) adObject;
            interstitial.delegate = self;
            if (interstitial.isReady) {
                [interstitial presentFromRootViewController:self];
            } else {
                [cell setSelected:NO];
            }
        }
    } else {
        [cell setSelected:NO];
    }

}

- (void)interstitialDidDisappear:(MPInterstitialAdController *)interstitial
{
    NSArray *keys = [_validator.getDisplayables allKeysForObject:interstitial];
    for (NSString * key in keys) {
        UITableViewCell *cell = [self.bidPriceToCell objectForKey:key];
        [cell setSelected:NO];
    }
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad
{
    NSArray *keys = [_validator.getDisplayables allKeysForObject:ad];
    for (NSString * key in keys) {
        UITableViewCell *cell = [self.bidPriceToCell objectForKey:key];
        [cell setSelected:NO];
    }
}




//// Helper function to properly encode the url
//- (NSString *)urlencode:(NSString *)string {
//
//    NSMutableString *output = [NSMutableString string];
//    const unsigned char *source = (const unsigned char *)[string UTF8String];
//    int sourceLen = (int)strlen((const char *)source);
//    for (int i = 0; i < sourceLen; ++i) {
//        const unsigned char thisChar = source[i];
//        if (thisChar == ' '){
//            [output appendString:@"+"];
//        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
//                   (thisChar >= 'a' && thisChar <= 'z') ||
//                   (thisChar >= 'A' && thisChar <= 'Z') ||
//                   (thisChar >= '0' && thisChar <= '9')) {
//            [output appendFormat:@"%c", thisChar];
//        } else {
//            [output appendFormat:@"%%%02X", thisChar];
//        }
//    }
//    return output;
//}

- (void)dealloc
{
    NSLog(@"Releasing LineItemAdsViewController...");
    [_validator destroy];
    _validator = nil;
}
@end
