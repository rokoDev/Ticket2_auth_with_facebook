//
//  AppDelegate.h
//  Ticket2
//
//  Created by roko on 05.06.13.
//  Copyright (c) 2013 roko. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FacebookSDK/FacebookSDK.h>
#import "sqlite3.h"

extern NSString *const SCSessionStateChangedNotification;
extern NSString *const LoginedViewControllerNotification;
extern NSString *const DatabaseFileName;
extern NSString *const TableName;
extern NSString *const UserPhotoKeyInDict;
extern NSString *const ACCESS_TOKEN_COLUMN;
extern NSString *const USER_DATA_COLUMN;
extern NSString *const DefaultUserImagePath;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    sqlite3 *facebook_user_db;
}

@property (strong, nonatomic) UIWindow *window;

- (void)loginedVCDidAppear;
- (void)showLoginView;
- (void)openSession;
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (NSString *)applicationDocumentsDirectory;
- (NSString*)dbPath;
- (void)openDB;
- (void)createTable:(NSString*)tableName keyField:(NSString*)access_token userData:(NSString*)userData;
- (void)saveUserDataToDB:(NSString*)tableName keyField:(NSString *)access_token userData:(NSData *)userData;
- (NSData*)restoreUserDataByAccessToken:(NSString*)access_token;
- (BOOL)checkIfTableExtists:(NSString*)tableName;
- (void)showErrorAlert:(NSError*)error;
- (void)deleteRowForKey:(NSString*)key;

- (BOOL)doesInternetConnectionExists;

@end
