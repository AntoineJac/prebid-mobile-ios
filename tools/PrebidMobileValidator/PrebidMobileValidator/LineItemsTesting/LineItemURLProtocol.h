//
//  LineItemURLProtocol.h
//  PrebidMobileValidator
//
//  Created by Punnaghai Puviarasu on 4/17/18.
//  Copyright © 2018 AppNexus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LineItemURLProtocol : NSURLProtocol

@property (nonatomic, strong) NSString *requestString;
@property (nonatomic, strong) NSString *responseString;


@end
