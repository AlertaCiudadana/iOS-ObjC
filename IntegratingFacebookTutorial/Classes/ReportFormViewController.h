//
//  ReportFormViewController.h
//  DangerAwayApp
//
//  Created by Dasoga on 11/03/15.
//
//

#import <UIKit/UIKit.h>
#import "BounceAnimationController.h"
#import "RoundRectPresentationController.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "XYAlertView.h"

@interface ReportFormViewController : UIViewController<UITextViewDelegate>{
    NSArray *crimeTypesArray;
    NSString *selectedCrime;
    CGFloat lat;
    CGFloat lon;
}
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UILabel *lblDateCrime;
@property (weak, nonatomic) IBOutlet UILabel *lblCrimeType;
@property (weak, nonatomic) IBOutlet UIView *datePicketContainer;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *crimeTipeContainer;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnReport;
@property (weak, nonatomic) IBOutlet UITextView *reportContent;
@property (weak, nonatomic) IBOutlet UIDatePicker *reportDate;
@property (weak, nonatomic) IBOutlet UIButton *btnCrimeCar;
@property (weak, nonatomic) IBOutlet UIButton *btnCrimeThief;
@property (weak, nonatomic) IBOutlet UIButton *btnCrimeHome;
@property (weak, nonatomic) IBOutlet UISegmentedControl *crimeTypes;

-(IBAction)saveReport:(id)sender;
- (IBAction)cancelReport:(id)sender;
- (IBAction)onClickCar:(id)sender;
- (IBAction)onClickThief:(id)sender;
- (IBAction)onClickHome:(id)sender;
- (void)setReportLocation:(CGFloat)latitud longitud:(CGFloat)longitud;
- (void)setParent:(id)father;
@end
