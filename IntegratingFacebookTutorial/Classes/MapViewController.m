//
//  MapViewController.m
//  DangerAwayApp
//
//  Created by German on 2/26/15.
//
//


#import "MapViewController.h"
#import "XYAlertView.h"


@interface MapViewController ()



@end



@implementation MapViewController{
    CLLocationManager *locationManager;
    GMSMarker *currentLocationMarker;
    XYAlertView *customAlert;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Danger Away!";
    }
    return self;
}

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self setNeedsStatusBarAppearanceUpdate];
    self.mapView.settings.myLocationButton = NO;
  
    //NSLog(@"Entro viewWillAppear");
    [self startLocalization];
}


-(void)viewDidAppear:(BOOL)animated{
    //NSLog(@"ENTRO viewDidAppear");
    [self loadReportsInMyLocation];
    if (home == nil && upMenuView == nil) {
        home = [self createHomeButtonView];
        
        upMenuView = [[DWBubbleMenuButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - home.frame.size.width - 10.f, self.view.frame.size.height - home.frame.size.height - 60.f,
                                                                          home.frame.size.width,home.frame.size.height) expansionDirection:DirectionUp];
        
        
        upMenuView.homeButtonView = home;
        crimeFilterButtons =[self createCrimeButtonArray];
        [upMenuView addButtons:crimeFilterButtons];
        [self.view addSubview:upMenuView];
        [self.view bringSubviewToFront:upMenuView];

    }
    
     if (homeDays == nil && daysMenuView == nil) {
         homeDays = [self createDaysFilterButtonView];
    
         daysMenuView = [[DWBubbleMenuButton alloc] initWithFrame:CGRectMake(10.f, self.view.frame.size.height - homeDays.frame.size.height - 60.f,homeDays.frame.size.width,homeDays.frame.size.height)
                                                              expansionDirection:DirectionUp];
    
    
         daysMenuView.homeButtonView = homeDays;
         dayFilterButtons =[self createDaysButtonArray];
         [daysMenuView addButtons:dayFilterButtons];
         [self.view addSubview:daysMenuView];
         [self.view bringSubviewToFront:daysMenuView];
     }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    foundAddress = [[NSArray alloc] init];
    [self.mapView setMyLocationEnabled:NO];
    // Creates a marker in the center of the map.
    self.mapView.delegate=self;
    /*
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager requestWhenInUseAuthorization];
    [locationManager startMonitoringSignificantLocationChanges];
    */
    crimeTypes = [NSArray arrayWithObjects:@"4CCprZpQYe", @"eS0izPXGNH", @"z9mAVcf8td",nil];
    crimeFilter =@"All";
    daysFilter = [NSNumber numberWithInt:1];
    
    app = [UIApplication sharedApplication];
    userId = [[PFUser currentUser] objectId];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startLocalization:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeNotifications:) name:UIApplicationWillTerminateNotification object:nil];
    
    //Admob
    NSLog(@"Google Mobile Ads SDK version: %@", [GADRequest sdkVersion]);
    
    self.bannerView.adUnitID = @"ca-app-pub-3503513343206931/3531335000";
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    
    NSString *today = [formatter stringFromDate:[NSDate date]];
    //NSLog(@"today %@",today);
    
    NSUserDefaults *dataSaved = [NSUserDefaults standardUserDefaults];  //load NSUserDefaults
    //[dataSaved setObject:@"10/04/2015" forKey:@"dateReport"];
    int initReports = 0;
    NSString *dateReport = [dataSaved objectForKey:@"dateReport"];
    if (![dateReport isEqualToString:today]) {
        NSLog(@"Ultimo reporte fue %@",dateReport);
        [dataSaved setInteger:initReports forKey:@"numberOfReports"];
        NSLog(@"Puse 0 en reportes por ser otro dia");
    }
    NSLog(@"hoy es %@",[dataSaved objectForKey:@"dateReport"]);
    int numo = (int)[dataSaved integerForKey:@"numberOfReports"];
    NSLog(@"Tienes hoy %d reportes",numo);


}


