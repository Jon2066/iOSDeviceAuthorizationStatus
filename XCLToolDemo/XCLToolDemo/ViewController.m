//
//  ViewController.m
//  XCLToolDemo
//
//  Created by Jonathan on 2018/7/21.
//  Copyright © 2018年 Jonathan. All rights reserved.
//

#import "ViewController.h"
#import "XCLDeviceAuthorization.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    XCLDeviceAuthorizationState state = [XCLDeviceAuthorization authorizedWithUsage:XCLDeviceUsagePhotoLibrary];
    if (state == XCLDeviceAuthorizationStateUnset) {
        [XCLDeviceAuthorization requestAuthorizeWithUsage:XCLDeviceUsagePhotoLibrary completionBlock:^(XCLDeviceAuthorizationState state) {
            NSLog(@"授权 = %ld",state);
        }];
    }
    
//    XCLDeviceAuthorizationState state = [XCLDeviceAuthorization authorizedWithUsage:XCLDeviceUsageCamera];
//    if (state == XCLDeviceAuthorizationStateUnset) {
//        [XCLDeviceAuthorization requestAuthorizeWithUsage:XCLDeviceUsageCamera completionBlock:^(XCLDeviceAuthorizationState state) {
//            NSLog(@"授权 = %ld",state);
//        }];
//    }
   
    
//    XCLDeviceAuthorizationState state = [XCLDeviceAuthorization authorizedWithUsage:XCLDeviceUsageMicrophone];
//    if (state == XCLDeviceAuthorizationStateUnset) {
//        [XCLDeviceAuthorization requestAuthorizeWithUsage:XCLDeviceUsageMicrophone completionBlock:^(XCLDeviceAuthorizationState state) {
//            NSLog(@"授权 = %ld",state);
//        }];
//    }
    
    
//    XCLDeviceAuthorizationState state = [XCLDeviceAuthorization authorizedWithUsage:XCLDeviceUsageLocationWhenInUse];
//    if (state == XCLDeviceAuthorizationStateUnset) {
//        [XCLDeviceAuthorization requestAuthorizeWithUsage:XCLDeviceUsageLocationWhenInUse completionBlock:^(XCLDeviceAuthorizationState state) {
//            NSLog(@"授权 = %ld",state);
//        }];
//    }
    
//    XCLDeviceAuthorizationState state = [XCLDeviceAuthorization authorizedWithUsage:XCLDeviceUsageLocationAlways];
//    if (state == XCLDeviceAuthorizationStateUnset) {
//        [XCLDeviceAuthorization requestAuthorizeWithUsage:XCLDeviceUsageLocationAlways completionBlock:^(XCLDeviceAuthorizationState state) {
//            NSLog(@"授权 = %ld",state);
//        }];
//    }
    
//    XCLDeviceAuthorizationState state = [XCLDeviceAuthorization authorizedWithUsage:XCLDeviceUsageContacts];
//    if (state == XCLDeviceAuthorizationStateUnset) {
//        [XCLDeviceAuthorization requestAuthorizeWithUsage:XCLDeviceUsageContacts completionBlock:^(XCLDeviceAuthorizationState state) {
//            NSLog(@"授权 = %ld",state);
//        }];
//    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
