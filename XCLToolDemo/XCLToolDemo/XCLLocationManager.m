//
//  XCLLocationManager.m
//  XCLToolDemo
//
//  Created by Jonathan on 2018/7/21.
//  Copyright © 2018年 Jonathan. All rights reserved.
//

#import "XCLLocationManager.h"
@interface XCLLocationManager ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy)   void(^authorizationComplete)(CLAuthorizationStatus status);
@end

@implementation XCLLocationManager
+ (instancetype)shareManager
{
    static dispatch_once_t token;
    static XCLLocationManager *manager = nil;
    dispatch_once(&token, ^{
        manager = [[XCLLocationManager alloc] init];
    });
    return manager;
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (void)requestLocationWhenInUseAuthorizationCompletion:(void (^)(CLAuthorizationStatus))completion
{
    [self requestLocationAuthorizationWhenInUse:YES completionBlock:completion];
}

- (void)requestLocationAlwaysAuthorizationCompletion:(void (^)(CLAuthorizationStatus))completion
{
    [self requestLocationAuthorizationWhenInUse:NO completionBlock:completion];
}

- (void)requestLocationAuthorizationWhenInUse:(BOOL)whenInUse completionBlock:(void (^)(CLAuthorizationStatus))completion
{
    self.authorizationComplete = completion;
    if (whenInUse) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    else{
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (self.authorizationComplete) {
        self.authorizationComplete(status);
    }
}


@end
