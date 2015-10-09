//
//  BlogTableTableViewController.m
//  DangerAwayApp
//
//  Created by German on 3/18/15.
//
//

#import "BlogTableTableViewController.h"

@interface BlogTableTableViewController ()

@end

@implementation BlogTableTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //self.blogEntries = [[NSArray alloc] init ];
    UIColor *navBackground = [Utilities colorwithHexString:@"#ffd900" alpha:1];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = navBackground;
    self.refreshControl.tintColor = [UIColor blackColor];
    
    [self.refreshControl addTarget:self
                            action:@selector(loadBlogEntries)
                  forControlEvents:UIControlEventValueChanged];
    

    [self loadBlogEntries];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self.refreshControl endRefreshing];
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [self.refreshControl beginRefreshing];
        [self.refreshControl endRefreshing];
    });
    self.navigationItem.title = NSLocalizedString(@"Blog",nil);

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if (self.blogEntries) {
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
    if (self.blogEntries) {
        return [self.blogEntries count];
    } else {
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
    }
    
    //Put tittle of the article
    UIFont *font = [UIFont fontWithName:@"Exo-Bold" size:14];
    [cell.textLabel setFont:font];
    
    NSDictionary *current = [self.blogEntries objectAtIndex:indexPath.row];
    NSString *title = [current objectForKey:@"title"];
    cell.textLabel.text = title;
    
    //Put image from article
    NSString *path = [current objectForKey:@"featured_image"];
    NSLog(@"Image name: %@",path);
    if (![path isEqual:@""]) {
        NSURL *url = [NSURL URLWithString:path];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];
        //CGSize size = img.size;
        cell.imageView.image = img;
    }else{
        //Put a default image
    }

    //cell.imageView.image.size = size;
    
    
    //Description like summary
    NSString *description = [current objectForKey:@"excerpt"];
    description = [description stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    if (![description  isEqual: @""]) {
        cell.detailTextLabel.text = description;
    }else{
        cell.detailTextLabel.text = NSLocalizedString(@"Details...",nil);
    }

    
    
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
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

    BlogViewController *detailViewController = [[BlogViewController alloc] initWithNibName:@"BlogViewController" bundle:nil];
    NSDictionary *current = [self.blogEntries objectAtIndex:indexPath.row];

    // Pass the selected object to the new view controller.
    [detailViewController loadBlogEntrie:current];
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

-(void)loadBlogEntries{
    NSString *blogURLStr = @"https://public-api.wordpress.com/rest/v1.1/sites/dangeraway.wordpress.com/posts";
    NSURL *blogURL = [NSURL URLWithString:blogURLStr];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:blogURL];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError == nil && data != nil) {
                                   NSError *error;
                                   
                                   NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                   // Add a nice corner radius to the image
                                   if (json != nil && error == nil) {
                                      self.blogEntries = [json objectForKey:@"posts"];
                                       
                                       if ([NSThread isMainThread]) {
                                           [self reloadData];
                                       }
                                   } else {
                                       NSLog(@"Failed to load blog entries.");
                                   }
                                   
                               } else {
                                   NSLog(@"Failed to load blog entries.");
                               }
                           }];
}

@end
