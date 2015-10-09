//
//  MyReportsTableViewController.h
//  DangerAwayApp
//
//  Created by German on 3/8/15.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ReportDetail.h"
#import "Utilities.h"

@interface MyReportsTableViewController : UITableViewController
@property (nonatomic, retain) NSArray *myReports;

-(void)loadMyReports;
@end
