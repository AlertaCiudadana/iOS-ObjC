//
//  BlogViewController.m
//  DangerAwayApp
//
//  Created by German on 3/11/15.
//
//

#import "BlogViewController.h"

@interface BlogViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation BlogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *tittlePage = [blogEntrie objectForKey:@"title"];
    NSLog(@"Title page: %@",tittlePage);
    NSString *content = [blogEntrie objectForKey:@"content"];
    
    NSString *webViewContent = [NSString stringWithFormat:
                                @"<html>"
                                "<body style=\"text-align:justify;margin:0;padding:0;color=black;\">"
                                "</br>"
                                "%@"
                                "</body></html>", content];
    [self.webView loadHTMLString:webViewContent baseURL:nil];


}

-(void)viewDidAppear:(BOOL)animated{
   /* [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor blackColor], NSForegroundColorAttributeName,
                                                                     [UIFont fontWithName:@"Exo-Bold" size:42.0], NSForegroundColorAttributeName, nil]];
    */
    self.navigationItem.title = [blogEntrie objectForKey:@"title"];
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

-(void)loadBlogEntrie:(NSDictionary *)blogPost{
    blogEntrie = blogPost;
    
}


@end
