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

#import "LoginViewController.h"


@implementation LoginViewController{
    

    
}

#pragma mark -
#pragma mark Init

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.title = @"Facebook Profile";
    }
    return self;
}

#pragma mark -
#pragma mark UIViewController


- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];

    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    //[self setNeedsStatusBarAppearanceUpdate];
    // Check if user is cached and linked to Facebook, if so, bypass login
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [self _presentMapViewControllerAnimated:NO];
    }
    
    UIColor *navBackground = [Utilities colorwithHexString:@"#ffd900" alpha:1];
    [self.btnFacebookLogin setBackgroundColor:navBackground];
    [self.loginButton setBackgroundColor:navBackground];
    [self.signUpButton setBackgroundColor:navBackground];

    //Query example
//    PFQuery *citys = [PFQuery queryWithClassName:@"Report"];
//    [citys findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        for (id object in objects) {
//            NSLog(@"%@",object[@"city"]);
//        }
//    }];
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"railway" ofType:@"gif"];
//    NSData *gif = [NSData dataWithContentsOfFile:filePath];
//    
//    UIWebView *webViewBG = [[UIWebView alloc] initWithFrame:self.view.frame];
//    [webViewBG loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
//    webViewBG.userInteractionEnabled = NO;
//    [self.view addSubview:webViewBG];
//    
//    UIView *filter = [[UIView alloc] initWithFrame:self.view.frame];
//    filter.backgroundColor = [UIColor blackColor];
//    filter.alpha = 0.05;
//    [self.view addSubview:filter];
//    
//    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 360, 240, 40)];
//    loginBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
//    loginBtn.layer.borderWidth = 2.0;
//    loginBtn.titleLabel.font = [UIFont systemFontOfSize:24];
//    [loginBtn setTintColor:[UIColor whiteColor]];
//    [loginBtn setTitle:@"Login" forState:UIControlStateNormal];
//    [self.view addSubview:loginBtn];
    NSString *deviceType = [UIDevice currentDevice].model;
    //UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];    
    int random = arc4random() % 3;
    NSString* webViewContent= nil;
    NSString *filePath;
    switch (random) {
        case 0:
            if([deviceType containsString:@"iPhone"]){
                filePath = [[NSBundle mainBundle] pathForResource:@"yellow" ofType:@"gif"];
            }else{
                filePath = [[NSBundle mainBundle] pathForResource:@"yellowiPad" ofType:@"gif"];
            }
            break;
        case 1:
            if([deviceType containsString:@"iPhone"]){
                filePath = [[NSBundle mainBundle] pathForResource:@"cars" ofType:@"gif"];
            }else{

                filePath = [[NSBundle mainBundle] pathForResource:@"carsiPad" ofType:@"gif"];
            }
            break;
        case 2:
            if([deviceType containsString:@"iPhone"]){
                filePath = [[NSBundle mainBundle] pathForResource:@"cars2" ofType:@"gif"];
            }else{

                filePath = [[NSBundle mainBundle] pathForResource:@"cars2iPad" ofType:@"gif"];
            }
            break;
        default:
            break;
    }
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    webViewContent = [NSString stringWithFormat:
                      @"<html>"
                      "<body style=\"text-align:center;margin:0;padding:0\">"
                      "<img src=\"file://%@\" width=\"%f\" height=\"%f\"/>"
                      "</body></html>", filePath,screenBounds.size.width,screenBounds.size.height];
    [self.backGif loadHTMLString:webViewContent baseURL:nil];

   // NSData *gif = [NSData dataWithContentsOfFile:filePath];
   // [self.backGif loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    
    self.userTextField.delegate = self;
    self.passwordTextField.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self checkTerms];
}


#pragma mark -
#pragma mark Login

