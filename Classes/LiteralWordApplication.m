#import "LiteralWordApplication.h"

@implementation NavViewController

#pragma mark UIViewController delegate
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // we support rotation in this view controller
    return YES;
}

@end

@implementation LiteralWordApplication
@synthesize window = _window;
@synthesize rootview = _viewController;
@synthesize bibleView=_bibleView;

- (UIWindow *) window {
	if (_window == nil) 
		_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	return _window;
}

-(BibleViewController *) bibleView{
	if (!_bibleView) _bibleView = [[BibleViewController alloc] init];
	return _bibleView;


}

- (NavViewController *) rootview {
	if (_viewController == nil) 
		_viewController = [[NavViewController alloc] initWithRootViewController: self.bibleView];
	return _viewController;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {

	[VersesDataBaseController openDataBase];
	application.statusBarHidden = YES;	
	[self.window addSubview: self.rootview.view];
	[self.window makeKeyAndVisible];
}

- (void)applicationWillTerminate:(UIApplication *)application {
        // Save data if appropriate

        [VersesDataBaseController closeDataBase];
}



- (void)dealloc {
	[self.window release];
	[self.rootview release];	
	[self.bibleView release];	
	[super dealloc];
}
@end

// vim:ft=objc