-(void)startLocalization:(NSNotification *)notification {
    [self startLocalization];
}

-(void)startLocalization {
    locationManager = [[CLLocationManager alloc] init];
    
    
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    /* Notify heading changes when heading is > 5.
     * Default value is kCLHeadingFilterNone: all movements are reported.
     */
    locationManager.headingFilter = 5;
    
    
    // Only report to location manager if the user has traveled 1000 meters
    locationManager.distanceFilter = 10.0f;
    locationManager.delegate = self;
    locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    [locationManager requestWhenInUseAuthorization];
}


-(void)removeNotifications:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];

}


- (UIImageView *)createHomeButtonView {
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 60.f, 60.f)];
    image.image =[UIImage imageNamed:@"map_CrimeMenu"];
    image.clipsToBounds=YES;
    return image;
}

-(void)getCrimeTypes {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Type"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            // Do something with the found objects
            
            if (objects != nil) {
                crimeTypes = objects;
                
            } else {
                crimeTypes = [[NSArray alloc] init];
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


- (NSArray *)createCrimeButtonArray {
    NSMutableArray *buttonsMutable = [[NSMutableArray alloc] init];
    
    int i = 0;
    //home 4CCprZpQYe
    //thief eS0izPXGNH
    //car z9mAVcf8td
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *imageName = @"map_CrimeMenu";
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.frame = CGRectMake(0.f, 0.f, 50.f, 50.f);
    button.layer.cornerRadius = button.frame.size.height / 2.f;
    button.clipsToBounds = YES;
    button.tag = 1000;
    
    [button addTarget:self action:@selector(filterCrimen:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsMutable addObject:button];
    
    for (NSString *title in crimeTypes) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *imageName = [NSString stringWithFormat:@"crimeIcon_%@",title];
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        button.frame = CGRectMake(0.f, 0.f, 50.f, 50.f);
        button.layer.cornerRadius = button.frame.size.height / 2.f;
        button.clipsToBounds = YES;
        button.tag = i++;
        
        [button addTarget:self action:@selector(filterCrimen:) forControlEvents:UIControlEventTouchUpInside];
        [button setAlpha:0.5f];
        [buttonsMutable addObject:button];
        
    }
    
    
   
    return [buttonsMutable copy];
}

-(UIButton *)createAllCrimesButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *imageName = @"map_CrimeMenu";
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.frame = CGRectMake(0.f, 0.f, 50.f, 50.f);
    button.layer.cornerRadius = button.frame.size.height / 2.f;
    button.clipsToBounds = YES;
    button.tag = 1000;
    
    [button addTarget:self action:@selector(filterCrimen:) forControlEvents:UIControlEventTouchUpInside];
    
    return [button copy];
}


- (UIImageView *)createDaysFilterButtonView {
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 60.f, 60.f)];
    //image.image =[UIImage imageNamed:@"map_DaysMenu"];
    image.image =[UIImage imageNamed:NSLocalizedString(@"dayIcon_1",nil)];
    image.clipsToBounds=YES;
    return image;
}



- (NSArray *)createDaysButtonArray {
    NSMutableArray *buttonsMutable = [[NSMutableArray alloc] init];
    
    //int i = 0;
    //home 4CCprZpQYe
    //thief eS0izPXGNH
    //car z9mAVcf8td
    for (NSString *title in @[@"1", @"7", @"30"]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *imageName = [NSString stringWithFormat:@"dayIcon_%@",title];
        [button setImage:[UIImage imageNamed:NSLocalizedString(imageName,nil)] forState:UIControlStateNormal];
        button.frame = CGRectMake(0.f, 0.f, 50.f, 50.f);
        button.layer.cornerRadius = button.frame.size.height / 2.f;
        button.clipsToBounds = YES;
        button.tag = [title intValue];
        if (button.tag != 1) {
            [button setAlpha:0.5f];
        }
        [button addTarget:self action:@selector(filterDays:) forControlEvents:UIControlEventTouchUpInside];
        
        [buttonsMutable addObject:button];
    }
    
    return [buttonsMutable copy];
}


