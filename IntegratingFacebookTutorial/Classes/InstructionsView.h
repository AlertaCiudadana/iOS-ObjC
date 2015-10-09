//
//  InstructionsView.h
//  Danger Away
//
//  Created by Dasoga on 12/04/15.
//
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@interface InstructionsView : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *screenLabel;
@property (assign, nonatomic) NSInteger indexNumber;

@property (weak, nonatomic) IBOutlet UIImageView *backImage;

@property (weak, nonatomic) IBOutlet UIButton *dondeButton;

@end
