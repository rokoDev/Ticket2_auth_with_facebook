//
//  AppDelegate.h
//  Ticket2
//
//  Created by roko on 05.06.13.
//  Copyright (c) 2013 roko. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FacebookSDK/FacebookSDK.h>

extern NSString *const SCSessionStateChangedNotification;
extern NSString *const LoginedViewControllerNotification;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)loginedVCDidAppear;
- (void)showLoginView;
- (void)openSession;
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;

@end
