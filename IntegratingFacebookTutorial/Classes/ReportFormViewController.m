//
//  ReportFormViewController.m
//  DangerAwayApp
//
//  Created by Dasoga on 11/03/15.
//
//

#import "ReportFormViewController.h"
#import "MapViewController.h"

@interface ReportFormViewController ()<UIViewControllerTransitioningDelegate>{
    MapViewController *fatherController;

}
@end


@implementation ReportFormViewController

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

- (void)setParent:(id)father{
    fatherController = father;
}

-(void)getCrimeTypes {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Type"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            // Do something with the found objects
            if (objects != nil) {
                crimeTypesArray = objects;
                CGFloat height =0;
                CGFloat totalWidth = 0;
                for (PFObject *object in objects) {
                    int i=0;
                    NSLog(@"%@", object.objectId);
                    NSString *crimeType =object.objectId;
                    NSString *crimeTypePin = [NSString stringWithFormat:@"crimeIcon_%@",crimeType];
                    UIImage *crimeIcon =[[UIImage imageNamed:crimeTypePin ] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    if (height < crimeIcon.size.height) {
                        height = crimeIcon.size.height;
                    }
                    totalWidth += crimeIcon.size.width;
                    [self.crimeTypes insertSegmentWithImage:crimeIcon atIndex:i animated:YES];
                    i++;
                }
                
                CGRect frame= self.crimeTypes .frame;
                [self.crimeTypes  setFrame:CGRectMake(frame.origin.x, frame.origin.y, totalWidth +20 , height + 20.0)];
            } else {
                crimeTypesArray = [[NSArray alloc] init];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.btnCrimeCar setAlpha:0.5];
    [self.btnCrimeThief setAlpha:1];
    [self.btnCrimeHome setAlpha:0.5];
    
    
    
    selectedCrime =@"eS0izPXGNH";
    CGRect bounds = self.titleLabel.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(20.0, 20.0)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;

    
    self.titleLabel.layer.mask = maskLayer;
    [self.reportContent setDelegate:self];
    
    self.btnCancel.layer.cornerRadius = 10; // this value vary as per your desire
    self.btnCancel.clipsToBounds = YES;
    
    self.btnReport.layer.cornerRadius = 10; // this value vary as per your desire
    self.btnReport.clipsToBounds = YES;
    //home 4CCprZpQYe
    //thief eS0izPXGNH
    //car z9mAVcf8td
    UIColor *navBackground = [Utilities colorwithHexString:@"#ffd900" alpha:1];
    self.view.backgroundColor =navBackground;
    self.crimeTipeContainer.backgroundColor = navBackground;
    self.datePicketContainer.backgroundColor = navBackground;
    
    
    
    CALayer* layer = [self.lblCrimeType layer];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.borderWidth = 2;
    bottomBorder.frame = CGRectMake(-2, layer.frame.size.height-2, layer.frame.size.width, 2);
    [bottomBorder setBorderColor:[UIColor blackColor].CGColor];
    [layer addSublayer:bottomBorder];
    
    
    
    CALayer* layerDateCrime = [self.lblDateCrime layer];
    
    CALayer *bottomBorderDateCrime = [CALayer layer];
    bottomBorderDateCrime.borderWidth = 2;
    bottomBorderDateCrime.frame = CGRectMake(-2, layerDateCrime.frame.size.height-2, layerDateCrime.frame.size.width, 2);
    [bottomBorderDateCrime setBorderColor:[UIColor blackColor].CGColor];
    [layerDateCrime addSublayer:bottomBorderDateCrime];
    
    CALayer* layerContent = [self.lblContent layer];
    
    CALayer *bottomBorderContent = [CALayer layer];
    bottomBorderContent.borderWidth = 2;
    bottomBorderContent.frame = CGRectMake(-2, layerContent.frame.size.height-2, layerContent.frame.size.width, 2);
    [bottomBorderContent setBorderColor:[UIColor blackColor].CGColor];
    [layerContent addSublayer:bottomBorderContent];
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-1];
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    
    [self.reportDate setMaximumDate:currentDate];
    [self.reportDate setMinimumDate:minDate];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.reportContent isFirstResponder] && [touch view] != self.reportContent) {
        [self.reportContent resignFirstResponder];
    }
    
    
    [super touchesBegan:touches withEvent:event];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setReportLocation:(CGFloat)latitud longitud:(CGFloat)longitud
{
    lat = latitud;
    lon = longitud;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self animateTextView: YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self animateTextView:NO];
    if ([textView text].length < 70) {
        NSLog(@"Menor a 70");
    }
}

