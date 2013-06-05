//
//  LoginedViewController.h
//  Ticket2
//
//  Created by roko on 05.06.13.
//  Copyright (c) 2013 roko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginedViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIImageView *userPhoto;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLbl;

- (IBAction)logoutBtnTapped:(id)sender;

- (void)showLoginView;

@end
