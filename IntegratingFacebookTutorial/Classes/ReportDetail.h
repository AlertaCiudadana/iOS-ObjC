//
//  ReportDetail.h
//  DangerAwayApp
//
//  Created by German on 3/9/15.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ReportDetail : UIViewController
{
    PFObject *report;
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *streetLabel;
    IBOutlet UILabel *typeIncident;
    IBOutlet UILabel *timeLabel;
    IBOutlet UITextView *descriptionText;
    
}
- (PFObject *)report;

- (void)setReport:(PFObject *)newValue;

@end
