//
//  InstructionsView.m
//  Danger Away
//
//  Created by Dasoga on 12/04/15.
//
//

#import "InstructionsView.h"

@interface InstructionsView ()

@end

@implementation InstructionsView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.dondeButton setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
}

-(void)viewDidAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    //self.screenLabel.text = [NSString stringWithFormat:@"Screen #%d",self.indexNumber];
    if(self.indexNumber == 0){
        self.backImage.image = [UIImage imageNamed:NSLocalizedString(@"en01",nil)];
    }else if(self.indexNumber == 1){
        self.backImage.image = [UIImage imageNamed:NSLocalizedString(@"en02",nil)];
    }else if(self.indexNumber == 2){
        self.backImage.image = [UIImage imageNamed:NSLocalizedString(@"en03",nil)];
    }else if(self.indexNumber == 3){
        self.backImage.image = [UIImage imageNamed:NSLocalizedString(@"en04",nil)];
        self.dondeButton.hidden = NO;
    }

}

- (IBAction)goToLogin:(id)sender {
    BaseViewController *tabBar = [[BaseViewController alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:tabBar animated:NO completion:nil];    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
