//
//  MapViewController.h
//  DangerAwayApp
//
//  Created by German on 2/26/15.
//
//
//@import GoogleMobileAds;

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "ReportMapController.h"
#import "MyReportsTableViewController.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "DWBubbleMenuButton.h"
#import "MarkerInfoView.h"
#import <GoogleMobileAds/GADInterstitial.h>
#import <GoogleMobileAds/GADBannerView.h>




@interface MapViewController : UIViewController<GMSMapViewDelegate, CLLocationManagerDelegate,UITabBarControllerDelegate, UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate>{
    CGFloat currentZoom;
    NSString *filterID;
    CGFloat lat;
    CGFloat lon;
    NSArray *foundAddress;
    NSArray *crimeTypes;
    NSNumber *daysFilter;
    NSString *crimeFilter;
    NSArray *crimeFilterButtons;
    NSArray *dayFilterButtons;
    UIButton *allCrimes;
    DWBubbleMenuButton *upMenuView;
    UIImageView *home;
    UIApplication *app;
    NSString *userId;
    UIImageView *homeDays;
    
    DWBubbleMenuButton *daysMenuView;
    
}


@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;


-(void)loadReportsInMyLocation;
-(void)createReportOnMyLocation;
-(void)createReportOnLocation:(CGFloat)latitud longitud:(CGFloat)longitud address:(NSString *)address;

@end
