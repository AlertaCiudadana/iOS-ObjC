//
//  SettingsViewController.h
//  DangerAwayApp
//
//  Created by Dasoga on 13/03/15.
//
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>
#import <GooglePlus/GooglePlus.h>
#import "TerminosViewController.h"
#import "XYAlertView.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface SettingsViewController : UIViewController<FBSDKAppInviteDialogDelegate>

@property(nonatomic,strong) IBOutlet UILabel *nameLabel;
@property(nonatomic,strong) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIButton *btnShareFacebook;
@property (weak, nonatomic) IBOutlet UIButton *btnShareTwitter;
@property (weak, nonatomic) IBOutlet UIButton *btnShareGoogle;
@property (weak, nonatomic) IBOutlet UIButton *btnFollowFacebook;

@property (weak, nonatomic) IBOutlet UIButton *btnFollowTwitter;
@property (weak, nonatomic) IBOutlet UIButton *btnFollowGoogle;
@property (weak, nonatomic) IBOutlet UIButton *btnContact;
@property (weak, nonatomic) IBOutlet UIButton *btnTerms;
@property (weak, nonatomic) IBOutlet UIButton *btnLogoutFacebook;
@end
