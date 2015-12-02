//
//  SettingsViewController.m
//  DangerAwayApp
//
//  Created by Dasoga on 13/03/15.
//
//

#import "SettingsViewController.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/ParseFacebookUtilsV4.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *navBackground = [Utilities colorwithHexString:@"#ffd900" alpha:1];

    // Do any additional setup after loading the view from its nib.
    self.nameLabel.text = @"User";
    [self _loadData];
    self.btnContact.layer.cornerRadius = 10;
    [self.btnContact setBackgroundColor:navBackground];
    self.btnTerms.layer.cornerRadius = 10;
    [self.btnTerms setBackgroundColor:navBackground];
    self.btnLogoutFacebook.layer.cornerRadius = 10;
    [self.btnLogoutFacebook setBackgroundColor:navBackground];
}

-(void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error{
    NSLog(@"%@",error.localizedDescription);
}
-(void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results{
    NSLog(@"Facebook Invite Complete");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_loadData {
    // If the user is already logged in, display any previously cached values before we get the latest from Facebook.
    if ([PFUser currentUser]) {
        [self _updateProfileData];
    }
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id, name, email, location, gender, birthday, relationship_status" forKey:@"fields"];
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
     {
         
         NSMutableDictionary *userProfile = [NSMutableDictionary dictionaryWithCapacity:7];
         
         NSString *facebookID = result[@"id"];
         if (facebookID) {
             userProfile[@"facebookId"] = facebookID;
         }
         
         NSString *name = result[@"name"];
         if (name) {
             userProfile[@"name"] = name;
         }
         
         NSString *location = result[@"location"][@"name"];
         if (location) {
             userProfile[@"location"] = location;
         }
         
         NSString *gender = result[@"gender"];
         if (gender) {
             userProfile[@"gender"] = gender;
         }
         
         NSString *birthday = result[@"birthday"];
         if (birthday) {
             userProfile[@"birthday"] = birthday;
         }
         
         NSString *relationshipStatus = result[@"relationship_status"];
         if (relationshipStatus) {
             userProfile[@"relationship"] = relationshipStatus;
         }
         
         userProfile[@"pictureURL"] = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID];

         
         [[PFUser currentUser] setObject:userProfile forKey:@"profile"];
         [[PFUser currentUser] saveInBackground];

         [self _updateProfileData];
         
         
     }];
    
    /*
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        // handle response
        if (!error) {
            // Parse the data received
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            
            
            NSMutableDictionary *userProfile = [NSMutableDictionary dictionaryWithCapacity:7];
            
            if (facebookID) {
                userProfile[@"facebookId"] = facebookID;
            }
            
            NSString *name = userData[@"name"];
            if (name) {
                userProfile[@"name"] = name;
            }
            
            NSString *location = userData[@"location"][@"name"];
            if (location) {
                userProfile[@"location"] = location;
            }
            
            NSString *gender = userData[@"gender"];
            if (gender) {
                userProfile[@"gender"] = gender;
            }
            
            NSString *birthday = userData[@"birthday"];
            if (birthday) {
                userProfile[@"birthday"] = birthday;
            }
            
            NSString *relationshipStatus = userData[@"relationship_status"];
            if (relationshipStatus) {
                userProfile[@"relationship"] = relationshipStatus;
            }
            
            userProfile[@"pictureURL"] = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID];
            
            [[PFUser currentUser] setObject:userProfile forKey:@"profile"];
            [[PFUser currentUser] saveInBackground];
            
            [self _updateProfileData];
        } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
                    isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"The facebook session was invalidated");
            [self logoutButtonAction:nil];
        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];
    */
}

// Set received values if they are not nil and reload the table
- (void)_updateProfileData {
    NSString *location = [PFUser currentUser][@"profile"][@"location"];
    if (location) {
        //self.rowDataArray[0] = location;
    }
    
    NSString *gender = [PFUser currentUser][@"profile"][@"gender"];
    if (gender) {
       // self.rowDataArray[1] = gender;
    }
    
    NSString *birthday = [PFUser currentUser][@"profile"][@"birthday"];
    if (birthday) {
        //self.rowDataArray[2] = birthday;
    }
    
    NSString *relationshipStatus = [PFUser currentUser][@"profile"][@"relationship"];
    if (relationshipStatus) {
        //self.rowDataArray[3] = relationshipStatus;
    }
    
    //[self.tableView reloadData];
    
    // Set the name in the header view label
    NSString *name = [PFUser currentUser][@"profile"][@"name"];
    if (name) {
        self.nameLabel.text = name;
    }
    
    NSString *userProfilePhotoURLString = [PFUser currentUser][@"profile"][@"pictureURL"];
    // Download the user's facebook profile picture
    if (userProfilePhotoURLString) {
        NSURL *pictureURL = [NSURL URLWithString:userProfilePhotoURLString];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];
        
        [NSURLConnection sendAsynchronousRequest:urlRequest
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   if (connectionError == nil && data != nil) {
                                       self.profileImage.image = [UIImage imageWithData:data];
                                       
                                       // Add a nice corner radius to the image
                                       self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2;
                                       self.profileImage.layer.masksToBounds = YES;
                                   } else {
                                       NSLog(@"Failed to load profile photo.");
                                   }
                               }];
    }
}


