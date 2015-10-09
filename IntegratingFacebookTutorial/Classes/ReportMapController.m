//
//  ReportMapController.m
//  DangerAwayApp
//
//  Created by German on 3/5/15.
//
//

#import "ReportMapController.h"

@interface ReportMapController ()
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;

@end

@implementation ReportMapController{
    CLLocationManager *locationManager;
    GMSMarker *currentLocationMarker;
    
}
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.mapView setMyLocationEnabled:YES];
    
    self.mapView.padding = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 120,  0);
    
    
    [self.mapView setDelegate:self];
    // Creates a marker in the center of the map.
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager requestWhenInUseAuthorization];
    
    
    UIBarButtonItem *btnConfig = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_config"]]];
    self.navigationItem.rightBarButtonItem = btnConfig;
    
    
    //self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_logo_black"]];
    //[self.navigationController setNavigationBarHidden:NO];
    
    UIColor *navBackground = [Utilities colorwithHexString:@"#ffd900" alpha:1];
    self.labelView.backgroundColor = navBackground;
    [self setFontFamily:@"Exo-Light" forView:self.view andSubViews:YES];
    UIFont *fontExoBold = [UIFont fontWithName:@"Exo-Bold" size:14];

    [self.lblMessage setFont:fontExoBold];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.mapView clear];
}

-(void)setFontFamily:(NSString*)fontFamily forView:(UIView*)view andSubViews:(BOOL)isSubViews
{
    if ([view isKindOfClass:[UILabel class]])
    {
        UILabel *lbl = (UILabel *)view;
        [lbl setFont:[UIFont fontWithName:fontFamily size:[[lbl font] pointSize]]];
    }
    
    if (isSubViews)
    {
        for (UIView *sview in view.subviews)
        {
            [self setFontFamily:fontFamily forView:sview andSubViews:YES];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse|| status == kCLAuthorizationStatusAuthorizedAlways) {
        
        // 3
        [manager startUpdatingLocation];
        //4
        [self.mapView setMyLocationEnabled:YES];
        [self.mapView.settings setMyLocationButton:YES];
    }
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    if (locations != nil) {
        CLLocation *currentLocation = [locations objectAtIndex:0];
        /*currentLocationMarker = [[GMSMarker alloc] init];
        currentLocationMarker.position = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
        currentLocationMarker.title = @"You";
        currentLocationMarker.snippet = @"";
        currentLocationMarker.map = self.mapView;*/
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentLocation.coordinate.latitude                                                             longitude:currentLocation.coordinate.longitude                                                                  zoom:15];
        [self.mapView setCamera:camera];
        [manager stopUpdatingLocation];
    }
}

-(void) mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate{
    GMSMarker *marker3 = [[GMSMarker alloc] init];
    marker3.position = coordinate;
    marker3.title = @"";
    marker3.snippet = @"";
    marker3.map = self.mapView ;
    lat = coordinate.latitude;
    lon = coordinate.longitude;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Alert",nil)
                                                    message:NSLocalizedString(@"Do you want to create a report in that location?",nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"No",nil)
                                          otherButtonTitles:NSLocalizedString(@"Yes",nil), nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex) {
        case 0: //"No" pressed
            //do something?
            [self.mapView clear];

            break;
        case 1: //"Yes" pressed
            //here you pop the viewController
            [self presentViewReport];
            break;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)presentViewReport{
    ReportFormViewController *report = [[ReportFormViewController alloc] initWithNibName:@"ReportFormViewController" bundle:nil];
    //report.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    //report.view.backgroundColor = [UIColor clearColor];
    [report setReportLocation:lat longitud:lon];
    [report setParent:self];
    [self presentViewController:report animated:YES completion:nil];
}

- (IBAction)onClickSearch:(id)sender {
    NSString *address = [self.txtSearch text];
    address = [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *geocodingBaseUrl = @"http://maps.googleapis.com/maps/api/geocode/json?";
    NSString *urlStr =[NSString stringWithFormat:@"%@address=%@&sensor=false",geocodingBaseUrl,address];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    dispatch_sync(kBgQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        [self markerForAddress:data];
    });
}



- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position {
    GMSCoordinateBounds *bounds =[[GMSCoordinateBounds alloc] initWithRegion: self.mapView.projection.visibleRegion];
    NSLog(@"%f,%f ", bounds.northEast.latitude,bounds.northEast.longitude);
    NSLog(@"%f,%f ", bounds.southWest.latitude,bounds.southWest.longitude);
    
    
}

-(void)markerForAddress:(NSData *)data {
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray *results = [json objectForKey:@"results"];
    if(results != nil && [results count] > 0){
        [self.mapView clear];
        for(int i= 0; i < [results count]; i++){
            NSDictionary *result = [results objectAtIndex:i];
            NSString *address = [result objectForKey:@"formatted_address"];
            NSDictionary *geometry = [result objectForKey:@"geometry"];
            NSDictionary *location = [geometry objectForKey:@"location"];
            NSString *latStr = [location objectForKey:@"lat"];
            NSString *lngStr = [location objectForKey:@"lng"];
            if(latStr != nil &&  lngStr != nil ){
                double latValue =[latStr doubleValue];
                double lngValue =[lngStr doubleValue];
                GMSMarker *marker = [[GMSMarker alloc] init];
                marker.position = CLLocationCoordinate2DMake(latValue,lngValue);
                marker.title = NSLocalizedString(@"Address",nil);
                marker.snippet = address;
                marker.map = self.mapView;
                GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latValue longitude:lngValue zoom:15];
                [self.mapView setCamera:camera];
            }
        }
    }
}@end
