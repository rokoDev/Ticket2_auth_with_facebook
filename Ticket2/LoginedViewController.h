//
//  LoginedViewController.h
//  Ticket2
//
//  Created by roko on 05.06.13.
//  Copyright (c) 2013 roko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface LoginedViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *userPhoto;
@property (weak, nonatomic) IBOutlet UITextView *textInfo;

- (IBAction)logoutBtnTapped:(id)sender;
- (void)ensureImageViewContentMode;

@end
