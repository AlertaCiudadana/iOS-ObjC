//
//  TermsConditionsViewController.m
//  Danger Away
//
//  Created by German on 4/12/15.
//
//

#import "TermsConditionsViewController.h"

@interface TermsConditionsViewController ()<UIViewControllerTransitioningDelegate>
@end

@implementation TermsConditionsViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        if ([self respondsToSelector:@selector(setTransitioningDelegate:)]) {
            self.modalPresentationStyle = UIModalPresentationCustom;
            self.transitioningDelegate = self;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIColor *navBackground = [Utilities colorwithHexString:@"#ffd900" alpha:1];
    self.view.backgroundColor =navBackground;
    CGRect bounds = self.lblTitle.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(20.0, 20.0)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    
    
    
    self.lblTitle.layer.mask = maskLayer;
    
    self.btnNo.layer.cornerRadius = 10;
    self.btnYes.layer.cornerRadius = 10;
    [self.termsTextView  scrollRangeToVisible:NSMakeRange(0, 0)];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[BounceAnimationController alloc] init];
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return [[RoundRectPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

- (IBAction)onClickNo:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onClickYes:(id)sender {
    NSUserDefaults *dataSaved = [NSUserDefaults standardUserDefaults];  //load NSUserDefaults

    [dataSaved setBool:YES forKey:@"TermsConditionsAccepted"];
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end
