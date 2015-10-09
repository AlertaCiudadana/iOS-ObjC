//
//  MarkerInfoView.h
//  DangerAwayApp
//
//  Created by German on 4/6/15.
//
//

#import <UIKit/UIKit.h>
#import "Utilities.h"
@interface MarkerInfoView : UIView
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
-(void)setColors;
@end
