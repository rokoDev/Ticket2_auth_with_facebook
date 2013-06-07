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
        NSLog(@"ghlk");
        //get user data from database
        NSString *userAccessToken = FBSession.activeSession.accessTokenData.accessToken;
        //if there is no data then we request for it in the facebook
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate openDB];
        //[appDelegate checkIfTableExtists:@"facebook_user_data"];
        NSData *userData = [appDelegate restoreUserDataByAccessToken:userAccessToken];
        NSLog(@"userData length = %i", [userData length]);

        if (userData) {
            NSLog(@"user data loaded from local db");
            NSPropertyListFormat plistFormat;
            NSDictionary *userDict = [NSPropertyListSerialization propertyListWithData:userData
                                                                               options:0
                                                                                format:&plistFormat
                                                                                 error:NULL];
            self.nameLbl.text = makeString([userDict objectForKey:@"first_name"], @"unknown");
            self.lastNameLbl.text = makeString([userDict objectForKey:@"last_name"], @"unknown");
            self.birthdayLbl.text = makeString([userDict objectForKey:@"birthday"], @"unknown");
            self.localeLbl.text = makeString([userDict objectForKey:@"locale"], @"unknown");
            self.imageView.image = [UIImage imageWithData:[userDict objectForKey:@"myfb_user_profile_photo"]];
            [self ensureImageViewContentMode];
        }
        else
            [FBRequestConnection startWithGraphPath:@"me"
                                     parameters:[NSDictionary dictionaryWithObject:@"picture.type(large),id,gender,first_name,last_name,email, birthday,name,username,locale,link,timezone,updated_time,verified"
                                                                            forKey:@"fields"]
                                     HTTPMethod:@"GET"
                              completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                  if(!error) {
                                      NSLog(@"%@", result);
                                      //NSLog(@"image size: %i", [[[result objectForKey:@"picture"] objectForKey:@"data"] length]);
                                      self.nameLbl.text = makeString([result objectForKey:@"first_name"], @"unknown");
                                      self.lastNameLbl.text = makeString([result objectForKey:@"last_name"], @"unknown");
                                      self.birthdayLbl.text = makeString([result objectForKey:@"birthday"], @"unknown");
                                      self.localeLbl.text = makeString([result objectForKey:@"locale"], @"unknown");

                                      NSString *urlStr = [[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
                                      NSData *imageData = nil;//[self loadProfileImageWithPath:urlStr];
                                      self.imageView.image = [UIImage imageWithData:imageData];
                                      [self ensureImageViewContentMode];
                                      
                                      
                                      ////////////////////////////////
                                      // Load images async
                                      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                          /* Код, который должен выполниться в фоне */
                                          NSURL *url = [NSURL URLWithString:urlStr];
                                          NSData *imageData = [NSData dataWithContentsOfURL:url];
                                          UIImage *userImage = [UIImage imageWithData:imageData];
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              /* Код, который выполниться в главном потоке */
                                              self.imageView.image = userImage;
                                              [self ensureImageViewContentMode];
                                              
                                              NSMutableDictionary * mutableUserDict = [NSMutableDictionary dictionaryWithDictionary:result];
                                              [mutableUserDict setObject:imageData forKey:@"myfb_user_profile_photo"];
                                              NSData *userData = [NSPropertyListSerialization dataWithPropertyList:mutableUserDict
                                                                                                            format:NSPropertyListBinaryFormat_v1_0
                                                                                                           options:0
                                                                                                             error:NULL];
                                              AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                                              [appDelegate openDB];
                                              [appDelegate createTable:@"facebook_user_data" keyField:@"access_token" userData:@"user_data"];
                                              NSLog(@"%i of user data is going to be saved", [userData length]);
                                              [appDelegate saveUserDataToDB:@"facebook_user_data" keyField:userAccessToken userData:userData];
                                          });
                                      });
                                  }
                                  else {
                                      NSString *blankImageName =
                                      [NSString
                                       stringWithFormat:@"FacebookSDKResources.bundle/FBProfilePictureView/images/fb_blank_profile_%@.png",
                                       1 ? @"square" : @"portrait"];
                                      self.imageView.image = [UIImage imageNamed:blankImageName];
                                      
                                      [(AppDelegate*)[[UIApplication sharedApplication] delegate] showErrorAlert:error];
                                  }
                              }];
    }
}

- (void)sessionStateChanged:(NSNotification*)notification {
    [self populateUserDetails];
}

- (void)ensureImageViewContentMode {
    // Set the image's contentMode such that if the image is larger than the control, we scale it down, preserving aspect
    // ratio.  Otherwise, we center it.  This ensures that we never scale up, and pixellate, the image.
    CGSize viewSize = CGSizeMake(75, 75);
    CGSize imageSize = self.imageView.image.size;
    UIViewContentMode contentMode;
    
    // If both of the view dimensions are larger than the image, we'll center the image to prevent scaling up.
    // Note that unlike in choosing the image size, we *don't* use any Retina-display scaling factor to choose centering
    // vs. filling.  If we were to do so, we'd get profile pics shrinking to fill the the view on non-Retina, but getting
    // centered and clipped on Retina.
    if (viewSize.width > imageSize.width && viewSize.height > imageSize.height) {
        contentMode = UIViewContentModeCenter;
    } else {
        contentMode = UIViewContentModeScaleAspectFit;
    }
    
    self.imageView.contentMode = contentMode;
}

@end
