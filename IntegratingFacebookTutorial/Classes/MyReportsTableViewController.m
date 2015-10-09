//
//  MyReportsTableViewController.m
//  DangerAwayApp
//
//  Created by German on 3/8/15.
//
//

#import "MyReportsTableViewController.h"

@interface MyReportsTableViewController ()

@end

@implementation MyReportsTableViewController
@synthesize myReports;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_logo_black"]];
    [self.navigationItem setHidesBackButton:YES];
    //myReports = [[NSArray alloc] init ];
    [self setFontFamily:@"Exo-Light" forView:self.view andSubViews:YES];
    UIColor *navBackground = [Utilities colorwithHexString:@"#ffd900" alpha:1];

    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.backgroundColor = navBackground;
    refresh.tintColor = [UIColor blackColor];
    
    [refresh addTarget:self
                            action:@selector(loadMyReports)
                  forControlEvents:UIControlEventValueChanged];
    self.refreshControl =refresh;

    [self loadMyReports];

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self.refreshControl endRefreshing];
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [self.refreshControl beginRefreshing];
        [self.refreshControl endRefreshing];
    });
    self.navigationItem.title = NSLocalizedString(@"My Reports",nil);

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


-(void)loadMyReports{
    PFQuery *query = [PFQuery queryWithClassName:@"Report"];
    NSString *userId = [[PFUser currentUser] objectId];

    [query whereKey:@"id_user" equalTo:userId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            // Do something with the found objects
            myReports = objects;
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                
            }
            
            if ([NSThread isMainThread]) {
                [self reloadData];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}

- (void)reloadData
{
    // Reload table data
    [self.tableView reloadData];

    // End the refreshing
    if (self.refreshControl) {

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:NSLocalizedString(@"Last update: %@",nil), [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor blackColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        [self.refreshControl setTintColor:[UIColor blackColor]];
        [self.refreshControl endRefreshing];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if (myReports) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.backgroundView = nil;

        return 1;

    } else {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = NSLocalizedString(@"No data is currently available. Please pull down to refresh.",nil);
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Exo-Bold" size:17];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (myReports) {
        return [myReports count];

    } else {
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
    }
    
    
    
    
    PFObject *current = [myReports objectAtIndex:indexPath.row];

    // Configure the cell...
    NSDate *date = current[@"date_time"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE MMMM d, YYYY"];
    NSString *dateString = [dateFormat stringFromDate:date];
    cell.textLabel.text = dateString;
    UIFont *font = [UIFont fontWithName:@"Exo-Bold" size:14];
    [cell.textLabel setFont:font];
        
    //Put image type crime
    NSString *id_type = current[@"id_type"];
    NSString *imageName = [NSString stringWithFormat:@"crimeIcon_%@",id_type];
    UIImage *image = [UIImage imageNamed:imageName];
    cell.imageView.image = image;
    NSLog(@"Image name %@",imageName);
    
    //Description like summary
    NSString *description = current[@"description"];
    NSLog(@"description: %@",description);
    if (![description  isEqual: @""]) {
        cell.detailTextLabel.text = description;
    }else{
        cell.detailTextLabel.text = NSLocalizedString(@"Details...",nil);
    }
    
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    self.navigationItem.title = NSLocalizedString(@"Back",nil);

    ReportDetail *detailViewController = [[ReportDetail alloc] initWithNibName:@"ReportDetail" bundle:nil];
    
    // Pass the selected object to the new view controller.
    [detailViewController setReport:[myReports objectAtIndex:indexPath.row]];
    // Push the view controller.

    [self.navigationController pushViewController:detailViewController animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
