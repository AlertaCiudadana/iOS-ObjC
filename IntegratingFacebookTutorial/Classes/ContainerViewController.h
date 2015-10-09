//
//  ContainerViewController.h
//  Danger Away
//
//  Created by Dasoga on 12/04/15.
//
//

#import <UIKit/UIKit.h>

@interface ContainerViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageController;

@end