- (void)filterCrimen:(UIButton *)sender {
    NSLog(@"Button tapped, tag: %ld", (long)sender.tag);
    for (UIButton *button in crimeFilterButtons) {
        [button setAlpha:0.5];
    }
    [sender setAlpha:1];
    [self.mapView clear];
    int selected = (int)sender.tag;
    NSString *imageName =@"";
    if (sender.tag != 1000) {
        
       NSString *selectedCrime =[crimeTypes objectAtIndex:selected];
        NSLog(@"Selected Crime %@",selectedCrime);
        crimeFilter =selectedCrime;
        imageName = [NSString stringWithFormat:@"crimeIcon_%@",crimeFilter];

    } else {
        NSLog(@"Display All Crime");
        crimeFilter = @"All";
        imageName = @"map_CrimeMenu";

    }
    
    UIImageView *homeCrimeButton = (UIImageView *)upMenuView.homeButtonView;

    [homeCrimeButton setImage:[UIImage imageNamed:imageName]];
    
    
    
    [self loadReportsInMyLocation];
    
}
- (void)filterDays:(UIButton *)sender {
    NSLog(@"Button tapped, tag: %ld", (long)sender.tag);
    for (UIButton *button in dayFilterButtons) {
        [button setAlpha:0.5];
    }
    [sender setAlpha:1];
    
    [self.mapView clear];
    daysFilter = [NSNumber numberWithInt:(int)sender.tag];
    NSString *imageName = [NSString stringWithFormat:@"dayIcon_%@",daysFilter];

    UIImageView *homeDaysButton = (UIImageView *)daysMenuView.homeButtonView;
    
    [homeDaysButton setImage:[UIImage imageNamed:NSLocalizedString(imageName,nil)]];
    

    [self loadReportsInMyLocation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//// ****  Location methods start ***** ///////

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        //[manager startUpdatingLocation];
        [manager startMonitoringSignificantLocationChanges];
        [self.mapView setMyLocationEnabled:YES];
        //[self.mapView.settings setMyLocationButton:YES];
    }
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    NSLog(@"Entro didUpdateLocations");
    if (locations != nil) {
        CLLocation *currentLocation = [locations objectAtIndex:0];
         GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentLocation.coordinate.latitude                                                             longitude:currentLocation.coordinate.longitude zoom:15];
        
        [self.mapView setCamera:camera];
        //[manager stopUpdatingLocation];
        //[manager stopMonitoringSignificantLocationChanges];
        /*if (app.applicationState == UIApplicationStateBackground) {
            UILocalNotification *not = [[UILocalNotification alloc] init];
            not.alertBody = @"Change location";
            not.fireDate = [NSDate dateWithTimeIntervalSinceNow:0.0];
            [app scheduleLocalNotification:not];
        }*/
        if (userId != nil) {
            
            NSMutableDictionary * params = [NSMutableDictionary new];
            params[@"id_user"] = userId;
            NSString *latStr = [[NSString alloc] initWithFormat:@"%f", currentLocation.coordinate.latitude];
            NSString *lonStr = [[NSString alloc] initWithFormat:@"%f", currentLocation.coordinate.longitude];
            
            params[@"latitude"] =latStr;
            params[@"longitude"] = lonStr;
            [PFCloud callFunctionInBackground:@"updateLocation" withParameters:params
                                        block:^(NSNumber *ratings, NSError *error) {
                                            if (!error) {
                                                // ratings is 4.5
                                                NSLog(@"");
                                            } else {
                                                NSLog(@"%@",[error description]);
                                            }
                                        }];
            NSLog(@"Actual location");
            
        }

        
    }
    
}

//// ****  Location methods end ***** ///////

