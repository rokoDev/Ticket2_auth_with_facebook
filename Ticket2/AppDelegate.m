//
//  AppDelegate.m
//  Ticket2
//
//  Created by roko on 05.06.13.
//  Copyright (c) 2013 roko. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginedViewController.h"
#import "GoingToLoginViewController.h"

NSString *const SCSessionStateChangedNotification = @"com.rokoprogs.Ticket2:SCSessionStateChangedNotification";
NSString *const LoginedViewControllerNotification = @"com.rokoprogs.Ticket2:loginedVCDidAppear";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [FBProfilePictureView class];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginedVCDidAppear) name:LoginedViewControllerNotification object:nil];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    
    // We need to properly handle activation of the application with regards to Facebook Login
    // (e.g., returning from iOS 6.0 Login Dialog or from fast app switching).
    NSLog(@"applicationDidBecomeActive");
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [FBSession.activeSession close];
}

- (void)showLoginView
{
    NSLog(@"showLoginView");
//    UINavigationController *navController = (UINavigationController*)self.window.rootViewController;
//    LoginedViewController *loginedVC = (LoginedViewController*)[navController visibleViewController];
//    [loginedVC performSegueWithIdentifier:@"showGoingToLoginVC" sender:loginedVC];
    
    UINavigationController *navController = (UINavigationController*)self.window.rootViewController;
    
    // If the login screen is not already displayed, display it. If the login screen is
    // displayed, then getting back here means the login in progress did not successfully
    // complete. In that case, notify the login view so it can update its UI appropriately.
    if (![[navController visibleViewController] isKindOfClass:[GoingToLoginViewController class]]) {
        LoginedViewController *loginedVC = (LoginedViewController*)[navController visibleViewController];
        [loginedVC performSegueWithIdentifier:@"showGoingToLoginVC" sender:loginedVC];
    } else {
        GoingToLoginViewController *goingToLoginVC = (GoingToLoginViewController*)[navController visibleViewController];
        [goingToLoginVC loginFailed];
    }
}

- (void)loginedVCDidAppear
{
    NSLog(@"loginedVCDidAppear");
    // See if the app has a valid token for the current state.
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        // To-do, show logged in view
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self openSession];
    } else {
        // No, display the login page.
        [self showLoginView];
    }
}

- (void)openSession
{
    NSLog(@"openSession");
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"email",
                            @"user_birthday",
                            @"user_location",
                            //@"user_likes",
                            nil];
    [FBSession openActiveSessionWithReadPermissions:permissions//nil
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    NSLog(@"sessionStateChanged");
    switch (state) {
        case FBSessionStateOpen: {
            NSLog(@"sessionStateChanged: FBSessionStateOpen");
            //NSLog(@"access token = %@", session.accessTokenData.accessToken);
            //NSLog(@"access token = %@", FBSession.activeSession.accessTokenData.accessToken);
            
            UIViewController *topViewController = [(UINavigationController*)self.window.rootViewController visibleViewController];
            
            if ([topViewController isKindOfClass:[GoingToLoginViewController class]])
            {
                [[NSNotificationCenter defaultCenter] removeObserver:self];
                [topViewController dismissViewControllerAnimated:YES completion:nil];
            }
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged in, we want them to
            // be looking at the root view.
            [(UINavigationController*)self.window.rootViewController popToRootViewControllerAnimated:NO];
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            [self showLoginView];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:SCSessionStateChangedNotification
     object:session];
    
    if (error) {
        [self showErrorAlert:error];
    }
    
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"email",
                            @"user_likes",
                            nil];
    return [FBSession openActiveSessionWithReadPermissions:permissions
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error) {
                                             [self sessionStateChanged:session
                                                                 state:state
                                                                 error:error];
                                         }];
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSString *)applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

#pragma mark - Database's path

- (NSString *)dbPath
{
    return [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"facebook_user_data.db"];
}

#pragma mark -------------------
//open database or create if it does not exist
- (void)openDB
{
    if (sqlite3_open([[self dbPath] UTF8String], &facebook_user_db) != SQLITE_OK) {
        sqlite3_close(facebook_user_db);
        NSAssert(0, @"Database failed to open");
    } else {
        NSLog(@"database opened");
    }
}

- (void)createTable:(NSString *)tableName keyField:(NSString *)access_token userData:(NSString *)userData
{
    char *err;
    //NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' TEXT PRIMARY KEY, '%@' BLOB)", tableName, access_token, userData];
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' TEXT UNIQUE, '%@' BLOB)", tableName, access_token, userData];
    if (SQLITE_OK != sqlite3_exec(facebook_user_db, [sql UTF8String], NULL, NULL, &err)) {
        sqlite3_close(facebook_user_db);
        NSAssert(0, @"Could not create table");
    } else {
        NSLog(@"table created");
    }
}

- (void)saveUserDataToDB:(NSString*)tableName keyField:(NSString *)access_token userData:(NSData *)userData
{
//    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ ('access_token', 'user_data') VALUES ('%@', '%@')", tableName, access_token, userData];
//    char *err;
//    if (SQLITE_OK != sqlite3_exec(facebook_user_db, [sql UTF8String], NULL, NULL, &err)) {
//        NSAssert(0, @"Could not update table");
//    } else {
//        NSLog(@"table updated");
//    }
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ ('access_token', 'user_data') VALUES (?, ?)", tableName];
    //const char* sqliteQuery = "INSERT INTO IMAGES (URL, IMAGE) VALUES (?, ?)";
    sqlite3_stmt* statement;
    
    if( sqlite3_prepare_v2(facebook_user_db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK )
    {
        sqlite3_bind_text(statement, 1, [access_token UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_blob(statement, 2, [userData bytes], [userData length], SQLITE_TRANSIENT);
        sqlite3_step(statement);
    }
    else NSLog( @"saveUserDataToDB: Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(facebook_user_db) );
    
    // Finalize and close database.
    sqlite3_finalize(statement);
    
//    sqlite3_stmt *stmt;
//    
//    sqlite3_bind_blob(stmt, 1, [userData bytes], [userData length], SQLITE_TRANSIENT);
//    sqlite3_step(stmt);
}

- (NSData*)restoreUserDataByAccessToken:(NSString *)access_token
{
    NSData* data = nil;
    NSString* sqliteQuery = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = '%@'", @"user_data", @"facebook_user_data", @"access_token", access_token];
    sqlite3_stmt* statement;
    
    if( sqlite3_prepare_v2(facebook_user_db, [sqliteQuery UTF8String], -1, &statement, NULL) == SQLITE_OK )
    {
        if( sqlite3_step(statement) == SQLITE_ROW )
        {
            int length = sqlite3_column_bytes(statement, 0);
            data       = [NSData dataWithBytes:sqlite3_column_blob(statement, 0) length:length];
        }
    }
    else NSLog( @"restoreUserDataByAccessToken: Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(facebook_user_db) );
    
    // Finalize and close database.
    sqlite3_finalize(statement);
    
    return data;
}

- (BOOL)checkIfTableExtists:(NSString *)tableName
{
    sqlite3_stmt *statementChk;
    NSString *sql = [NSString stringWithFormat:@"SELECT name FROM sqlite_master WHERE type='table' AND name='%@';", tableName];
    sqlite3_prepare_v2(facebook_user_db, [sql UTF8String], -1, &statementChk, nil);
    
    BOOL boo = YES;
    
    if (sqlite3_step(statementChk) == SQLITE_ROW) {
        boo = NO;
    }
    sqlite3_finalize(statementChk);
    return boo;
}

- (void)showErrorAlert:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:error.localizedDescription
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
}



@end
