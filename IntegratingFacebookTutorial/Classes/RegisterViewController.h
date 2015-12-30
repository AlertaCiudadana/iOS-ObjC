//
//  RegisterViewController.h
//  Alerta Ciudadana
//
//  Created by Dante Solorio on 12/29/15.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Utilities.h"

@interface RegisterViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *mailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *repeatPasswordField;


@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *alreadyAccountButton;


- (IBAction)registerButton:(id)sender;
- (IBAction)alreadyAccountActionButton:(id)sender;

@end