-(void)loadReportsInMyLocation{
    GMSCoordinateBounds *bounds =[[GMSCoordinateBounds alloc] initWithRegion: self.mapView.projection.visibleRegion];
       //NSString *userId = [[PFUser currentUser] objectId];
    
    if (userId != nil) {
        NSMutableDictionary * params = [NSMutableDictionary new];
        params[@"id_user"] = userId;

        
        NSString *northeastOfSF_latitude = [[NSString alloc] initWithFormat:@"%.14f", bounds.northEast.latitude];
        NSString *northeastOfSF_longitude = [[NSString alloc] initWithFormat:@"%.14f", bounds.northEast.longitude];
        NSString *southwestOfSF_latitude = [[NSString alloc] initWithFormat:@"%.14f", bounds.southWest.latitude];
        NSString *southwestOfSF_longitude = [[NSString alloc] initWithFormat:@"%.14f", bounds.southWest.longitude];

        currentZoom = self.mapView.camera.zoom;
        NSNumber *zoom = [NSNumber numberWithDouble: (double)currentZoom];
        
        params[@"zoom"] =zoom;
        params[@"type"] =crimeFilter;
        params[@"days"] =daysFilter;
        NSLog(@"North East: %@,%@ ", northeastOfSF_latitude,northeastOfSF_longitude);
        NSLog(@"South West: %@,%@ ", southwestOfSF_latitude,southwestOfSF_longitude);

        NSLog(@"Zoom: %@",zoom);
        NSLog(@"Crime: %@",crimeFilter);
        NSLog(@"Days: %@",daysFilter);
        
        params[@"northeastOfSF_latitude"] =northeastOfSF_latitude;
        params[@"northeastOfSF_longitude"] = northeastOfSF_longitude;
        
        params[@"southwestOfSF_latitude"] = southwestOfSF_latitude;
        params[@"southwestOfSF_longitude"] = southwestOfSF_longitude;
        
        
        [PFCloud callFunctionInBackground:@"getDangerZones" withParameters:params
                                    block:^( NSArray *objects, NSError *error) {
                                        if (!error) {
                                            if (objects != nil && [objects count] > 0) {
                                                //NSLog(@"Total Reports: %lu",(unsigned long)[objects count]);
                                                for (PFObject *object in objects) {
                                                    NSNumber *latNum = object[@"latitude"];
                                                    NSNumber *lngNum = object[@"longitude"];
                                                    NSString *crimeType =object[@"id_type"];
                                                    NSString *crimeDescription=object[@"description"];
                                                    //NSString *crimeCity =object[@"city"];
                                                    //NSString *crimeCountry =object[@"country"];
                                                    //NSString *crimeState =object[@"state"];
                                                    NSString *crimeStreet =object[@"street"];
                                                    //NSString *crimeZipCode =object[@"zip_code"];
                                                    NSDate *date_time =object[@"date_time"];
                                                    
                                                    NSString *crimeTypePin = [NSString stringWithFormat:@"pin_%@",crimeType];
                                                    UIImage *pinIcon =[UIImage imageNamed:crimeTypePin];
                                                    
                                                    double latValue =[latNum doubleValue];
                                                    double lngValue =[lngNum doubleValue];
                                                    
                                                    NSLog(@"%@", object.objectId);
                                                    GMSMarker *marker3 = [[GMSMarker alloc] init];
                                                    marker3.position = CLLocationCoordinate2DMake(latValue,lngValue);
                                                    //marker3.infoWindowAnchor = CGPointMake(0.44f, 0.45f);
                                                    if (pinIcon != nil) {
                                                        marker3.icon =pinIcon;
                                                    }
                                                    NSString *date =@"";
                                                    if (date_time != nil) {
                                                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                                        [formatter setDateFormat:@"MMM d, h:mm a"];
                                                        date = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date_time]];
                                                    } else {
                                                        date=NSLocalizedString(@"Not available",nil);
                                                    }
                                                    
                                                    if (crimeDescription == nil ) {
                                                        crimeDescription = @"";
                                                    }
                                                    if ([crimeDescription isEqualToString:@""] == YES) {
                                                        crimeDescription = NSLocalizedString(@"Not available",nil);
                                                    }
                                                    
                                                    
                                                    marker3.title = NSLocalizedString(@"Report", nil);
                                                    marker3.snippet = [NSString stringWithFormat:NSLocalizedString(@"Date: %@\nAddress: %@\nDescription: %@", nil),date,crimeStreet,crimeDescription ];
                                                    marker3.map = self.mapView ;
                                                }
                                                
                                                
                                            } else {
                                                NSLog(@"No Reports found");
                                            }
                                        } else {
                                            NSLog(@"%@",error.localizedDescription );
                                        }
                                    }];
    }
}

