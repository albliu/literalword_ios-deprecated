#import "LiteralWordApplication.h"


@implementation LiteralWordApplication
@synthesize window = _window;
@synthesize rootview = _viewController;

- (UIWindow *) window {
	if (_window == nil) 
		_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	return _window;
}



- (NavViewController *) rootview {
	if (_viewController == nil) 
		_viewController = [[NavViewController alloc] initRootView];
	return _viewController;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {

	[VersesDataBaseController openDataBase];
	[BibleDataBaseController initBibleDataBase];
	application.statusBarHidden = YES;	
	[self.window addSubview: self.rootview.view];
	[self.window makeKeyAndVisible];
}

- (void)applicationWillTerminate:(UIApplication *)application {
        // Save data if appropriate

        [VersesDataBaseController closeDataBase];
	[BibleDataBaseController closeBibleDataBase];
}



- (void)dealloc {
	[self.window release];
	[self.rootview release];	
	[super dealloc];
}
@end

// vim:ft=objc