- (IBAction)loginButtonTouchHandler:(id)sender  {
    if ([self checkTerms] == YES) {
        
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

        // Login PFUser using Facebook

        [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
            [_activityIndicator stopAnimating]; // Hide loading indicator
            
            if (!user) {
                NSString *errorMessage = nil;
                if (!error) {
                    NSLog(@"The user cancelled the Facebook login.");
                    errorMessage = NSLocalizedString(@"The user cancelled the Facebook login.",nil);
                } else {
                    NSLog(@"An error occurred: %@", error);
                    errorMessage = [error localizedDescription];
                    if ([error code] == 2) {
                        errorMessage = NSLocalizedString(@"Please go to Settings -> Privacy -> Facebook and enable Danger Away!",nil);
                    } else if ([error code] == 5) {
                        [self loginButtonTouchHandler:nil];
                        errorMessage = nil;
                    }
                }
                /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                 message:errorMessage
                 delegate:nil
                 cancelButtonTitle:nil
                 otherButtonTitles:@"Dismiss", nil];
                 [alert show];*/
                if (errorMessage != nil) {
                    XYAlertView *customAlert = [XYAlertView alertViewWithTitle:NSLocalizedString(@"Log In Error",nil)
                                                                       message:errorMessage
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
                }
                
                
            } else {
                NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
                if ([language hasPrefix:@"es"]) {
                    language = @"es";
                }
                if (user.isNew) {
                    NSLog(@"New user");
                    
                    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
                    [parameters setValue:@"id, name, email" forKey:@"fields"];
                    
                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
                    {
                        NSLog(@"Fetched user is:%@", result);
                        [[PFUser currentUser] setObject:result[@"email"] forKey:@"email"];
                        [[PFUser currentUser] setObject:result[@"name"] forKey:@"name"];                        
                        [[PFUser currentUser] saveInBackground];

                    }];

                    /*
                    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error2) {
                        NSDictionary *userData = (NSDictionary *)result;
                        
                        [[PFUser currentUser] setObject:userData[@"email"] forKey:@"email"];
                        [[PFUser currentUser] setObject:userData[@"name"] forKey:@"name"];
                        
                        [[PFUser currentUser] saveInBackground];
                        
                    }];
                    */
                    
                    PFInstallation *installation = [PFInstallation currentInstallation];
                    installation[@"user"] = [PFUser currentUser];
                    [installation addUniqueObject:language forKey:@"channels"];
                    [installation saveInBackground];
                    
                    NSLog(@"User with facebook signed up and logged in!");
                } else {
                    PFInstallation *installation = [PFInstallation currentInstallation];
                    installation[@"user"] = [PFUser currentUser];
                    [installation addUniqueObject:language forKey:@"channels"];
                    [installation saveInBackground];
                    
                    NSLog(@"User with facebook logged in!");
                }
                [self _presentMapViewControllerAnimated:YES];
            }
        }];
        
        [_activityIndicator startAnimating]; // Show loading indicator until login is finished
    }
    
}


-(void)loginAction:(id)sender{
    NSString *userText = self.userTextField.text;
    NSString *passText = self.passwordTextField.text;
    
    [PFUser logInWithUsernameInBackground:userText password:passText block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        if (user) {
            NSLog(@"user %@",user);
            
            if (![[user objectForKey:@"emailVerified"] boolValue]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:NSLocalizedString(@"You need to verify your email adress.", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                return;
            }else{
                NSLog(@"Verified");
                [self _presentMapViewControllerAnimated:YES];
            }
            
        }else{
            NSLog(@"login error %@",error.localizedDescription);
            [self showMessageAlert:@"Error" withMessage:NSLocalizedString(@"Please verify user and password.", nil)];
        }
    }];
    
}

-(void)showMessageAlert:(NSString *)title  withMessage:(NSString*)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Ok",nil)
                                          otherButtonTitles:nil,nil];
    [alert show];
    
}

#pragma mark -
#pragma mark UserDetailsViewController

- (void)_presentUserDetailsViewControllerAnimated:(BOOL)animated {
    UserDetailsViewController *detailsViewController = [[UserDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:detailsViewController animated:animated];
}


- (void)_presentMapViewControllerAnimated:(BOOL)animated {
    NSUserDefaults *dataSaved = [NSUserDefaults standardUserDefaults];  //load NSUserDefaults
    bool result = [dataSaved boolForKey:@"tutorial"];
    if (result == false) {
        ContainerViewController *pageView = [[ContainerViewController alloc] init];
        [self presentViewController:pageView animated:YES completion:nil];
    }
    else{
        BaseViewController *tabBar = [[BaseViewController alloc] initWithNibName:nil bundle:nil];
        [self presentViewController:tabBar animated:NO completion:nil];
    }
    
}

- (void)_presentInfoViewControllerAnimated:(BOOL)animated {

    InfoViewController *infoController = [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil];
    infoController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    infoController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    infoController.view.backgroundColor = [UIColor clearColor];
    [self presentViewController:infoController animated:YES completion:nil];
}

- (IBAction)infoButton:(id)sender {
    [self _presentInfoViewControllerAnimated:YES];
}



-(BOOL)checkTerms{
    NSUserDefaults *dataSaved = [NSUserDefaults standardUserDefaults];  //load NSUserDefaults
    bool result = [dataSaved boolForKey:@"TermsConditionsAccepted"];
    if (result == false) {
        TermsConditionsViewController *report = [[TermsConditionsViewController alloc] initWithNibName:@"TermsConditionsViewController" bundle:nil];
        
        [self presentViewController:report animated:YES completion:nil];
        return NO;
    }
    

    return YES;
}


-(void)signUpButtonTouch:(id)sender{
    [self _presentSignUpViewControllerAnimated:YES];
}

- (void)_presentSignUpViewControllerAnimated:(BOOL)animated {
    
    RegisterViewController *signUpController = [[RegisterViewController alloc] initWithNibName:@"SignUp" bundle:nil];
    signUpController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    signUpController.modalTransitionStyle = UIModalPresentationFullScreen;
    [self presentViewController:signUpController animated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.userTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

@end
