//
//  LoginedViewController.m
//  Ticket2
//
//  Created by roko on 05.06.13.
//  Copyright (c) 2013 roko. All rights reserved.
//

#import "LoginedViewController.h"
#import "AppDelegate.h"

@interface LoginedViewController ()

@end

@implementation LoginedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear: LoginedViewController");
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate loginedVCDidAppear];
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
}

@end
