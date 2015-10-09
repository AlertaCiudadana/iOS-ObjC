    //
//  BaseViewController.m
//  RaisedCenterTabBar
//
//  Created by Peter Boctor on 12/15/10.
//
// Copyright (c) 2011 Peter Boctor
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE
//

#import "BaseViewController.h"

@implementation BaseViewController
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


-(void)viewDidLoad{
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    //[self getCrimeTypes];
    UIImage *dangerZonesIcon = [UIImage imageNamed:@"map_zonas_peligrosas"];
    UIImage *myReportIcon = [UIImage imageNamed:@"map_mis_reportes"];
    UIImage *blogIcon = [UIImage imageNamed:@"map_blog"];
    UIImage *contactIcon = [UIImage imageNamed:@"nav_config"];
    
    //dangerZonesIcon = [self imageWithImage:dangerZonesIcon scaledToSize:CGSizeMake(30, 30)];
    //myReportIcon = [self imageWithImage:myReportIcon scaledToSize:CGSizeMake(30, 30)];
    //blogIcon = [self imageWithImage:blogIcon scaledToSize:CGSizeMake(30, 30)];
    //contactIcon = [self imageWithImage:contactIcon scaledToSize:CGSizeMake(30, 20)];

    
    mapViewController = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    mapViewController.tabBarItem =[[UITabBarItem alloc] initWithTitle:nil image:dangerZonesIcon tag:0];
    
    mapViewController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    mapViewController.title = nil;
    [self formatNavITem:mapViewController.navigationItem];
 
    
    MyReportsTableViewController *myReportsScreen = [[MyReportsTableViewController alloc] initWithNibName:@"MyReportsTableViewController" bundle:nil];
    myReportsScreen.tabBarItem =[[UITabBarItem alloc] initWithTitle:nil image:myReportIcon tag:1];
    myReportsScreen.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    myReportsScreen.title = nil;
    //[self formatNavITem:myReportsScreen.navigationItem];

    
    /*ReportMapController *reportScreen = [[ReportMapController alloc] initWithNibName:@"ReportMapController" bundle:nil];
    reportScreen.tabBarItem =[[UITabBarItem alloc] initWithTitle:nil image:nil tag:2];
    mapViewController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    mapViewController.title = nil;
    [self formatNavITem:reportScreen.navigationItem];

    */
 
    BlogTableTableViewController *blogScreen = [[BlogTableTableViewController alloc] initWithNibName:@"BlogTableTableViewController" bundle:nil];
    blogScreen.tabBarItem =[[UITabBarItem alloc] initWithTitle:nil image:blogIcon tag:3];
    blogScreen.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    blogScreen.title = nil;
    //[self formatNavITem:blogScreen.navigationItem];

    
    
    SettingsViewController *contactScreen = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    
    contactScreen.tabBarItem =[[UITabBarItem alloc] initWithTitle:nil image:contactIcon tag:4];
    contactScreen.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    contactScreen.title = nil;
    [self formatNavITem:contactScreen.navigationItem];
    //contactScreen.tabBarItem.imageInsets = UIEdgeInsetsMake( 9,  0,  0,  0);

    
    mapNavController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
    UINavigationController * myRepNavController = [[UINavigationController alloc] initWithRootViewController:myReportsScreen];
    UINavigationController * repNavController = [[UINavigationController alloc] init];
    UINavigationController * blogNavController = [[UINavigationController alloc] initWithRootViewController:blogScreen];
    UINavigationController * contactNavController = [[UINavigationController alloc] initWithRootViewController:contactScreen];

    
    self.viewControllers = [NSArray arrayWithObjects:mapNavController,myRepNavController, repNavController , blogNavController,contactNavController, nil];
    [self addCenterButtonWithImage:[UIImage imageNamed:NSLocalizedString(@"map_botonreport",nil)] highlightImage:[UIImage imageNamed:NSLocalizedString(@"map_botonreport",nil)]];
    [self setSelectedIndex:0];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)formatNavITem:(UINavigationItem *)navITem {
    navITem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_logo_black"]];
    [navITem setHidesBackButton:YES];
}

-(void)clickSettings:(id)sender{
    //NSLog(@"Entro");
    SettingsViewController *settingsView = [[SettingsViewController alloc] init];
    [self presentViewController:settingsView animated:YES completion:nil];
}



// Create a view controller and setup it's tab bar item with a title and image
-(UIViewController*) viewControllerWithTabTitle:(NSString*) title image:(UIImage*)image
{
  UIViewController* viewController =  [[UIViewController alloc] init];
  viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image tag:0] ;

  return viewController;
}

// Create a custom UIButton and add it to the center of our tab bar
-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
{
  UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
  button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
  [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
  [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];

  CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
  if (heightDifference < 0)
    button.center = self.tabBar.center;
  else
  {
    CGPoint center = self.tabBar.center;
    center.y = center.y - heightDifference/2.0;
    button.center = center;
  }
    [button addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [[UITabBar appearance] setItemWidth:(self.view.frame.size.width-80)/5];
  
  [self.view addSubview:button];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return YES;
}


-(void)btnClicked
{
    // Here You can write functionality
    [mapViewController createReportOnMyLocation];
    [self setSelectedIndex:0];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (self.selectedIndex == 0) {
        [mapViewController loadReportsInMyLocation];
    }
}

@end
