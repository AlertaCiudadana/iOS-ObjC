//
//  BlogViewController.h
//  DangerAwayApp
//
//  Created by German on 3/11/15.
//
//

#import <UIKit/UIKit.h>

@interface BlogViewController : UIViewController{
    NSDictionary *blogEntrie;
}
-(void)loadBlogEntrie:(NSDictionary *)blogPost;

@end
