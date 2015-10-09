//
//  ReportDetail.m
//  DangerAwayApp
//
//  Created by German on 3/9/15.
//
//

#import "ReportDetail.h"

@interface ReportDetail ()

@end

@implementation ReportDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self formatNavITem:self.navigationItem];

    [self loadReportDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)formatNavITem:(UINavigationItem *)navITem {
    [navITem setHidesBackButton:NO];
    navITem.title = NSLocalizedString(@"My Reports",nil);

}

-(void)clickSettings:(id)sender{

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (PFObject *)report {
    return report;
}

- (void)setReport:(PFObject *)newValue {
    report = newValue;
}

-(void)loadReportDetails{
    NSDate *date =report[@"date_time"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE MMMM d, YYYY"];
    NSString *dateString = [dateFormat stringFromDate:date];
    dateLabel.text = dateString;

    NSString *street = report[@"street"];
    streetLabel.text = street;
    
    NSDateFormatter *dateFormatTime = [[NSDateFormatter alloc] init];
    [dateFormatTime setDateFormat:@"h:mm a"];
    NSString *timeString = [dateFormatTime stringFromDate:date];
    timeLabel.text = timeString;
    
    NSString *history = report[@"description"];
    descriptionText.text = history;
    
    

}

@end