/*
-(void)checkFacebookPublishPermissionWithblock:(void (^)(BOOL canShare, NSError *error))completionBlock{
    
    FBSession *session = [PFFacebookUtils session];
    [session refreshPermissionsWithCompletionHandler:^(FBSession *session, NSError *error) {
        if ([session hasGranted:@"publish_actions"]) {
            // TODO: publish content.
            if (completionBlock){
                completionBlock(YES,nil);
            }
            
        } else {
            if (completionBlock){
                completionBlock(NO,error);
            }
        }
    }];
}

*/
- (void)logoutButtonAction:(id)sender {
    // Logout user, this automatically clears the cache
    [PFUser logOut];
    
    // Return to login view controller
    //[self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)logoutAction:(id)sender{
    // Logout user, this automatically clears the cache
    [PFUser logOut];
    
    LoginViewController *loginView = [[LoginViewController alloc] init];
    [self presentViewController:loginView animated:YES completion:nil];
}

-(IBAction)cancelAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onClickContact:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:contacto@denunciaecatepec.com"]];

}

- (IBAction)onClickTerms:(id)sender {
    TerminosViewController *terminos = [[TerminosViewController alloc] initWithNibName:@"TerminosViewController" bundle:nil];
    [self presentViewController:terminos animated:YES completion:nil];

}

- (IBAction)onClickShareFacebook:(id)sender {
    FBSDKAppInviteContent *content = [[FBSDKAppInviteContent alloc] init];
    [content setAppLinkURL:[NSURL URLWithString:@"http://fb.me/632680106831666"]];
    
    //optionally set previewImageURL

    [content setAppInvitePreviewImageURL:[NSURL URLWithString:@"http://http://denunciaecatepec.com/alertaciudadana"]];
    
    // present the dialog. Assumes self implements protocol `FBSDKAppInviteDialogDelegate`
    [FBSDKAppInviteDialog showFromViewController:self withContent:content delegate:self];   

    
    /**SLComposeViewController *fbController=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
            
            [fbController dismissViewControllerAnimated:YES completion:nil];
            
            switch(result){
                case SLComposeViewControllerResultCancelled:
                default:
                {
                    NSLog(@"Cancelled.....");
                    
                }
                    break;
                case SLComposeViewControllerResultDone:
                {
                    NSLog(@"Posted....");
                }
                    break;
            }};
        
        //[fbController addImage:[UIImage imageNamed:@"logo.jpg"]];
        [fbController setInitialText:@""];
        //[fbController addURL:[NSURL URLWithString: @"http://zahuisoftware.com/dangeraway/"]];
        
        [fbController setCompletionHandler:completionHandler];
        [self presentViewController:fbController animated:YES completion:nil];
    }
    */
   /*
    [self checkFacebookPublishPermissionWithblock:^(BOOL canShare, NSError *error) {
        if (error == nil) {
            if (canShare == YES) {
                NSMutableDictionary *fbArguments = [[NSMutableDictionary alloc] init];
                
                NSString *wallPost = @"DangerAway!";
                NSString *linkURL  = @"http://zahuisoftware.com/dangeraway/";
                //NSString *imgURL   = @"http://zahuisoftware.com/dangeraway/img/DAFooterLogo.png";
                
                [fbArguments setObject:wallPost forKey:@"message"];
                [fbArguments setObject:linkURL  forKey:@"link"];
                //[fbArguments setObject:imgURL   forKey:@"picture"];
                //FBRequest *request = [FBRequest requestForMe];
                
                FBRequest *request = [FBRequest requestWithGraphPath:@"me/feed"
                                                          parameters:fbArguments
                                                          HTTPMethod:@"POST"
                                      ];
                [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    if (!error) {
    
                        NSDictionary *userData = (NSDictionary *)result; // The result is a dictionary
                        
                        NSString *facebookId = userData[@"id"];
                        NSString *name = userData[@"name"];
                        NSString *location = userData[@"location"][@"name"];
                        NSString *gender = userData[@"gender"];
                        NSString *birthday = userData[@"birthday"];
                        */
                        // Now do what you wanted next...
                        // ...
    /*
                        XYAlertView *customAlert = [XYAlertView alertViewWithTitle:@"Danger Away!"
                                                              message:NSLocalizedString(@"Thanks for your support",nil)
                                                              buttons:[NSArray arrayWithObjects:@"OK", nil]
                                                         afterDismiss:^(int buttonIndex) {
                                                             NSLog(@"button index: %d pressed!", buttonIndex);
                                                         }];
                        [customAlert setButtonStyle:XYButtonStyleGray atIndex:0];
                        
                        UIColor *navBackground = [Utilities colorwithHexString:@"#ffd900" alpha:1];
                        
                        [customAlert setTitleFontColor:navBackground];
                        [customAlert setMessageFontColor:[UIColor blackColor]];
                        // display
                        [customAlert show];

                    } else {
                        NSLog(@"%@",error.description);
                    }
                }];
            } else {
                [self requestPermission];
            }
            
        } else{
            [self requestPermission];
        }
    }];
    
    */
}

