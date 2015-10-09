//
//  ReportMapController.h
//  DangerAwayApp
//
//  Created by German on 3/5/15.
//
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <Parse/Parse.h>
#import "Utilities.h"
#import "ReportFormViewController.h"


@interface ReportMapController : UIViewController<GMSMapViewDelegate, CLLocationManagerDelegate>{
    CGFloat lat;
    CGFloat lon;
}
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UIView *labelView;

- (IBAction)onClickSearch:(id)sender;
@end
