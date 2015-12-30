//
//  RegisterViewController.m
//  Alerta Ciudadana
//
//  Created by Dante Solorio on 12/29/15.
//
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpView{
    self.usernameField.delegate = self;
    self.firstNameField.delegate = self;
    self.lastNameField.delegate = self;
    self.mailField.delegate = self;
    self.passwordField.delegate = self;
    self.repeatPasswordField.delegate = self;
}

- (void)registerButton:(id)sender{
    NSString *username = [self.usernameField text];
    NSString *firstName = [self.firstNameField text];
    NSString *lastName = [self.lastNameField text];
    NSString *mail = [self.mailField text];
    NSString *password = [self.passwordField text];
    NSString *repeatPassword = [self.repeatPasswordField text];
    NSString *completeName = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
    
    if (([username length] > 0) && ([firstName length] > 0) && ([lastName length] > 0) && ([mail length] > 0) && ([password length] > 0) && ([repeatPassword length] > 0) ){
        if (password == repeatPassword) {
            
            PFUser *newUser = [[PFUser alloc] init];
            newUser.username = username;
            newUser.password = password;
            newUser.email = mail;
            
            [newUser setObject:completeName forKey:@"name"];
            
            [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                
                if (succeeded){
                    NSLog(@"registered!");
                    [self showMessageAlert:NSLocalizedString(@"Success", nil) withMessage:@"Registration was successful, please verify your email address"];
                }else{
                    NSLog(@"error %@",error.localizedDescription);
                    if (error.code == 203){
                        [self showMessageAlert:@"Error" withMessage:NSLocalizedString(@"The email address has already been taken", nil)];
                    }else{
                        [self showMessageAlert:@"Error" withMessage:NSLocalizedString(error.localizedDescription, nil)];
                    }

                }
            }];
            
        }else{
            [self showMessageAlert:NSLocalizedString(@"Error", nil) withMessage:NSLocalizedString(@"The Password doesn't match, please try again", nil)];
        }
        
    }else{
        [self showMessageAlert:@"Error" withMessage:NSLocalizedString(@"Please complete all fields",nil)];
    }
}

-(void)showMessageAlert:(NSString *)title  withMessage:(NSString*)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Ok",nil)
                                          otherButtonTitles:nil,nil];
    [alert show];

}

-(void)alreadyAccountActionButton:(id)sender{
    [self dismissViewControllerAnimated:true completion:nil];
}

// textField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    // verify the text field you wanna validate
    if ((textField == self.firstNameField) || (textField == self.lastNameField)) {
        
        // do not allow the first character to be space | do not allow more than one space
        if ([string isEqualToString:@" "]) {
            if (!textField.text.length)
                return NO;
            if ([[textField.text stringByReplacingCharactersInRange:range withString:string] rangeOfString:@"  "].length)
                return NO;
        }
        
        // allow backspace
        if ([textField.text stringByReplacingCharactersInRange:range withString:string].length < textField.text.length) {
            return YES;
        }
        
        // in case you need to limit the max number of characters
        if ([textField.text stringByReplacingCharactersInRange:range withString:string].length > 30) {
            return NO;
        }
        
        // limit the input to only the stuff in this character set, so no emoji or cirylic or any other insane characters
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890 "];
        
        if ([string rangeOfCharacterFromSet:set].location == NSNotFound) {
            return NO;
        }
        
        return YES;
    }
    
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