/*
-(void)requestPermission{
    NSString * EMAIL = @"email";
    //NSString * BIRTHDAY = @"user_birthday";
    //NSString * PUBLISH = @"publish_actions";
    
    //NSString * ABOUT_ME = @"user_about_me";
    //NSString * PHOTOS = @"user_photos";
    //NSString * HOMETOWN = @"user_hometown";
    //NSString * LOCATION = @"user_location";
    
    
    // Set permissions required from the facebook user account
    //NSArray *permissionsArray = @[ EMAIL, ABOUT_ME, PHOTOS, BIRTHDAY, HOMETOWN,LOCATION,PUBLISH];
    NSArray *permissionsArray = @[ EMAIL];

    FBSession *session = [PFFacebookUtils session];
    [session requestNewPublishPermissions:permissionsArray defaultAudience:FBSessionDefaultAudienceEveryone completionHandler:^(FBSession *session, NSError *error){
        if (error == nil) {
            
        } else {
            NSLog(@"%@",error.description);
        }
        
    }];
}
*/
- (IBAction)onClickShareTwitter:(id)sender {
    
    BOOL isAvailable = [SLComposeViewController isAvailableForServiceType: SLServiceTypeTwitter];
    if (isAvailable) {
        SLComposeViewController * composeVC = [SLComposeViewController composeViewControllerForServiceType: SLServiceTypeTwitter];
        [composeVC addImage:[UIImage imageNamed:@"logo.jpg"]];
        [composeVC setInitialText:@"DangerAway!."];
        [composeVC addURL:[NSURL URLWithString:@"ttp://http://denunciaecatepec.com/alertaciudadana"]];
        [self presentViewController: composeVC animated: YES completion: nil];
    }
}


- (IBAction)onClickShareGoogle:(id)sender {
    id<GPPShareBuilder> shareBuilder = [[GPPShare sharedInstance] shareDialog];
    
    // This line will fill out the title, description, and thumbnail from
    // the URL that you are sharing and includes a link to that URL.
    [shareBuilder setURLToShare:[NSURL URLWithString:@"ttp://http://denunciaecatepec.com/alertaciudadana"]];
    //[shareBuilder setTitle:@"DangerAway!" description:@"" thumbnailURL:[NSURL URLWithString:@"http://zahuisoftware.com/dangeraway/img/DAFooterLogo.png"]];
    // Optionally attach a deep link ID for your mobile app
    //[shareBuilder setContentDeepLinkID:@"/restaurant/sf/1234567/"];
    
    [shareBuilder open];
}


- (IBAction)onClickFollowFacebook:(id)sender {
    NSString *pageID = @"506544932746650";
    
    BOOL isInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]];
    NSString *url = @"";
    if (isInstalled) {
        url = [NSString stringWithFormat:@"fb://profile/%@/",pageID];
    } else {
        url = [NSString stringWithFormat:@"http://www.facebook.com/pages/AlertaEcatepec/%@",pageID];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];

}
- (IBAction)onClickFollowTwitter:(id)sender {
    NSURL *url = [NSURL URLWithString:@"twitter://"];
    if ( [[UIApplication sharedApplication] canOpenURL:url] ){
        url = [NSURL URLWithString:@"twitter://user?screen_name=Alerta_Ecatepec"];

    } else {
        url = [NSURL URLWithString:@"https://twitter.com/#!/Alerta_Ecatepec"];

    }
    [[UIApplication sharedApplication] openURL:url];

}

- (IBAction)onClickFollowGoogle:(id)sender {
    NSString *channelName = @"MegaMarchaEcate";
    
    NSURL *linkToAppURL = [NSURL URLWithString:[NSString stringWithFormat:@"youtube://user/%@",channelName]];
    NSURL *linkToWebURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com/user/%@",channelName]];
    
    if ([[UIApplication sharedApplication] canOpenURL:linkToAppURL]) {
        // Can open the youtube app URL so launch the youTube app with this URL
        [[UIApplication sharedApplication] openURL:linkToAppURL];
    }
    else{
        // Can't open the youtube app URL so launch Safari instead
        [[UIApplication sharedApplication] openURL:linkToWebURL];
    }

}


@end
