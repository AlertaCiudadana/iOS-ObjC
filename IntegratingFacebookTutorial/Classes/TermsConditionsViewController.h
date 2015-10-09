//
//  TermsConditionsViewController.h
//  Danger Away
//
//  Created by German on 4/12/15.
//
//

#import <UIKit/UIKit.h>
#import "BounceAnimationController.h"
#import "RoundRectPresentationController.h"
#import "Utilities.h"

@interface TermsConditionsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
- (IBAction)onClickNo:(id)sender;
- (IBAction)onClickYes:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnNo;
@property (weak, nonatomic) IBOutlet UIButton *btnYes;
@property (weak, nonatomic) IBOutlet UITextView *termsTextView;

@end
