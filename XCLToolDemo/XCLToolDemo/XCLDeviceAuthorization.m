//
//  XCLDeviceAuthorization.m
//  XCLToolDemo
//
//  Created by Jonathan on 2018/7/21.
//  Copyright © 2018年 Jonathan. All rights reserved.
//

#import "XCLDeviceAuthorization.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
#import <UserNotifications/UserNotifications.h>
#import "XCLLocationManager.h"

typedef void (^XCLDeviceAuthorizationCompletion)(XCLDeviceAuthorizationState);

@implementation XCLDeviceAuthorization
+ (XCLDeviceAuthorizationState)authorizedWithUsage:(XCLDeviceUsage)usage
{
    if (usage == XCLDeviceUsagePhotoLibrary) {
        return [self photoLibraryState];
    }
    else if(usage == XCLDeviceUsageCamera){
        return [self cameraState];
    }
    else if (usage == XCLDeviceUsageMicrophone){
        return [self microphoneState];
    }
    else if (usage == XCLDeviceUsageLocationWhenInUse ||
             usage == XCLDeviceUsageLocationAlways){
        return [self locationState];
    }
//    else if (usage == XCLDeviceUsageBluetooth){
//        return [self bluetoothState];
//    }
    else if (usage == XCLDeviceUsageContacts){
        return [self contactsState];
    }
    return XCLDeviceAuthorizationStateUnknow;
}

+ (BOOL)multiUsagesAuthorized:(XCLDeviceUsage)usages
{
    BOOL authorized = YES;
    if (usages & XCLDeviceUsagePhotoLibrary) {
        authorized &= ([self photoLibraryState] == XCLDeviceAuthorizationStateAuthorized);
    }
    if (usages & XCLDeviceUsageCamera) {
        authorized &= ([self cameraState] == XCLDeviceAuthorizationStateAuthorized);
    }
    if (usages & XCLDeviceUsageMicrophone) {
        authorized &= ([self microphoneState] == XCLDeviceAuthorizationStateAuthorized);
    }
    if (usages & XCLDeviceUsageLocationWhenInUse || usages & XCLDeviceUsageLocationAlways) {
        authorized &= ([self locationState] == XCLDeviceAuthorizationStateAuthorized);
    }
    if (usages & XCLDeviceUsageContacts) {
        authorized &= ([self contactsState] == XCLDeviceAuthorizationStateAuthorized);
    }
    return authorized;
}


+ (XCLDeviceAuthorizationState)photoLibraryState
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if(status == PHAuthorizationStatusAuthorized){
        return XCLDeviceAuthorizationStateAuthorized;
    }
    else if(status == PHAuthorizationStatusDenied){
        return XCLDeviceAuthorizationStateRejected;
    }
    else if(status == PHAuthorizationStatusNotDetermined){
        return XCLDeviceAuthorizationStateUnset;
    }
    return XCLDeviceAuthorizationStateUnknow;
}

+ (XCLDeviceAuthorizationState)cameraState
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusDenied) {
        return XCLDeviceAuthorizationStateRejected;
    }
    else if (status == AVAuthorizationStatusAuthorized){
        return XCLDeviceAuthorizationStateAuthorized;
    }
    else if (status == AVAuthorizationStatusNotDetermined){
        return XCLDeviceAuthorizationStateUnset;
    }
    return XCLDeviceAuthorizationStateUnknow;
}

+ (XCLDeviceAuthorizationState)microphoneState
{
    AVAudioSessionRecordPermission status = [AVAudioSession sharedInstance].recordPermission;
    if (status == AVAudioSessionRecordPermissionDenied) {
        return XCLDeviceAuthorizationStateRejected;
    }
    else if (status == AVAudioSessionRecordPermissionGranted){
        return XCLDeviceAuthorizationStateAuthorized;
    }
    else if (status == AVAudioSessionRecordPermissionUndetermined){
        return XCLDeviceAuthorizationStateUnset;
    }
    return XCLDeviceAuthorizationStateUnknow;
}

+ (XCLDeviceAuthorizationState)locationState
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusDenied) {
        return XCLDeviceAuthorizationStateRejected;
    }
    else if (status == kCLAuthorizationStatusAuthorizedAlways ||
             status == kCLAuthorizationStatusAuthorizedWhenInUse){
        return XCLDeviceAuthorizationStateAuthorized;
    }
    else if (status == kCLAuthorizationStatusNotDetermined){
        return XCLDeviceAuthorizationStateUnset;
    }
    return XCLDeviceAuthorizationStateUnknow;
}

