//
//  TBNavBar.m
//  TrailTracker
//
//  Created by Andrew Johnson on 8/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "NavControlBar.h"
#import <QuartzCore/QuartzCore.h>


@implementation NavControlBar


@synthesize viewControllers, navBar;


#define FrameWithNavBar CGRectMake(0,40,320,376)
#define FrameWithoutNavBar CGRectMake(0,0,320,416)
#define RootFrameWithTabBar CGRectMake(0,20,320,416)
#define RootFrameWithoutTabBar CGRectMake(0,20,320,460)
#define BACK_BUTTON_FRAME CGRectMake(5, 5, 50, 30)
#define BAR_FRAME CGRectMake(0,0,320,40)
#define TITLE_FRAME CGRectMake(110, 5, 100, 30)
#define BACKGROUND_IMAGE @"navbar-background.png"


// set the frame to the right height to use a UITabBar
- (id) init {
	
	self.viewControllers = [[NSMutableArray alloc] init];
	self.view.frame = RootFrameWithTabBar;		
	return self;
	
}


// set the frame to the right height for a view without a UITabBar
-(void) setFrameWithoutTabBar {
	
	self.view.frame = RootFrameWithoutTabBar;		

}


// init with no NavBar showing
- (id) initWithViewController:(NavControlBar*)subview {
	
	self = [self init];   
		
	[subview setNavBar: self];	
	
	[self.viewControllers addObject: [[NSDictionary alloc] initWithObjectsAndKeys: 
																		subview, @"viewController", 
																		[[UIImageView alloc]initWithImage:[UIImage imageNamed:BACKGROUND_IMAGE]], @"controlBar", 
																		[NSNumber numberWithBool: YES], @"navBarHidden", nil]];
	
	[self showViewController:0];
	
	return self;
}


// init with a NavBar, and add bar as a subview
- (id) initWithViewController:(NavControlBar*)subview withControlBar:(UIView*)bar {
	
	self = [self init]; 
		
	[subview setNavBar: self];	
	UIView *cBar = [[UIView alloc]initWithFrame:BAR_FRAME];
	[cBar addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IMAGE]]];
	[cBar addSubview:bar];
	bar.frame = BAR_FRAME;

	[self.viewControllers addObject: [[NSDictionary alloc] initWithObjectsAndKeys: 
																		subview, @"viewController", 
																		cBar, @"controlBar", 
																		[NSNumber numberWithBool: NO], @"navBarHidden", nil]];

	[self showViewController:0];
	
	return self;
	
}
	

// init with a NavBar that just shows a title
- (id)initWithViewController:(NavControlBar*)subview withTitle:(NSString*)title {
	
	self = [self init];
		
	UIView *cBar = [[UIView alloc]initWithFrame:BAR_FRAME];
	[cBar addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IMAGE]]];
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:TITLE_FRAME];
	titleLabel.text = title;
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.textAlignment = UITextAlignmentCenter;
	[cBar addSubview:titleLabel];  

	[subview setNavBar: self];	
	
	[self.viewControllers addObject: [[NSDictionary alloc] initWithObjectsAndKeys: 
																		subview, @"viewController", 
																		cBar, @"controlBar", 
																		[NSNumber numberWithBool: NO], @"navBarHidden", nil]];
	
	[self showViewController:0];
			
	return self;
	
}


// add a view to the stack, with a navBar with a "back" button
- (void) pushViewControllerWithBackBar:(UIViewController*)subview {
	
	UIView *cBar = [[UIView alloc]initWithFrame:BAR_FRAME];
  [cBar addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IMAGE]]];
	
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[backButton setTitle:@"Back" forState:UIControlStateNormal];
	[backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
	backButton.frame = BACK_BUTTON_FRAME;
	[cBar addSubview:backButton];  

	[self.viewControllers addObject: [[NSDictionary alloc] initWithObjectsAndKeys: 
																		subview, @"viewController", 
																		cBar, @"controlBar", 
																		[NSNumber numberWithBool: NO], @"navBarHidden", nil]];
	
	[self showViewController:[self.viewControllers count]-1];
	
	CATransition *animation = [CATransition animation];
	[animation setDuration:0.5];
	[animation setType:kCATransitionPush];
	[animation setSubtype:kCATransitionFromRight];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];	
	[[self.view layer] addAnimation:animation forKey:@"SwitchToView1"];
	
}	


// add a view to the stack, with a custom bar
// this bar should usually include a back button
- (void) pushViewController:(UIViewController*)subview withControlBar:(UIView*)bar {
	
	UIView * cBar = [[UIView alloc] initWithFrame:BAR_FRAME];
	[cBar addSubview:[[UIImageView alloc]initWithImage:[UIImage imageNamed:BACKGROUND_IMAGE]]];
	[cBar addSubview:bar];
	bar.frame = BAR_FRAME;

	[self.viewControllers addObject: [[NSDictionary alloc] initWithObjectsAndKeys: 
																		subview, @"viewController", 
																		cBar, @"controlBar", 
																		[NSNumber numberWithBool: NO], @"navBarHidden", nil]];

	[self showViewController:[self.viewControllers count]-1];
	
	CATransition *animation = [CATransition animation];
	[animation setDuration:0.5];
	[animation setType:kCATransitionPush];
	[animation setSubtype:kCATransitionFromRight];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];	
	[[self.view layer] addAnimation:animation forKey:@"SwitchToView1"];
	
}	


// add a view from self.viewControllers to the stack
- (void) showViewController:(int)index {
	
	NSDictionary* vcDict = [self.viewControllers objectAtIndex:index];
	UIViewController * vc = [vcDict objectForKey:@"viewController"];
  UIView *cb = [vcDict objectForKey:@"controlBar"];	
	
	if ([[vcDict objectForKey:@"navBarHidden"]boolValue]) {
		vc.view.frame = FrameWithoutNavBar;
	} else {
		vc.view.frame = FrameWithNavBar;
		[self.view addSubview:cb];		
	}	
	[self.view addSubview:[vc view]];
	
}


// remove a view controller from the tack and release it
- (void) popViewController{

	UIViewController *currentView = [[self.viewControllers objectAtIndex:[self.viewControllers count]-1] objectForKey: @"viewController"];
	UIView *bar = [[self.viewControllers objectAtIndex:[self.viewControllers count]-1] objectForKey: @"controlBar"];
	[currentView.view removeFromSuperview];
	[bar removeFromSuperview];
	
	// set up an animation for the transition between the views
	CATransition *animation = [CATransition animation];
	[animation setDuration:0.5];
	[animation setType:kCATransitionPush];
	[animation setSubtype:kCATransitionFromLeft];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];		
	[[self.view layer] addAnimation:animation forKey:@"SwitchToView1"];
	
	[self.viewControllers removeLastObject];
  [currentView release];

}


- (void)didReceiveMemoryWarning {

	[super didReceiveMemoryWarning];

}


- (void)dealloc {
	
	[super dealloc];
	[viewControllers release];

}


@end
