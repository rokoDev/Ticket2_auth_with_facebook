//
//  Ticket2Tests.m
//  Ticket2Tests
//
//  Created by roko on 05.06.13.
//  Copyright (c) 2013 roko. All rights reserved.
//

#import "Ticket2Tests.h"
#import <OCMock/OCMock.h>
#import "LoginedViewController.h"
#import "GoingToLoginViewController.h"

@implementation Ticket2Tests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    
    self.appDelegate = [[AppDelegate alloc] init];
}

- (void)tearDown
{
    // Tear-down code here.
    
    self.appDelegate = nil;
    
    [super tearDown];
}

//- (void)testExample
//{
//    STFail(@"Unit tests are not implemented yet in Ticket2Tests");
//}

- (void)testAppDelegateInstantiates
{
    STAssertNotNil(self.appDelegate, @"AppDelegate instantiate failed!");
}

//- (void)testWindowCreated
//{
//    [self.appDelegate application:nil didFinishLaunchingWithOptions:nil];
//    STAssertNotNil(self.appDelegate.window, @"window wasn't created!");
//    
//    
//    STAssertTrue([self.appDelegate.window isKindOfClass:[UIWindow class]], @"window is not kind of UIWindow class");
//}

- (void)testOCMockPass {
    NSLog(@"test osmock");
    id mock = [OCMockObject mockForClass:NSString.class];
    [[[mock stub] andReturn:@"mocktest"] lowercaseString];
    
    NSString *returnValue = [mock lowercaseString];
    STAssertEqualObjects(@"mocktest", returnValue, @"Should have returned the expected string.");
}

- (void)testExistenceOfDefaultImageInFacebookSDKResources_bundle
{
    UIImage *defaultUserImage = [UIImage imageNamed:DefaultUserImagePath];
    STAssertNotNil(defaultUserImage, [NSString stringWithFormat:@"file at path:%@ not found", DefaultUserImagePath]);
}

- (void)testThat_GoingToLoginViewController_wichIsLoadedFromStoryboardIsNotNil
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    GoingToLoginViewController *goingToLoginVC = [storyboard instantiateViewControllerWithIdentifier:@"GoingToLoginVC"];
    STAssertNotNil(goingToLoginVC, @"goingToLoginVC is nil!");
}

//- (void)testWhether_loginBtnTapped_IsCalledAfterUserTapLoginButton
//{
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//    GoingToLoginViewController *initViewController = [storyboard instantiateViewControllerWithIdentifier:@"GoingToLoginVC"];
//    
//    id vcMock = [OCMockObject partialMockForObject:initViewController];
//    id btnMock = [OCMockObject partialMockForObject:initViewController.loginBtn];
//    
//    //[[vcMock expect] loginBtnTapped:[OCMArg any]];
//    [[btnMock expect] sendActionsForControlEvents:[OCMArg any]];
//    [initViewController.loginBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
//    //[vcMock verify];
//    [btnMock verify];
//}



@end
