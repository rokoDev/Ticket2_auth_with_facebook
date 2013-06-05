//
//  LoginedViewController.m
//  Ticket2
//
//  Created by roko on 05.06.13.
//  Copyright (c) 2013 roko. All rights reserved.
//

#import "LoginedViewController.h"
#import "GoingToLoginViewController.h"

@interface LoginedViewController ()

@end

@implementation LoginedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"init LoginedViewController");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"viewDidLoad: LoginedViewController");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logoutBtnTapped:(id)sender {
    NSLog(@"logoutBtnTapped");
}

- (void)showLoginView
{
//    GoingToLoginViewController* loginViewController =
//    [[GoingToLoginViewController alloc] initWithNibName:<#(NSString *)#> bundle:<#(NSBundle *)#>];
//    [topViewController presentModalViewController:loginViewController animated:NO];
}

@end