+ (XCLDeviceAuthorizationState)contactsState
{

    if (@available(iOS 9.0, *)) {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if (status == CNAuthorizationStatusDenied) {
            return XCLDeviceAuthorizationStateRejected;
        }
        else if (status == CNAuthorizationStatusAuthorized){
            return XCLDeviceAuthorizationStateAuthorized;
        }
        else if (status == CNAuthorizationStatusNotDetermined){
            return XCLDeviceAuthorizationStateUnset;
        }
        
    }
    else if (@available(iOS 8.0, *)) {
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        if (status == kABAuthorizationStatusDenied) {
            return XCLDeviceAuthorizationStateRejected;
        }
        else if (status == kABAuthorizationStatusAuthorized){
            return XCLDeviceAuthorizationStateAuthorized;
        }
        else if (status == kABAuthorizationStatusNotDetermined){
            return XCLDeviceAuthorizationStateUnset;
        }
    }
    return XCLDeviceAuthorizationStateUnknow;
}


#pragma mark - open setting -

+ (BOOL)openSetting
{
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    }
    return NO;
}

#pragma mark - request authorize -
+ (void)requestAuthorizeWithUsage:(XCLDeviceUsage)usage completionBlock:(void (^)(XCLDeviceAuthorizationState))completion
{
    if (usage == XCLDeviceUsagePhotoLibrary) {
        [self authorizePhotoLibraryWithCompletion:completion];
    }
    else if(usage == XCLDeviceUsageCamera){
        [self authorizeCameraWithCompletion:completion];
    }
    else if (usage == XCLDeviceUsageMicrophone){
        [self authorizeMicphoneWithCompletion:completion];
    }
    else if (usage == XCLDeviceUsageLocationWhenInUse ||
             usage == XCLDeviceUsageLocationAlways){
        [self authorizeLocationWithUsage:usage completion:completion];
    }
    else if (usage == XCLDeviceUsageContacts){
        [self authorizeContactsWithCompletion:completion];
    }
}

+ (void)authorizePhotoLibraryWithCompletion:(XCLDeviceAuthorizationCompletion)completion
{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (completion) {
            completion([self photoLibraryState]);
        }
    }];
}

+ (void)authorizeCameraWithCompletion:(XCLDeviceAuthorizationCompletion)completion
{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (completion) {
            completion(granted?XCLDeviceAuthorizationStateAuthorized:XCLDeviceAuthorizationStateRejected);
        }
    }];
}

+ (void)authorizeMicphoneWithCompletion:(XCLDeviceAuthorizationCompletion)completion
{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        if (completion) {
            completion(granted?XCLDeviceAuthorizationStateAuthorized:XCLDeviceAuthorizationStateRejected);
        }
    }];
}

+ (void)authorizeContactsWithCompletion:(XCLDeviceAuthorizationCompletion)completion
{
    if (@available(iOS 9.0, *)) {
        CNContactStore *contactStore = [[CNContactStore alloc] init];
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (completion) {
                completion(granted?XCLDeviceAuthorizationStateAuthorized:XCLDeviceAuthorizationStateRejected);
            }
        }];
    } else {
        __block ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if (addressBook) {
                CFRelease(addressBook);
                addressBook = NULL;
            }
            completion(granted?XCLDeviceAuthorizationStateAuthorized:XCLDeviceAuthorizationStateRejected);
        });
    }
}

+ (void)authorizeLocationWithUsage:(XCLDeviceUsage)usage completion:(XCLDeviceAuthorizationCompletion)completion
{
    if (usage == XCLDeviceUsageLocationWhenInUse){
        [[XCLLocationManager shareManager] requestLocationWhenInUseAuthorizationCompletion:^(CLAuthorizationStatus status) {
            if (completion) {
                XCLDeviceAuthorizationState state = [self locationState];
                if (state != XCLDeviceAuthorizationStateUnset) {
                    completion(state);
                }
            }
        }];
    }
    else if (usage == XCLDeviceUsageLocationAlways){
        [[XCLLocationManager shareManager] requestLocationAlwaysAuthorizationCompletion:^(CLAuthorizationStatus status) {
            if (completion) {
                XCLDeviceAuthorizationState state = [self locationState];
                if (state != XCLDeviceAuthorizationStateUnset) {
                    completion(state);
                }
            }
        }];
    }
}

@end
