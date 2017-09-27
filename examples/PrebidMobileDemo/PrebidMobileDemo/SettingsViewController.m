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

#import "BannerTestsViewController.h"
#import "Constants.h"
#import "InterstitialTestsViewController.h"
#import "SettingsViewController.h"
#import "VideoTestsViewController.h"

static NSString *const kSeeAdButtonTitle = @"See Ad";
static NSString *const kAdSettingsTableViewReuseId = @"AdSettingsTableItem";
static CGFloat const kRightMargin = 15;

@interface SettingsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *settingsTableView;
@property (strong, nonatomic) NSArray *generalSettingsData;
@property (strong, nonatomic) NSArray *sectionHeaders;
@property (strong, nonatomic) NSMutableDictionary *generalSettingsFields;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _settingsTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _settingsTableView.dataSource = self;
    _settingsTableView.delegate = self;
    [self.view addSubview:_settingsTableView];

    _generalSettingsData = @[kAdServer, kAdType, kSize, kDemandSource];
    [self initializeGeneralSettingsFields];

    _sectionHeaders = @[@"General"];//, @"Targeting", @"Custom Keywords"];

    UIBarButtonItem *previewAdButton = [[UIBarButtonItem alloc] initWithTitle:kSeeAdButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(previewAdButtonClicked:)];
    self.navigationItem.rightBarButtonItem = previewAdButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeGeneralSettingsFields {
    _generalSettingsFields = [[NSMutableDictionary alloc] init];

    UISegmentedControl *adServerSegControl = [[UISegmentedControl alloc] initWithItems:@[kDFPAdServer, kMoPubAdServer]];
    adServerSegControl.selectedSegmentIndex = 0;
    UISegmentedControl *adTypeSegControl = [[UISegmentedControl alloc] initWithItems:@[kBanner, kInterstitial]];
    adTypeSegControl.selectedSegmentIndex = 0;

    UITextField *placementIdTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 50)];
    placementIdTextField.placeholder = kDefaultPlacementId;
    placementIdTextField.text = kDefaultPlacementId;
    placementIdTextField.textAlignment = NSTextAlignmentRight;

	UITextField *demandSourceTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 160, 50)];
	demandSourceTextField.placeholder = kFBAudienceNetwork;
	demandSourceTextField.text = kFBAudienceNetwork;
	demandSourceTextField.textAlignment = NSTextAlignmentRight;

    UITextField *sizeTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 50)];
    sizeTextField.placeholder = kDefaultSize;
    sizeTextField.text = kDefaultSize;
    sizeTextField.textAlignment = NSTextAlignmentRight;

    [_generalSettingsFields setObject:adServerSegControl forKey:kAdServer];
    [_generalSettingsFields setObject:adTypeSegControl forKey:kAdType];
    [_generalSettingsFields setObject:demandSourceTextField forKey:kDemandSource];
    [_generalSettingsFields setObject:sizeTextField forKey:kSize];
}

- (void)previewAdButtonClicked:(id)sender {
    UISegmentedControl *adServerSegControl = [self.generalSettingsFields objectForKey:kAdServer];
    UISegmentedControl *adTypeSegControl = [self.generalSettingsFields objectForKey:kAdType];
    UITextField *placementIdField = [self.generalSettingsFields objectForKey:kPlacementId];
    UITextField *sizeIdField = [self.generalSettingsFields objectForKey:kSize];
    UITextField *demandSourceField = [self.generalSettingsFields objectForKey:kDemandSource];

    NSString *adType =[adTypeSegControl titleForSegmentAtIndex:[adTypeSegControl selectedSegmentIndex]];

    NSDictionary *settings = @{kAdServer : [adServerSegControl titleForSegmentAtIndex:[adServerSegControl selectedSegmentIndex]],
                               kSize : [sizeIdField text],
                               kDemandSource: [demandSourceField text]};

    UIViewController *vcToPush;
    if ([adType isEqualToString:kBanner]) {
        vcToPush = [[BannerTestsViewController alloc] initWithSettings:settings];
    } else if ([adType isEqualToString:kInterstitial]) {
        vcToPush = [[InterstitialTestsViewController alloc] initWithSettings:settings];
    } else if ([adType isEqualToString:kVideo]) {
        vcToPush = [[VideoTestsViewController alloc] init];
    }

    if (vcToPush != nil) {
        vcToPush.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vcToPush animated:NO];
    }
}

- (void)adServerClicked:(id)sender {
    
}

#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionHeaders.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.sectionHeaders objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.generalSettingsData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *simpleTableIdentifier = kAdSettingsTableViewReuseId;

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    UIView *rightContentView = [self.generalSettingsFields objectForKey:[self.generalSettingsData objectAtIndex:indexPath.row]];

    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [self.generalSettingsData objectAtIndex:indexPath.row];
            rightContentView.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - rightContentView.frame.size.width - kRightMargin,
                                                (cell.contentView.frame.size.height - rightContentView.frame.size.height) / 2,
                                                rightContentView.frame.size.width,
                                                rightContentView.frame.size.height);
            [cell.contentView addSubview:rightContentView];
            break;
        default:
            break;
    }
    return cell;
}

@end
