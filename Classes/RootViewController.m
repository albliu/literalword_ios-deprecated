#import "RootViewController.h"

@implementation NavViewController

@synthesize bibleView=_bibleView;

-(BibleViewController *) bibleView{
	if (!_bibleView) _bibleView = [[BibleViewController alloc] init];
	return _bibleView;
}

- (id) initRootView {
	return [self initWithRootViewController: self.bibleView];
}

#pragma mark UIViewController delegate
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // we support rotation in this view controller
    return YES;
}


- (void)dealloc {

	[self.bibleView release];	
	[super dealloc];
}
@end

