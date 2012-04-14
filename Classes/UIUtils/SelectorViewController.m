#import "SelectorViewController.h"
#import "BibleViewController.h"
#import <QuartzCore/QuartzCore.h>
@implementation SelectorViewController

@synthesize rootview;

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

-(id) initWithFrame: (CGRect) f RootView:(id) myview {
	myframe = f;
	self.rootview = myview;
	return [self init];
}

- (void) loadClearView {

	self.view.frame = myframe;
	UIButton * clearBackground =  [UIButton buttonWithType:UIButtonTypeCustom];
	clearBackground.frame = self.view.frame;
	[clearBackground addTarget:self action:@selector(dismissMyView) forControlEvents:UIControlEventTouchUpInside];
	[clearBackground setBackgroundColor: [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.4f]];
	clearBackground.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ) ; 
	[self.view addSubview:clearBackground];

}




- (void) dismissMyView {
	[self.view removeFromSuperview];
	[[self rootview] SelectorViewDismissed];
}
@end
