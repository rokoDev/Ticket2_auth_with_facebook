//
//  GoingToLoginViewController.m
//  Ticket2
//
//  Created by roko on 05.06.13.
//  Copyright (c) 2013 roko. All rights reserved.
//

#import "GoingToLoginViewController.h"

@interface GoingToLoginViewController ()

@end

@implementation GoingToLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"init GoingToLoginViewController");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"viewDidLoad: GoingToLoginViewController");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginBtnTapped:(id)sender {
    NSLog(@"loginBtnTapped");
}
@end
