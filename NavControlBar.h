//  Created by Andrew Johnson on 8/7/09.
//  This code is free for any sort of use, but with no warranty attached.

/* Usage

 1. The NavControlBar is just like Apple's UINavigationController, 
    except you can add arbitrary controls to the bar. NavControlBar 
    lets you do things like show a Search Field, or some Radio Buttons 
    on your NavBar.
 
 2. To create a view with NavControlBar, the usage is like this:
 
    UIViewController* myRootViewController = [[UIViewController alloc] init];
    UIView *controlBar = [[UIView alloc] init];
    NavControlBar *navControlBar = [[NavControlBar alloc] initWithViewController:myRootViewController 
                                                                  withControlBar:(UIView*)contolBar];
 
    The UIView controlBar is just a view that contains whatever 
    TextFields, Buttons, and Labels you want to show. 
 
 3. Here are a few more usage tips:
 
    NavControlBar defaults to assume you are using a UITabBar. If you 
    are not, you should reset the frame:
 
    [navControlBar setFrameWithoutTabBar];
 
    If you want to add a subview, simply call the following function:
 
    [navControlbar pushViewControllerWithBackBar:mySubviewController];
 
    Similarly, you can remove a view from the stack by calling:
 
    [self popViewController];
       
*/


#import <UIKit/UIKit.h>


@interface NavControlBar : UIViewController {

	// an array of dictionaries, each dict has: a ViewController, 
	// a UIView for the NavControlBar, and a BOOL showNavBar
	NSMutableArray *viewControllers;   
	
	// this is just defined here so ViewControllers can be cast to NavControlBars to avoid warnings.
	NavControlBar *navBar;
}


- (id) init;
- (id) initWithViewController:(UIViewController*)subview;
- (id) initWithViewController:(UIViewController*)subview withControlBar:(UIView*)bar;
- (void) pushViewControllerWithBackBar:(UIViewController*)subview;
- (void) pushViewController:(UIViewController*)subview withControlBar:(UIView*)bar;
- (void) showViewController:(int)index;
- (void) popViewController;
- (void) setFrameWithoutTabBar;

	
@property(nonatomic, retain) NSMutableArray *viewControllers;
@property(nonatomic, retain) NavControlBar *navBar;

@end
