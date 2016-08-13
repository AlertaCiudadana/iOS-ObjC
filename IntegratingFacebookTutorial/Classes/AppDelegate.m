/**
 * Copyright (c) 2014, Parse, LLC. All rights reserved.
 *
 * You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
 * copy, modify, and distribute this software in source code or binary form for use
 * in connection with the web services and APIs provided by Parse.

 * As with any software that integrates with the Parse platform, your use of
 * this software is subject to the Parse Terms of Service
 * [https://www.parse.com/about/terms]. This copyright notice shall be
 * included in all copies or substantial portions of the software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 */

#import "AppDelegate.h"



@implementation AppDelegate
//static NSString * const kClientID = @"AIzaSyAsaxcNYu-FvXDSNGOGd6wZz_EkoB9J-2U";
static NSString * const kClientIDGoogle = @"your google maps key";
static NSString * const kAppParseId = @"your parse id";
static NSString * const kParseClientId = @"your parse client id";

#pragma mark -
#pragma mark UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
 

    // ****************************************************************************
    // Fill in with your Parse credentials:
    // ****************************************************************************
    [Parse setApplicationId: kAppParseId clientKey:kParseClientId];

    // ****************************************************************************
    // Your Facebook application id is configured in Info.plist.
    // ****************************************************************************
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    if (([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) || [PFUser currentUser]) {
        BaseViewController *tabBar = [[BaseViewController alloc] initWithNibName:nil bundle:nil];
        self.window.rootViewController = tabBar;
    }else {
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
//        NSUserDefaults *dataSaved = [NSUserDefaults standardUserDefaults];  //load NSUserDefaults
//        bool result = [dataSaved boolForKey:@"TermsConditionsAccepted"];
//        if (result == false) {
//            self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[ContainerViewController alloc] init]];
//        }else{
//            self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
//        }
    }
    // Override point for customization after application launch.
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    NSString *keyMaps = kClientIDGoogle;
    [GMSServices provideAPIKey:keyMaps];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        UIColor *navBackground = [Utilities colorwithHexString:@"#ffd900" alpha:1];
        [[UINavigationBar appearance] setBarTintColor:navBackground];
        [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
        [[UINavigationBar appearance] setTranslucent:NO];
        NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Exo-Bold" size:22],NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName,nil];

        [[UINavigationBar appearance] setTitleTextAttributes:size];

        
        [[UISearchBar appearance] setBackgroundColor:navBackground];
        [[UISearchBar appearance] setBarTintColor:navBackground];
        [[UISearchBar appearance] setTranslucent:NO];
        
        [[UITabBar appearance] setBackgroundColor:navBackground];
        [[UITabBar appearance] setBarTintColor:navBackground];
        [[UITabBar appearance] setTintColor:[UIColor blackColor]];
        [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tabBarSelected"]];
        [[UITabBar appearance] setSelectedImageTintColor:[UIColor blackColor]];
        [[UITabBar appearance] setTranslucent:YES];
    }
    
    [GIDSignIn sharedInstance].clientID = kClientIDGoogle;
    
    [self startSignificantChangeUpdates];
    //[self stopSignificantChangeUpdates];
    
    return YES;
}

// ****************************************************************************
// App switching methods to support Facebook Single Sign-On.
// ****************************************************************************
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //return [FBAppCall handleOpenURL:url
                  //sourceApplication:sourceApplication
                    //    withSession:[PFFacebookUtils session]];
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
    //return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
} 

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
    //[FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
//    [FBAppCall handleDidBecomeActive];
    [FBSDKAppEvents activateApp];
}



- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    NSLog(@"stop updating location");
    [locationManager stopMonitoringSignificantLocationChanges];
    [locationManager stopUpdatingLocation];
    //[[PFFacebookUtils session] close];
}


-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    //Store the deviceToken in the current installation and save it to Parse
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[@"global"];
    [currentInstallation saveInBackground];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [PFPush handlePush:userInfo];
}


- (void)startSignificantChangeUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    /* Notify heading changes when heading is > 5.
     * Default value is kCLHeadingFilterNone: all movements are reported.
     */
    locationManager.headingFilter = 5;
    
    
    // Only report to location manager if the user has traveled 1000 meters
    locationManager.distanceFilter = 10.0f;
    locationManager.delegate = self;
    locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    
    // Start monitoring significant locations here as default, will switch to
    // update locations on enter foreground
    [locationManager requestAlwaysAuthorization];
    /* Pinpoint our location with the following accuracy:
     *
     *     kCLLocationAccuracyBestForNavigation  highest + sensor data
     *     kCLLocationAccuracyBest               highest
     *     kCLLocationAccuracyNearestTenMeters   10 meters
     *     kCLLocationAccuracyHundredMeters      100 meters
     *     kCLLocationAccuracyKilometer          1000 meters
     *     kCLLocationAccuracyThreeKilometers    3000 meters
     */
    //self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    /* Notify changes when device has moved x meters.
     * Default value is kCLDistanceFilterNone: all movements are reported.
     */
}

-(void)stopSignificantChangeUpdates{
    [locationManager stopMonitoringSignificantLocationChanges];
}


- (void)willEnterForeground:(UIApplication *)application
{
    NSLog(@"Went to Foreground");
    [locationManager stopMonitoringSignificantLocationChanges];
    //[locationManager startUpdatingLocation];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"Went to Background");
    // Need to stop regular updates first
    //[locationManager stopUpdatingLocation];
    // Only monitor significant changes
    [locationManager startMonitoringSignificantLocationChanges];
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        // 3
        //[manager startMonitoringSignificantLocationChanges];
        //4
    }
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    if (locations != nil) {
        CLLocation *currentLocation = [locations objectAtIndex:0];
        NSString *userId = [[PFUser currentUser] objectId];
        NSLog(@"Getting location");
        if (userId != nil) {
            
            NSMutableDictionary * params = [NSMutableDictionary new];
            params[@"id_user"] = userId;
            NSString *lat = [[NSString alloc] initWithFormat:@"%f", currentLocation.coordinate.latitude];
            NSString *lon = [[NSString alloc] initWithFormat:@"%f", currentLocation.coordinate.longitude];
            
            params[@"latitude"] =lat;
            params[@"longitude"] = lon;
            [PFCloud callFunctionInBackground:@"updateLocation" withParameters:params
                                        block:^(NSNumber *ratings, NSError *error) {
                                            if (!error) {
                                                // ratings is 4.5
                                                NSLog(@"");
                                            } else {
                                                NSLog(@"%@",[error description]);
                                            }
                                        }];
        }
    }
}



@end