- (UIView *)mapView:(GMSMapView *)mapView  markerInfoWindow:(GMSMarker *)marker {
    MarkerInfoView *infoView = [[[NSBundle mainBundle] loadNibNamed:@"MarkerInfoView" owner:self options:nil] objectAtIndex:0];
    infoView.lblTitle.text = marker.title;
    infoView.lblDescription.text = marker.snippet;
    [infoView setColors];
        return infoView;
}

- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position {
    [self loadReportsInMyLocation];
}


-(void) mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate{
    
    
    [self createReportOnLocation:coordinate.latitude longitud:coordinate.longitude address:@""];
}


-(void)createReportOnMyLocation{
    [self createReportOnLocation:self.mapView.myLocation.coordinate.latitude longitud:self.mapView.myLocation.coordinate.longitude address:@""];
}

-(void)createReportOnLocation:(CGFloat)latitud longitud:(CGFloat)longitud address:(NSString *)address {
    currentZoom = self.mapView.camera.zoom;
    if (currentZoom >= 13) {
        lat = latitud;
        lon = longitud;
        
        if([address isEqualToString:@""] == YES){
            
            [[GMSGeocoder geocoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake(lat, lon) completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
                //NSLog(@"reverse geocoding results:");
                NSArray *locations = [response results];
                if ([locations count] > 0) {
                    GMSAddress* addressObj = [locations objectAtIndex:0];
                    if([addressObj.lines count] > 0) {
                        NSMutableString *address = [[NSMutableString alloc] init];
                        address= [ addressObj.lines objectAtIndex:0];
                        if ([address isEqualToString:@""] == false) {
                            NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Do you want to create a report in the following address: %@?", nil),address];
                            [self showAlert:message];
                        } else {
                            [self showOKAlert:NSLocalizedString(@"Invalid location",nil) title:NSLocalizedString(@"Danger Away!", nil)];

                        }
                        
                        
                    }
                }
            }];
            
        } else {
            NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Do you want to create a report in the following address: %@?", nil) ,address];
            [self showAlert:message];
            
        }

    } else {
        
        [self showOKAlert:NSLocalizedString(@"Please zoom in for better acurasy",nil) title:NSLocalizedString(@"Danger Away!", nil)];
        
    }
    
}

-(void)showOKAlert:(NSString *)message title:(NSString *)title {
    XYAlertView *customAlertOK = [XYAlertView alertViewWithTitle:title
                                                         message:message
                                                         buttons:[NSArray arrayWithObjects:NSLocalizedString(@"OK", nil),  nil]
                                                    afterDismiss:^(int buttonIndex) {
                                                        NSLog(@"button index: %d pressed!", buttonIndex);
                                                    }];
    /// set the second button as gray style
    [customAlertOK setButtonStyle:XYButtonStyleGray atIndex:0];
    
    UIColor *navBackground = [Utilities colorwithHexString:@"#ffd900" alpha:1];
    
    [customAlertOK setTitleFontColor:navBackground];
    [customAlertOK setMessageFontColor:[UIColor blackColor]];
    // display
    [customAlertOK show];
    

}

-(void)showAlert:(NSString *)message{
    // create an alertView
    customAlert = [XYAlertView alertViewWithTitle:NSLocalizedString(@"Report", nil)
                                                     message:message
                                                     buttons:[NSArray arrayWithObjects:NSLocalizedString(@"Yes", nil), NSLocalizedString(@"No", nil), nil]
                                                afterDismiss:^(int buttonIndex) {
                                                    NSLog(@"button index: %d pressed!", buttonIndex);
                                                    if (buttonIndex == 0) {
                                                        [self presentViewReport];
                                                    }

                                                    //[[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.navigationController.view ];

                                                    //[self.navigationController.view becomeFirstResponder];
                                                }];
    // set the second button as gray style
    [customAlert setButtonStyle:XYButtonStyleGray atIndex:0];

    [customAlert setButtonStyle:XYButtonStyleGray atIndex:1];
    UIColor *navBackground = [Utilities colorwithHexString:@"#ffd900" alpha:1];

    [customAlert setTitleFontColor:navBackground];
    [customAlert setMessageFontColor:[UIColor blackColor]];
    // display
    [customAlert show];

}


