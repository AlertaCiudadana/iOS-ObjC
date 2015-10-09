//
//  MarkerInfoView.m
//  DangerAwayApp
//
//  Created by German on 4/6/15.
//
//

#import "MarkerInfoView.h"

@implementation MarkerInfoView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.lblTitle.layer.cornerRadius = 10;
    self.layer.cornerRadius = 10;
}

-(void)setColors{
    UIColor *navBackground = [Utilities colorwithHexString:@"#ffd900" alpha:1];
    [self setBackgroundColor:navBackground];
    [self.lblTitle setTextColor:navBackground];
    //self.lblDescription.numberOfLines = 0;
    [self.lblDescription sizeToFit];
}

@end