- (void) animateTextView:(BOOL) up
{
    const int movementDistance =120; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    int movement= movement = (up ? -movementDistance : movementDistance);
    NSLog(@"%d",movement);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

-(void)saveReport:(id)sender{
    NSDate *selectedDate = self.reportDate.date;
    NSString *content = self.reportContent.text;
    NSString *userId = [[PFUser currentUser] objectId];    
    if (content.length < 70) {
        XYAlertView *customAlert = [XYAlertView alertViewWithTitle:NSLocalizedString(@"Alert",nil)
                                                           message:NSLocalizedString(@"Your description must be at least of 70 characters",nil)
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

    }else{
    
        NSMutableDictionary * params = [NSMutableDictionary new];
        
        
        
        NSNumber *latNum = [NSNumber numberWithDouble: (double)lat];
        NSNumber *lonNum = [NSNumber numberWithDouble: (double)lon];
        
        
        params[@"id_user"] = userId;
        
        params[@"date_time"] =selectedDate;
        params[@"latitude"] =[NSString stringWithFormat:@"%@", latNum];
        params[@"longitude"] =[NSString stringWithFormat:@"%@", lonNum];
        params[@"description"] =content;
        params[@"id_type"] =selectedCrime;
        
        
        
        [PFCloud callFunctionInBackground:@"makeReport"
                           withParameters:params
                                    block:^(NSNumber *ratings, NSError *error) {
                                        if (!error) {
                                            // ratings is 4.5
                                            [fatherController.tabBarController setSelectedIndex:0];
                                            [fatherController loadReportsInMyLocation];
                                            
                                            [self dismissViewControllerAnimated:YES completion:nil];
                                            
                                        } else {
                                            /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                             message:@"Report creation failed"
                                             delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
                                             [alert show];*/
                                            XYAlertView *customAlert = [XYAlertView alertViewWithTitle:NSLocalizedString(@"Alert",nil)
                                                                                               message:NSLocalizedString(@"Report creation failed",nil)
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
                                    }];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd/MM/yyyy"];
        
        NSString *today = [formatter stringFromDate:[NSDate date]];
        //NSLog(@"today %@",today);
        NSUserDefaults *dataSaved = [NSUserDefaults standardUserDefaults];  //load NSUserDefaults
        int numOfReports = (int)[dataSaved integerForKey:@"numberOfReports"];
        NSString *dateReport = [dataSaved objectForKey:@"dateReport"];
        NSLog(@"Num of reports %@",[NSString stringWithFormat:@"%i",numOfReports]);
        if ([dateReport isEqualToString:today]) {
            numOfReports = numOfReports + 1;
        }else{
            numOfReports = 1;
        }
        NSLog(@"Pondre %d num of reports",numOfReports);
        [dataSaved setInteger:numOfReports forKey:@"numberOfReports"];
        [dataSaved setObject:today forKey:@"dateReport"];        

    }
    
}

- (IBAction)cancelReport:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)onClickCar:(id)sender {
    [self.btnCrimeCar setAlpha:1];
    [self.btnCrimeThief setAlpha:0.5];
    [self.btnCrimeHome setAlpha:0.5];
    selectedCrime =@"z9mAVcf8td";
}

- (IBAction)onClickThief:(id)sender {
    [self.btnCrimeCar setAlpha:0.5];
    [self.btnCrimeThief setAlpha:1];
    [self.btnCrimeHome setAlpha:0.5];
    selectedCrime =@"eS0izPXGNH";
}

- (IBAction)onClickHome:(id)sender {
    [self.btnCrimeCar setAlpha:0.5];
    [self.btnCrimeThief setAlpha:0.5];
    [self.btnCrimeHome setAlpha:1];
    selectedCrime =@"4CCprZpQYe";
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

@end
