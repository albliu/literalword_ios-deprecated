#import "SelectorViewController.h"
#import "BibleViewController.h"
#import <QuartzCore/QuartzCore.h>
@implementation SelectorViewController

@synthesize rootview=_rootview;

-(UIButton *) generateButton:(const char *) t selector:(SEL) sel frame:(CGRect) f {

	UIButton * select = [UIButton buttonWithType:UIButtonTypeCustom];
	select.frame = f;
	[select addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
	[select setTitle:[NSString stringWithUTF8String:t] forState:UIControlStateNormal]; 
	[select setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[select setBackgroundColor:[UIColor SHEET_BLUE]];

	[[select layer] setCornerRadius:8.0f];
	[[select layer] setMasksToBounds:YES];
//	[[select layer] setBorderWidth:1.0f];
	return select;

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // we support rotation in this view controller
    return YES;
}

-(id) initWithFrame: (CGRect) f RootView:(id) view {
	self.view.frame = f;
	self.rootview = view;
	return self;
}

- (void) loadClearView {

	UIView * clearBackground = [[UIView alloc] initWithFrame:self.view.frame];
	[clearBackground setBackgroundColor: [UIColor colorWithRed:0.332f green:0.332f blue:0.332f alpha:0.4f]];
	clearBackground.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ) ; 
	[self.view addSubview:clearBackground];
	[clearBackground release];

}

- (void) viewDidLoad {

	[self.rootview showMainView];
	[self.rootview allowNavigationController:NO];

}

- (void) dismissMyView {
	[self.rootview allowNavigationController:YES];
	[self.view removeFromSuperview];
}
@end
