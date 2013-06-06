//
//  LoginedViewController.m
//  Ticket2
//
//  Created by roko on 05.06.13.
//  Copyright (c) 2013 roko. All rights reserved.
//

#import "LoginedViewController.h"
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

#ifndef makeString
#define makeString(x,y) (((x) == (nil)) ? (y) : (x))
#endif  // makeString

@interface LoginedViewController ()

@end

@implementation LoginedViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (FBSession.activeSession.isOpen) {
        [self populateUserDetails];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:SCSessionStateChangedNotification
     object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear: LoginedViewController");
    [[NSNotificationCenter defaultCenter] postNotificationName:LoginedViewControllerNotification object:nil];
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    //[appDelegate loginedVCDidAppear];
}

//- (void)viewWillLayoutSubviews
//{
//    NSLog(@"viewWillLayoutSubviews: LoginedViewController");
//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    [appDelegate loginedVCDidAppear];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)logoutBtnTapped:(id)sender {
    NSLog(@"logoutBtnTapped");
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (void)populateUserDetails
{
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 self.nameLbl.text = makeString(user.first_name, @"unknown");
                 self.lastNameLbl.text = makeString(user.last_name, @"unknown");
                 self.birthdayLbl.text = makeString(user.birthday, @"unknown");
                 self.localeLbl.text = makeString([user objectForKey:@"locale"], @"unknown");
                 self.userPhoto.profileID = user.id;
             }
         }];
    }
}

- (void)sessionStateChanged:(NSNotification*)notification {
    [self populateUserDetails];
}

@end
