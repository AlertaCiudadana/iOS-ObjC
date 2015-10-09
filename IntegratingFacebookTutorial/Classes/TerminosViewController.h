//
//  TerminosViewController.h
//  DangerAwayApp
//
//  Created by German on 4/4/15.
//
//

#import <UIKit/UIKit.h>
#import "BounceAnimationController.h"
#import "RoundRectPresentationController.h"
#import "Utilities.h"

@interface TerminosViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;
- (IBAction)onClickBtnClose:(id)sender;

@end
