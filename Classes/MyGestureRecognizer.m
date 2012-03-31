#import "MyGestureRecognizer.h"
#import "BibleViewController.h"

@implementation MyGestureRecognizer
@synthesize delegate = _delegate;

-(MyGestureRecognizer *) initWithDelegate:(id) delegate View:(UIView *) view {

	self.delegate = delegate;

	UIPinchGestureRecognizer *myPinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
	myPinch.delegate = self;
	[view addGestureRecognizer:myPinch];

	UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(swipeRightAction:)];
	swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
	swipeRight.delegate = self;
	[view addGestureRecognizer:swipeRight];
 
	UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftAction:)];
	swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
	swipeLeft.delegate = self;
	[view addGestureRecognizer:swipeLeft];

	UITapGestureRecognizer *SingTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
	SingTap.numberOfTapsRequired = 1;
	SingTap.delegate = self;
	[view addGestureRecognizer:SingTap];


	UITapGestureRecognizer *DoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
	DoubleTap.numberOfTapsRequired = 2;
	DoubleTap.delegate = self;
	[view addGestureRecognizer:DoubleTap];

	return self;
}

#pragma mark Gestures

- (void)pinch:(UIPinchGestureRecognizer *)gesture {

	NSLog(@"Pinch");

	[self.delegate changeFontSize:gesture.scale];
	gesture.scale = 1;
}


- (void)swipeLeftAction:(id)ignored
{
	NSLog(@"Swipe Left");
	[self.delegate nextPassage];
}
 
- (void)swipeRightAction:(id)ignored
{
	NSLog(@"Swipe Right");
	[self.delegate prevPassage];
}
- (void) handleTap:(UIGestureRecognizer *)sender
{

	[self.delegate showMainView];
}
- (void) handleDoubleTap:(UIGestureRecognizer *)sender
{
	CGPoint tapPoint = [sender locationInView:sender.view.superview];

	[self.delegate highlightX:tapPoint.x Y:tapPoint.y];

}
#pragma mark GestureRecognizerDelegate

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}



@end