-(void)presentViewReport{
    NSUserDefaults *dataSaved = [NSUserDefaults standardUserDefaults];  //load NSUserDefaults
    int numOfReports = (int)[dataSaved integerForKey:@"numberOfReports"];
    if (numOfReports < 5){
        ReportFormViewController *report = [[ReportFormViewController alloc] initWithNibName:@"ReportFormViewController" bundle:nil];
        [report setReportLocation:lat longitud:lon];
        [report setParent:self];
        [self presentViewController:report animated:YES completion:nil];
    }else{
        XYAlertView *customAlertRep = [XYAlertView alertViewWithTitle:NSLocalizedString(@"Alert",nil)
                                                           message:NSLocalizedString(@"Your user has more than 5 reports today, please try report tomorrow",nil)
                                                           buttons:[NSArray arrayWithObjects:@"OK", nil]
                                                      afterDismiss:^(int buttonIndex) {
                                                          NSLog(@"button index: %d pressed!", buttonIndex);
                                                      }];
        [customAlertRep setButtonStyle:XYButtonStyleGray atIndex:0];
        
        UIColor *navBackground = [Utilities colorwithHexString:@"#ffd900" alpha:1];
        
        [customAlertRep setTitleFontColor:navBackground];
        [customAlertRep setMessageFontColor:[UIColor blackColor]];
        // display
        [customAlertRep show];
    }
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
                marker.title = @"Address";
                marker.snippet = address;
                marker.map = self.mapView;
                GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latValue longitude:lngValue zoom:15];
                [self.mapView setCamera:camera];
            }
        }
    }
}


///////////////// SEARCH ADDRESS ////////////////

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [foundAddress count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    NSDictionary *result  = [foundAddress objectAtIndex:indexPath.row];
    NSString *address = [result objectForKey:@"formatted_address"];
    cell.textLabel.text = address;
    UIFont *font = [UIFont fontWithName:@"Exo-Bold" size:14];
    [cell.textLabel setFont:font];
    return cell;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSString *address = [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *geocodingBaseUrl = @"http://maps.googleapis.com/maps/api/geocode/json?";
    NSString *urlStr =[NSString stringWithFormat:@"%@address=%@&sensor=false",geocodingBaseUrl,address];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    dispatch_sync(kBgQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSArray *results = [json objectForKey:@"results"];
        if(results != nil && [results count] > 0){
            foundAddress =results;
        }
        
    });

}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *result = [foundAddress objectAtIndex:indexPath.row];
    //NSString *address = [result objectForKey:@"formatted_address"];
    NSDictionary *geometry = [result objectForKey:@"geometry"];
    NSDictionary *location = [geometry objectForKey:@"location"];
    NSString *latStr = [location objectForKey:@"lat"];
    NSString *lngStr = [location objectForKey:@"lng"];
    if(latStr != nil &&  lngStr != nil ){
        double latValue =[latStr doubleValue];
        double lngValue =[lngStr doubleValue];
 
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latValue longitude:lngValue zoom:15];
        [self.mapView setCamera:camera];
        //[self createReportOnLocation:latValue longitud:lngValue address:address];
    }
    foundAddress = [[NSArray alloc] init];
    
    [self.searchDisplayController setActive:NO];

}

-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        CGRect statusBarFrame =  [[UIApplication sharedApplication] statusBarFrame];
        [UIView animateWithDuration:0.25 animations:^{
            for (UIView *subview in self.view.subviews)
                subview.transform = CGAffineTransformMakeTranslation(0, statusBarFrame.size.height);
        }];
    }
}

-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [UIView animateWithDuration:0.25 animations:^{
            for (UIView *subview in self.view.subviews)
                subview.transform = CGAffineTransformIdentity;
        }];
    }
}

@end
