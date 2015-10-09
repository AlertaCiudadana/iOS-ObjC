//
//  ContactViewController.m
//  DangerAwayApp
//
//  Created by German on 3/11/15.
//
//

#import "ContactViewController.h"
#import "XYAlertView.h"

@interface ContactViewController ()

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"contact info");
    //[self showAlert];
}

-(void) showAlert{
    // create an alertView
    XYAlertView *alertView = [XYAlertView alertViewWithTitle:@"Reporte"
                                                     message:@"Quieres crear aqui el reporte"
                                                     buttons:[NSArray arrayWithObjects:@"Si", @"No", nil]
                                                afterDismiss:^(int buttonIndex) {
                                                    NSLog(@"button index: %d pressed!", buttonIndex);
                                                }];
    
    // set the second button as gray style
    [alertView setButtonStyle:XYButtonStyleGray atIndex:1];
    
    // display
    [alertView show];
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
