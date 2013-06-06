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
                 self.nameLbl.text = user.first_name;
                 self.lastNameLbl.text = user.last_name;
                 self.birthdayLbl.text = user.birthday;
                 if (!self.birthdayLbl.text) {
                     self.birthdayLbl.text = @"unknown";
                 }
                 self.userPhoto.profileID = user.id;
             }
         }];
    }
}

- (void)sessionStateChanged:(NSNotification*)notification {
    [self populateUserDetails];
}

@end
