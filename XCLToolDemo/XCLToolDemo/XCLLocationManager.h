//
//  XCLLocationManager.h
//  XCLToolDemo
//
//  Created by Jonathan on 2018/7/21.
//  Copyright © 2018年 Jonathan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface XCLLocationManager : NSObject
+ (instancetype)shareManager;

- (void)requestLocationWhenInUseAuthorizationCompletion:(void(^)(CLAuthorizationStatus status))completion;
- (void)requestLocationAlwaysAuthorizationCompletion:(void(^)(CLAuthorizationStatus status))completion;

@end
